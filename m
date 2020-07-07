Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63302217259
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728923AbgGGPbu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:31:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:35362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729897AbgGGPWn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:22:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F77720663;
        Tue,  7 Jul 2020 15:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135362;
        bh=ekFw6BZwMJUnbj0tXZ1gofNuSBihwYf9hUW4rRANOqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YCfOTBIY9Cfz6uj6ig/GFqFqsMSRO/kCW88QomXtJhaCSjmwrN6pTjJgM1TX2C3Kl
         xQhDS1Izw5iLsJ1wOtgM/VYduNhpkW2RMhRdKSQKxj3Wk1KmfV3AnlAHuovLqFU5pl
         3/WJUUYA7dH8AqbdDSQBOepOAa+DUmtkga5q5NkM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+e8c028b62439eac42073@syzkaller.appspotmail.com,
        YueHaibing <yuehaibing@huawei.com>,
        Ahmed Abdelsalam <ahabdels@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 011/112] seg6: fix seg6_validate_srh() to avoid slab-out-of-bounds
Date:   Tue,  7 Jul 2020 17:16:16 +0200
Message-Id: <20200707145801.534263483@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ahmed Abdelsalam <ahabdels@gmail.com>

[ Upstream commit bb986a50421a11bf31a81afb15b9b8f45a4a3a11 ]

The seg6_validate_srh() is used to validate SRH for three cases:

case1: SRH of data-plane SRv6 packets to be processed by the Linux kernel.
Case2: SRH of the netlink message received  from user-space (iproute2)
Case3: SRH injected into packets through setsockopt

In case1, the SRH can be encoded in the Reduced way (i.e., first SID is
carried in DA only and not represented as SID in the SRH) and the
seg6_validate_srh() now handles this case correctly.

In case2 and case3, the SRH shouldn’t be encoded in the Reduced way
otherwise we lose the first segment (i.e., the first hop).

The current implementation of the seg6_validate_srh() allow SRH of case2
and case3 to be encoded in the Reduced way. This leads a slab-out-of-bounds
problem.

This patch verifies SRH of case1, case2 and case3. Allowing case1 to be
reduced while preventing SRH of case2 and case3 from being reduced .

Reported-by: syzbot+e8c028b62439eac42073@syzkaller.appspotmail.com
Reported-by: YueHaibing <yuehaibing@huawei.com>
Fixes: 0cb7498f234e ("seg6: fix SRH processing to comply with RFC8754")
Signed-off-by: Ahmed Abdelsalam <ahabdels@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/seg6.h       |  2 +-
 net/core/filter.c        |  2 +-
 net/ipv6/ipv6_sockglue.c |  2 +-
 net/ipv6/seg6.c          | 16 ++++++++++------
 net/ipv6/seg6_iptunnel.c |  2 +-
 net/ipv6/seg6_local.c    |  6 +++---
 6 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/include/net/seg6.h b/include/net/seg6.h
index 640724b352731..9d19c15e8545c 100644
--- a/include/net/seg6.h
+++ b/include/net/seg6.h
@@ -57,7 +57,7 @@ extern void seg6_iptunnel_exit(void);
 extern int seg6_local_init(void);
 extern void seg6_local_exit(void);
 
-extern bool seg6_validate_srh(struct ipv6_sr_hdr *srh, int len);
+extern bool seg6_validate_srh(struct ipv6_sr_hdr *srh, int len, bool reduced);
 extern int seg6_do_srh_encap(struct sk_buff *skb, struct ipv6_sr_hdr *osrh,
 			     int proto);
 extern int seg6_do_srh_inline(struct sk_buff *skb, struct ipv6_sr_hdr *osrh);
