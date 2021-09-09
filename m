Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24E2D4050EF
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345707AbhIIMcs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:32:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:33294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353503AbhIIM1N (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:27:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F49661B3B;
        Thu,  9 Sep 2021 11:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188322;
        bh=cuOdGNw7f1QnFZNVV4eoDeQrIqRmu4KsyB2G/6dTrig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qQzIMEwYWgZ/Ov4w0eRSeSNSf3Pz9def3FKb05PPXNoon/zKBQ/K0q9oFdcPYzj9x
         FdHRAYYSDDp+SgXnXXdEdqhHLhjG0NtsX8Vpqe2JHytbf0zZwB0a7zxp+CC075U6H/
         hV0O9b1gapcqRkExMcvhumQcq8QqPcLJ3bPDlQ5p4lXE27Gf4HCs+6r2tdUQ4H+P9h
         GF8gXdTb8XkH+U6dLFMpu3aeXcoWxf4Yk5/V0GL2/sAMHM8ZNZgFDFlxEXpHoymS/Q
         w0RW6fT4mi2rJLAJ1ZC8BbEkOwXlCELa7iZ+w/4DmtwJuzbMZPt4tp3kEXJ1h7HCM1
         lCyfkvvqsYreA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evgeny Novikov <novikov@ispras.ru>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 034/176] media: platform: stm32: unprepare clocks at handling errors in probe
Date:   Thu,  9 Sep 2021 07:48:56 -0400
Message-Id: <20210909115118.146181-34-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115118.146181-1-sashal@kernel.org>
References: <20210909115118.146181-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evgeny Novikov <novikov@ispras.ru>

[ Upstream commit 055d2db28ec2fa3ab5c527c5604f1b32b89fa13a ]

stm32_cec_probe() did not unprepare clocks on error handling paths. The
patch fixes that.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Evgeny Novikov <novikov@ispras.ru>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/cec/platform/stm32/stm32-cec.c | 26 ++++++++++++++------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/media/cec/platform/stm32/stm32-cec.c b/drivers/media/cec/platform/stm32/stm32-cec.c
index ea4b1ebfca99..0ffd89712536 100644
--- a/drivers/media/cec/platform/stm32/stm32-cec.c
+++ b/drivers/media/cec/platform/stm32/stm32-cec.c
@@ -305,14 +305,16 @@ static int stm32_cec_probe(struct platform_device *pdev)
 
 	cec->clk_hdmi_cec = devm_clk_get(&pdev->dev, "hdmi-cec");
 	if (IS_ERR(cec->clk_hdmi_cec) &&
-	    PTR_ERR(cec->clk_hdmi_cec) == -EPROBE_DEFER)
-		return -EPROBE_DEFER;
+	    PTR_ERR(cec->clk_hdmi_cec) == -EPROBE_DEFER) {
+		ret = -EPROBE_DEFER;
+		goto err_unprepare_cec_clk;
+	}
 
 	if (!IS_ERR(cec->clk_hdmi_cec)) {
 		ret = clk_prepare(cec->clk_hdmi_cec);
 		if (ret) {
 			dev_err(&pdev->dev, "Can't prepare hdmi-cec clock\n");
-			return ret;
+			goto err_unprepare_cec_clk;
 		}
 	}
 
@@ -324,19 +326,27 @@ static int stm32_cec_probe(struct platform_device *pdev)
 			CEC_NAME, caps,	CEC_MAX_LOG_ADDRS);
 	ret = PTR_ERR_OR_ZERO(cec->adap);
 	if (ret)
-		return ret;
+		goto err_unprepare_hdmi_cec_clk;
 
 	ret = cec_register_adapter(cec->adap, &pdev->dev);
-	if (ret) {
-		cec_delete_adapter(cec->adap);
-		return ret;
-	}
+	if (ret)
+		goto err_delete_adapter;
 
 	cec_hw_init(cec);
 
 	platform_set_drvdata(pdev, cec);
 
 	return 0;
+
+err_delete_adapter:
+	cec_delete_adapter(cec->adap);
+
+err_unprepare_hdmi_cec_clk:
+	clk_unprepare(cec->clk_hdmi_cec);
+
+err_unprepare_cec_clk:
+	clk_unprepare(cec->clk_cec);
+	return ret;
 }
 
 static int stm32_cec_remove(struct platform_device *pdev)
-- 
2.30.2

