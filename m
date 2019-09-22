Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31BC3BA473
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 20:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391858AbfIVSsy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:48:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:45856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391849AbfIVSsy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:48:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E179421A4C;
        Sun, 22 Sep 2019 18:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178133;
        bh=seL4JwafJp8UZCv4oDKz5AUomDKOVrqUXEXpQSwlfAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R/e9FwQ1MW20+xas3O2McVpbTs5r+RJarKz9bVNGYm2fWzvZvJ40F+8/rlHI2Sex1
         Rie02hHJFXPOqRcGfbRLYCwgrs10JfHWprV1aVQ0Ghfbv6EMT+Ca5zyjODhg+Ey0GD
         RxGThTUv2J2q85sHA6IRJZGo3+t+1Y3XOVqJFShM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 185/203] mmc: dw_mmc: Re-store SDIO IRQs mask at system resume
Date:   Sun, 22 Sep 2019 14:43:31 -0400
Message-Id: <20190922184350.30563-185-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184350.30563-1-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ulf Hansson <ulf.hansson@linaro.org>

[ Upstream commit 7c526608d5afb62cbc967225e2ccaacfdd142e9d ]

In cases when SDIO IRQs have been enabled, runtime suspend is prevented by
the driver. However, this still means dw_mci_runtime_suspend|resume() gets
called during system suspend/resume, via pm_runtime_force_suspend|resume().
This means during system suspend/resume, the register context of the dw_mmc
device most likely loses its register context, even in cases when SDIO IRQs
have been enabled.

To re-enable the SDIO IRQs during system resume, the dw_mmc driver
currently relies on the mmc core to re-enable the SDIO IRQs when it resumes
the SDIO card, but this isn't the recommended solution. Instead, it's
better to deal with this locally in the dw_mmc driver, so let's do that.

Tested-by: Matthias Kaehlcke <mka@chromium.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/dw_mmc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index eea52e2c5a0ce..79c55c7b4afd9 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -3460,6 +3460,10 @@ int dw_mci_runtime_resume(struct device *dev)
 	/* Force setup bus to guarantee available clock output */
 	dw_mci_setup_bus(host->slot, true);
 
+	/* Re-enable SDIO interrupts. */
+	if (sdio_irq_claimed(host->slot->mmc))
+		__dw_mci_enable_sdio_irq(host->slot, 1);
+
 	/* Now that slots are all setup, we can enable card detect */
 	dw_mci_enable_cd(host);
 
-- 
2.20.1

