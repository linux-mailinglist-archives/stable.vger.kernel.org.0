Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B23322E64EF
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390720AbgL1Ngi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:36:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:36366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390713AbgL1Ngh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:36:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18ECE20867;
        Mon, 28 Dec 2020 13:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162581;
        bh=3fNXPCLn+df4fHPGcmz0dIT0FYWo1Wbk35m/GDVDrW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PoBJJA0eguqfmvgrAqgAGugyDsSI/ADZbg9qS3K4Naht6FouMjaFWchr0tXnsUtO+
         sZpSaRRuyzoXwdf2VP8i7e5heLOcL4/V/FRDqzhgwc4dEf5xqCV1c+dqsDS6uCUpIi
         MzYCUFYhjnr5vqshbSpHreySUO2gIEWVjSJdZVwQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Chuhong Yuan <hslester96@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.19 320/346] spi: st-ssc4: Fix unbalanced pm_runtime_disable() in probe error path
Date:   Mon, 28 Dec 2020 13:50:39 +0100
Message-Id: <20201228124935.262621586@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit 5ef76dac0f2c26aeae4ee79eb830280f16d5aceb upstream.

If the calls to devm_platform_ioremap_resource(), irq_of_parse_and_map()
or devm_request_irq() fail on probe of the ST SSC4 SPI driver, the
runtime PM disable depth is incremented even though it was not
decremented before.  Fix it.

Fixes: cd050abeba2a ("spi: st-ssc4: add missed pm_runtime_disable")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: <stable@vger.kernel.org> # v5.5+
Cc: Chuhong Yuan <hslester96@gmail.com>
Link: https://lore.kernel.org/r/fbe8768c30dc829e2d77eabe7be062ca22f84024.1604874488.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-st-ssc4.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/spi/spi-st-ssc4.c
+++ b/drivers/spi/spi-st-ssc4.c
@@ -379,13 +379,14 @@ static int spi_st_probe(struct platform_
 	ret = devm_spi_register_master(&pdev->dev, master);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to register master\n");
-		goto clk_disable;
+		goto rpm_disable;
 	}
 
 	return 0;
 
-clk_disable:
+rpm_disable:
 	pm_runtime_disable(&pdev->dev);
+clk_disable:
 	clk_disable_unprepare(spi_st->clk);
 put_master:
 	spi_master_put(master);