diff --git a/net/core/filter.c b/net/core/filter.c
index 9512a9772d691..45fa65a289833 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4920,7 +4920,7 @@ static int bpf_push_seg6_encap(struct sk_buff *skb, u32 type, void *hdr, u32 len
 	int err;
 	struct ipv6_sr_hdr *srh = (struct ipv6_sr_hdr *)hdr;
 
-	if (!seg6_validate_srh(srh, len))
+	if (!seg6_validate_srh(srh, len, false))
 		return -EINVAL;
 
 	switch (type) {
diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index 5af97b4f5df30..ff187fd2083ff 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -458,7 +458,7 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 				struct ipv6_sr_hdr *srh = (struct ipv6_sr_hdr *)
 							  opt->srcrt;
 
-				if (!seg6_validate_srh(srh, optlen))
+				if (!seg6_validate_srh(srh, optlen, false))
 					goto sticky_done;
 				break;
 			}
diff --git a/net/ipv6/seg6.c b/net/ipv6/seg6.c
index 37b434293bda3..d2f8138e5a73a 100644
--- a/net/ipv6/seg6.c
+++ b/net/ipv6/seg6.c
@@ -25,7 +25,7 @@
 #include <net/seg6_hmac.h>
 #endif
 
-bool seg6_validate_srh(struct ipv6_sr_hdr *srh, int len)
+bool seg6_validate_srh(struct ipv6_sr_hdr *srh, int len, bool reduced)
 {
 	unsigned int tlv_offset;
 	int max_last_entry;
@@ -37,13 +37,17 @@ bool seg6_validate_srh(struct ipv6_sr_hdr *srh, int len)
 	if (((srh->hdrlen + 1) << 3) != len)
 		return false;
 
-	max_last_entry = (srh->hdrlen / 2) - 1;
-
-	if (srh->first_segment > max_last_entry)
+	if (!reduced && srh->segments_left > srh->first_segment) {
 		return false;
+	} else {
+		max_last_entry = (srh->hdrlen / 2) - 1;
 
-	if (srh->segments_left > srh->first_segment + 1)
-		return false;
+		if (srh->first_segment > max_last_entry)
+			return false;
+
+		if (srh->segments_left > srh->first_segment + 1)
+			return false;
+	}
 
 	tlv_offset = sizeof(*srh) + ((srh->first_segment + 1) << 4);
 
diff --git a/net/ipv6/seg6_iptunnel.c b/net/ipv6/seg6_iptunnel.c
index c7cbfeae94f5e..e0e9f48ab14fe 100644
--- a/net/ipv6/seg6_iptunnel.c
+++ b/net/ipv6/seg6_iptunnel.c
@@ -426,7 +426,7 @@ static int seg6_build_state(struct net *net, struct nlattr *nla,
 	}
 
 	/* verify that SRH is consistent */
-	if (!seg6_validate_srh(tuninfo->srh, tuninfo_len - sizeof(*tuninfo)))
+	if (!seg6_validate_srh(tuninfo->srh, tuninfo_len - sizeof(*tuninfo), false))
 		return -EINVAL;
 
 	newts = lwtunnel_state_alloc(tuninfo_len + sizeof(*slwt));
diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index 52493423f3299..eba23279912df 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -87,7 +87,7 @@ static struct ipv6_sr_hdr *get_srh(struct sk_buff *skb)
 	 */
 	srh = (struct ipv6_sr_hdr *)(skb->data + srhoff);
 
-	if (!seg6_validate_srh(srh, len))
+	if (!seg6_validate_srh(srh, len, true))
 		return NULL;
 
 	return srh;
@@ -495,7 +495,7 @@ bool seg6_bpf_has_valid_srh(struct sk_buff *skb)
 			return false;
 
 		srh->hdrlen = (u8)(srh_state->hdrlen >> 3);
-		if (!seg6_validate_srh(srh, (srh->hdrlen + 1) << 3))
+		if (!seg6_validate_srh(srh, (srh->hdrlen + 1) << 3, true))
 			return false;
 
 		srh_state->valid = true;
@@ -670,7 +670,7 @@ static int parse_nla_srh(struct nlattr **attrs, struct seg6_local_lwt *slwt)
 	if (len < sizeof(*srh) + sizeof(struct in6_addr))
 		return -EINVAL;
 
-	if (!seg6_validate_srh(srh, len))
+	if (!seg6_validate_srh(srh, len, false))
 		return -EINVAL;
 
 	slwt->srh = kmemdup(srh, len, GFP_KERNEL);
-- 
2.25.1



