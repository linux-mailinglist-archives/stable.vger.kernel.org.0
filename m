Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F30E370D1C
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233306AbhEBOIj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:08:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:51294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233852AbhEBOH6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:07:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65AE1613DB;
        Sun,  2 May 2021 14:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964390;
        bh=lEDISDrTraxdVliu3aKglGCr3Uv7wtMYwl4s23X/418=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WK/rC/DhU7Z4DeVKlegZ6yAoO3kGGv8SCqiHWoSdyU2+9xF4q9arwxWSh+rev2Wvn
         XYFInJVwoM+wsJ9wQX/7/Z3ukqMlcVGIhz1CaSZ0f/0/NadegPhtSzkgp+DnZPLz2o
         w9qpg7JPTksHwEWmzikRhYmHg0sPPQqf6krsrKm/X6amt1SHbGzDbHM0eiRcscA53m
         FCfVbbQi4erCRCDMXmlyxaXbZJXzjG9tej68BjWh8EAWOLe4uEsNfqEvtMsW4vogtX
         zheDkhKs4gCMyXC+nravf6MRyWkWSMFQAAhoU0YB15dVmWqI/Rp1nWFmzn2UPbJRU+
         rS+Wm7jSmHc4w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 05/10] spi: dln2: Fix reference leak to master
Date:   Sun,  2 May 2021 10:06:17 -0400
Message-Id: <20210502140623.2720479-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140623.2720479-1-sashal@kernel.org>
References: <20210502140623.2720479-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 9b844b087124c1538d05f40fda8a4fec75af55be ]

Call spi_master_get() holds the reference count to master device, thus
we need an additional spi_master_put() call to reduce the reference
count, otherwise we will leak a reference to master.

This commit fix it by removing the unnecessary spi_master_get().

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Link: https://lore.kernel.org/r/20210409082955.2907950-1-weiyongjun1@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-dln2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-dln2.c b/drivers/spi/spi-dln2.c
index 3b7d91d94fea..64b64174ce2f 100644
--- a/drivers/spi/spi-dln2.c
+++ b/drivers/spi/spi-dln2.c
@@ -781,7 +781,7 @@ static int dln2_spi_probe(struct platform_device *pdev)
 
 static int dln2_spi_remove(struct platform_device *pdev)
 {
-	struct spi_master *master = spi_master_get(platform_get_drvdata(pdev));
+	struct spi_master *master = platform_get_drvdata(pdev);
 	struct dln2_spi *dln2 = spi_master_get_devdata(master);
 
 	pm_runtime_disable(&pdev->dev);
-- 
2.30.2

