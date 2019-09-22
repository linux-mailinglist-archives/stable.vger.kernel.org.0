Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 823DABA957
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436859AbfIVTOR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:14:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:59366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394724AbfIVS5A (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:57:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2AE3206C2;
        Sun, 22 Sep 2019 18:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178619;
        bh=+hiAlNfbSBPF8qKfDkfN4sNImtyxNSb/HIggk7vL2UE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1uu/e0bYGILzw7eLALmGZiUWMbiJYNR1NX4l9Yspc5/tCK7x3GpBV++0phJhsUhZe
         imR+ICsnge5yeicqiLB7Ps08KwfvDbIdVe96WjEcNwZzJckJdzZVLjKNuXepdq1pbD
         Vem8E59XB0flM+e74AHb6YQ7d4DY4XeM5A6t2Vqs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 118/128] mmc: dw_mmc: Re-store SDIO IRQs mask at system resume
Date:   Sun, 22 Sep 2019 14:54:08 -0400
Message-Id: <20190922185418.2158-118-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922185418.2158-1-sashal@kernel.org>
References: <20190922185418.2158-1-sashal@kernel.org>
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
index 942da07c9eb87..22c454c7aaca6 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -3486,6 +3486,10 @@ int dw_mci_runtime_resume(struct device *dev)
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

