Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E234B11AF5D
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731256AbfLKPMy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:12:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:35362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730636AbfLKPMx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:12:53 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A87032467F;
        Wed, 11 Dec 2019 15:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077173;
        bh=oAgvk0szn6Zv2vG5haaR1xbFC4wzoPEwZ9AaSte1z44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PuihQRM1WOHMj0sM1QkAkRa1QCgm0uO0YBti4wkSxcgVYvtN139T2/cCIBYbjF5zE
         Q5wMrY8THjhc+wGoJai0pmfXREy7T7NLuBB4D0zbhTRc7+RKUA3nvcQk/MaaIXCH9R
         kEw/iws8ZLUxvq4wiDhZRqNavNYby4rm62hX+Urw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alain Volmat <alain.volmat@st.com>,
        Pierre-Yves MORDRET <pierre-yves.mordret@st.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>, linux-i2c@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 058/134] i2c: stm32f7: fix & reorder remove & probe error handling
Date:   Wed, 11 Dec 2019 10:10:34 -0500
Message-Id: <20191211151150.19073-58-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211151150.19073-1-sashal@kernel.org>
References: <20191211151150.19073-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alain Volmat <alain.volmat@st.com>

[ Upstream commit 53aaaa5d9b1e95eb40e877fbffa6f964a8394bb7 ]

Add missing dma channels free calls in case of error during probe
and reorder the remove function so that dma channels are freed after
the i2c adapter is deleted.
Overall, reorder the remove function so that probe error handling order
and remove function order are same.

Fixes: 7ecc8cfde553 ("i2c: i2c-stm32f7: Add DMA support")
Signed-off-by: Alain Volmat <alain.volmat@st.com>
Reviewed-by: Pierre-Yves MORDRET <pierre-yves.mordret@st.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-stm32f7.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/i2c/busses/i2c-stm32f7.c b/drivers/i2c/busses/i2c-stm32f7.c
index b24e7b937f210..84cfed17ff4f5 100644
--- a/drivers/i2c/busses/i2c-stm32f7.c
+++ b/drivers/i2c/busses/i2c-stm32f7.c
@@ -1985,6 +1985,11 @@ pm_disable:
 	pm_runtime_set_suspended(i2c_dev->dev);
 	pm_runtime_dont_use_autosuspend(i2c_dev->dev);
 
+	if (i2c_dev->dma) {
+		stm32_i2c_dma_free(i2c_dev->dma);
+		i2c_dev->dma = NULL;
+	}
+
 clk_free:
 	clk_disable_unprepare(i2c_dev->clk);
 
@@ -1995,21 +2000,21 @@ static int stm32f7_i2c_remove(struct platform_device *pdev)
 {
 	struct stm32f7_i2c_dev *i2c_dev = platform_get_drvdata(pdev);
 
-	if (i2c_dev->dma) {
-		stm32_i2c_dma_free(i2c_dev->dma);
-		i2c_dev->dma = NULL;
-	}
-
 	i2c_del_adapter(&i2c_dev->adap);
 	pm_runtime_get_sync(i2c_dev->dev);
 
-	clk_disable_unprepare(i2c_dev->clk);
-
 	pm_runtime_put_noidle(i2c_dev->dev);
 	pm_runtime_disable(i2c_dev->dev);
 	pm_runtime_set_suspended(i2c_dev->dev);
 	pm_runtime_dont_use_autosuspend(i2c_dev->dev);
 
+	if (i2c_dev->dma) {
+		stm32_i2c_dma_free(i2c_dev->dma);
+		i2c_dev->dma = NULL;
+	}
+
+	clk_disable_unprepare(i2c_dev->clk);
+
 	return 0;
 }
 
-- 
2.20.1

