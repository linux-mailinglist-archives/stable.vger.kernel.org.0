Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA1D450D65
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbhKOR44 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:56:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:39822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239214AbhKORzD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:55:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02C3E63327;
        Mon, 15 Nov 2021 17:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997618;
        bh=vcW+5ZRdrGx+AtFDutn68szzICfIRXVYM+ST+zGdUeE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tFf4UX7HK1fsLykjkB7u4VudRFh4y0QzYk1CXPEqc9R78rvnKpYCXYKQdl++MXBdU
         +VTUPAY+kDhWIXKt+eMaYdPcdGq4opTcji11M9CMMsNuqqQ5MISI0xOUCim03JeauG
         qU9DOpLpt/zaJKoDWFaSHrv03bFqoYTtkC10BPgo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Xiong <xiongx18@fudan.edu.cn>,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 212/575] mmc: moxart: Fix reference count leaks in moxart_probe
Date:   Mon, 15 Nov 2021 17:58:57 +0100
Message-Id: <20211115165351.049813865@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Xiong <xiongx18@fudan.edu.cn>

[ Upstream commit 8105c2abbf36296bf38ca44f55ee45d160db476a ]

The issue happens in several error handling paths on two refcounted
object related to the object "host" (dma_chan_rx, dma_chan_tx). In
these paths, the function forgets to decrement one or both objects'
reference count increased earlier by dma_request_chan(), causing
reference count leaks.

Fix it by balancing the refcounts of both objects in some error
handling paths. In correspondence with the changes in moxart_probe(),
IS_ERR() is replaced with IS_ERR_OR_NULL() in moxart_remove() as well.

Signed-off-by: Xin Xiong <xiongx18@fudan.edu.cn>
Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Link: https://lore.kernel.org/r/20211009041918.28419-1-xiongx18@fudan.edu.cn
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/moxart-mmc.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/moxart-mmc.c b/drivers/mmc/host/moxart-mmc.c
index 2e4a7c6971dc9..dcd128ecdf15b 100644
--- a/drivers/mmc/host/moxart-mmc.c
+++ b/drivers/mmc/host/moxart-mmc.c
@@ -624,6 +624,14 @@ static int moxart_probe(struct platform_device *pdev)
 			ret = -EPROBE_DEFER;
 			goto out;
 		}
+		if (!IS_ERR(host->dma_chan_tx)) {
+			dma_release_channel(host->dma_chan_tx);
+			host->dma_chan_tx = NULL;
+		}
+		if (!IS_ERR(host->dma_chan_rx)) {
+			dma_release_channel(host->dma_chan_rx);
+			host->dma_chan_rx = NULL;
+		}
 		dev_dbg(dev, "PIO mode transfer enabled\n");
 		host->have_dma = false;
 	} else {
@@ -678,6 +686,10 @@ static int moxart_probe(struct platform_device *pdev)
 	return 0;
 
 out:
+	if (!IS_ERR_OR_NULL(host->dma_chan_tx))
+		dma_release_channel(host->dma_chan_tx);
+	if (!IS_ERR_OR_NULL(host->dma_chan_rx))
+		dma_release_channel(host->dma_chan_rx);
 	if (mmc)
 		mmc_free_host(mmc);
 	return ret;
@@ -690,9 +702,9 @@ static int moxart_remove(struct platform_device *pdev)
 
 	dev_set_drvdata(&pdev->dev, NULL);
 
-	if (!IS_ERR(host->dma_chan_tx))
+	if (!IS_ERR_OR_NULL(host->dma_chan_tx))
 		dma_release_channel(host->dma_chan_tx);
-	if (!IS_ERR(host->dma_chan_rx))
+	if (!IS_ERR_OR_NULL(host->dma_chan_rx))
 		dma_release_channel(host->dma_chan_rx);
 	mmc_remove_host(mmc);
 	mmc_free_host(mmc);
-- 
2.33.0



