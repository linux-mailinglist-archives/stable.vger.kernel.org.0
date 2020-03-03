Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A790A176CBB
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 03:59:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727546AbgCCC6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Mar 2020 21:58:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:43460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728243AbgCCCsC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Mar 2020 21:48:02 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 746A0246D8;
        Tue,  3 Mar 2020 02:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583203681;
        bh=5KKM57E/6i1ezCg+qBrkEvzBJzmv+cHuBS7GbTFfXtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gSSdIjxicxgu3+YBUZrwA0x18+eTwK94d7mZ7Ny/yNCgbDv86JLM/yKbn2PFWwK9S
         ViMxGds+VjKULWQU6hbt19DngbQ1vMJjfugUrjiu6fherp2AUlG0OpsXGf3YKUjCXL
         0zVpbSWCIkJ27P+0kT4TBcy/Y/nO1UHHVgBQdKoY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Harigovindan P <harigovi@codeaurora.org>,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 17/58] drm/msm/dsi/pll: call vco set rate explicitly
Date:   Mon,  2 Mar 2020 21:46:59 -0500
Message-Id: <20200303024740.9511-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200303024740.9511-1-sashal@kernel.org>
References: <20200303024740.9511-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

