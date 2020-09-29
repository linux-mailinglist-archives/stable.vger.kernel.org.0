Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBB3B27C714
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731187AbgI2LtB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:49:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:51782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730987AbgI2Ls4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:48:56 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB2702074A;
        Tue, 29 Sep 2020 11:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601380136;
        bh=VQ4uWf4bw04QSq1Hr9QWlEphd7mef1m+0p9YY6gJILY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r692rr1Tv+VryWhnkKuBCkdgtvHNjhnXqS2SM4YAv7fUhvNxmtWrwPmZVN963O/U5
         0L1zBUM1Zqs8XrqUk5bbd23xWg180ESbmkxomN71fQ3uW0ksC2P7mnTZYIIuULojPQ
         9MuDHo1+CTiI35Th1/eRubf64OSDdnzsyJrdb/Go=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Crispin <john@phrozen.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 56/99] mac80211: fix 80 MHz association to 160/80+80 AP on 6 GHz
Date:   Tue, 29 Sep 2020 13:01:39 +0200
Message-Id: <20200929105932.484101409@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105929.719230296@linuxfoundation.org>
References: <20200929105929.719230296@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Crispin <john@phrozen.org>

[ Upstream commit 75bcbd6913de649601f4e7d3fb6d2b5effc24e9e ]

When trying to associate to an AP support 180 or 80+80 MHz on 6 GHz with a
STA that only has 80 Mhz support the cf2 field inside the chandef will get
set causing the association to fail when trying to validate the chandef.
Fix this by checking the support flags prior to setting cf2.

Fixes: 57fa5e85d53ce ("mac80211: determine chandef from HE 6 GHz operation")
Signed-off-by: John Crispin <john@phrozen.org>
Link: https://lore.kernel.org/r/20200918115304.1135693-1-john@phrozen.org
[reword commit message a bit]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/util.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index dd9f5c7a1ade6..7b1f3645603ca 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -3354,9 +3354,10 @@ bool ieee80211_chandef_he_6ghz_oper(struct ieee80211_sub_if_data *sdata,
 		he_chandef.center_freq1 =
 			ieee80211_channel_to_frequency(he_6ghz_oper->ccfs0,
 						       NL80211_BAND_6GHZ);
-		he_chandef.center_freq2 =
-			ieee80211_channel_to_frequency(he_6ghz_oper->ccfs1,
-						       NL80211_BAND_6GHZ);
+		if (support_80_80 || support_160)
+			he_chandef.center_freq2 =
+				ieee80211_channel_to_frequency(he_6ghz_oper->ccfs1,
+							       NL80211_BAND_6GHZ);
 	}
 
 	if (!cfg80211_chandef_valid(&he_chandef)) {
-- 
2.25.1



