Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C26E6318E2A
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbhBKPWX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:22:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:52632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230213AbhBKPSV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:18:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DA5664F17;
        Thu, 11 Feb 2021 15:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613055963;
        bh=QzJeBS0buSUYwMAuGzi1I4Qv2WP5kLvvJR19riZnNOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tgZaZrFLUv54pfVUCK29Zsbqj9e2T95tR2+yfqogV0zEK8Bz1D9Gt4GqEH4rkUPs1
         bYVWu2DYu2rel8GSERyaCG6nnWhCio8oEqpyaqOdgK1JpNDJHwQUmjVOK1OHw0fdqv
         s2iGjO0Quhr2FPpSRaS5Cz7+QnyeJlj4odSRumHo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aviad Brikman <aviad.brikman@celeno.com>,
        Shay Bar <shay.bar@celeno.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 04/24] mac80211: 160MHz with extended NSS BW in CSA
Date:   Thu, 11 Feb 2021 16:02:27 +0100
Message-Id: <20210211150148.714624454@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210211150148.516371325@linuxfoundation.org>
References: <20210211150148.516371325@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shay Bar <shay.bar@celeno.com>

[ Upstream commit dcf3c8fb32ddbfa3b8227db38aa6746405bd4527 ]

Upon receiving CSA with 160MHz extended NSS BW from associated AP,
STA should set the HT operation_mode based on new_center_freq_seg1
because it is later used as ccfs2 in ieee80211_chandef_vht_oper().

Signed-off-by: Aviad Brikman <aviad.brikman@celeno.com>
Signed-off-by: Shay Bar <shay.bar@celeno.com>
Link: https://lore.kernel.org/r/20201222064714.24888-1-shay.bar@celeno.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/spectmgmt.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/spectmgmt.c b/net/mac80211/spectmgmt.c
index 5fe2b645912f6..132f8423addaa 100644
--- a/net/mac80211/spectmgmt.c
+++ b/net/mac80211/spectmgmt.c
@@ -132,16 +132,20 @@ int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (wide_bw_chansw_ie) {
+		u8 new_seg1 = wide_bw_chansw_ie->new_center_freq_seg1;
 		struct ieee80211_vht_operation vht_oper = {
 			.chan_width =
 				wide_bw_chansw_ie->new_channel_width,
 			.center_freq_seg0_idx =
 				wide_bw_chansw_ie->new_center_freq_seg0,
-			.center_freq_seg1_idx =
-				wide_bw_chansw_ie->new_center_freq_seg1,
+			.center_freq_seg1_idx = new_seg1,
 			/* .basic_mcs_set doesn't matter */
 		};
-		struct ieee80211_ht_operation ht_oper = {};
+		struct ieee80211_ht_operation ht_oper = {
+			.operation_mode =
+				cpu_to_le16(new_seg1 <<
+					    IEEE80211_HT_OP_MODE_CCFS2_SHIFT),
+		};
 
 		/* default, for the case of IEEE80211_VHT_CHANWIDTH_USE_HT,
 		 * to the previously parsed chandef
-- 
2.27.0



