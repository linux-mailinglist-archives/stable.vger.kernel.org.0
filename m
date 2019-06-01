Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0736931E74
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728600AbfFANVq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:21:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:49234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728593AbfFANVq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:21:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2D7227301;
        Sat,  1 Jun 2019 13:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395305;
        bh=q6lYAXrbOHjk6G5hDGd3xLkcRNksrwOKLZ8xq7pp21w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mZoBj4VxIM1zOOS1YsFf+E+ZY8n06BNaKg9PnHowKRYX0dPDBGnHrHsGhJ7TdwhNf
         cK0+OInoSPAYRZvjoEHpvjmMYLdR0A8ML/N/yGWjqaB8LuNVPNXPN47ygp/7xqAS1w
         4keAJTEUl2K0Yppl3TdH9fqEnrV5ZU5CzGQ2Sh1U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ludovic Barre <ludovic.barre@st.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 063/173] mmc: mmci: Prevent polling for busy detection in IRQ context
Date:   Sat,  1 Jun 2019 09:17:35 -0400
Message-Id: <20190601131934.25053-63-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601131934.25053-1-sashal@kernel.org>
References: <20190601131934.25053-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ludovic Barre <ludovic.barre@st.com>

[ Upstream commit 8520ce1e17799b220ff421d4f39438c9c572ade3 ]

The IRQ handler, mmci_irq(), loops until all status bits have been cleared.
However, the status bit signaling busy in variant->busy_detect_flag, may be
set even if busy detection isn't monitored for the current request.

This may be the case for the CMD11 when switching the I/O voltage, which
leads to that mmci_irq() busy loops in IRQ context. Fix this problem, by
clearing the status bit for busy, before continuing to validate the
condition for the loop. This is safe, because the busy status detection has
already been taken care of by mmci_cmd_irq().

Signed-off-by: Ludovic Barre <ludovic.barre@st.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/mmci.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index e352f5ad58018..cb010a83faf4b 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -1534,9 +1534,10 @@ static irqreturn_t mmci_irq(int irq, void *dev_id)
 		}
 
 		/*
-		 * Don't poll for busy completion in irq context.
+		 * Busy detection has been handled by mmci_cmd_irq() above.
+		 * Clear the status bit to prevent polling in IRQ context.
 		 */
-		if (host->variant->busy_detect && host->busy_status)
+		if (host->variant->busy_detect_flag)
 			status &= ~host->variant->busy_detect_flag;
 
 		ret = 1;
-- 
2.20.1

