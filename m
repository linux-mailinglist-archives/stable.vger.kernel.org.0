Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14AD42E64F4
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390816AbgL1Pyv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:54:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:36670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390728AbgL1Ngj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:36:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA71122582;
        Mon, 28 Dec 2020 13:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162584;
        bh=MBsRX0JfOb89PKhMoHVVa+yrEZlnmUuBRK6UAA5HWVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TbHr2AGoBAprjzWqOxaAh2M+1g5GYzEl99vZb4Dx9tJ8JIsK04dgV7WKTDkLT82xN
         DVCR0diymX3oRLkchFsJkgF306nKPGzMaJ+xBLkB/lxWzp7SWrKZewF1TLkZeWPnWG
         tWPbZ0e+IVqkc10t3XH9nK2iu/M3JUH7BzeH2ROU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qinglang Miao <miaoqinglang@huawei.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.19 321/346] spi: mt7621: fix missing clk_disable_unprepare() on error in mt7621_spi_probe
Date:   Mon, 28 Dec 2020 13:50:40 +0100
Message-Id: <20201228124935.303797409@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qinglang Miao <miaoqinglang@huawei.com>

commit 702b15cb97123cedcec56a39d9a21c5288eb9ae1 upstream.

Fix the missing clk_disable_unprepare() before return
from mt7621_spi_probe in the error handling case.

Fixes: cbd66c626e16 ("spi: mt7621: Move SPI driver out of staging")
Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Link: https://lore.kernel.org/r/20201103074912.195576-1-miaoqinglang@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/mt7621-spi/spi-mt7621.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/staging/mt7621-spi/spi-mt7621.c
+++ b/drivers/staging/mt7621-spi/spi-mt7621.c
@@ -455,6 +455,7 @@ static int mt7621_spi_probe(struct platf
 	master = spi_alloc_master(&pdev->dev, sizeof(*rs));
 	if (master == NULL) {
 		dev_info(&pdev->dev, "master allocation failed\n");
+		clk_disable_unprepare(clk);
 		return -ENOMEM;
 	}
 
@@ -480,6 +481,7 @@ static int mt7621_spi_probe(struct platf
 	ret = device_reset(&pdev->dev);
 	if (ret) {
 		dev_err(&pdev->dev, "SPI reset failed!\n");
+		clk_disable_unprepare(clk);
 		return ret;
 	}
 


