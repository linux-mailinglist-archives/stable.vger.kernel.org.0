Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4402C39A6B3
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 19:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbhFCRJX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 13:09:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:40186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230208AbhFCRJW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 13:09:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7ED5613C9;
        Thu,  3 Jun 2021 17:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740057;
        bh=BBKDhLvfHfDQKntbuT6ln9K7x/C71GDfo+Ci54AwVFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WOHNvscvzPrRH0yqDmRJ1IPRMGvjcvWKxRk0Y9JTos1n70tPEXsg+z+rDuNVefO1u
         6xWJ6SkyHhnTSo6Kojz5f02tUdY2oArrVBabPzam8HhsH64DmsVNd/SnaBE01ndsV4
         sByuGOTCPsZb0XTmX4MGm/HGVVPw+kT351vSdAHHL/b4JJnULclEnI5n8CKi1pXP7J
         4ftKygscvFRh+T5nXtbyJXqrArQvsmbe4nkRlbmQ18PgDVSML8EWA2d8D1zpwGgg0u
         9O2UxunMR/kjQYgJhaMVv0e7rgzae/MIhPdr/wr+ZFa6qgY/a8NdpdqQqix4bZu8N6
         ak3F1p6UZw0xA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.12 02/43] ASoC: amd: fix for pcm_read() error
Date:   Thu,  3 Jun 2021 13:06:52 -0400
Message-Id: <20210603170734.3168284-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170734.3168284-1-sashal@kernel.org>
References: <20210603170734.3168284-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index d3536fd6a124..a013a607b3d4 100644
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

