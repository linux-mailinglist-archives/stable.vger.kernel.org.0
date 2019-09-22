Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEB1BBA95A
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729793AbfIVTOW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:14:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:59352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394715AbfIVS47 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:56:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAE29214D9;
        Sun, 22 Sep 2019 18:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178618;
        bh=DWNzfLJ61MFerPbmG0E1WG/O8uncf6ZwntcksS8TIQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SAsncWrgT/ljNBFfG4pEXwXNL74g73wOVvJKQxcY7BhBXZ+mcqlFFcdjoP/V84+Dj
         lhPBdNSWA6yP2EalSOkJAzV+oADG/mVxXp6YpSSQqXAbC/qb5z4QDVeGrN0rIExTjE
         fM6ElUd9wE7aSURTdVBvg5tHyJH3kWfD/HEGdU9s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 117/128] mmc: core: Add helper function to indicate if SDIO IRQs is enabled
Date:   Sun, 22 Sep 2019 14:54:07 -0400
Message-Id: <20190922185418.2158-117-sashal@kernel.org>
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

[ Upstream commit bd880b00697befb73eff7220ee20bdae4fdd487b ]

To avoid each host driver supporting SDIO IRQs, from keeping track
internally about if SDIO IRQs has been claimed, let's introduce a common
helper function, sdio_irq_claimed().

The function returns true if SDIO IRQs are claimed, via using the
information about the number of claimed irqs. This is safe, even without
any locks, as long as the helper function is called only from
runtime/system suspend callbacks of the host driver.

Tested-by: Matthias Kaehlcke <mka@chromium.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mmc/host.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 2ff52de1c2b89..840462ed1ec7e 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -488,6 +488,15 @@ void mmc_command_done(struct mmc_host *host, struct mmc_request *mrq);
 
 void mmc_cqe_request_done(struct mmc_host *host, struct mmc_request *mrq);
 
+/*
+ * May be called from host driver's system/runtime suspend/resume callbacks,
+ * to know if SDIO IRQs has been claimed.
+ */
+static inline bool sdio_irq_claimed(struct mmc_host *host)
+{
+	return host->sdio_irqs > 0;
+}
+
 static inline void mmc_signal_sdio_irq(struct mmc_host *host)
 {
 	host->ops->enable_sdio_irq(host, 0);
-- 
2.20.1

