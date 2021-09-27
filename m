Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D003419C00
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237209AbhI0RYq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:24:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:36854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237112AbhI0RXK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:23:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CC296108E;
        Mon, 27 Sep 2021 17:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762881;
        bh=S5HE0XjUMBtW5wljJ8wi+/kxUx/2wg/1d1IAK8AAWiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rBH01gNIxRX/yPu8rStqeP051d4iUIFQ7El6xeYxgtL8FljjioHEdamRkZ4oSWITJ
         G0ct9vyJE8WZhRAAn+NPcElfKZzzmFN+B6BazyRbRyvTxlI6P1uYhGMiM4FGX2My3Y
         sspQrDRc6v2HF8sBaMoBL52B4eSdMTZCF1m6wkdk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 085/162] nfc: st-nci: Add SPI ID matching DT compatible
Date:   Mon, 27 Sep 2021 19:02:11 +0200
Message-Id: <20210927170236.378470281@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 31339440b2d0a4987030aac026adbaba44e22490 ]

Currently autoloading for SPI devices does not use the DT ID table, it uses
SPI modalises. Supporting OF modalises is going to be difficult if not
impractical, an attempt was made but has been reverted, so ensure that
module autoloading works for this driver by adding the part name used in
the compatible to the list of SPI IDs.

Fixes: 96c8395e2166 ("spi: Revert modalias changes")
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/st-nci/spi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nfc/st-nci/spi.c b/drivers/nfc/st-nci/spi.c
index 250d56f204c3..e62b1a0916d8 100644
--- a/drivers/nfc/st-nci/spi.c
+++ b/drivers/nfc/st-nci/spi.c
@@ -278,6 +278,7 @@ static int st_nci_spi_remove(struct spi_device *dev)
 
 static struct spi_device_id st_nci_spi_id_table[] = {
 	{ST_NCI_SPI_DRIVER_NAME, 0},
+	{"st21nfcb-spi", 0},
 	{}
 };
 MODULE_DEVICE_TABLE(spi, st_nci_spi_id_table);
-- 
2.33.0



