Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAD9F37856D
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235191AbhEJLAY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:00:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:52740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234171AbhEJK4B (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:56:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EECE610A7;
        Mon, 10 May 2021 10:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643472;
        bh=dVDuS0/JAk3BBVKWAnP1KZ9W/o1EEu+0rnNq1zwcQUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=olf9gz2BktHUemjO/nVbbAhng5Zl32txnbUWeQE0TZhWomeKnTp0dpeG8inlG6yd1
         SEN8Y09aiItAEtK6PUzMxzM+y7LYmuFTjkrZvgFmYKvpaWO85QvjQt8m+SaUkSFxbJ
         G1VktM5hXI/tlIyZuGAVJtEN8EAOpo5hrQO1aPo8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Kerello <christophe.kerello@foss.st.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.11 029/342] spi: stm32-qspi: fix pm_runtime usage_count counter
Date:   Mon, 10 May 2021 12:16:59 +0200
Message-Id: <20210510102011.067763891@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
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


