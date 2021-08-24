Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 382BB3F6557
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239241AbhHXRMF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:12:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:52012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240184AbhHXRKN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:10:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DD6261A55;
        Tue, 24 Aug 2021 17:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824436;
        bh=+V96zo4Y52xd10TojP98jvm9kOCgl64dzt0SJyBdOfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YOuYu1K2cIUq2z3MDSIDf2ckX/j94XGtI0/jllW5ZHqw2onpalQhD3t+/w/4R1GDB
         Pd3HrJrOOHo++ILVSO1oEs1f3HH2YWIHIuJxX+5vUpbxY2qLL4vGVmVwYg8IoWRyfA
         qbDtEG4LQeX9wtQ8lQnEyeGfGpqjq1vpe7sgNZ37Bx1deRm+fIsKIaeCP2SZnuewRU
         QGqK2zw980Waq66+l67TPgjNRri7H4QAI961c6lMgI+4etXisB9pUyr3rgDe25jcbS
         //IXdHflNpIsceXJZ2Q+wWb0Kd97uF00g+Yav9EbrppUdfsexNZix6/KQAVJB6KxQb
         Kv05SMyFsuWOA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicolas Saenz Julienne <nsaenz@kernel.org>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 87/98] mmc: sdhci-iproc: Set SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN on BCM2711
Date:   Tue, 24 Aug 2021 12:58:57 -0400
Message-Id: <20210824165908.709932-88-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
References: <20210824165908.709932-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.61-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.61-rc1
X-KernelTest-Deadline: 2021-08-26T16:58+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Saenz Julienne <nsaenz@kernel.org>

[ Upstream commit 419dd626e357e89fc9c4e3863592c8b38cfe1571 ]

The controller doesn't seem to pick-up on clock changes, so set the
SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN flag to query the clock frequency
directly from the clock.

Fixes: f84e411c85be ("mmc: sdhci-iproc: Add support for emmc2 of the BCM2711")
Signed-off-by: Nicolas Saenz Julienne <nsaenz@kernel.org>
Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/1628334401-6577-6-git-send-email-stefan.wahren@i2se.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-iproc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-iproc.c b/drivers/mmc/host/sdhci-iproc.c
index b9eb2ec61a83..9f0eef97ebdd 100644
--- a/drivers/mmc/host/sdhci-iproc.c
+++ b/drivers/mmc/host/sdhci-iproc.c
@@ -295,7 +295,8 @@ static const struct sdhci_ops sdhci_iproc_bcm2711_ops = {
 };
 
 static const struct sdhci_pltfm_data sdhci_bcm2711_pltfm_data = {
-	.quirks = SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12,
+	.quirks = SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12 |
+		  SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN,
 	.ops = &sdhci_iproc_bcm2711_ops,
 };
 
-- 
2.30.2

