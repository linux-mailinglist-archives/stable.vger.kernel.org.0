Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7883A624F
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234110AbhFNK64 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:58:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:60708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234382AbhFNK4v (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:56:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FAE661581;
        Mon, 14 Jun 2021 10:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667280;
        bh=Yj6PSnT7sMaVAfUtyqwp/ioxZKN6h05NLJ/hGU0xVfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gqBbD8JMEyfImRrrF2mtiAnAHklN+O9twZPju/IPsHFyhakLliClBHRiGqNeB/ZEw
         PSjhFKsAQb4zDYA8+9SiXoagoGlp/q7frLXF1WTytsZqZPcDQDbA64AU8MXGtjmPEc
         cMmQs8Hh/Qwt/wPy3lOp8VjZmOSZBnpzZQwnc4kM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 003/131] ASoC: amd: fix for pcm_read() error
Date:   Mon, 14 Jun 2021 12:26:04 +0200
Message-Id: <20210614102653.081896115@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102652.964395392@linuxfoundation.org>
References: <20210614102652.964395392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit 6879e8e759bf9e05eaee85e32ca1a936e6b46da1 ]

Below phython script throwing pcm_read() error.

import subprocess

p = subprocess.Popen(["aplay -t raw -D plughw:1,0 /dev/zero"], shell=True)
subprocess.call(["arecord -Dhw:1,0 --dump-hw-params"], shell=True)
subprocess.call(["arecord -Dhw:1,0 -fdat -d1 /dev/null"], shell=True)
p.kill()

Handling ACP global external interrupt enable register
causing this issue.
This register got updated wrongly when there is active
stream causing interrupts disabled for active stream.
Refactored code to handle enabling and disabling external interrupts.

Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://lore.kernel.org/r/1619555017-29858-1-git-send-email-Vijendar.Mukunda@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/raven/acp3x-pcm-dma.c | 10 ----------
 sound/soc/amd/raven/acp3x.h         |  1 +
 sound/soc/amd/raven/pci-acp3x.c     | 15 +++++++++++++++
 3 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/sound/soc/amd/raven/acp3x-pcm-dma.c b/sound/soc/amd/raven/acp3x-pcm-dma.c
index 417cda24030c..2447a1e6e913 100644
--- a/sound/soc/amd/raven/acp3x-pcm-dma.c
+++ b/sound/soc/amd/raven/acp3x-pcm-dma.c
@@ -237,10 +237,6 @@ static int acp3x_dma_open(struct snd_soc_component *component,
 		return ret;
 	}
 
-	if (!adata->play_stream && !adata->capture_stream &&
-	    !adata->i2ssp_play_stream && !adata->i2ssp_capture_stream)
-		rv_writel(1, adata->acp3x_base + mmACP_EXTERNAL_INTR_ENB);
-
 	i2s_data->acp3x_base = adata->acp3x_base;
 	runtime->private_data = i2s_data;
 	return ret;
@@ -367,12 +363,6 @@ static int acp3x_dma_close(struct snd_soc_component *component,
 		}
 	}
 
-	/* Disable ACP irq, when the current stream is being closed and
-	 * another stream is also not active.
-	 */
-	if (!adata->play_stream && !adata->capture_stream &&
-		!adata->i2ssp_play_stream && !adata->i2ssp_capture_stream)
-		rv_writel(0, adata->acp3x_base + mmACP_EXTERNAL_INTR_ENB);
 	return 0;
 }
 
diff --git a/sound/soc/amd/raven/acp3x.h b/sound/soc/amd/raven/acp3x.h
index 03fe93913e12..c3f0c8b7545d 100644
--- a/sound/soc/amd/raven/acp3x.h
+++ b/sound/soc/amd/raven/acp3x.h
@@ -77,6 +77,7 @@
 #define ACP_POWER_OFF_IN_PROGRESS	0x03
 
 #define ACP3x_ITER_IRER_SAMP_LEN_MASK	0x38
+#define ACP_EXT_INTR_STAT_CLEAR_MASK 0xFFFFFFFF
 
 struct acp3x_platform_info {
 	u16 play_i2s_instance;
diff --git a/sound/soc/amd/raven/pci-acp3x.c b/sound/soc/amd/raven/pci-acp3x.c
index 77f2d9389606..df83d2ce75ea 100644
--- a/sound/soc/amd/raven/pci-acp3x.c
+++ b/sound/soc/amd/raven/pci-acp3x.c
@@ -76,6 +76,19 @@ static int acp3x_reset(void __iomem *acp3x_base)
 	return -ETIMEDOUT;
 }
 
+static void acp3x_enable_interrupts(void __iomem *acp_base)
+{
+	rv_writel(0x01, acp_base + mmACP_EXTERNAL_INTR_ENB);
+}
+
+static void acp3x_disable_interrupts(void __iomem *acp_base)
+{
+	rv_writel(ACP_EXT_INTR_STAT_CLEAR_MASK, acp_base +
+		  mmACP_EXTERNAL_INTR_STAT);
+	rv_writel(0x00, acp_base + mmACP_EXTERNAL_INTR_CNTL);
+	rv_writel(0x00, acp_base + mmACP_EXTERNAL_INTR_ENB);
+}
+
 static int acp3x_init(struct acp3x_dev_data *adata)
 {
 	void __iomem *acp3x_base = adata->acp3x_base;
@@ -93,6 +106,7 @@ static int acp3x_init(struct acp3x_dev_data *adata)
 		pr_err("ACP3x reset failed\n");
 		return ret;
 	}
+	acp3x_enable_interrupts(acp3x_base);
 	return 0;
 }
 
@@ -100,6 +114,7 @@ static int acp3x_deinit(void __iomem *acp3x_base)
 {
 	int ret;
 
+	acp3x_disable_interrupts(acp3x_base);
 	/* Reset */
 	ret = acp3x_reset(acp3x_base);
 	if (ret) {
-- 
2.30.2



