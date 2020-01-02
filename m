Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D00512EF76
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730219AbgABWa6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:30:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:35450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729966AbgABWa4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:30:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F89420863;
        Thu,  2 Jan 2020 22:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004255;
        bh=lUUJhjEuGA3Oseknaq7GlT9S4DmCuURlVakH+oLWOAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QMT7uf7Nnhpz/Rxq2SWvTmJBy1PMTeCFdS8NYNRxqr2+05seKnUFvZkOR0dQWsWLR
         vkM2NSMIF+zG5psdjsnaIHzdcrQvwNztCH0f+KjP6WFe31z87UF3oNY+yGPOWgQET/
         LU6KuOVXpDHFC142wFRka1Hoy2RCScV21wZMUJOs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 077/171] spi: st-ssc4: add missed pm_runtime_disable
Date:   Thu,  2 Jan 2020 23:06:48 +0100
Message-Id: <20200102220557.617918001@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220546.960200039@linuxfoundation.org>
References: <20200102220546.960200039@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index e54b59638458..710adbc2485f 100644
--- a/drivers/spi/spi-st-ssc4.c
+++ b/drivers/spi/spi-st-ssc4.c
@@ -385,6 +385,7 @@ static int spi_st_probe(struct platform_device *pdev)
 	return 0;
 
 clk_disable:
+	pm_runtime_disable(&pdev->dev);
 	clk_disable_unprepare(spi_st->clk);
 put_master:
 	spi_master_put(master);
@@ -396,6 +397,8 @@ static int spi_st_remove(struct platform_device *pdev)
 	struct spi_master *master = platform_get_drvdata(pdev);
 	struct spi_st *spi_st = spi_master_get_devdata(master);
 
+	pm_runtime_disable(&pdev->dev);
+
 	clk_disable_unprepare(spi_st->clk);
 
 	pinctrl_pm_select_sleep_state(&pdev->dev);
-- 
2.20.1



