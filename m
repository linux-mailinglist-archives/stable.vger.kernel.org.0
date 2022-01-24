Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D59449A2A2
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2365892AbiAXXvz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:51:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356464AbiAXW4A (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:56:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85186C0698C2;
        Mon, 24 Jan 2022 13:10:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24FC66141C;
        Mon, 24 Jan 2022 21:10:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08A66C340E5;
        Mon, 24 Jan 2022 21:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058627;
        bh=n/lcnXhgHSaRyo+ZtvUumelV6/WcgjJd3RAK8llaias=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DVXo35GjGgC2CQSs58JZnfUH8y61eJeBOgrcop1bvXhoD9RRoFZrf+7dxyocSTUqC
         t0htKPtPuIaiyPQITiSNn/sdAQwDLFVTAnV9EO03Qk3b0+wTOVY4NQV7TvJMaIUl79
         lD3Ip8fSoqK3LtHSX9FOOaw7VghlSYHcmuWTi79g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Baochen Qiang <quic_bqiang@quicinc.com>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0351/1039] ath11k: Fix unexpected return buffer manager error for QCA6390
Date:   Mon, 24 Jan 2022 19:35:40 +0100
Message-Id: <20220124184137.083494354@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baochen Qiang <quic_bqiang@quicinc.com>

[ Upstream commit 71c748b5e01e3e28838a8e26a8966fb5adb03df7 ]

We are seeing below error on QCA6390:
...
[70211.671189] ath11k_pci 0000:72:00.0: failed to parse rx error in wbm_rel ring desc -22
[70212.696154] ath11k_pci 0000:72:00.0: failed to parse rx error in wbm_rel ring desc -22
[70213.092941] ath11k_pci 0000:72:00.0: failed to parse rx error in wbm_rel ring desc -22
...

The reason is that, with commit 734223d78428 ("ath11k: change return
buffer manager for QCA6390"), ath11k expects the return buffer manager
(RBM) field of descriptor configured as HAL_RX_BUF_RBM_SW1_BM when
parsing error frames from WBM2SW3_RELEASE ring. This is a wrong change
cause the RBM field is set as HAL_RX_BUF_RBM_SW3_BM.

The same issue also applies to REO2TCL ring though we have not got any
error reported.

Fix it by changing RBM from HAL_RX_BUF_RBM_SW1_BM to HAL_RX_BUF_RBM_SW3_BM
for these two rings.

Tested-on: QCA6390 hw2.0 PCI WLAN.HST.1.0.1-01740-QCAHSTSWPLZ_V2_TO_X86-1

Fixes: 734223d78428 ("ath11k: change return buffer manager for QCA6390")
Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20211222013536.582527-1-quic_bqiang@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c  | 2 +-
 drivers/net/wireless/ath/ath11k/hal_rx.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index c5320847b80a7..22b6b6a470d4c 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -3800,7 +3800,7 @@ int ath11k_dp_process_rx_err(struct ath11k_base *ab, struct napi_struct *napi,
 		ath11k_hal_rx_msdu_link_info_get(link_desc_va, &num_msdus, msdu_cookies,
 						 &rbm);
 		if (rbm != HAL_RX_BUF_RBM_WBM_IDLE_DESC_LIST &&
-		    rbm != ab->hw_params.hal_params->rx_buf_rbm) {
+		    rbm != HAL_RX_BUF_RBM_SW3_BM) {
 			ab->soc_stats.invalid_rbm++;
 			ath11k_warn(ab, "invalid return buffer manager %d\n", rbm);
 			ath11k_dp_rx_link_desc_return(ab, desc,
diff --git a/drivers/net/wireless/ath/ath11k/hal_rx.c b/drivers/net/wireless/ath/ath11k/hal_rx.c
index 329c404cfa80d..922926246db7a 100644
--- a/drivers/net/wireless/ath/ath11k/hal_rx.c
+++ b/drivers/net/wireless/ath/ath11k/hal_rx.c
@@ -374,7 +374,7 @@ int ath11k_hal_wbm_desc_parse_err(struct ath11k_base *ab, void *desc,
 
 	ret_buf_mgr = FIELD_GET(BUFFER_ADDR_INFO1_RET_BUF_MGR,
 				wbm_desc->buf_addr_info.info1);
-	if (ret_buf_mgr != ab->hw_params.hal_params->rx_buf_rbm) {
+	if (ret_buf_mgr != HAL_RX_BUF_RBM_SW3_BM) {
 		ab->soc_stats.invalid_rbm++;
 		return -EINVAL;
 	}
-- 
2.34.1



