Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE72450C10
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237497AbhKORec (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:34:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:46316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238079AbhKORcf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:32:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C9036120F;
        Mon, 15 Nov 2021 17:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996874;
        bh=gyVbWcngSJMVDvCkGD7S8EdPHToOdZcTlVzV2SHOiso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wD384bpPp5dlSrkn/vg7wsVTFkB457Alcvy3PPur0uObidBOcPEhM1vG0wfwxaHBE
         s2R5X4nxz06tVht/rXmsUsrt/Zj6ZzmEGTZTXvVnVn2vFjrm9dTkiTVjJj7pM0jXm1
         N8P37my9El5XVcECxPJqdLiqCWT/AsOLjz9RbDCM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evgeny Novikov <novikov@ispras.ru>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Pratyush Yadav <p.yadav@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 298/355] mtd: spi-nor: hisi-sfc: Remove excessive clk_disable_unprepare()
Date:   Mon, 15 Nov 2021 18:03:42 +0100
Message-Id: <20211115165323.361694664@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
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
index 8fcc48056a8bc..569cfd473c87b 100644
--- a/drivers/mtd/spi-nor/hisi-sfc.c
+++ b/drivers/mtd/spi-nor/hisi-sfc.c
@@ -474,7 +474,6 @@ static int hisi_spi_nor_remove(struct platform_device *pdev)
 
 	hisi_spi_nor_unregister_all(host);
 	mutex_destroy(&host->lock);
-	clk_disable_unprepare(host->clk);
 	return 0;
 }
 
-- 
2.33.0



