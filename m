Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39D5524BA36
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727792AbgHTMCl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:02:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:46310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730437AbgHTJ7q (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:59:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40701207FB;
        Thu, 20 Aug 2020 09:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917585;
        bh=MQEJ/9DrOxqDIpB95RQkneAyDumTBMEidzaunoBkBAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qwtxM0ol2v2ytflgZx2HhH+cgCPz1l2jK5KXRpeYbW1W0kl4zkB/5cN4wYOKf0KAi
         QBcx1kJfoys+xrbQY5afeHoYtUzW6k/2UsZb4aDsNsqVZg6xnM6001SBtuoGSRyUcF
         nRP1z0W1uZHk6eORTfkNa5Twtu6hWU+djXoGvB6g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Squires <julian@cipht.net>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 066/212] cfg80211: check vendor command doit pointer before use
Date:   Thu, 20 Aug 2020 11:20:39 +0200
Message-Id: <20200820091605.703291165@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091602.251285210@linuxfoundation.org>
References: <20200820091602.251285210@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Squires <julian@cipht.net>

[ Upstream commit 4052d3d2e8f47a15053320bbcbe365d15610437d ]

In the case where a vendor command does not implement doit, and has no
flags set, doit would not be validated and a NULL pointer dereference
would occur, for example when invoking the vendor command via iw.

I encountered this while developing new vendor commands.  Perhaps in
practice it is advisable to always implement doit along with dumpit,
but it seems reasonable to me to always check doit anyway, not just
when NEED_WDEV.

Signed-off-by: Julian Squires <julian@cipht.net>
Link: https://lore.kernel.org/r/20200706211353.2366470-1-julian@cipht.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 0048f90944ddf..e107754e29a77 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -11317,13 +11317,13 @@ static int nl80211_vendor_cmd(struct sk_buff *skb, struct genl_info *info)
 				if (!wdev->netdev && !wdev->p2p_started)
 					return -ENETDOWN;
 			}
-
-			if (!vcmd->doit)
-				return -EOPNOTSUPP;
 		} else {
 			wdev = NULL;
 		}
 
+		if (!vcmd->doit)
+			return -EOPNOTSUPP;
+
 		if (info->attrs[NL80211_ATTR_VENDOR_DATA]) {
 			data = nla_data(info->attrs[NL80211_ATTR_VENDOR_DATA]);
 			len = nla_len(info->attrs[NL80211_ATTR_VENDOR_DATA]);
-- 
2.25.1



