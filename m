Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8CA412F15F
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 00:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbgABWNd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:13:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:53340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727386AbgABWNb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:13:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64EAB22525;
        Thu,  2 Jan 2020 22:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003210;
        bh=mBhPzEHMmHjCJxgZUXZTiGKdQ5QQBIVVgNcKfxVzItY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cK4CpP93ruPJV5OKVWq1KTsitsKZakI+fPVramxBzaag1d/sbFrqDIeZcJ534STfy
         ea8R0sofhQubPgw6tyc24m2aY68E1Ywg31xUSx4Ocmq9Ogp9oNde5r/i2D8sEfJ1tW
         ZWveliDtVj4uwmhXIxzZh4sv7aRUJ0LHD4fb2sVQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alain Volmat <alain.volmat@st.com>,
        Pierre-Yves MORDRET <pierre-yves.mordret@st.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 058/191] i2c: stm32f7: fix & reorder remove & probe error handling
Date:   Thu,  2 Jan 2020 23:05:40 +0100
Message-Id: <20200102215836.171338610@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index b24e7b937f21..84cfed17ff4f 100644
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



