Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48BB617F96F
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729685AbgCJM4r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:56:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:36080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729691AbgCJM4q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:56:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13E2920674;
        Tue, 10 Mar 2020 12:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845005;
        bh=5KKM57E/6i1ezCg+qBrkEvzBJzmv+cHuBS7GbTFfXtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1MBEjP+I7yW+t2EXD95tEg925XNARlAhe3pyJzKNVd7cDEA7/XHRO2H2Ui2YZeyah
         ypXFGHPbrVA5E+1LDuREVagCnxECmiw4P2MseelVCzBOjr5iQvL/29Vh2aFmi+CGi5
         ApUBjzT5PHri4MYEtCCBMaf7v+Uj4ytgyxdrsmQ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harigovindan P <harigovi@codeaurora.org>,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 028/189] drm/msm/dsi/pll: call vco set rate explicitly
Date:   Tue, 10 Mar 2020 13:37:45 +0100
Message-Id: <20200310123642.285673719@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harigovindan P <harigovi@codeaurora.org>

[ Upstream commit c6659785dfb3f8d75f1fe637e4222ff8178f5280 ]

For a given byte clock, if VCO recalc value is exactly same as
vco set rate value, vco_set_rate does not get called assuming
VCO is already set to required value. But Due to GDSC toggle,
VCO values are erased in the HW. To make sure VCO is programmed
correctly, we forcefully call set_rate from vco_prepare.

Signed-off-by: Harigovindan P <harigovi@codeaurora.org>
Reviewed-by: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/pll/dsi_pll_10nm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/msm/dsi/pll/dsi_pll_10nm.c b/drivers/gpu/drm/msm/dsi/pll/dsi_pll_10nm.c
index 8f6100db90ed4..aa9385d5bfff9 100644
--- a/drivers/gpu/drm/msm/dsi/pll/dsi_pll_10nm.c
+++ b/drivers/gpu/drm/msm/dsi/pll/dsi_pll_10nm.c
@@ -411,6 +411,12 @@ static int dsi_pll_10nm_vco_prepare(struct clk_hw *hw)
 	if (pll_10nm->slave)
 		dsi_pll_enable_pll_bias(pll_10nm->slave);
 
+	rc = dsi_pll_10nm_vco_set_rate(hw,pll_10nm->vco_current_rate, 0);
+	if (rc) {
+		pr_err("vco_set_rate failed, rc=%d\n", rc);
+		return rc;
+	}
+
 	/* Start PLL */
 	pll_write(pll_10nm->phy_cmn_mmio + REG_DSI_10nm_PHY_CMN_PLL_CNTRL,
 		  0x01);
-- 
2.20.1



