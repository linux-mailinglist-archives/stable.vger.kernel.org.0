Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7465F4A43FB
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:26:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378441AbiAaLY0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:24:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376598AbiAaLVu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:21:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD6FAC0797B8;
        Mon, 31 Jan 2022 03:14:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8681E611D8;
        Mon, 31 Jan 2022 11:14:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F3C4C340E8;
        Mon, 31 Jan 2022 11:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627658;
        bh=zswzNO2HKzY+6xdUru5NZf7GVc9OVOevY31Jj/qwN88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sz9fR1IQjzxOxV77c2yPAnw0h4k4dDuhZRf+BuW4qkq/7rGQ86y3Ftnv/JxcaJNu9
         OMK3kojJOB684HZtV36bu63PY6YwBwPX7VpKFgu6/FBpVkXCk4CNayRc/4inKZt3kx
         lvkBJbmbKkB2He4YfBFv+2MdtdowWEvJ02twW7Vc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 155/171] Revert "ipv6: Honor all IPv6 PIO Valid Lifetime values"
Date:   Mon, 31 Jan 2022 11:57:00 +0100
Message-Id: <20220131105235.267308908@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Nault <gnault@redhat.com>

[ Upstream commit 36268983e90316b37000a005642af42234dabb36 ]

This reverts commit b75326c201242de9495ff98e5d5cff41d7fc0d9d.

This commit breaks Linux compatibility with USGv6 tests. The RFC this
commit was based on is actually an expired draft: no published RFC
currently allows the new behaviour it introduced.

Without full IETF endorsement, the flash renumbering scenario this
patch was supposed to enable is never going to work, as other IPv6
equipements on the same LAN will keep the 2 hours limit.

Fixes: b75326c20124 ("ipv6: Honor all IPv6 PIO Valid Lifetime values")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/addrconf.h |  2 ++
 net/ipv6/addrconf.c    | 27 ++++++++++++++++++++-------
 2 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/include/net/addrconf.h b/include/net/addrconf.h
index 78ea3e332688f..e7ce719838b5e 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -6,6 +6,8 @@
 #define RTR_SOLICITATION_INTERVAL	(4*HZ)
 #define RTR_SOLICITATION_MAX_INTERVAL	(3600*HZ)	/* 1 hour */
 
+#define MIN_VALID_LIFETIME		(2*3600)	/* 2 hours */
+
 #define TEMP_VALID_LIFETIME		(7*86400)
 #define TEMP_PREFERRED_LIFETIME		(86400)
 #define REGEN_MAX_RETRY			(3)
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 846037e73723f..bf13865426340 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2587,7 +2587,7 @@ int addrconf_prefix_rcv_add_addr(struct net *net, struct net_device *dev,
 				 __u32 valid_lft, u32 prefered_lft)
 {
 	struct inet6_ifaddr *ifp = ipv6_get_ifaddr(net, addr, dev, 1);
-	int create = 0;
+	int create = 0, update_lft = 0;
 
 	if (!ifp && valid_lft) {
 		int max_addresses = in6_dev->cnf.max_addresses;
@@ -2631,19 +2631,32 @@ int addrconf_prefix_rcv_add_addr(struct net *net, struct net_device *dev,
 		unsigned long now;
 		u32 stored_lft;
 
-		/* Update lifetime (RFC4862 5.5.3 e)
-		 * We deviate from RFC4862 by honoring all Valid Lifetimes to
-		 * improve the reaction of SLAAC to renumbering events
-		 * (draft-gont-6man-slaac-renum-06, Section 4.2)
-		 */
+		/* update lifetime (RFC2462 5.5.3 e) */
 		spin_lock_bh(&ifp->lock);
 		now = jiffies;
 		if (ifp->valid_lft > (now - ifp->tstamp) / HZ)
 			stored_lft = ifp->valid_lft - (now - ifp->tstamp) / HZ;
 		else
 			stored_lft = 0;
-
 		if (!create && stored_lft) {
+			const u32 minimum_lft = min_t(u32,
+				stored_lft, MIN_VALID_LIFETIME);
+			valid_lft = max(valid_lft, minimum_lft);
+
+			/* RFC4862 Section 5.5.3e:
+			 * "Note that the preferred lifetime of the
+			 *  corresponding address is always reset to
+			 *  the Preferred Lifetime in the received
+			 *  Prefix Information option, regardless of
+			 *  whether the valid lifetime is also reset or
+			 *  ignored."
+			 *
+			 * So we should always update prefered_lft here.
+			 */
+			update_lft = 1;
+		}
+
+		if (update_lft) {
 			ifp->valid_lft = valid_lft;
 			ifp->prefered_lft = prefered_lft;
 			ifp->tstamp = now;
-- 
2.34.1



