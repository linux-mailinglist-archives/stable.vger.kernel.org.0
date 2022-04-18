Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 107A0505262
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232572AbiDRMlj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240821AbiDRMjj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:39:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51E55BEC;
        Mon, 18 Apr 2022 05:30:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04089B80ED6;
        Mon, 18 Apr 2022 12:30:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AD4AC385A7;
        Mon, 18 Apr 2022 12:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285052;
        bh=PegEbT3n0i2LdUmAqbH0lGb/v7kofzcUA1BCGaGp0fs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IttAV4hHuVVIiUL0PeCR8FzemweEL5ZJlYAvuGSHAShNRnVcE01lRM34NZXRLIuR8
         RQPUfsRonTXPYXY+Q7B4XdOtQR2YVaEzNilknlnvpC+Hsq/IF0DaUPO0chOHTrND1A
         VqmRC1bEHgMQb4Ag+MF2m0kUpTtZFDUfPtRnH8pg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anilkumar Kolli <quic_akolli@quicinc.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 059/189] Revert "ath11k: mesh: add support for 256 bitmap in blockack frames in 11ax"
Date:   Mon, 18 Apr 2022 14:11:19 +0200
Message-Id: <20220418121202.185148438@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anilkumar Kolli <quic_akolli@quicinc.com>

[ Upstream commit 10cb21f4ff3f9cb36d1e1c39bf80426f02f4986a ]

This reverts commit 743b9065fe6348a5f8f5ce04869ce2d701e5e1bc.

The original commit breaks the 256 bitmap in blockack frames in AP
mode. After reverting the commit the feature works again in both AP and
mesh modes

Tested-on: IPQ8074 hw2.0 PCI WLAN.HK.2.6.0.1-00786-QCAHKSWPL_SILICONZ-1

Fixes: 743b9065fe63 ("ath11k: mesh: add support for 256 bitmap in blockack frames in 11ax")
Signed-off-by: Anilkumar Kolli <quic_akolli@quicinc.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/1648701477-16367-1-git-send-email-quic_akolli@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/mac.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 3834be158705..07004564a3ec 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -2156,6 +2156,19 @@ static void ath11k_mac_op_bss_info_changed(struct ieee80211_hw *hw,
 		if (ret)
 			ath11k_warn(ar->ab, "failed to update bcn template: %d\n",
 				    ret);
+		if (vif->bss_conf.he_support) {
+			ret = ath11k_wmi_vdev_set_param_cmd(ar, arvif->vdev_id,
+							    WMI_VDEV_PARAM_BA_MODE,
+							    WMI_BA_MODE_BUFFER_SIZE_256);
+			if (ret)
+				ath11k_warn(ar->ab,
+					    "failed to set BA BUFFER SIZE 256 for vdev: %d\n",
+					    arvif->vdev_id);
+			else
+				ath11k_dbg(ar->ab, ATH11K_DBG_MAC,
+					   "Set BA BUFFER SIZE 256 for VDEV: %d\n",
+					   arvif->vdev_id);
+		}
 	}
 
 	if (changed & (BSS_CHANGED_BEACON_INFO | BSS_CHANGED_BEACON)) {
@@ -2191,14 +2204,6 @@ static void ath11k_mac_op_bss_info_changed(struct ieee80211_hw *hw,
 
 		if (arvif->is_up && vif->bss_conf.he_support &&
 		    vif->bss_conf.he_oper.params) {
-			ret = ath11k_wmi_vdev_set_param_cmd(ar, arvif->vdev_id,
-							    WMI_VDEV_PARAM_BA_MODE,
-							    WMI_BA_MODE_BUFFER_SIZE_256);
-			if (ret)
-				ath11k_warn(ar->ab,
-					    "failed to set BA BUFFER SIZE 256 for vdev: %d\n",
-					    arvif->vdev_id);
-
 			param_id = WMI_VDEV_PARAM_HEOPS_0_31;
 			param_value = vif->bss_conf.he_oper.params;
 			ret = ath11k_wmi_vdev_set_param_cmd(ar, arvif->vdev_id,
-- 
2.35.1



