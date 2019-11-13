Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA2BFA556
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728488AbfKMBx2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:53:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:43142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728575AbfKMBx2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:53:28 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5FEC222CD;
        Wed, 13 Nov 2019 01:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610007;
        bh=nFIHgYARN6QoZyAs6j4pPa0Obg16o0fLwzGO5HLl37g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MKXm40UaO3IN9gEmw95lFCEbPGXiyqVeGxxMInrO7RPG955Vc3Bf7dV7feCdVtmMd
         Am8fz3bemhOcyEoXRPvOkl7L9JD/+blxA7AuoFeNkR9vo4+/Cvb4RHBXnsqDc/NdcO
         BP1j1hI0IV6qedU4PDymNwO3gjXi3BqbWszlejI4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rami Rosen <ramirose@gmail.com>, Vinod Koul <vkoul@kernel.org>,
        Sasha Levin <sashal@kernel.org>, dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 112/209] dmaengine: ioat: fix prototype of ioat_enumerate_channels
Date:   Tue, 12 Nov 2019 20:48:48 -0500
Message-Id: <20191113015025.9685-112-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 21a5708985bc2..0fec3c554fe35 100644
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
@@ -575,7 +575,7 @@ static void ioat_dma_remove(struct ioatdma_device *ioat_dma)
  * ioat_enumerate_channels - find and initialize the device's channels
  * @ioat_dma: the ioat dma device to be enumerated
  */
-static int ioat_enumerate_channels(struct ioatdma_device *ioat_dma)
+static void ioat_enumerate_channels(struct ioatdma_device *ioat_dma)
 {
 	struct ioatdma_chan *ioat_chan;
 	struct device *dev = &ioat_dma->pdev->dev;
@@ -594,7 +594,7 @@ static int ioat_enumerate_channels(struct ioatdma_device *ioat_dma)
 	xfercap_log = readb(ioat_dma->reg_base + IOAT_XFERCAP_OFFSET);
 	xfercap_log &= 0x1f; /* bits [4:0] valid */
 	if (xfercap_log == 0)
-		return 0;
+		return;
 	dev_dbg(dev, "%s: xfercap = %d\n", __func__, 1 << xfercap_log);
 
 	for (i = 0; i < dma->chancnt; i++) {
@@ -611,7 +611,6 @@ static int ioat_enumerate_channels(struct ioatdma_device *ioat_dma)
 		}
 	}
 	dma->chancnt = i;
-	return i;
 }
 
 /**
-- 
2.20.1

