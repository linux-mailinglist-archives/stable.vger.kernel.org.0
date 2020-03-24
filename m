Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE33A190F14
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728212AbgCXNRY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:17:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:37102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728205AbgCXNRX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:17:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB1FD206F6;
        Tue, 24 Mar 2020 13:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585055842;
        bh=6sMiOYJlvl4BCbzeY5JOBzZ28TFMQhLKacMo9wqSaKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SNnQyoDYDmYg+tb/LHq7xGVJvigEOG3QqohFaVvNNkTrTQENwTo5woAnkM78ZjuCI
         VCxTmB9iwpb5qyZEHh0atKONa9M1guk61vfZWEMIjuxuMPWuHu1/w2asvMoAM96gGD
         YCELZH0aJEZd5dk+9WU/tzGePCYiOEcVFHbaqZ2Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuji sasaki <sasakiy@chromium.org>,
        Vinod Koul <vkoul@kernel.org>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 008/102] spi: qup: call spi_qup_pm_resume_runtime before suspending
Date:   Tue, 24 Mar 2020 14:10:00 +0100
Message-Id: <20200324130807.382615962@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130806.544601211@linuxfoundation.org>
References: <20200324130806.544601211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuji Sasaki <sasakiy@chromium.org>

[ Upstream commit 136b5cd2e2f97581ae560cff0db2a3b5369112da ]

spi_qup_suspend() will cause synchronous external abort when
runtime suspend is enabled and applied, as it tries to
access SPI controller register while clock is already disabled
in spi_qup_pm_suspend_runtime().

Signed-off-by: Yuji sasaki <sasakiy@chromium.org>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Link: https://lore.kernel.org/r/20200214074340.2286170-1-vkoul@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-qup.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-qup.c b/drivers/spi/spi-qup.c
index 2f559e5311002..fa8079fbea77a 100644
--- a/drivers/spi/spi-qup.c
+++ b/drivers/spi/spi-qup.c
@@ -1217,6 +1217,11 @@ static int spi_qup_suspend(struct device *device)
 	struct spi_qup *controller = spi_master_get_devdata(master);
 	int ret;
 
+	if (pm_runtime_suspended(device)) {
+		ret = spi_qup_pm_resume_runtime(device);
+		if (ret)
+			return ret;
+	}
 	ret = spi_master_suspend(master);
 	if (ret)
 		return ret;
@@ -1225,10 +1230,8 @@ static int spi_qup_suspend(struct device *device)
 	if (ret)
 		return ret;
 
-	if (!pm_runtime_suspended(device)) {
-		clk_disable_unprepare(controller->cclk);
-		clk_disable_unprepare(controller->iclk);
-	}
+	clk_disable_unprepare(controller->cclk);
+	clk_disable_unprepare(controller->iclk);
 	return 0;
 }
 
-- 
2.20.1



