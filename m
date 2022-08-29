Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 726BC5A498C
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232076AbiH2L0L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:26:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231828AbiH2LYv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:24:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB60276477;
        Mon, 29 Aug 2022 04:15:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57D30B80EF9;
        Mon, 29 Aug 2022 11:15:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E69C433C1;
        Mon, 29 Aug 2022 11:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771710;
        bh=te7sInvU0bTNWg5iIS7SawPRIw8wZSbSzzBDD6te5pU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D1stDIjmke8YpApMd0ZUzwrysECjL8l2ecR4qMn/rDvbllNYPFafUpum3NPnF4hUH
         aeO9M9ee1qG1uqqXrJG4iC88JefdD1a7cqZ9Zd67urI+g6rQMszpXKK29DP26Dn2RY
         DrsQJ2X/z8/KeITAleaVKOS3YoZegSKMSfsZyaNg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 070/158] net: Fix data-races around sysctl_optmem_max.
Date:   Mon, 29 Aug 2022 12:58:40 +0200
Message-Id: <20220829105811.938696175@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
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
index 1b7f385643b4c..94374d529ea42 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -310,11 +310,12 @@ BPF_CALL_2(bpf_sk_storage_delete, struct bpf_map *, map, struct sock *, sk)
 static int bpf_sk_storage_charge(struct bpf_local_storage_map *smap,
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
index 60c854e7d98ba..063176428086b 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -1214,10 +1214,11 @@ void sk_filter_uncharge(struct sock *sk, struct sk_filter *fp)
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
@@ -1548,7 +1549,7 @@ int sk_reuseport_attach_filter(struct sock_fprog *fprog, struct sock *sk)
 	if (IS_ERR(prog))
 		return PTR_ERR(prog);
 
-	if (bpf_prog_size(prog->len) > sysctl_optmem_max)
+	if (bpf_prog_size(prog->len) > READ_ONCE(sysctl_optmem_max))
 		err = -ENOMEM;
 	else
 		err = reuseport_attach_prog(sk, prog);
@@ -1615,7 +1616,7 @@ int sk_reuseport_attach_bpf(u32 ufd, struct sock *sk)
 		}
 	} else {
 		/* BPF_PROG_TYPE_SOCKET_FILTER */
-		if (bpf_prog_size(prog->len) > sysctl_optmem_max) {
+		if (bpf_prog_size(prog->len) > READ_ONCE(sysctl_optmem_max)) {
 			err = -ENOMEM;
 			goto err_prog_put;
 		}
diff --git a/net/core/sock.c b/net/core/sock.c
index 62f69bc3a0e6e..d672e63a5c2d4 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2535,7 +2535,7 @@ struct sk_buff *sock_omalloc(struct sock *sk, unsigned long size,
 
 	/* small safe race: SKB_TRUESIZE may differ from final skb->truesize */
 	if (atomic_read(&sk->sk_omem_alloc) + SKB_TRUESIZE(size) >
-	    sysctl_optmem_max)
+	    READ_ONCE(sysctl_optmem_max))
 		return NULL;
 
 	skb = alloc_skb(size, priority);
@@ -2553,8 +2553,10 @@ struct sk_buff *sock_omalloc(struct sock *sk, unsigned long size,
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
index a8a323ecbb54b..e49a61a053a68 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -772,7 +772,7 @@ static int ip_set_mcast_msfilter(struct sock *sk, sockptr_t optval, int optlen)
 
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
@@ -1233,7 +1233,7 @@ static int do_ip_setsockopt(struct sock *sk, int level, int optname,
 
 		if (optlen < IP_MSFILTER_SIZE(0))
 			goto e_inval;
-		if (optlen > sysctl_optmem_max) {
+		if (optlen > READ_ONCE(sysctl_optmem_max)) {
 			err = -ENOBUFS;
 			break;
 		}
diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index 222f6bf220ba0..e0dcc7a193df2 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -210,7 +210,7 @@ static int ipv6_set_mcast_msfilter(struct sock *sk, sockptr_t optval,
 
 	if (optlen < GROUP_FILTER_SIZE(0))
 		return -EINVAL;
-	if (optlen > sysctl_optmem_max)
+	if (optlen > READ_ONCE(sysctl_optmem_max))
 		return -ENOBUFS;
 
 	gsf = memdup_sockptr(optval, optlen);
@@ -244,7 +244,7 @@ static int compat_ipv6_set_mcast_msfilter(struct sock *sk, sockptr_t optval,
 
 	if (optlen < size0)
 		return -EINVAL;
-	if (optlen > sysctl_optmem_max - 4)
+	if (optlen > READ_ONCE(sysctl_optmem_max) - 4)
 		return -ENOBUFS;
 
 	p = kmalloc(optlen + 4, GFP_KERNEL);
-- 
2.35.1



