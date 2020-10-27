Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6CC329B50D
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:12:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1793708AbgJ0PH4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:07:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:34544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1762585AbgJ0PAx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:00:53 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49D8220714;
        Tue, 27 Oct 2020 15:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810851;
        bh=DDF0I1k5C+unUaX+r+5FEtnY69aKSSDIEB+xmGaIxPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ka/Zjri62s0Z3k9VoluRfmN16GT6/UgADrvcNnYe9FQc7mBxUDyoZ0xPCkZ9OnMqB
         VjSf9hgC0xxE859pYeShmlLMc7XL2dZCPI9/iKP8jCjsZp5LHDAjFJs+VL0qG3eytS
         y6zWMgFOJvfjLYFTEEHPKSWUiR1V8guoiAEctHPA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 278/633] nl80211: fix OBSS PD min and max offset validation
Date:   Tue, 27 Oct 2020 14:50:21 +0100
Message-Id: <20201027135535.712418669@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rajkumar Manoharan <rmanohar@codeaurora.org>

[ Upstream commit 6c8b6e4a5f745ec49286ac0a3f1d591a34818f82 ]

The SRG min and max offset won't present when SRG Information Present of
SR control field of Spatial Reuse Parameter Set element set to 0. Per
spec. IEEE802.11ax D7.0, SRG OBSS PD Min Offset ≤ SRG OBSS PD Max
Offset. Hence fix the constrain check to allow same values in both
offset and also call appropriate nla_get function to read the values.

Fixes: 796e90f42b7e ("cfg80211: add support for parsing OBBS_PD attributes")
Signed-off-by: Rajkumar Manoharan <rmanohar@codeaurora.org>
Link: https://lore.kernel.org/r/1601278091-20313-1-git-send-email-rmanohar@codeaurora.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 4d7b255067225..7cbb94b4d4917 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4683,16 +4683,14 @@ static int nl80211_parse_he_obss_pd(struct nlattr *attrs,
 	if (err)
 		return err;
 
-	if (!tb[NL80211_HE_OBSS_PD_ATTR_MIN_OFFSET] ||
-	    !tb[NL80211_HE_OBSS_PD_ATTR_MAX_OFFSET])
-		return -EINVAL;
-
-	he_obss_pd->min_offset =
-		nla_get_u32(tb[NL80211_HE_OBSS_PD_ATTR_MIN_OFFSET]);
-	he_obss_pd->max_offset =
-		nla_get_u32(tb[NL80211_HE_OBSS_PD_ATTR_MAX_OFFSET]);
-
-	if (he_obss_pd->min_offset >= he_obss_pd->max_offset)
+	if (tb[NL80211_HE_OBSS_PD_ATTR_MIN_OFFSET])
+		he_obss_pd->min_offset =
+			nla_get_u8(tb[NL80211_HE_OBSS_PD_ATTR_MIN_OFFSET]);
+	if (tb[NL80211_HE_OBSS_PD_ATTR_MAX_OFFSET])
+		he_obss_pd->max_offset =
+			nla_get_u8(tb[NL80211_HE_OBSS_PD_ATTR_MAX_OFFSET]);
+
+	if (he_obss_pd->min_offset > he_obss_pd->max_offset)
 		return -EINVAL;
 
 	he_obss_pd->enable = true;
-- 
2.25.1



