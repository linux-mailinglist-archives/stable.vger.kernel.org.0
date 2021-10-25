Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E76643A1B8
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236312AbhJYTl0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:41:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:58988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236429AbhJYTjV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:39:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20EF96109D;
        Mon, 25 Oct 2021 19:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190519;
        bh=/K5XDfW1ew+0puRi9FhlVY0jb+ciGrb2Sh4ZJFYmQjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SOeAWj+mIx/uczJ0ktiENmt+0jM1W/6W1b/y4XVS3w3jHMzazfdefUZMg7Hi3J0Ju
         cEfujIUizl9jqCHG/J4dJwE+hx8WECPA2DbjE9cbA8nk3sKUfgyIoV4a9BJFmMtRvw
         Xzzs0OGmT9A7NIXjTX+ElPmFP963FdEtrvjC4S2o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+664b58e9a40fbb2cec71@syzkaller.appspotmail.com,
        syzbot+33f36d0754d4c5c0e102@syzkaller.appspotmail.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.10 88/95] bpf, test, cgroup: Use sk_{alloc,free} for test cases
Date:   Mon, 25 Oct 2021 21:15:25 +0200
Message-Id: <20211025191009.530350596@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190956.374447057@linuxfoundation.org>
References: <20211025190956.374447057@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit 435b08ec0094ac1e128afe6cfd0d9311a8c617a7 upstream.

BPF test infra has some hacks in place which kzalloc() a socket and perform
minimum init via sock_net_set() and sock_init_data(). As a result, the sk's
skcd->cgroup is NULL since it didn't go through proper initialization as it
would have been the case from sk_alloc(). Rather than re-adding a NULL test
in sock_cgroup_ptr() just for this, use sk_{alloc,free}() pair for the test
socket. The latter also allows to get rid of the bpf_sk_storage_free() special
case.

Fixes: 8520e224f547 ("bpf, cgroups: Fix cgroup v2 fallback on v1/v2 mixed mode")
Fixes: b7a1848e8398 ("bpf: add BPF_PROG_TEST_RUN support for flow dissector")
Fixes: 2cb494a36c98 ("bpf: add tests for direct packet access from CGROUP_SKB")
Reported-by: syzbot+664b58e9a40fbb2cec71@syzkaller.appspotmail.com
Reported-by: syzbot+33f36d0754d4c5c0e102@syzkaller.appspotmail.com
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Tested-by: syzbot+664b58e9a40fbb2cec71@syzkaller.appspotmail.com
Tested-by: syzbot+33f36d0754d4c5c0e102@syzkaller.appspotmail.com
Link: https://lore.kernel.org/bpf/20210927123921.21535-2-daniel@iogearbox.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bpf/test_run.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -481,6 +481,12 @@ static void convert_skb_to___skb(struct
 	__skb->gso_segs = skb_shinfo(skb)->gso_segs;
 }
 
+static struct proto bpf_dummy_proto = {
+	.name   = "bpf_dummy",
+	.owner  = THIS_MODULE,
+	.obj_size = sizeof(struct sock),
+};
+
 int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 			  union bpf_attr __user *uattr)
 {
@@ -525,20 +531,19 @@ int bpf_prog_test_run_skb(struct bpf_pro
 		break;
 	}
 
-	sk = kzalloc(sizeof(struct sock), GFP_USER);
+	sk = sk_alloc(net, AF_UNSPEC, GFP_USER, &bpf_dummy_proto, 1);
 	if (!sk) {
 		kfree(data);
 		kfree(ctx);
 		return -ENOMEM;
 	}
-	sock_net_set(sk, net);
 	sock_init_data(NULL, sk);
 
 	skb = build_skb(data, 0);
 	if (!skb) {
 		kfree(data);
 		kfree(ctx);
-		kfree(sk);
+		sk_free(sk);
 		return -ENOMEM;
 	}
 	skb->sk = sk;
@@ -611,8 +616,7 @@ out:
 	if (dev && dev != net->loopback_dev)
 		dev_put(dev);
 	kfree_skb(skb);
-	bpf_sk_storage_free(sk);
-	kfree(sk);
+	sk_free(sk);
 	kfree(ctx);
 	return ret;
 }


