Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28D872F79E1
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387535AbhAOMlw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:41:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:47086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387854AbhAOMjf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:39:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DC80207C4;
        Fri, 15 Jan 2021 12:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714335;
        bh=SVqLzJthz+vIMjPwp9FB7tdXTohbTXyxEVY+5fW2Wqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mUqzsmWeFFIDcIFGD0pGWsnWVNyWWHjKFAM6Rccg4aK3DA18Cz5MuKOVMSKc7mLtU
         M7sWSR/Jp/+pR6i4oHwqWDoSndu3ZqE86In3nO+kpcOTPTU6HbCZiUF91VKi7/oNi8
         45BHamEo2D+4UbJOFBpdklZi42ob+1G6aFgjKWms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 089/103] regulator: qcom-rpmh-regulator: correct hfsmps515 definition
Date:   Fri, 15 Jan 2021 13:28:22 +0100
Message-Id: <20210115122010.320977587@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

commit df6b92fa40050e59ea89784294bf6d04c0c47705 upstream.

According to the datasheet pm8009's HFS515 regulators have 16mV
resolution rather than declared 1.6 mV. Correct the resolution.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Fixes: 06369bcc15a1 ("regulator: qcom-rpmh: Add support for SM8150")
Reviewed-by: Vinod Koul <vkoul@kernel.org>
Link: https://lore.kernel.org/r/20201231122348.637917-3-dmitry.baryshkov@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/regulator/qcom-rpmh-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/regulator/qcom-rpmh-regulator.c
+++ b/drivers/regulator/qcom-rpmh-regulator.c
@@ -726,7 +726,7 @@ static const struct rpmh_vreg_hw_data pm
 static const struct rpmh_vreg_hw_data pmic5_hfsmps515 = {
 	.regulator_type = VRM,
 	.ops = &rpmh_regulator_vrm_ops,
-	.voltage_range = REGULATOR_LINEAR_RANGE(2800000, 0, 4, 1600),
+	.voltage_range = REGULATOR_LINEAR_RANGE(2800000, 0, 4, 16000),
 	.n_voltages = 5,
 	.pmic_mode_map = pmic_mode_map_pmic5_smps,
 	.of_map_mode = rpmh_regulator_pmic4_smps_of_map_mode,


