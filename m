Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 654E14424C
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731688AbfFMQVF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:21:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:56544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731066AbfFMIjA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:39:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8388521473;
        Thu, 13 Jun 2019 08:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415140;
        bh=/sJcTRTUnl8sOZXR26aYghkbLJA5ZN7KFjxG7cybJsE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CqUWBhuwn+aNpJjn0tbELskvgu/vm72OfPTq6xYpzW9QEhrOYIyuqRvh6VCa9Z1lP
         6n3Z3DtiMcllbUgJEQluPnXTMA/M+TziJAqExqXXHsWhAepGDREd5SeumTTUawDVYe
         4msiLoE84MRlBt8bjUwXB11FZSXc1lPc7QMWRll8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amit Kucheria <amit.kucheria@linaro.org>,
        Eduardo Valentin <edubezval@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 018/118] drivers: thermal: tsens: Dont print error message on -EPROBE_DEFER
Date:   Thu, 13 Jun 2019 10:32:36 +0200
Message-Id: <20190613075644.680914873@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075643.642092651@linuxfoundation.org>
References: <20190613075643.642092651@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index a2c9bfae3d86..b139713289a4 100644
--- a/drivers/thermal/qcom/tsens.c
+++ b/drivers/thermal/qcom/tsens.c
@@ -171,7 +171,8 @@ static int tsens_probe(struct platform_device *pdev)
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



