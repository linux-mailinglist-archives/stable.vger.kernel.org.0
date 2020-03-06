Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCA2D17C84F
	for <lists+stable@lfdr.de>; Fri,  6 Mar 2020 23:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbgCFW3p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Mar 2020 17:29:45 -0500
Received: from outils.crapouillou.net ([89.234.176.41]:48022 "EHLO
        crapouillou.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgCFW3o (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Mar 2020 17:29:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1583533778; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nS7t8N3M4o94giFmzM6hdDtLFQ+onJNz4EmiTVZEnsU=;
        b=dlnqtEmACLF48IY2do4pb0MogKLoOs491uFBKVvJyO7gs1X5sgaGP7RxxVC0bQ+L33S4/z
        xQ3SJn5Fo4UhFznOdUSf1SXGUgEkIrz4oWDM6xh5+seJ21TAgk1JkozfMmPQbUQLjahroU
        nUyOlxCkADcbO1qKYRrku52bJjy6ChE=
From:   Paul Cercueil <paul@crapouillou.net>
To:     Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>
Cc:     alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, od@zcrc.me,
        Zhou Yanjie <zhouyanjie@wanyeetech.com>,
        Paul Cercueil <paul@crapouillou.net>, stable@vger.kernel.org
Subject: [PATCH 2/6] ASoC: jz4740-i2s: Fix divider written at incorrect offset in register
Date:   Fri,  6 Mar 2020 23:29:27 +0100
Message-Id: <20200306222931.39664-2-paul@crapouillou.net>
In-Reply-To: <20200306222931.39664-1-paul@crapouillou.net>
References: <20200306222931.39664-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The 4-bit divider value was written at offset 8, while the jz4740
programming manual locates it at offset 0.

Fixes: 26b0aad80a86 ("ASoC: jz4740: Add dynamic sampling rate support to jz4740-i2s")
Cc: stable@vger.kernel.org
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
---
 sound/soc/jz4740/jz4740-i2s.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/jz4740/jz4740-i2s.c b/sound/soc/jz4740/jz4740-i2s.c
index 9d5405881209..434737b2b2b2 100644
--- a/sound/soc/jz4740/jz4740-i2s.c
+++ b/sound/soc/jz4740/jz4740-i2s.c
@@ -83,7 +83,7 @@
 #define JZ_AIC_I2S_STATUS_BUSY BIT(2)
 
 #define JZ_AIC_CLK_DIV_MASK 0xf
-#define I2SDIV_DV_SHIFT 8
+#define I2SDIV_DV_SHIFT 0
 #define I2SDIV_DV_MASK (0xf << I2SDIV_DV_SHIFT)
 #define I2SDIV_IDV_SHIFT 8
 #define I2SDIV_IDV_MASK (0xf << I2SDIV_IDV_SHIFT)
-- 
2.25.1

