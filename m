Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8E740132D
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239610AbhIFBY2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:24:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:37738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239715AbhIFBXZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:23:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96C376113A;
        Mon,  6 Sep 2021 01:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891299;
        bh=+ObXvCSoshHtRVhorgytPBy98rQ8dGpq0PmrcjzPfEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oPHd4xzqBfd/KPXmQWjcZ6p3jUWeVsbY5sku1yhnFbxB1YnrEcwqg/f0rFNkUhJJ+
         PFwz2nrjjrvOPE6U7UI6CfPZ5flKCJExlIKzLSs9cxN2GrGrmri0ABumiBnip1EEuZ
         BIapdDBn8cpY3yHUwTjh7K3++QyvycBoXnsKJ8qYvdSOOBEaSaj3iR1CErGdBg+zID
         cwt2WjAL2d2gkqJrg+Yiwx7KKHn37sHvXO1HkTC7sB66Qz0V5Tj+uMVlSJjgU2hw5X
         8WuF5b6pk70gxdtjygo5Xn/tRG7cFyYOguFUDRpHR8Ue/9dAdfPA8e6Ue64dkb0rA4
         CWwvWbAM6IyXQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai Ye <yekai13@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 36/46] crypto: hisilicon/sec - modify the hardware endian configuration
Date:   Sun,  5 Sep 2021 21:20:41 -0400
Message-Id: <20210906012052.929174-36-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012052.929174-1-sashal@kernel.org>
References: <20210906012052.929174-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Ye <yekai13@huawei.com>

[ Upstream commit a52626106d6f7edf3d106c065e13a0313cfeb82f ]

When the endian configuration of the hardware is abnormal, it will
cause the SEC engine is faulty that reports empty message. And it
will affect the normal function of the hardware. Currently the soft
configuration method can't restore the faulty device. The endian
needs to be configured according to the system properties. So fix it.

Signed-off-by: Kai Ye <yekai13@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/sec2/sec.h      |  5 ----
 drivers/crypto/hisilicon/sec2/sec_main.c | 31 +++++++-----------------
 2 files changed, 9 insertions(+), 27 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec.h b/drivers/crypto/hisilicon/sec2/sec.h
index dfdce2f21e65..1aeb53f28edd 100644
--- a/drivers/crypto/hisilicon/sec2/sec.h
+++ b/drivers/crypto/hisilicon/sec2/sec.h
@@ -140,11 +140,6 @@ struct sec_ctx {
 	struct device *dev;
 };
 
-enum sec_endian {
-	SEC_LE = 0,
-	SEC_32BE,
-	SEC_64BE
-};
 
 enum sec_debug_file_index {
 	SEC_CLEAR_ENABLE,
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index e682e2a77b70..0305e656b477 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -304,31 +304,20 @@ static const struct pci_device_id sec_dev_ids[] = {
 };
 MODULE_DEVICE_TABLE(pci, sec_dev_ids);
 
-static u8 sec_get_endian(struct hisi_qm *qm)
+static void sec_set_endian(struct hisi_qm *qm)
 {
 	u32 reg;
 
-	/*
-	 * As for VF, it is a wrong way to get endian setting by
-	 * reading a register of the engine
-	 */
-	if (qm->pdev->is_virtfn) {
-		dev_err_ratelimited(&qm->pdev->dev,
-				    "cannot access a register in VF!\n");
-		return SEC_LE;
-	}
 	reg = readl_relaxed(qm->io_base + SEC_CONTROL_REG);
-	/* BD little endian mode */
-	if (!(reg & BIT(0)))
-		return SEC_LE;
+	reg &= ~(BIT(1) | BIT(0));
+	if (!IS_ENABLED(CONFIG_64BIT))
+		reg |= BIT(1);
 
-	/* BD 32-bits big endian mode */
-	else if (!(reg & BIT(1)))
-		return SEC_32BE;
 
-	/* BD 64-bits big endian mode */
-	else
-		return SEC_64BE;
+	if (!IS_ENABLED(CONFIG_CPU_LITTLE_ENDIAN))
+		reg |= BIT(0);
+
+	writel_relaxed(reg, qm->io_base + SEC_CONTROL_REG);
 }
 
 static int sec_engine_init(struct hisi_qm *qm)
@@ -382,9 +371,7 @@ static int sec_engine_init(struct hisi_qm *qm)
 		       qm->io_base + SEC_BD_ERR_CHK_EN_REG3);
 
 	/* config endian */
-	reg = readl_relaxed(qm->io_base + SEC_CONTROL_REG);
-	reg |= sec_get_endian(qm);
-	writel_relaxed(reg, qm->io_base + SEC_CONTROL_REG);
+	sec_set_endian(qm);
 
 	return 0;
 }
-- 
2.30.2

