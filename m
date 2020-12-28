Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68FD82E63F7
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404473AbgL1Nna (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:43:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:43938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404468AbgL1Nn3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:43:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22A032063A;
        Mon, 28 Dec 2020 13:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162968;
        bh=vjpw8D6rG4KQXy7E3X/s0OW6bMv5lYfdlyFwqJ07DlI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UFJQrAE/RP6psYI4FuTnvTCqcHLSWclfPxBR1NuuydFWr+qPEOiabw9yie1Wu+V56
         8Jq6zRnhFs6d8jzVqWW8f/VO8ri4VXGG2rrifS8Aw2zh4LsWDZtQFAQpSfKHeP1pL6
         IVICoWvuQq6RFQXe2u9X/VN6ELCZPD4Ui4YCPLP4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 123/453] spi: sprd: fix reference leak in sprd_spi_remove
Date:   Mon, 28 Dec 2020 13:45:59 +0100
Message-Id: <20201228124943.135215333@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit e4062765bc2a41e025e29dd56bad798505036427 ]

pm_runtime_get_sync will increment pm usage counter even it
failed. Forgetting to pm_runtime_put_noidle will result in
reference leak in sprd_spi_remove, so we should fix it.

Fixes: e7d973a31c24b ("spi: sprd: Add SPI driver for Spreadtrum SC9860")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Acked-by: Chunyan Zhang <zhang.lyra@gmail.com>
Link: https://lore.kernel.org/r/20201106015035.139574-1-zhangqilong3@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-sprd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-sprd.c b/drivers/spi/spi-sprd.c
index e60aff9903951..c2bdf19ccdd26 100644
--- a/drivers/spi/spi-sprd.c
+++ b/drivers/spi/spi-sprd.c
@@ -1008,6 +1008,7 @@ static int sprd_spi_remove(struct platform_device *pdev)
 
 	ret = pm_runtime_get_sync(ss->dev);
 	if (ret < 0) {
+		pm_runtime_put_noidle(ss->dev);
 		dev_err(ss->dev, "failed to resume SPI controller\n");
 		return ret;
 	}
-- 
2.27.0



