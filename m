Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18B13594883
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244020AbiHOXRp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:17:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346250AbiHOXOg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:14:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF7D5594;
        Mon, 15 Aug 2022 13:02:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0650612B8;
        Mon, 15 Aug 2022 20:02:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE897C433B5;
        Mon, 15 Aug 2022 20:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593725;
        bh=jHyMyMatRJhRmVNf5r/JBkCXflB3Luzqgobzqx62qoc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qWjtEheQqBmLyAE5E3pVNFYkMxaqw1LuJgnEEDnD8RyX6elk9SLMfyviByPwzguHX
         b5cKjfzxR7Ci5XTZ8sboOw/n9ccJ73dCSss8Q+L7oF23R7b9ROsLzuxaf0Vj8XJ1em
         wSh7yPMnLN5MhwHisyMlDN5eBvUoaUApgEAHTssY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Baochen Qiang <quic_bqiang@quicinc.com>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0316/1157] ath11k: Fix warning on variable sar dereference before check
Date:   Mon, 15 Aug 2022 19:54:32 +0200
Message-Id: <20220815180452.295650597@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Baochen Qiang <quic_bqiang@quicinc.com>

[ Upstream commit 77bbbd5e0ed3b5998a353b0948584faa4f565f0e ]

We are seeing below warning:
warn: variable dereferenced before check 'sar'

Fix it by moving ahead pointer check on 'sar'.

Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3

Fixes: 652f69ed9c1b ("ath11k: Add support for SAR")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20220517004844.2412660-1-quic_bqiang@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/mac.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index ee1590b16eff..7d574ad67e59 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -8297,11 +8297,15 @@ static int ath11k_mac_op_set_bios_sar_specs(struct ieee80211_hw *hw,
 					    const struct cfg80211_sar_specs *sar)
 {
 	struct ath11k *ar = hw->priv;
-	const struct cfg80211_sar_sub_specs *sspec = sar->sub_specs;
+	const struct cfg80211_sar_sub_specs *sspec;
 	int ret, index;
 	u8 *sar_tbl;
 	u32 i;
 
+	if (!sar || sar->type != NL80211_SAR_TYPE_POWER ||
+	    sar->num_sub_specs == 0)
+		return -EINVAL;
+
 	mutex_lock(&ar->conf_mutex);
 
 	if (!test_bit(WMI_TLV_SERVICE_BIOS_SAR_SUPPORT, ar->ab->wmi_ab.svc_map) ||
@@ -8310,12 +8314,6 @@ static int ath11k_mac_op_set_bios_sar_specs(struct ieee80211_hw *hw,
 		goto exit;
 	}
 
-	if (!sar || sar->type != NL80211_SAR_TYPE_POWER ||
-	    sar->num_sub_specs == 0) {
-		ret = -EINVAL;
-		goto exit;
-	}
-
 	ret = ath11k_wmi_pdev_set_bios_geo_table_param(ar);
 	if (ret) {
 		ath11k_warn(ar->ab, "failed to set geo table: %d\n", ret);
@@ -8328,6 +8326,7 @@ static int ath11k_mac_op_set_bios_sar_specs(struct ieee80211_hw *hw,
 		goto exit;
 	}
 
+	sspec = sar->sub_specs;
 	for (i = 0; i < sar->num_sub_specs; i++) {
 		if (sspec->freq_range_index >= (BIOS_SAR_TABLE_LEN >> 1)) {
 			ath11k_warn(ar->ab, "Ignore bad frequency index %u, max allowed %u\n",
-- 
2.35.1



