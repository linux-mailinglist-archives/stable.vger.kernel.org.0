Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A55A5A48A6
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231337AbiH2LN2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbiH2LMm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:12:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 904D26D54D;
        Mon, 29 Aug 2022 04:08:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF6FD6119A;
        Mon, 29 Aug 2022 11:08:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF039C433D6;
        Mon, 29 Aug 2022 11:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771335;
        bh=FBjnolGWm8I+ACwCNQKR8MFQwuJvon39dOzEFnY0FHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ARvdstuRp+zB2P5nQCIoMBlkn2qXn6nIrhKsG1peQxeJ62msYG7HZW+jJCehE74g4
         vzBmjpdWQueMsBcAbXA3Tvkd4I6i2HLayrHGKheAsLguR/glzktyOeMNqLEFZLp2yq
         955cqUQWLJChi9NpUWM+Q7u7nJoHg2+FuTz/8JMY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 52/86] net: Fix data-races around sysctl_optmem_max.
Date:   Mon, 29 Aug 2022 12:59:18 +0200
Message-Id: <20220829105758.668117902@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105756.500128871@linuxfoundation.org>
References: <20220829105756.500128871@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 7de6d09f51917c829af2b835aba8bb5040f8e86a ]

While reading sysctl_optmem_max, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its readers.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/bpf_sk_storage.c | 5 +++--
 net/core/filter.c         | 9 +++++----
 net/core/sock.c           | 8 +++++---
 net/ipv4/ip_sockglue.c    | 6 +++---
 net/ipv6/ipv6_sockglue.c  | 4 ++--
 5 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index 39c5a059d1c2b..d67d06d6b817c 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -304,11 +304,12 @@ BPF_CALL_2(bpf_sk_storage_delete, struct bpf_map *, map, struct sock *, sk)
 static int sk_storage_charge(struct bpf_local_storage_map *smap,
 			     void *owner, u32 size)
 {
+	int optmem_max = READ_ONCE(sysctl_optmem_max);
 	struct sock *sk = (struct sock *)owner;
 
 	/* same check as in sock_kmalloc() */
-	if (size <= sysctl_optmem_max &&
-	    atomic_read(&sk->sk_omem_alloc) + size < sysctl_optmem_max) {
+	if (size <= optmem_max &&
+	    atomic_read(&sk->sk_omem_alloc) + size < optmem_max) {
 		atomic_add(size, &sk->sk_omem_alloc);
 		return 0;
 	}
diff --git a/net/core/filter.c b/net/core/filter.c
index 6a90c1eb6f67e..4c22e6d1da746 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -1212,10 +1212,11 @@ void sk_filter_uncharge(struct sock *sk, struct sk_filter *fp)
 static bool __sk_filter_charge(struct sock *sk, struct sk_filter *fp)
 {
 	u32 filter_size = bpf_prog_size(fp->prog->len);
+	int optmem_max = READ_ONCE(sysctl_optmem_max);
 
 	/* same check as in sock_kmalloc() */
-	if (filter_size <= sysctl_optmem_max &&
-	    atomic_read(&sk->sk_omem_alloc) + filter_size < sysctl_optmem_max) {
+	if (filter_size <= optmem_max &&
+	    atomic_read(&sk->sk_omem_alloc) + filter_size < optmem_max) {
 		atomic_add(filter_size, &sk->sk_omem_alloc);
 		return true;
 	}
@@ -1547,7 +1548,7 @@ int sk_reuseport_attach_filter(struct sock_fprog *fprog, struct sock *sk)
 	if (IS_ERR(prog))
 		return PTR_ERR(prog);
 
-	if (bpf_prog_size(prog->len) > sysctl_optmem_max)
+	if (bpf_prog_size(prog->len) > READ_ONCE(sysctl_optmem_max))
 		err = -ENOMEM;
 	else
 		err = reuseport_attach_prog(sk, prog);
@@ -1614,7 +1615,7 @@ int sk_reuseport_attach_bpf(u32 ufd, struct sock *sk)
 		}
 	} else {
 		/* BPF_PROG_TYPE_SOCKET_FILTER */
-		if (bpf_prog_size(prog->len) > sysctl_optmem_max) {
+		if (bpf_prog_size(prog->len) > READ_ONCE(sysctl_optmem_max)) {
 			err = -ENOMEM;
 			goto err_prog_put;
 		}
diff --git a/net/core/sock.c b/net/core/sock.c
index 25d25dcd0c3db..f01e71c98d5be 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2219,7 +2219,7 @@ struct sk_buff *sock_omalloc(struct sock *sk, unsigned long size,
 
 	/* small safe race: SKB_TRUESIZE may differ from final skb->truesize */
 	if (atomic_read(&sk->sk_omem_alloc) + SKB_TRUESIZE(size) >
-	    sysctl_optmem_max)
+	    READ_ONCE(sysctl_optmem_max))
 		return NULL;
 
 	skb = alloc_skb(size, priority);
@@ -2237,8 +2237,10 @@ struct sk_buff *sock_omalloc(struct sock *sk, unsigned long size,
  */
 void *sock_kmalloc(struct sock *sk, int size, gfp_t priority)
 {
-	if ((unsigned int)size <= sysctl_optmem_max &&
-	    atomic_read(&sk->sk_omem_alloc) + size < sysctl_optmem_max) {
+	int optmem_max = READ_ONCE(sysctl_optmem_max);
+
+	if ((unsigned int)size <= optmem_max &&
+	    atomic_read(&sk->sk_omem_alloc) + size < optmem_max) {
 		void *mem;
 		/* First do the add, to avoid the race if kmalloc
 		 * might sleep.
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index 22507a6a3f71c..4cc39c62af55d 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -773,7 +773,7 @@ static int ip_set_mcast_msfilter(struct sock *sk, sockptr_t optval, int optlen)
 
 	if (optlen < GROUP_FILTER_SIZE(0))
 		return -EINVAL;
-	if (optlen > sysctl_optmem_max)
+	if (optlen > READ_ONCE(sysctl_optmem_max))
 		return -ENOBUFS;
 
 	gsf = memdup_sockptr(optval, optlen);
@@ -808,7 +808,7 @@ static int compat_ip_set_mcast_msfilter(struct sock *sk, sockptr_t optval,
 
 	if (optlen < size0)
 		return -EINVAL;
-	if (optlen > sysctl_optmem_max - 4)
+	if (optlen > READ_ONCE(sysctl_optmem_max) - 4)
 		return -ENOBUFS;
 
 	p = kmalloc(optlen + 4, GFP_KERNEL);
@@ -1231,7 +1231,7 @@ static int do_ip_setsockopt(struct sock *sk, int level, int optname,
 
 		if (optlen < IP_MSFILTER_SIZE(0))
 			goto e_inval;
-		if (optlen > sysctl_optmem_max) {
+		if (optlen > READ_ONCE(sysctl_optmem_max)) {
 			err = -ENOBUFS;
 			break;
 		}
diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index 43a894bf9a1be..6fa118bf40cdd 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -208,7 +208,7 @@ static int ipv6_set_mcast_msfilter(struct sock *sk, sockptr_t optval,
 
 	if (optlen < GROUP_FILTER_SIZE(0))
 		return -EINVAL;
-	if (optlen > sysctl_optmem_max)
+	if (optlen > READ_ONCE(sysctl_optmem_max))
 		return -ENOBUFS;
 
 	gsf = memdup_sockptr(optval, optlen);
@@ -242,7 +242,7 @@ static int compat_ipv6_set_mcast_msfilter(struct sock *sk, sockptr_t optval,
 
 	if (optlen < size0)
 		return -EINVAL;
-	if (optlen > sysctl_optmem_max - 4)
+	if (optlen > READ_ONCE(sysctl_optmem_max) - 4)
 		return -ENOBUFS;
 
 	p = kmalloc(optlen + 4, GFP_KERNEL);
-- 
2.35.1



