Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D58BD106BDA
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:47:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728843AbfKVKrt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:47:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:55970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729810AbfKVKrs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:47:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E61F20715;
        Fri, 22 Nov 2019 10:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419668;
        bh=5W2ErCyc47JdlxUbc9VA8AEfZ4i7AtaSVHCx4GuH8Jc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PPUVEx07Et3S4fAVT6zFsUieHksH2iheun2zZPOjSkHRzu9FAGyoGdkU8lAKXGXxh
         g+4dG+42Z7S8Qai4V/D+DdY1fJsIdNyQQZReTMd2Gg0D2oVCV0LoCXqqLWTHLsLin+
         KH+FUAE3JYxjufIszogch6/V3vQwrmf1Wy7YkNHo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rami Rosen <ramirose@gmail.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 191/222] dmaengine: ioat: fix prototype of ioat_enumerate_channels
Date:   Fri, 22 Nov 2019 11:28:51 +0100
Message-Id: <20191122100916.080432176@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100830.874290814@linuxfoundation.org>
References: <20191122100830.874290814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rami Rosen <ramirose@gmail.com>

[ Upstream commit f4d34aa8c887a8a2d23ef546da0efa10e3f77241 ]

Signed-off-by: Rami Rosen <ramirose@gmail.com>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ioat/init.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/ioat/init.c b/drivers/dma/ioat/init.c
index d139706f01fe8..9d936584d3310 100644
--- a/drivers/dma/ioat/init.c
+++ b/drivers/dma/ioat/init.c
@@ -129,7 +129,7 @@ static void
 ioat_init_channel(struct ioatdma_device *ioat_dma,
 		  struct ioatdma_chan *ioat_chan, int idx);
 static void ioat_intr_quirk(struct ioatdma_device *ioat_dma);
-static int ioat_enumerate_channels(struct ioatdma_device *ioat_dma);
+static void ioat_enumerate_channels(struct ioatdma_device *ioat_dma);
 static int ioat3_dma_self_test(struct ioatdma_device *ioat_dma);
 
 static int ioat_dca_enabled = 1;
@@ -573,7 +573,7 @@ static void ioat_dma_remove(struct ioatdma_device *ioat_dma)
  * ioat_enumerate_channels - find and initialize the device's channels
  * @ioat_dma: the ioat dma device to be enumerated
  */
-static int ioat_enumerate_channels(struct ioatdma_device *ioat_dma)
+static void ioat_enumerate_channels(struct ioatdma_device *ioat_dma)
 {
 	struct ioatdma_chan *ioat_chan;
 	struct device *dev = &ioat_dma->pdev->dev;
@@ -592,7 +592,7 @@ static int ioat_enumerate_channels(struct ioatdma_device *ioat_dma)
 	xfercap_log = readb(ioat_dma->reg_base + IOAT_XFERCAP_OFFSET);
 	xfercap_log &= 0x1f; /* bits [4:0] valid */
 	if (xfercap_log == 0)
-		return 0;
+		return;
 	dev_dbg(dev, "%s: xfercap = %d\n", __func__, 1 << xfercap_log);
 
 	for (i = 0; i < dma->chancnt; i++) {
@@ -609,7 +609,6 @@ static int ioat_enumerate_channels(struct ioatdma_device *ioat_dma)
 		}
 	}
 	dma->chancnt = i;
-	return i;
 }
 
 /**
-- 
2.20.1



