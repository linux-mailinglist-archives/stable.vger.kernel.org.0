Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2AA22F0B5
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732605AbgG0O01 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:26:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:56664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732552AbgG0O00 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:26:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7E89207FC;
        Mon, 27 Jul 2020 14:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859985;
        bh=DgP8QoXgHkkBMA1H5XydTzU0oPZhdEGeesvrTY8nD+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y/K4CSfcuoRnJKYwrMDj4LgWtF+MQmeQDsO5WNkQ80GYOT0ukPIgBDGKTVUnEKOLb
         c0NWOyiisPwb2iple7F+K4QRek3XvlALRRgdKAzRsBZW82B9/B0QtQ5zVlZLFflHI0
         K8APGgM9A40lOy1/Bfwiy7jBh7L709qzAi0LWNPQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jun Nie <jun.nie@linaro.org>,
        Mike Tipton <mdtipton@codeaurora.org>,
        Georgi Djakov <georgi.djakov@linaro.org>
Subject: [PATCH 5.7 154/179] interconnect: msm8916: Fix buswidth of pcnoc_s nodes
Date:   Mon, 27 Jul 2020 16:05:29 +0200
Message-Id: <20200727134940.172079666@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Georgi Djakov <georgi.djakov@linaro.org>

commit 92d232d176041db5b033dd7b7f7f2cf343f82237 upstream.

The buswidth of the pcnoc_s_* nodes is actually not 8, but
4 bytes. Let's fix it.

