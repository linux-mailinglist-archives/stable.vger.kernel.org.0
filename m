Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3F640939A
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240330AbhIMOW0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:22:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:41744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345883AbhIMOUZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:20:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6B6A60F26;
        Mon, 13 Sep 2021 13:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540790;
        bh=AayjKb2k5+zVPxEVCcXziF7Kj/gs+4rbeig7KBZivlk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vykpUDQqPzaxCpcPiv5ZgdZUqKNNJy3/SJxO5r/P+9/PMNWLuWcIu3bDoXKQPoxfL
         O+gqPC4ewlnHtzjRNeHhqlytoRexcnMIniVVsTlU4Zq4M/Ndt+9RRqM/HDVeaYj92P
         4HIdaakOqBXWT1MSzH4NK3000plbJu6sVGQsOiqM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kai Ye <yekai13@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 036/334] crypto: hisilicon/sec - modify the hardware endian configuration
Date:   Mon, 13 Sep 2021 15:11:30 +0200
Message-Id: <20210913131114.645213782@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 018415b9840a..d97cf02b1df7 100644
--- a/drivers/crypto/hisilicon/sec2/sec.h
+++ b/drivers/crypto/hisilicon/sec2/sec.h
@@ -157,11 +157,6 @@ struct sec_ctx {
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
index 8addbd7a3339..a0cc46b649a3 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -312,31 +312,20 @@ static const struct pci_device_id sec_dev_ids[] = {
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
 
 static void sec_open_sva_prefetch(struct hisi_qm *qm)
@@ -429,9 +418,7 @@ static int sec_engine_init(struct hisi_qm *qm)
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



