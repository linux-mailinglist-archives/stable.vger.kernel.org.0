Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0F5B45C098
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346723AbhKXNJp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:09:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:46776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348107AbhKXNIg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:08:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4224661A56;
        Wed, 24 Nov 2021 12:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757553;
        bh=6p+oV9IKWD3OsRiA4aQAT2xbfvGRey0gh+HeueIqNAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nxvthTxrmo741kdjNevso1ILa05LQrKYXQkgBsuywlgc4UJUj2C6uLV/sMqaNXHB4
         oK5UN+IfFCdQ5SYx0n+Ym4Upg47svQ72s1CvQD0V1dkpyad8HOG/0P3whZZWLNeV+O
         5KuSTtThgPQ68AI4uYiFDSr2UE1pWCbpW3zI5Tho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evgeny Novikov <novikov@ispras.ru>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Pratyush Yadav <p.yadav@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 207/323] mtd: spi-nor: hisi-sfc: Remove excessive clk_disable_unprepare()
Date:   Wed, 24 Nov 2021 12:56:37 +0100
Message-Id: <20211124115725.926011875@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evgeny Novikov <novikov@ispras.ru>

[ Upstream commit 78e4d342187625585932bb437ec26e1060f7fc6f ]

hisi_spi_nor_probe() invokes clk_disable_unprepare() on all paths after
successful call of clk_prepare_enable(). Besides, the clock is enabled by
hispi_spi_nor_prep() and disabled by hispi_spi_nor_unprep(). So at remove
time it is not possible to have the clock enabled. The patch removes
excessive clk_disable_unprepare() from hisi_spi_nor_remove().

Found by Linux Driver Verification project (linuxtesting.org).

Fixes: e523f11141bd ("mtd: spi-nor: add hisilicon spi-nor flash controller driver")
Signed-off-by: Evgeny Novikov <novikov@ispras.ru>
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Reviewed-by: Pratyush Yadav <p.yadav@ti.com>
Link: https://lore.kernel.org/r/20210709144529.31379-1-novikov@ispras.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/hisi-sfc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mtd/spi-nor/hisi-sfc.c b/drivers/mtd/spi-nor/hisi-sfc.c
index 184ba5069ac51..36d2eb0918d9f 100644
--- a/drivers/mtd/spi-nor/hisi-sfc.c
+++ b/drivers/mtd/spi-nor/hisi-sfc.c
@@ -485,7 +485,6 @@ static int hisi_spi_nor_remove(struct platform_device *pdev)
 
 	hisi_spi_nor_unregister_all(host);
 	mutex_destroy(&host->lock);
-	clk_disable_unprepare(host->clk);
 	return 0;
 }
 
-- 
2.33.0



