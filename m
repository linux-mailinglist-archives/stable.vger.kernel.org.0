Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78572186243
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 03:38:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730182AbgCPCfv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Mar 2020 22:35:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:40638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729525AbgCPCfu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Mar 2020 22:35:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 255D320724;
        Mon, 16 Mar 2020 02:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584326150;
        bh=MHzvLO6pQ9hDsO4k5x5F0p44tCBqF8g2CiJnwVzl7XU=;
        h=From:To:Cc:Subject:Date:From;
        b=wVMOJiqgc5lAsfx4WyIh0WrHhbDwKZSbedDf+p/XxpHYTMVZYkqaXKsIcI6iQBLjq
         S4vjhVgeTMhxLnQ0jM10I455fv9zrXQTzS32AyajZHlkW1A5M3guCpJGCQ6C9KBQOO
         GsQ3/vOtdUxjzR0xg5j9wk7JY1hUMBKJCeEgHKrM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yuji Sasaki <sasakiy@chromium.org>, Vinod Koul <vkoul@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 1/7] spi: qup: call spi_qup_pm_resume_runtime before suspending
Date:   Sun, 15 Mar 2020 22:35:41 -0400
Message-Id: <20200316023548.2347-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
 drivers/spi/spi-qup.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/spi/spi-qup.c b/drivers/spi/spi-qup.c
index 810a7fae34798..2487a91c4cfdb 100644
--- a/drivers/spi/spi-qup.c
+++ b/drivers/spi/spi-qup.c
@@ -961,6 +961,11 @@ static int spi_qup_suspend(struct device *device)
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
-- 
2.20.1

