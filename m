Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0D3EF06E
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387427AbfKDVt3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:49:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:40786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387420AbfKDVt2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:49:28 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BBFE214D8;
        Mon,  4 Nov 2019 21:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904168;
        bh=A/tP7fn3uXUKYltJg5iZEN3dR2cwHntAg7zHoHujsT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iLY9HQliyEev/3QW8+HJGgf9d982ltL8mCmAPBHtXnRruEDreYJHTr6oTOrwcfVvn
         bYUkycsAnOLENFGfz5iHBCrasK9yHiA9gZv3Q4gKMJSrP8oEaaDVU9QLLNy14jX5UV
         AWCvlzQHIv0zveaHbRoXLIDECRAXZRV1n1NtGU5k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Markus Theil <markus.theil@tu-ilmenau.de>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.4 36/46] nl80211: fix validation of mesh path nexthop
Date:   Mon,  4 Nov 2019 22:45:07 +0100
Message-Id: <20191104211909.532938772@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104211830.912265604@linuxfoundation.org>
References: <20191104211830.912265604@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Markus Theil <markus.theil@tu-ilmenau.de>

commit 1fab1b89e2e8f01204a9c05a39fd0b6411a48593 upstream.

Mesh path nexthop should be a ethernet address, but current validation
checks against 4 byte integers.

Cc: stable@vger.kernel.org
Fixes: 2ec600d672e74 ("nl80211/cfg80211: support for mesh, sta dumping")
Signed-off-by: Markus Theil <markus.theil@tu-ilmenau.de>
Link: https://lore.kernel.org/r/20191029093003.10355-1-markus.theil@tu-ilmenau.de
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/nl80211.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -292,7 +292,8 @@ static const struct nla_policy nl80211_p
 	[NL80211_ATTR_MNTR_FLAGS] = { /* NLA_NESTED can't be empty */ },
 	[NL80211_ATTR_MESH_ID] = { .type = NLA_BINARY,
 				   .len = IEEE80211_MAX_MESH_ID_LEN },
-	[NL80211_ATTR_MPATH_NEXT_HOP] = { .type = NLA_U32 },
+	[NL80211_ATTR_MPATH_NEXT_HOP] = { .type = NLA_BINARY,
+					  .len = ETH_ALEN },
 
 	[NL80211_ATTR_REG_ALPHA2] = { .type = NLA_STRING, .len = 2 },
 	[NL80211_ATTR_REG_RULES] = { .type = NLA_NESTED },


