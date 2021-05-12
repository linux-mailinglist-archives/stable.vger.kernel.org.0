Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1CC137CC02
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241731AbhELQjp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:39:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:47298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242077AbhELQbv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:31:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42BEA61965;
        Wed, 12 May 2021 15:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835088;
        bh=3wvLeUUkIoY4LRI/Vc4BE0c7i34nHlRd4eqyH8jLElM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=06znbazuPHTmUcCszGwX9LJdKQe6cC/+CvfIH05S2NBoBhYDVf9rozETyVzYl2uNa
         7llYH7ykfSHVRgaLZi3XmkNW3J/POt/iSK+ETB3y+PFFK/SwgFxPEeUtDHsb7n1XfR
         nRfDrKXgjJus1OTDvdnCi3dmssUg7tXmHZFWhk8I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Baruch Siach <baruch@tkos.co.il>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 186/677] mtd: parsers: qcom: incompatible with spi-nor 4k sectors
Date:   Wed, 12 May 2021 16:43:52 +0200
Message-Id: <20210512144843.427048397@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baruch Siach <baruch@tkos.co.il>

[ Upstream commit 8f62f59f83c3bc902af91c80732cfcd17e0d7069 ]

Partition size and offset value are in block size units, which is the
same as 'erasesize'. But when 4K sectors are enabled erasesize is set to
4K. Bail out in that case.

Fixes: 803eb124e1a64 ("mtd: parsers: Add Qcom SMEM parser")
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/0a2611f885b894274436ded3ca78bc0440fca74a.1614790096.git.baruch@tkos.co.il
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/parsers/qcomsmempart.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/mtd/parsers/qcomsmempart.c b/drivers/mtd/parsers/qcomsmempart.c
index 1c8a44d0d6e4..d9083308f6ba 100644
--- a/drivers/mtd/parsers/qcomsmempart.c
+++ b/drivers/mtd/parsers/qcomsmempart.c
@@ -65,6 +65,13 @@ static int parse_qcomsmem_part(struct mtd_info *mtd,
 	int ret, i, numparts;
 	char *name, *c;
 
+	if (IS_ENABLED(CONFIG_MTD_SPI_NOR_USE_4K_SECTORS)
+			&& mtd->type == MTD_NORFLASH) {
+		pr_err("%s: SMEM partition parser is incompatible with 4K sectors\n",
+				mtd->name);
+		return -EINVAL;
+	}
+
 	pr_debug("Parsing partition table info from SMEM\n");
 	ptable = qcom_smem_get(SMEM_APPS, SMEM_AARM_PARTITION_TABLE, &len);
 	if (IS_ERR(ptable)) {
-- 
2.30.2



