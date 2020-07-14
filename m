Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3295B21FAF0
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 20:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730658AbgGNS5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:57:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:55260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730643AbgGNS5E (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:57:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 828C322A99;
        Tue, 14 Jul 2020 18:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594753024;
        bh=sbRmsv14hG+c/knYd16JUaQzs0Ea5HPaKXNDJTSuOz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iQUV/CmMLPTMtGfMGtGCAuTeWpiyF0N/UE+A9LNqhnU86O723DX6eDEVOY60/7k30
         xFpOz6upKPKfkta3i17vjR9WD1IcgoCO8MhqNFtvUt7jGY4n8GYBFdR324s7y6c2kY
         5MsvmkwlXnPSsPzP11+HM3a/kEGeC/NkXJAqgucY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 060/166] bpf, sockmap: RCU dereferenced psock may be used outside RCU block
Date:   Tue, 14 Jul 2020 20:43:45 +0200
Message-Id: <20200714184118.747651916@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

[ Upstream commit 8025751d4d55a2f32be6bdf825b6a80c299875f5 ]

If an ingress verdict program specifies message sizes greater than
skb->len and there is an ENOMEM error due to memory pressure we
may call the rcv_msg handler outside the strp_data_ready() caller
context. This is because on an ENOMEM error the strparser will
retry from a workqueue. The caller currently protects the use of
psock by calling the strp_data_ready() inside a rcu_read_lock/unlock
block.

But, in above workqueue error case the psock is accessed outside
the read_lock/unlock block of the caller. So instead of using
psock directly we must do a look up against the sk again to
ensure the psock is available.

There is an an ugly piece here where we must handle
the case where we paused the strp and removed the psock. On
psock removal we first pause the strparser and then remove
the psock. If the strparser is paused while an skb is
scheduled on the workqueue the skb will be dropped on the
flow and kfree_skb() is called. If the workqueue manages
to get called before we pause the strparser but runs the rcvmsg
callback after the psock is removed we will hit the unlikely
case where we run the sockmap rcvmsg handler but do not have
a psock. For now we will follow strparser logic and drop the
skb on the floor with skb_kfree(). This is ugly because the
data is dropped. To date this has not caused problems in practice
because either the application controlling the sockmap is
coordinating with the datapath so that skbs are "flushed"
before removal or we simply wait for the sock to be closed before
removing it.

This patch fixes the describe RCU bug and dropping the skb doesn't
make things worse. Future patches will improve this by allowing
the normal case where skbs are not merged to skip the strparser
altogether. In practice many (most?) use cases have no need to
merge skbs so its both a code complexity hit as seen above and
a performance issue. For example, in the Cilium case we always
set the strparser up to return sbks 1:1 without any merging and
have avoided above issues.

Fixes: e91de6afa81c1 ("bpf: Fix running sk_skb program types with ktls")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Link: https://lore.kernel.org/bpf/159312679888.18340.15248924071966273998.stgit@john-XPS-13-9370
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skmsg.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index c41ab6906b210..6a32a1fd34f8c 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -781,11 +781,18 @@ static void sk_psock_verdict_apply(struct sk_psock *psock,
 
 static void sk_psock_strp_read(struct strparser *strp, struct sk_buff *skb)
 {
-	struct sk_psock *psock = sk_psock_from_strp(strp);
+	struct sk_psock *psock;
 	struct bpf_prog *prog;
 	int ret = __SK_DROP;
+	struct sock *sk;
 
 	rcu_read_lock();
+	sk = strp->sk;
+	psock = sk_psock(sk);
+	if (unlikely(!psock)) {
+		kfree_skb(skb);
+		goto out;
+	}
 	prog = READ_ONCE(psock->progs.skb_verdict);
 	if (likely(prog)) {
 		skb_orphan(skb);
@@ -794,6 +801,7 @@ static void sk_psock_strp_read(struct strparser *strp, struct sk_buff *skb)
 		ret = sk_psock_map_verd(ret, tcp_skb_bpf_redirect_fetch(skb));
 	}
 	sk_psock_verdict_apply(psock, skb, ret);
+out:
 	rcu_read_unlock();
 }
 
-- 
2.25.1



