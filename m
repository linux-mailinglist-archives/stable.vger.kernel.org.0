Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61F9C31F52
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727678AbfFANSH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:18:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:45044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727653AbfFANSG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:18:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8DE225525;
        Sat,  1 Jun 2019 13:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395085;
        bh=9LtJcQqBfxPcd8c+f+mLXBhSAgVvJzMyNfE/twj+KOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v2uXPxtqOZMmHa7LYjJ3wJYqewlUUB4yH4Pu33bcTzU9z6ToGrwUAaViFGtCyMjc5
         wWseC+PEe8W5ERRdKCd2R5JL1upQUReG1pTuy096e8vw7ippZq+wCEp57GCXmhIGz7
         NcOJoMxPd+gN/4HovJ8euJADURRovKdWFtdodO5k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Amit Kucheria <amit.kucheria@linaro.org>,
        Eduardo Valentin <edubezval@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 025/186] drivers: thermal: tsens: Don't print error message on -EPROBE_DEFER
Date:   Sat,  1 Jun 2019 09:14:01 -0400
Message-Id: <20190601131653.24205-25-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601131653.24205-1-sashal@kernel.org>
References: <20190601131653.24205-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amit Kucheria <amit.kucheria@linaro.org>

[ Upstream commit fc7d18cf6a923cde7f5e7ba2c1105bb106d3e29a ]

We print a calibration failure message on -EPROBE_DEFER from
nvmem/qfprom as follows:
[    3.003090] qcom-tsens 4a9000.thermal-sensor: version: 1.4
[    3.005376] qcom-tsens 4a9000.thermal-sensor: tsens calibration failed
[    3.113248] qcom-tsens 4a9000.thermal-sensor: version: 1.4

This confuses people when, in fact, calibration succeeds later when
nvmem/qfprom device is available. Don't print this message on a
-EPROBE_DEFER.

Signed-off-by: Amit Kucheria <amit.kucheria@linaro.org>
Signed-off-by: Eduardo Valentin <edubezval@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/qcom/tsens.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/qcom/tsens.c b/drivers/thermal/qcom/tsens.c
index f1ec9bbe4717e..54b2c0e3c4f49 100644
--- a/drivers/thermal/qcom/tsens.c
+++ b/drivers/thermal/qcom/tsens.c
@@ -160,7 +160,8 @@ static int tsens_probe(struct platform_device *pdev)
 	if (tmdev->ops->calibrate) {
 		ret = tmdev->ops->calibrate(tmdev);
 		if (ret < 0) {
-			dev_err(dev, "tsens calibration failed\n");
+			if (ret != -EPROBE_DEFER)
+				dev_err(dev, "tsens calibration failed\n");
 			return ret;
 		}
 	}
-- 
2.20.1

