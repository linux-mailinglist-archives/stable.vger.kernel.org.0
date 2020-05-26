Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 817FF1E2D9C
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391949AbgEZTWa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:22:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:39276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390905AbgEZTKI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:10:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC5FA208A7;
        Tue, 26 May 2020 19:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520207;
        bh=z+fk0Pv+x94C2kIS/ampQZxF3sACccTi42Enl/SnzGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WDP/pM63BbVaW+mHgz1uASa6qFy0C7/EGrmimMSdx2iMT4MMvz4qFlydaAIKpHGFu
         TH3Rj2aSIN/e6OvXCbj43pyb/+5Bz3QTpn4PzhQUyr91/I4BgDe14cx3t6FO02pvXh
         3C1DR2eq3FmJgP8JXKbu5Y/rAEZHN7DVETvYUths=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Sitnicki <jakub@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Stanislav Fomichev <sdf@google.com>
Subject: [PATCH 5.4 100/111] flow_dissector: Drop BPF flow dissector prog ref on netns cleanup
Date:   Tue, 26 May 2020 20:53:58 +0200
Message-Id: <20200526183942.375473256@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183932.245016380@linuxfoundation.org>
References: <20200526183932.245016380@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Sitnicki <jakub@cloudflare.com>

commit 5cf65922bb15279402e1e19b5ee8c51d618fa51f upstream.

When attaching a flow dissector program to a network namespace with
bpf(BPF_PROG_ATTACH, ...) we grab a reference to bpf_prog.

If netns gets destroyed while a flow dissector is still attached, and there
are no other references to the prog, we leak the reference and the program
remains loaded.

Leak can be reproduced by running flow dissector tests from selftests/bpf:

  # bpftool prog list
  # ./test_flow_dissector.sh
  ...
  selftests: test_flow_dissector [PASS]
  # bpftool prog list
  4: flow_dissector  name _dissect  tag e314084d332a5338  gpl
          loaded_at 2020-05-20T18:50:53+0200  uid 0
          xlated 552B  jited 355B  memlock 4096B  map_ids 3,4
          btf_id 4
  #

Fix it by detaching the flow dissector program when netns is going away.

Fixes: d58e468b1112 ("flow_dissector: implements flow dissector BPF hook")
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Stanislav Fomichev <sdf@google.com>
Link: https://lore.kernel.org/bpf/20200521083435.560256-1-jakub@cloudflare.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/core/flow_dissector.c |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -129,12 +129,10 @@ int skb_flow_dissector_bpf_prog_attach(c
 	return 0;
 }
 
-int skb_flow_dissector_bpf_prog_detach(const union bpf_attr *attr)
+static int flow_dissector_bpf_prog_detach(struct net *net)
 {
 	struct bpf_prog *attached;
-	struct net *net;
 
-	net = current->nsproxy->net_ns;
 	mutex_lock(&flow_dissector_mutex);
 	attached = rcu_dereference_protected(net->flow_dissector_prog,
 					     lockdep_is_held(&flow_dissector_mutex));
@@ -169,6 +167,24 @@ static __be16 skb_flow_get_be16(const st
 	return 0;
 }
 
+int skb_flow_dissector_bpf_prog_detach(const union bpf_attr *attr)
+{
+	return flow_dissector_bpf_prog_detach(current->nsproxy->net_ns);
+}
+
+static void __net_exit flow_dissector_pernet_pre_exit(struct net *net)
+{
+	/* We're not racing with attach/detach because there are no
+	 * references to netns left when pre_exit gets called.
+	 */
+	if (rcu_access_pointer(net->flow_dissector_prog))
+		flow_dissector_bpf_prog_detach(net);
+}
+
+static struct pernet_operations flow_dissector_pernet_ops __net_initdata = {
+	.pre_exit = flow_dissector_pernet_pre_exit,
+};
+
 /**
  * __skb_flow_get_ports - extract the upper layer ports and return them
  * @skb: sk_buff to extract the ports from
@@ -1759,7 +1775,7 @@ static int __init init_default_flow_diss
 	skb_flow_dissector_init(&flow_keys_basic_dissector,
 				flow_keys_basic_dissector_keys,
 				ARRAY_SIZE(flow_keys_basic_dissector_keys));
-	return 0;
-}
 
+	return register_pernet_subsys(&flow_dissector_pernet_ops);
+}
 core_initcall(init_default_flow_dissectors);


