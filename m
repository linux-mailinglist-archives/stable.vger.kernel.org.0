Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9754345240B
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:33:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354291AbhKPBfu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:35:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:46084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242417AbhKOSgr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:36:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FE8E6326C;
        Mon, 15 Nov 2021 18:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999367;
        bh=8Ch3EU3UK83abFyDFxq8C9tda3V4GfTWuRtUmaB6dXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o16OJqN2pU2bH6RgVp0F+0L9iuuZj42/+FzJDewueC4gcU4XumqUeGqIUzLvzipSv
         iBL94DAVUOBkuwTmqHlyQrgAGlwDdOlhHklirA5ZD11YOY4Eql3dUz26uTJhn4sK8G
         qfrmkDl/8wk7oEHGeAVVrubPwVBzp3vBCVy7plvQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Xiong <xiongx18@fudan.edu.cn>,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 271/849] mmc: moxart: Fix reference count leaks in moxart_probe
Date:   Mon, 15 Nov 2021 17:55:54 +0100
Message-Id: <20211115165429.412105624@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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
index 6c9d38132f74c..7b9fcef490de7 100644
--- a/drivers/mmc/host/moxart-mmc.c
+++ b/drivers/mmc/host/moxart-mmc.c
@@ -621,6 +621,14 @@ static int moxart_probe(struct platform_device *pdev)
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
@@ -675,6 +683,10 @@ static int moxart_probe(struct platform_device *pdev)
 	return 0;
 
 out:
+	if (!IS_ERR_OR_NULL(host->dma_chan_tx))
+		dma_release_channel(host->dma_chan_tx);
+	if (!IS_ERR_OR_NULL(host->dma_chan_rx))
+		dma_release_channel(host->dma_chan_rx);
 	if (mmc)
 		mmc_free_host(mmc);
 	return ret;
@@ -687,9 +699,9 @@ static int moxart_remove(struct platform_device *pdev)
 
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



