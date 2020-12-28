Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 254FB2E3C82
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437186AbgL1ODk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:03:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:35908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437160AbgL1OD3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:03:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3B83206D4;
        Mon, 28 Dec 2020 14:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164194;
        bh=uK7ZcFfCS7K7aNfFEFcM0fZ+Z+I7c2//vK28nrvLgZ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XaVXsngO9MwqkCRtQxzeSzn+LhkHdKgmgUksrnn3vn5q7Mz97Sb/wrWmM7iyBo2tl
         Y3AxK9V8Ek6CyH4fSLVma7aoxJzR63BWj9RAZa33ZN+56VgpQ8W1TnZkTNaT5I9TKx
         1vFbZGTIH7qq+dG6lHxEMSzfj45Q6OMpA0HKCsKA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qinglang Miao <miaoqinglang@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 077/717] spi: mt7621: fix missing clk_disable_unprepare() on error in mt7621_spi_probe
Date:   Mon, 28 Dec 2020 13:41:15 +0100
Message-Id: <20201228125024.676319235@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qinglang Miao <miaoqinglang@huawei.com>

[ Upstream commit 702b15cb97123cedcec56a39d9a21c5288eb9ae1 ]

Fix the missing clk_disable_unprepare() before return
from mt7621_spi_probe in the error handling case.

Fixes: cbd66c626e16 ("spi: mt7621: Move SPI driver out of staging")
Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Link: https://lore.kernel.org/r/20201103074912.195576-1-miaoqinglang@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mt7621.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/spi/spi-mt7621.c b/drivers/spi/spi-mt7621.c
index 2c3b7a2a1ec77..2cdae7994e2aa 100644
--- a/drivers/spi/spi-mt7621.c
+++ b/drivers/spi/spi-mt7621.c
@@ -353,6 +353,7 @@ static int mt7621_spi_probe(struct platform_device *pdev)
 	master = spi_alloc_master(&pdev->dev, sizeof(*rs));
 	if (!master) {
 		dev_info(&pdev->dev, "master allocation failed\n");
+		clk_disable_unprepare(clk);
 		return -ENOMEM;
 	}
 
@@ -377,6 +378,7 @@ static int mt7621_spi_probe(struct platform_device *pdev)
 	ret = device_reset(&pdev->dev);
 	if (ret) {
 		dev_err(&pdev->dev, "SPI reset failed!\n");
+		clk_disable_unprepare(clk);
 		return ret;
 	}
 
-- 
2.27.0



