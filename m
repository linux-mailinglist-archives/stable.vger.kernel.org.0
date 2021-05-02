Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90B99370C75
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233437AbhEBOGZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:06:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:51596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233111AbhEBOFw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:05:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DEB3B613CA;
        Sun,  2 May 2021 14:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964300;
        bh=yerl3LVPL+j+sR+WInYXxmtiDu1aifINyRVyNiiATYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aNn5ih6cW8uVui2XWI/dGH1fLqI0PYQryNMDHGZ9pwwW8FlevYn25IIiCeYHbsMWA
         n0Ghc5WCusmui+w1LIci/bLbpLk9gGiFlfLnHNYWys48y3d/6s1vgNAIZBbzRcPD7W
         a+uLAuKW9toYNMPJnCaV/RV15FJL/oJf1Pg0VvWDY7Wo5hTFAr/c+haYq1y6xVlNDq
         H5e/qlmMhObxXWCGGRBODMQfNUKPKl9LK5QuqVeqextuH4/ea86NYPpydn+w2gSz2S
         Yx0Kku8upEMIsYKgq35WHAYanNl0WkW5JuiMPTZ+dlj0fxci+uil3YiSUlw10r14iY
         TUH1EceEWZkFQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 21/34] spi: dln2: Fix reference leak to master
Date:   Sun,  2 May 2021 10:04:21 -0400
Message-Id: <20210502140434.2719553-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140434.2719553-1-sashal@kernel.org>
References: <20210502140434.2719553-1-sashal@kernel.org>
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
index 75b33d7d14b0..9a4d942fafcf 100644
--- a/drivers/spi/spi-dln2.c
+++ b/drivers/spi/spi-dln2.c
@@ -780,7 +780,7 @@ static int dln2_spi_probe(struct platform_device *pdev)
 
 static int dln2_spi_remove(struct platform_device *pdev)
 {
-	struct spi_master *master = spi_master_get(platform_get_drvdata(pdev));
+	struct spi_master *master = platform_get_drvdata(pdev);
 	struct dln2_spi *dln2 = spi_master_get_devdata(master);
 
 	pm_runtime_disable(&pdev->dev);
-- 
2.30.2

