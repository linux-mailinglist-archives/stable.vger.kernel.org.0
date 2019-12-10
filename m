Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C25C61194D1
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729160AbfLJVNA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:13:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:38568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729132AbfLJVM7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:12:59 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 853402077B;
        Tue, 10 Dec 2019 21:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012379;
        bh=IO6gjZTcPvk2H490et7pheKZt1cWfyqZYtuINWHMa0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ycwEd6TeXX94cpWqPVo2+iggt8lOOCJhEHNcWuidnT2d2Qtd3F8xRJG2qaxD1yfm7
         d2W8/rPIhLoB6ckFSGdiR/rsG8iPwdeI3O1ZOpRWfBR2C7gv1PVfalWRYFpdTnwMPg
         QffN8izJH8IBSUI+XR6NZ+b1FAB8aagZ8rDUFOfs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuhong Yuan <hslester96@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 303/350] spi: st-ssc4: add missed pm_runtime_disable
Date:   Tue, 10 Dec 2019 16:06:48 -0500
Message-Id: <20191210210735.9077-264-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

[ Upstream commit cd050abeba2a95fe5374eec28ad2244617bcbab6 ]

The driver forgets to call pm_runtime_disable in probe failure
and remove.
Add the missed calls to fix it.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Link: https://lore.kernel.org/r/20191118024848.21645-1-hslester96@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-st-ssc4.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/spi/spi-st-ssc4.c b/drivers/spi/spi-st-ssc4.c
index 0c24c494f3865..77d26d64541a5 100644
--- a/drivers/spi/spi-st-ssc4.c
+++ b/drivers/spi/spi-st-ssc4.c
@@ -381,6 +381,7 @@ static int spi_st_probe(struct platform_device *pdev)
 	return 0;
 
 clk_disable:
+	pm_runtime_disable(&pdev->dev);
 	clk_disable_unprepare(spi_st->clk);
 put_master:
 	spi_master_put(master);
@@ -392,6 +393,8 @@ static int spi_st_remove(struct platform_device *pdev)
 	struct spi_master *master = platform_get_drvdata(pdev);
 	struct spi_st *spi_st = spi_master_get_devdata(master);
 
+	pm_runtime_disable(&pdev->dev);
+
 	clk_disable_unprepare(spi_st->clk);
 
 	pinctrl_pm_select_sleep_state(&pdev->dev);
-- 
2.20.1

