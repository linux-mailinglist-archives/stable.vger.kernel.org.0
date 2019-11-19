Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 423C11018B6
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728265AbfKSF2f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:28:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:47042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728002AbfKSF2e (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:28:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BC30222DC;
        Tue, 19 Nov 2019 05:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141313;
        bh=S4hGAQcWq3BmNUikVDjThFlx+Q15Rqc902O6gvM3WAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KGH6GFIKkYHXtH0OzgnHDJdz9yl9p8dIgvyJ0RQw0q2FgMU03tG+nMxxd1sMvEf+u
         BTU5gn6M2l/VEWMvPalEUTIu/aKN7FzoALkls5Lf2iyHleY1bwg8etA/+eyuRW19Wn
         86gYcQhd9pN4eS5j4rBIbDASn+jhq5FWyL2imWNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Naftali Goldstein <naftali.goldstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 118/422] mac80211: fix saving a few HE values
Date:   Tue, 19 Nov 2019 06:15:15 +0100
Message-Id: <20191119051406.704137001@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naftali Goldstein <naftali.goldstein@intel.com>

[ Upstream commit 77cbbc35a49b75969d98edce9400beb21720aa39 ]

After masking the he_oper_params, to get the requested values as
integers one must rshift and not lshift.  Fix that by using the
le32_get_bits() macro.

Fixes: 41cbb0f5a295 ("mac80211: add support for HE")
Signed-off-by: Naftali Goldstein <naftali.goldstein@intel.com>
[converted to use le32_get_bits()]
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 5c9dcafbc3424..b0667467337d4 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3255,19 +3255,16 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (bss_conf->he_support) {
-		u32 he_oper_params =
-			le32_to_cpu(elems.he_operation->he_oper_params);
+		bss_conf->bss_color =
+			le32_get_bits(elems.he_operation->he_oper_params,
+				      IEEE80211_HE_OPERATION_BSS_COLOR_MASK);
 
-		bss_conf->bss_color = he_oper_params &
-				      IEEE80211_HE_OPERATION_BSS_COLOR_MASK;
 		bss_conf->htc_trig_based_pkt_ext =
-			(he_oper_params &
-			 IEEE80211_HE_OPERATION_DFLT_PE_DURATION_MASK) <<
-			IEEE80211_HE_OPERATION_DFLT_PE_DURATION_OFFSET;
+			le32_get_bits(elems.he_operation->he_oper_params,
+			      IEEE80211_HE_OPERATION_DFLT_PE_DURATION_MASK);
 		bss_conf->frame_time_rts_th =
-			(he_oper_params &
-			 IEEE80211_HE_OPERATION_RTS_THRESHOLD_MASK) <<
-			IEEE80211_HE_OPERATION_RTS_THRESHOLD_OFFSET;
+			le32_get_bits(elems.he_operation->he_oper_params,
+			      IEEE80211_HE_OPERATION_RTS_THRESHOLD_MASK);
 
 		bss_conf->multi_sta_back_32bit =
 			sta->sta.he_cap.he_cap_elem.mac_cap_info[2] &
-- 
2.20.1



