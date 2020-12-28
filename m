Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36D4D2E6966
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbgL1Qs7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:48:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:49818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728094AbgL1MxL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 07:53:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 742CF22BEA;
        Mon, 28 Dec 2020 12:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609159967;
        bh=9yUyVpWtHmtbW8ffzytxnswISzXu3eLT8hYgQKmS3ec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vJ/5kxis6UKiBJobz5bOPRWfc8CMrbbagyZvUhfVl5H7x8L+WnTkf7xSQX9wgkMjL
         ftwGb3GhqRjf0JZhggW2K6BwE6AaVG02bBS4BatIbA4YWwP3rOvkFLx0q7QW1cB1+F
         yDndXFcV8vMySgh9iF5ItF2KHE7i97EosEviDq5w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 038/132] spi: spi-ti-qspi: fix reference leak in ti_qspi_setup
Date:   Mon, 28 Dec 2020 13:48:42 +0100
Message-Id: <20201228124848.249320651@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124846.409999325@linuxfoundation.org>
References: <20201228124846.409999325@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 45c0cba753641e5d7c3207f04241bd0e7a021698 ]

pm_runtime_get_sync will increment pm usage counter even it
failed. Forgetting to pm_runtime_put_noidle will result in
reference leak in ti_qspi_setup, so we should fix it.

Fixes: 505a14954e2d7 ("spi/qspi: Add qspi flash controller")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20201103140947.3815-1-zhangqilong3@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-ti-qspi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-ti-qspi.c b/drivers/spi/spi-ti-qspi.c
index 5044c61983324..6e97f71a8cea3 100644
--- a/drivers/spi/spi-ti-qspi.c
+++ b/drivers/spi/spi-ti-qspi.c
@@ -159,6 +159,7 @@ static int ti_qspi_setup(struct spi_device *spi)
 
 	ret = pm_runtime_get_sync(qspi->dev);
 	if (ret < 0) {
+		pm_runtime_put_noidle(qspi->dev);
 		dev_err(qspi->dev, "pm_runtime_get_sync() failed\n");
 		return ret;
 	}
-- 
2.27.0



