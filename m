Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43CB21907B
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 20:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727285AbfEISpP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:45:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:36948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727281AbfEISpN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:45:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45F9D21841;
        Thu,  9 May 2019 18:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427512;
        bh=o9e+5S1SpqW12DKzjkV4b8hL9mapOfmvPq18dvpq0f8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZImGvjLDPOQSaKT2qnA7eIBVAaBdLaBc0rFvm0sjOodFfOH6S3ybaOERZVUPgukkT
         8naWlqTZ5qIheNQ+2hZ6bEuYF3QGHkST/uPvYlNdWuEypuYr8bOtW6IeT5yrLafC8u
         oYI+bYM4UENL0ZFGqNHP6Kh9ANgMkvzDojhMqclk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 10/42] ASoC: wm_adsp: Add locking to wm_adsp2_bus_error
Date:   Thu,  9 May 2019 20:41:59 +0200
Message-Id: <20190509181254.790281117@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181252.616018683@linuxfoundation.org>
References: <20190509181252.616018683@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a2225a6d155fcb247fe4c6d87f7c91807462966d ]

Best to lock across handling the bus error to ensure the DSP doesn't
change power state as we are reading the status registers.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm_adsp.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/wm_adsp.c b/sound/soc/codecs/wm_adsp.c
index 67330b6ab204c..d632a0511d62a 100644
--- a/sound/soc/codecs/wm_adsp.c
+++ b/sound/soc/codecs/wm_adsp.c
@@ -3711,11 +3711,13 @@ irqreturn_t wm_adsp2_bus_error(struct wm_adsp *dsp)
 	struct regmap *regmap = dsp->regmap;
 	int ret = 0;
 
+	mutex_lock(&dsp->pwr_lock);
+
 	ret = regmap_read(regmap, dsp->base + ADSP2_LOCK_REGION_CTRL, &val);
 	if (ret) {
 		adsp_err(dsp,
 			"Failed to read Region Lock Ctrl register: %d\n", ret);
-		return IRQ_HANDLED;
+		goto error;
 	}
 
 	if (val & ADSP2_WDT_TIMEOUT_STS_MASK) {
@@ -3734,7 +3736,7 @@ irqreturn_t wm_adsp2_bus_error(struct wm_adsp *dsp)
 			adsp_err(dsp,
 				 "Failed to read Bus Err Addr register: %d\n",
 				 ret);
-			return IRQ_HANDLED;
+			goto error;
 		}
 
 		adsp_err(dsp, "bus error address = 0x%x\n",
@@ -3747,7 +3749,7 @@ irqreturn_t wm_adsp2_bus_error(struct wm_adsp *dsp)
 			adsp_err(dsp,
 				 "Failed to read Pmem Xmem Err Addr register: %d\n",
 				 ret);
-			return IRQ_HANDLED;
+			goto error;
 		}
 
 		adsp_err(dsp, "xmem error address = 0x%x\n",
@@ -3760,6 +3762,9 @@ irqreturn_t wm_adsp2_bus_error(struct wm_adsp *dsp)
 	regmap_update_bits(regmap, dsp->base + ADSP2_LOCK_REGION_CTRL,
 			   ADSP2_CTRL_ERR_EINT, ADSP2_CTRL_ERR_EINT);
 
+error:
+	mutex_unlock(&dsp->pwr_lock);
+
 	return IRQ_HANDLED;
 }
 EXPORT_SYMBOL_GPL(wm_adsp2_bus_error);
-- 
2.20.1



