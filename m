Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB2F4BE4A8
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:59:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351354AbiBUJuT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:50:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352877AbiBUJsA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:48:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF5D715A3F;
        Mon, 21 Feb 2022 01:20:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C63E60F93;
        Mon, 21 Feb 2022 09:20:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59372C340E9;
        Mon, 21 Feb 2022 09:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435243;
        bh=aNwa+d78H0BlGjxTMk0xgXffpMO5DvkRXR0EIe29Pc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=saZjobVN3Zhzt2Ae3s16daKs3JRpV3u6Qbpw59bf/gWUSEeJSflNg/nio6MocGtqA
         i9QvA2wrZ8OhoHFIIVX6sROIeKaKaYTUPxKXmPw90hzC7p7JrFB5XiEkw7iWsZrcep
         tNTz6fr2qfLx7o8mNDok5vjuUWPjlTnxehmCz6ss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Miri Korenblit <miriam.rachel.korenblit@intel.com>,
        Ye Guojin <ye.guojin@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 5.16 095/227] iwlwifi: fix iwl_legacy_rate_to_fw_idx
Date:   Mon, 21 Feb 2022 09:48:34 +0100
Message-Id: <20220221084938.040034033@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

commit 973f02c932b0be41a26bb9bdf38b7b92721611d2 upstream.

There are a couple of bugs in this function:

1. It is declared as a non-static function, even though
   it's only used in one file.
2. Its return value should be of type u32 but it returns
   (in some cases) -1.

Fix them by making this function static and returning an
error value of type unsigned.

In addition, we're assigning the return value of this function
as the legacy rate even if the function returned an error value.
Fix this by assigning the lowest rate in this case.

Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Reported-by: Ye Guojin <ye.guojin@zte.com.cn>
Reported-by: Zeal Robot <zealci@zte.com.cn>
Fixes: 9998f81e4ba5 ("iwlwifi: mvm: convert old rate & flags to the new format.")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/iwlwifi.20220128142706.5612eeb9d6d0.I992e10d93fc22919b2bc42daad087ee1b5d6f014@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/rs.h |    1 
 drivers/net/wireless/intel/iwlwifi/fw/rs.c     |   33 +++++++++++++------------
 2 files changed, 18 insertions(+), 16 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/fw/api/rs.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/rs.h
@@ -710,7 +710,6 @@ struct iwl_lq_cmd {
 
 u8 iwl_fw_rate_idx_to_plcp(int idx);
 u32 iwl_new_rate_from_v1(u32 rate_v1);
-u32 iwl_legacy_rate_to_fw_idx(u32 rate_n_flags);
 const struct iwl_rate_mcs_info *iwl_rate_mcs(int idx);
 const char *iwl_rs_pretty_ant(u8 ant);
 const char *iwl_rs_pretty_bw(int bw);
--- a/drivers/net/wireless/intel/iwlwifi/fw/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/rs.c
@@ -91,6 +91,20 @@ const char *iwl_rs_pretty_bw(int bw)
 }
 IWL_EXPORT_SYMBOL(iwl_rs_pretty_bw);
 
+static u32 iwl_legacy_rate_to_fw_idx(u32 rate_n_flags)
+{
+	int rate = rate_n_flags & RATE_LEGACY_RATE_MSK_V1;
+	int idx;
+	bool ofdm = !(rate_n_flags & RATE_MCS_CCK_MSK_V1);
+	int offset = ofdm ? IWL_FIRST_OFDM_RATE : 0;
+	int last = ofdm ? IWL_RATE_COUNT_LEGACY : IWL_FIRST_OFDM_RATE;
+
+	for (idx = offset; idx < last; idx++)
+		if (iwl_fw_rate_idx_to_plcp(idx) == rate)
+			return idx - offset;
+	return IWL_RATE_INVALID;
+}
+
 u32 iwl_new_rate_from_v1(u32 rate_v1)
 {
 	u32 rate_v2 = 0;
@@ -144,7 +158,10 @@ u32 iwl_new_rate_from_v1(u32 rate_v1)
 	} else {
 		u32 legacy_rate = iwl_legacy_rate_to_fw_idx(rate_v1);
 
-		WARN_ON(legacy_rate < 0);
+		if (WARN_ON_ONCE(legacy_rate == IWL_RATE_INVALID))
+			legacy_rate = (rate_v1 & RATE_MCS_CCK_MSK_V1) ?
+				IWL_FIRST_CCK_RATE : IWL_FIRST_OFDM_RATE;
+
 		rate_v2 |= legacy_rate;
 		if (!(rate_v1 & RATE_MCS_CCK_MSK_V1))
 			rate_v2 |= RATE_MCS_LEGACY_OFDM_MSK;
@@ -172,20 +189,6 @@ u32 iwl_new_rate_from_v1(u32 rate_v1)
 }
 IWL_EXPORT_SYMBOL(iwl_new_rate_from_v1);
 
-u32 iwl_legacy_rate_to_fw_idx(u32 rate_n_flags)
-{
-	int rate = rate_n_flags & RATE_LEGACY_RATE_MSK_V1;
-	int idx;
-	bool ofdm = !(rate_n_flags & RATE_MCS_CCK_MSK_V1);
-	int offset = ofdm ? IWL_FIRST_OFDM_RATE : 0;
-	int last = ofdm ? IWL_RATE_COUNT_LEGACY : IWL_FIRST_OFDM_RATE;
-
-	for (idx = offset; idx < last; idx++)
-		if (iwl_fw_rate_idx_to_plcp(idx) == rate)
-			return idx - offset;
-	return -1;
-}
-
 int rs_pretty_print_rate(char *buf, int bufsz, const u32 rate)
 {
 	char *type;


