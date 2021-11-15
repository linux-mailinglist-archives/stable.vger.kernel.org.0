Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2054522D5
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:14:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354579AbhKPBQZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:16:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:42212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244513AbhKOTPH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:15:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02E4A63417;
        Mon, 15 Nov 2021 18:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000512;
        bh=kTg7vA0T5h8J6aM/WFZfU/0eUdXmNFLFTgfEQnUOvbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nWMRZCFOQo3IUlpXubEeI19nke0xXnKWyy+oHxH5hyuIHAyQWub+e0sQ7imckjz5H
         FSMp4HhXv0BduTzmgeB/BgEIDWy2BMc/nT7V5dsRlVLmaAODMbUplVgVQjhqfJ0RGy
         iuF57OVQJ14khdu6qVJ4IhqFFkVR8bCdwUmz7FGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evgeny Novikov <novikov@ispras.ru>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Pratyush Yadav <p.yadav@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 688/849] mtd: spi-nor: hisi-sfc: Remove excessive clk_disable_unprepare()
Date:   Mon, 15 Nov 2021 18:02:51 +0100
Message-Id: <20211115165443.536526373@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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
 drivers/mtd/spi-nor/controllers/hisi-sfc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mtd/spi-nor/controllers/hisi-sfc.c b/drivers/mtd/spi-nor/controllers/hisi-sfc.c
index 47fbf1d1e5573..516e502694780 100644
--- a/drivers/mtd/spi-nor/controllers/hisi-sfc.c
+++ b/drivers/mtd/spi-nor/controllers/hisi-sfc.c
@@ -477,7 +477,6 @@ static int hisi_spi_nor_remove(struct platform_device *pdev)
 
 	hisi_spi_nor_unregister_all(host);
 	mutex_destroy(&host->lock);
-	clk_disable_unprepare(host->clk);
 	return 0;
 }
 
-- 
2.33.0



