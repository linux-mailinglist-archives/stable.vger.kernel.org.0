Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6B743A11A
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235672AbhJYThR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:37:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:53414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236311AbhJYTeQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:34:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA97D600D3;
        Mon, 25 Oct 2021 19:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190199;
        bh=Mayt8WWNnjzHeMKdc0UAkdpP5zCctwZ8VketLaO98Ew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1v6A+127RKeGhSH9EIL1A41z8gC1+el3hXdBBpJBRwGtpiNzOw8Db07XD7NVjjYi2
         YvPLTGdeog05uKYGDBXHKFJQPS8iWqVD6oPExZJCp0x3277OUfANecW75d84xknIea
         ajC4tArQ+rHRI31nhb/n87RA45+SiNPnd0ejfCyU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Xin Long <lucien.xin@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 16/95] netfilter: ip6t_rt: fix rt0_hdr parsing in rt_mt6
Date:   Mon, 25 Oct 2021 21:14:13 +0200
Message-Id: <20211025190959.263826408@linuxfoundation.org>
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

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit a482c5e00a9b5a194085bcd372ac36141028becb ]

In rt_mt6(), when it's a nonlinear skb, the 1st skb_header_pointer()
only copies sizeof(struct ipv6_rt_hdr) to _route that rh points to.
The access by ((const struct rt0_hdr *)rh)->reserved will overflow
the buffer. So this access should be moved below the 2nd call to
skb_header_pointer().

Besides, after the 2nd skb_header_pointer(), its return value should
also be checked, othersize, *rp may cause null-pointer-ref.

v1->v2:
  - clean up some old debugging log.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/netfilter/ip6t_rt.c | 48 +++++-------------------------------
 1 file changed, 6 insertions(+), 42 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_rt.c b/net/ipv6/netfilter/ip6t_rt.c
index 733c83d38b30..4ad8b2032f1f 100644
--- a/net/ipv6/netfilter/ip6t_rt.c
+++ b/net/ipv6/netfilter/ip6t_rt.c
@@ -25,12 +25,7 @@ MODULE_AUTHOR("Andras Kis-Szabo <kisza@sch.bme.hu>");
 static inline bool
 segsleft_match(u_int32_t min, u_int32_t max, u_int32_t id, bool invert)
 {
-	bool r;
-	pr_debug("segsleft_match:%c 0x%x <= 0x%x <= 0x%x\n",
-		 invert ? '!' : ' ', min, id, max);
-	r = (id >= min && id <= max) ^ invert;
-	pr_debug(" result %s\n", r ? "PASS" : "FAILED");
-	return r;
+	return (id >= min && id <= max) ^ invert;
 }
 
 static bool rt_mt6(const struct sk_buff *skb, struct xt_action_param *par)
@@ -65,30 +60,6 @@ static bool rt_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 		return false;
 	}
 
-	pr_debug("IPv6 RT LEN %u %u ", hdrlen, rh->hdrlen);
-	pr_debug("TYPE %04X ", rh->type);
-	pr_debug("SGS_LEFT %u %02X\n", rh->segments_left, rh->segments_left);
-
-	pr_debug("IPv6 RT segsleft %02X ",
-		 segsleft_match(rtinfo->segsleft[0], rtinfo->segsleft[1],
-				rh->segments_left,
-				!!(rtinfo->invflags & IP6T_RT_INV_SGS)));
-	pr_debug("type %02X %02X %02X ",
-		 rtinfo->rt_type, rh->type,
-		 (!(rtinfo->flags & IP6T_RT_TYP) ||
-		  ((rtinfo->rt_type == rh->type) ^
-		   !!(rtinfo->invflags & IP6T_RT_INV_TYP))));
-	pr_debug("len %02X %04X %02X ",
-		 rtinfo->hdrlen, hdrlen,
-		 !(rtinfo->flags & IP6T_RT_LEN) ||
-		  ((rtinfo->hdrlen == hdrlen) ^
-		   !!(rtinfo->invflags & IP6T_RT_INV_LEN)));
-	pr_debug("res %02X %02X %02X ",
-		 rtinfo->flags & IP6T_RT_RES,
-		 ((const struct rt0_hdr *)rh)->reserved,
-		 !((rtinfo->flags & IP6T_RT_RES) &&
-		   (((const struct rt0_hdr *)rh)->reserved)));
-
 	ret = (segsleft_match(rtinfo->segsleft[0], rtinfo->segsleft[1],
 			      rh->segments_left,
 			      !!(rtinfo->invflags & IP6T_RT_INV_SGS))) &&
@@ -107,22 +78,22 @@ static bool rt_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 						       reserved),
 					sizeof(_reserved),
 					&_reserved);
+		if (!rp) {
+			par->hotdrop = true;
+			return false;
+		}
 
 		ret = (*rp == 0);
 	}
 
-	pr_debug("#%d ", rtinfo->addrnr);
 	if (!(rtinfo->flags & IP6T_RT_FST)) {
 		return ret;
 	} else if (rtinfo->flags & IP6T_RT_FST_NSTRICT) {
-		pr_debug("Not strict ");
 		if (rtinfo->addrnr > (unsigned int)((hdrlen - 8) / 16)) {
-			pr_debug("There isn't enough space\n");
 			return false;
 		} else {
 			unsigned int i = 0;
 
-			pr_debug("#%d ", rtinfo->addrnr);
 			for (temp = 0;
 			     temp < (unsigned int)((hdrlen - 8) / 16);
 			     temp++) {
@@ -138,26 +109,20 @@ static bool rt_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 					return false;
 				}
 
-				if (ipv6_addr_equal(ap, &rtinfo->addrs[i])) {
-					pr_debug("i=%d temp=%d;\n", i, temp);
+				if (ipv6_addr_equal(ap, &rtinfo->addrs[i]))
 					i++;
-				}
 				if (i == rtinfo->addrnr)
 					break;
 			}
-			pr_debug("i=%d #%d\n", i, rtinfo->addrnr);
 			if (i == rtinfo->addrnr)
 				return ret;
 			else
 				return false;
 		}
 	} else {
-		pr_debug("Strict ");
 		if (rtinfo->addrnr > (unsigned int)((hdrlen - 8) / 16)) {
-			pr_debug("There isn't enough space\n");
 			return false;
 		} else {
-			pr_debug("#%d ", rtinfo->addrnr);
 			for (temp = 0; temp < rtinfo->addrnr; temp++) {
 				ap = skb_header_pointer(skb,
 							ptr
@@ -173,7 +138,6 @@ static bool rt_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 				if (!ipv6_addr_equal(ap, &rtinfo->addrs[temp]))
 					break;
 			}
-			pr_debug("temp=%d #%d\n", temp, rtinfo->addrnr);
 			if (temp == rtinfo->addrnr &&
 			    temp == (unsigned int)((hdrlen - 8) / 16))
 				return ret;
-- 
2.33.0



