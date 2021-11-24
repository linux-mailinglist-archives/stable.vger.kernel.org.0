Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DEF445C5A2
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350591AbhKXN7f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:59:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:44668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348208AbhKXN46 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:56:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 977EA63392;
        Wed, 24 Nov 2021 13:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759258;
        bh=uNtTpnsTSiVV8aks5pnimutDQRMMDEBTXfJl/2sESUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fm2elAoZkMU2lELkPgXaqb6/0qLIUrFoXKfsMVFhGkLapvxNhpggcE674XSjNW/PE
         BWNC8TGvGzNj/D+0SiXz48xirmJALtiW3jNEk0ZTo4zBgqIbfZJY/H2RWmPZbRsxvp
         5Ee93FuoKYH5ZkL1ZrWmJtKfHNDsHY6MFFGIEXj8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Vinod Koul <vkoul@kernel.org>,
        Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 181/279] pinctrl: qcom: sm8350: Correct UFS and SDC offsets
Date:   Wed, 24 Nov 2021 12:57:48 +0100
Message-Id: <20211124115724.996405823@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

[ Upstream commit 62209e805b5c68577602a5803a71d8e2e11ee0d3 ]

The downstream TLMM binding covers a group of TLMM-related hardware
blocks, but the upstream binding only captures the particular block
related to controlling the TLMM pins from an OS. In the translation of
the driver from downstream, the offset of 0x100000 was lost for the UFS
and SDC pingroups.

Fixes: d5d348a3271f ("pinctrl: qcom: Add SM8350 pinctrl driver")
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Reviewed-by: Vinod Koul <vkoul@kernel.org>
Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Link: https://lore.kernel.org/r/20211104170835.1993686-1-bjorn.andersson@linaro.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-sm8350.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-sm8350.c b/drivers/pinctrl/qcom/pinctrl-sm8350.c
index 4d8f8636c2b39..1c042d39380c6 100644
--- a/drivers/pinctrl/qcom/pinctrl-sm8350.c
+++ b/drivers/pinctrl/qcom/pinctrl-sm8350.c
@@ -1597,10 +1597,10 @@ static const struct msm_pingroup sm8350_groups[] = {
 	[200] = PINGROUP(200, qdss_gpio, _, _, _, _, _, _, _, _),
 	[201] = PINGROUP(201, _, _, _, _, _, _, _, _, _),
 	[202] = PINGROUP(202, _, _, _, _, _, _, _, _, _),
-	[203] = UFS_RESET(ufs_reset, 0x1d8000),
-	[204] = SDC_PINGROUP(sdc2_clk, 0x1cf000, 14, 6),
-	[205] = SDC_PINGROUP(sdc2_cmd, 0x1cf000, 11, 3),
-	[206] = SDC_PINGROUP(sdc2_data, 0x1cf000, 9, 0),
+	[203] = UFS_RESET(ufs_reset, 0xd8000),
+	[204] = SDC_PINGROUP(sdc2_clk, 0xcf000, 14, 6),
+	[205] = SDC_PINGROUP(sdc2_cmd, 0xcf000, 11, 3),
+	[206] = SDC_PINGROUP(sdc2_data, 0xcf000, 9, 0),
 };
 
 static const struct msm_gpio_wakeirq_map sm8350_pdc_map[] = {
-- 
2.33.0