Reported-by: Jun Nie <jun.nie@linaro.org>
Reviewed-by: Mike Tipton <mdtipton@codeaurora.org>
Fixes: 30c8fa3ec61a ("interconnect: qcom: Add MSM8916 interconnect provider driver")
Link: https://lore.kernel.org/r/20200709130004.12462-1-georgi.djakov@linaro.org
Signed-off-by: Georgi Djakov <georgi.djakov@linaro.org>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200723083735.5616-3-georgi.djakov@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/interconnect/qcom/msm8916.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/interconnect/qcom/msm8916.c
+++ b/drivers/interconnect/qcom/msm8916.c
@@ -197,13 +197,13 @@ DEFINE_QNODE(pcnoc_int_0, MSM8916_PNOC_I
 DEFINE_QNODE(pcnoc_int_1, MSM8916_PNOC_INT_1, 8, -1, -1, MSM8916_PNOC_SNOC_MAS);
 DEFINE_QNODE(pcnoc_m_0, MSM8916_PNOC_MAS_0, 8, -1, -1, MSM8916_PNOC_INT_0);
 DEFINE_QNODE(pcnoc_m_1, MSM8916_PNOC_MAS_1, 8, -1, -1, MSM8916_PNOC_SNOC_MAS);
-DEFINE_QNODE(pcnoc_s_0, MSM8916_PNOC_SLV_0, 8, -1, -1, MSM8916_SLAVE_CLK_CTL, MSM8916_SLAVE_TLMM, MSM8916_SLAVE_TCSR, MSM8916_SLAVE_SECURITY, MSM8916_SLAVE_MSS);
-DEFINE_QNODE(pcnoc_s_1, MSM8916_PNOC_SLV_1, 8, -1, -1, MSM8916_SLAVE_IMEM_CFG, MSM8916_SLAVE_CRYPTO_0_CFG, MSM8916_SLAVE_MSG_RAM, MSM8916_SLAVE_PDM, MSM8916_SLAVE_PRNG);
-DEFINE_QNODE(pcnoc_s_2, MSM8916_PNOC_SLV_2, 8, -1, -1, MSM8916_SLAVE_SPDM, MSM8916_SLAVE_BOOT_ROM, MSM8916_SLAVE_BIMC_CFG, MSM8916_SLAVE_PNOC_CFG, MSM8916_SLAVE_PMIC_ARB);
-DEFINE_QNODE(pcnoc_s_3, MSM8916_PNOC_SLV_3, 8, -1, -1, MSM8916_SLAVE_MPM, MSM8916_SLAVE_SNOC_CFG, MSM8916_SLAVE_RBCPR_CFG, MSM8916_SLAVE_QDSS_CFG, MSM8916_SLAVE_DEHR_CFG);
-DEFINE_QNODE(pcnoc_s_4, MSM8916_PNOC_SLV_4, 8, -1, -1, MSM8916_SLAVE_VENUS_CFG, MSM8916_SLAVE_CAMERA_CFG, MSM8916_SLAVE_DISPLAY_CFG);
-DEFINE_QNODE(pcnoc_s_8, MSM8916_PNOC_SLV_8, 8, -1, -1, MSM8916_SLAVE_USB_HS, MSM8916_SLAVE_SDCC_1, MSM8916_SLAVE_BLSP_1);
-DEFINE_QNODE(pcnoc_s_9, MSM8916_PNOC_SLV_9, 8, -1, -1, MSM8916_SLAVE_SDCC_2, MSM8916_SLAVE_LPASS, MSM8916_SLAVE_GRAPHICS_3D_CFG);
+DEFINE_QNODE(pcnoc_s_0, MSM8916_PNOC_SLV_0, 4, -1, -1, MSM8916_SLAVE_CLK_CTL, MSM8916_SLAVE_TLMM, MSM8916_SLAVE_TCSR, MSM8916_SLAVE_SECURITY, MSM8916_SLAVE_MSS);
+DEFINE_QNODE(pcnoc_s_1, MSM8916_PNOC_SLV_1, 4, -1, -1, MSM8916_SLAVE_IMEM_CFG, MSM8916_SLAVE_CRYPTO_0_CFG, MSM8916_SLAVE_MSG_RAM, MSM8916_SLAVE_PDM, MSM8916_SLAVE_PRNG);
+DEFINE_QNODE(pcnoc_s_2, MSM8916_PNOC_SLV_2, 4, -1, -1, MSM8916_SLAVE_SPDM, MSM8916_SLAVE_BOOT_ROM, MSM8916_SLAVE_BIMC_CFG, MSM8916_SLAVE_PNOC_CFG, MSM8916_SLAVE_PMIC_ARB);
+DEFINE_QNODE(pcnoc_s_3, MSM8916_PNOC_SLV_3, 4, -1, -1, MSM8916_SLAVE_MPM, MSM8916_SLAVE_SNOC_CFG, MSM8916_SLAVE_RBCPR_CFG, MSM8916_SLAVE_QDSS_CFG, MSM8916_SLAVE_DEHR_CFG);
+DEFINE_QNODE(pcnoc_s_4, MSM8916_PNOC_SLV_4, 4, -1, -1, MSM8916_SLAVE_VENUS_CFG, MSM8916_SLAVE_CAMERA_CFG, MSM8916_SLAVE_DISPLAY_CFG);
+DEFINE_QNODE(pcnoc_s_8, MSM8916_PNOC_SLV_8, 4, -1, -1, MSM8916_SLAVE_USB_HS, MSM8916_SLAVE_SDCC_1, MSM8916_SLAVE_BLSP_1);
+DEFINE_QNODE(pcnoc_s_9, MSM8916_PNOC_SLV_9, 4, -1, -1, MSM8916_SLAVE_SDCC_2, MSM8916_SLAVE_LPASS, MSM8916_SLAVE_GRAPHICS_3D_CFG);
 DEFINE_QNODE(pcnoc_snoc_mas, MSM8916_PNOC_SNOC_MAS, 8, 29, -1, MSM8916_PNOC_SNOC_SLV);
 DEFINE_QNODE(pcnoc_snoc_slv, MSM8916_PNOC_SNOC_SLV, 8, -1, 45, MSM8916_SNOC_INT_0, MSM8916_SNOC_INT_BIMC, MSM8916_SNOC_INT_1);
 DEFINE_QNODE(qdss_int, MSM8916_SNOC_QDSS_INT, 8, -1, -1, MSM8916_SNOC_INT_0, MSM8916_SNOC_INT_BIMC);


