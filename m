Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C589529BB20
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:29:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1784510AbgJ0P5E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:57:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:53610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1803044AbgJ0PwG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:52:06 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A36F12225E;
        Tue, 27 Oct 2020 15:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813924;
        bh=f3mIBaTX5UcmzkqFWcYCbEA40V1tAclHvuZfTWZ31vQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=auJLwNiYGDZhGJK6DqtgBohBVLPnE7Jyq/qaHp4jU+cPy1WyymlCbXSlWqMBcGGdQ
         N0QPIE5yNOzY1D6DhsEdguSjLGPckUU2ubR4x2XYR48iG761O3NvNlEZ8fye2Qx2Ww
         pFtkElE8Ir2Fsopv+Zf0vWWzx14S+cz3oLIcdLuM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Pedersen <thomas@adapt-ip.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 675/757] mac80211: handle lack of sband->bitrates in rates
Date:   Tue, 27 Oct 2020 14:55:25 +0100
Message-Id: <20201027135522.195991411@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Pedersen <thomas@adapt-ip.com>

[ Upstream commit 8b783d104e7f40684333d2ec155fac39219beb2f ]

Even though a driver or mac80211 shouldn't produce a
legacy bitrate if sband->bitrates doesn't exist, don't
crash if that is the case either.

This fixes a kernel panic if station dump is run before
last_rate can be updated with a data frame when
sband->bitrates is missing (eg. in S1G bands).

Signed-off-by: Thomas Pedersen <thomas@adapt-ip.com>
Link: https://lore.kernel.org/r/20201005164522.18069-1-thomas@adapt-ip.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c      | 3 ++-
 net/mac80211/sta_info.c | 4 ++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 87fddd84c621e..82d516d117385 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -709,7 +709,8 @@ void sta_set_rate_info_tx(struct sta_info *sta,
 		u16 brate;
 
 		sband = ieee80211_get_sband(sta->sdata);
-		if (sband) {
+		WARN_ON_ONCE(sband && !sband->bitrates);
+		if (sband && sband->bitrates) {
 			brate = sband->bitrates[rate->idx].bitrate;
 			rinfo->legacy = DIV_ROUND_UP(brate, 1 << shift);
 		}
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index f2840d1d95cfb..fb4f2b9b294f0 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2122,6 +2122,10 @@ static void sta_stats_decode_rate(struct ieee80211_local *local, u32 rate,
 		int rate_idx = STA_STATS_GET(LEGACY_IDX, rate);
 
 		sband = local->hw.wiphy->bands[band];
+
+		if (WARN_ON_ONCE(!sband->bitrates))
+			break;
+
 		brate = sband->bitrates[rate_idx].bitrate;
 		if (rinfo->bw == RATE_INFO_BW_5)
 			shift = 2;
-- 
2.25.1



