Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A64B3378332
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232222AbhEJKmw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:42:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:50390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232344AbhEJKlK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:41:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CAD0561966;
        Mon, 10 May 2021 10:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642720;
        bh=dVDuS0/JAk3BBVKWAnP1KZ9W/o1EEu+0rnNq1zwcQUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EI2F3HQisLPfUS+/INT8Qv+ivvy9Iz7oacFdkzq1+OuPkiN8fCI88R2SloaqQ0DhR
         OVQca4gMK3N03QXcu/t7qLFINmElwvwg2RTePn22pb7KA2K+d6v/BKUkRnRYlA3BY9
         fW/LOyNVbRKWrf3vtVk2EwMxDnCgg5QdwBgM3eOw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Kerello <christophe.kerello@foss.st.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 024/299] spi: stm32-qspi: fix pm_runtime usage_count counter
Date:   Mon, 10 May 2021 12:17:01 +0200
Message-Id: <20210510102005.650747244@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Kerello <christophe.kerello@foss.st.com>

commit 102e9d1936569d43f55dd1ea89be355ad207143c upstream.

pm_runtime usage_count counter is not well managed.
pm_runtime_put_autosuspend callback drops the usage_counter but this
one has never been increased. Add pm_runtime_get_sync callback to bump up
the usage counter. It is also needed to use pm_runtime_force_suspend and
pm_runtime_force_resume APIs to handle properly the clock.

Fixes: 9d282c17b023 ("spi: stm32-qspi: Add pm_runtime support")
Signed-off-by: Christophe Kerello <christophe.kerello@foss.st.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210419121541.11617-2-patrice.chotard@foss.st.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-stm32-qspi.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/drivers/spi/spi-stm32-qspi.c
+++ b/drivers/spi/spi-stm32-qspi.c
@@ -727,21 +727,31 @@ static int __maybe_unused stm32_qspi_sus
 {
 	pinctrl_pm_select_sleep_state(dev);
 
-	return 0;
+	return pm_runtime_force_suspend(dev);
 }
 
 static int __maybe_unused stm32_qspi_resume(struct device *dev)
 {
 	struct stm32_qspi *qspi = dev_get_drvdata(dev);
+	int ret;
+
+	ret = pm_runtime_force_resume(dev);
+	if (ret < 0)
+		return ret;
 
 	pinctrl_pm_select_default_state(dev);
-	clk_prepare_enable(qspi->clk);
+
+	ret = pm_runtime_get_sync(dev);
+	if (ret < 0) {
+		pm_runtime_put_noidle(dev);
+		return ret;
+	}
 
 	writel_relaxed(qspi->cr_reg, qspi->io_base + QSPI_CR);
 	writel_relaxed(qspi->dcr_reg, qspi->io_base + QSPI_DCR);
 
-	pm_runtime_mark_last_busy(qspi->dev);
-	pm_runtime_put_autosuspend(qspi->dev);
+	pm_runtime_mark_last_busy(dev);
+	pm_runtime_put_autosuspend(dev);
 
 	return 0;
 }


