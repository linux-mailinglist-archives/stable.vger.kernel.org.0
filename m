Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C398F27C734
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730714AbgI2LwB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:52:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:50254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730437AbgI2LsK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:48:10 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98CB321941;
        Tue, 29 Sep 2020 11:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601380087;
        bh=F9v5U96bzuyXYvFJ083FRdwS917633WDmhaRKpPm8L0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pcBkMuLIJkmqKGUcikPsME2+g+dqp0ihHpb6qCGdSANSnBT5JWTBq3DNtaIcL7jVB
         ntO+SYoVujXNSOOQORWA4aqSJia7Rv7QpHjnmX0LITfGkCzH3cFPFk5OnbGVltz1PT
         S7/2N2k1/GiWU+zDT0x2wq75vYLq/0H9WSasSm94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Gong <wgong@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 54/99] mac80211: do not disable HE if HT is missing on 2.4 GHz
Date:   Tue, 29 Sep 2020 13:01:37 +0200
Message-Id: <20200929105932.380313962@linuxfoundation.org>
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

From: Wen Gong <wgong@codeaurora.org>

[ Upstream commit 780a8c9efc65f6d86acd44794495cedcd32eeb26 ]

VHT is not supported on 2.4 GHz, but HE is; don't disable HE if HT
is missing there, do that only on 5 GHz (6 GHz is only HE).

Fixes: 57fa5e85d53ce51 ("mac80211: determine chandef from HE 6 GHz operation")
Signed-off-by: Wen Gong <wgong@codeaurora.org>
Link: https://lore.kernel.org/r/010101747cb617f2-593c5410-1648-4a42-97a0-f3646a5a6dd1-000000@us-west-2.amazonses.com
[rewrite the commit message]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index b2a9d47cf86dd..c85186799d059 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4853,6 +4853,7 @@ static int ieee80211_prep_channel(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_supported_band *sband;
 	struct cfg80211_chan_def chandef;
 	bool is_6ghz = cbss->channel->band == NL80211_BAND_6GHZ;
+	bool is_5ghz = cbss->channel->band == NL80211_BAND_5GHZ;
 	struct ieee80211_bss *bss = (void *)cbss->priv;
 	int ret;
 	u32 i;
@@ -4871,7 +4872,7 @@ static int ieee80211_prep_channel(struct ieee80211_sub_if_data *sdata,
 		ifmgd->flags |= IEEE80211_STA_DISABLE_HE;
 	}
 
-	if (!sband->vht_cap.vht_supported && !is_6ghz) {
+	if (!sband->vht_cap.vht_supported && is_5ghz) {
 		ifmgd->flags |= IEEE80211_STA_DISABLE_VHT;
 		ifmgd->flags |= IEEE80211_STA_DISABLE_HE;
 	}
-- 
2.25.1



