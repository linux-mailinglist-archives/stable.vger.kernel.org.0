Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5877EE0C06
	for <lists+stable@lfdr.de>; Tue, 22 Oct 2019 20:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732517AbfJVSzN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Oct 2019 14:55:13 -0400
Received: from smtp1.de.adit-jv.com ([93.241.18.167]:34775 "EHLO
        smtp1.de.adit-jv.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732322AbfJVSzN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Oct 2019 14:55:13 -0400
Received: from localhost (smtp1.de.adit-jv.com [127.0.0.1])
        by smtp1.de.adit-jv.com (Postfix) with ESMTP id 2FDD13C04C1;
        Tue, 22 Oct 2019 20:55:10 +0200 (CEST)
Received: from smtp1.de.adit-jv.com ([127.0.0.1])
        by localhost (smtp1.de.adit-jv.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 1Mi11-ba1-B3; Tue, 22 Oct 2019 20:55:04 +0200 (CEST)
Received: from HI2EXCH01.adit-jv.com (hi2exch01.adit-jv.com [10.72.92.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp1.de.adit-jv.com (Postfix) with ESMTPS id 4517C3C009D;
        Tue, 22 Oct 2019 20:55:04 +0200 (CEST)
Received: from vmlxhi-102.adit-jv.com (10.72.93.184) by HI2EXCH01.adit-jv.com
 (10.72.92.24) with Microsoft SMTP Server (TLS) id 14.3.468.0; Tue, 22 Oct
 2019 20:55:03 +0200
From:   Eugeniu Rosca <erosca@de.adit-jv.com>
To:     Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>
CC:     Eugeniu Rosca <erosca@de.adit-jv.com>,
        Eugeniu Rosca <roscaeugeniu@gmail.com>,
        Jiada Wang <jiada_wang@mentor.com>,
        Timo Wischer <twischer@de.adit-jv.com>,
        Andrew Gabbasov <andrew_gabbasov@mentor.com>,
        <stable@vger.kernel.org>
Subject: [RESEND PATCH] ASoC: rsnd: dma: fix SSI9 4/5/6/7 busif dma address
Date:   Tue, 22 Oct 2019 20:54:29 +0200
Message-ID: <20191022185429.12769-1-erosca@de.adit-jv.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.72.93.184]
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiada Wang <jiada_wang@mentor.com>

Currently each SSI unit's busif dma address is calculated by
following calculation formula:
0xec540000 + 0x1000 * id + busif / 4 * 0xA000 + busif % 4 * 0x400

But according to R-Car3 HW manual 41.1.4 Register Configuration,
ssi9 4/5/6/7 busif data register address
(SSI9_4_BUSIF/SSI9_5_BUSIF/SSI9_6_BUSIF/SSI9_7_BUSIF)
are out of this rule.

This patch updates the calculation formula to correct
ssi9 4/5/6/7 busif data register address.

Fixes: 5e45a6fab3b9 ("ASoc: rsnd: dma: Calculate dma address with consider of BUSIF")
Signed-off-by: Jiada Wang <jiada_wang@mentor.com>
Signed-off-by: Timo Wischer <twischer@de.adit-jv.com>
[erosca: minor improvements in commit description]
Cc: Andrew Gabbasov <andrew_gabbasov@mentor.com>
Cc: stable@vger.kernel.org # v4.20+
Signed-off-by: Eugeniu Rosca <erosca@de.adit-jv.com>
---

Originally submitted as https://patchwork.kernel.org/patch/10825513/
("ASoC: rsnd: dma: fix SSI9 4/5/6/7 busif dma address")

---
 sound/soc/sh/rcar/dma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sh/rcar/dma.c b/sound/soc/sh/rcar/dma.c
index 0324a5c39619..28f65eba2bb4 100644
--- a/sound/soc/sh/rcar/dma.c
+++ b/sound/soc/sh/rcar/dma.c
@@ -508,10 +508,10 @@ static struct rsnd_mod_ops rsnd_dmapp_ops = {
 #define RDMA_SSI_I_N(addr, i)	(addr ##_reg - 0x00300000 + (0x40 * i) + 0x8)
 #define RDMA_SSI_O_N(addr, i)	(addr ##_reg - 0x00300000 + (0x40 * i) + 0xc)
 
-#define RDMA_SSIU_I_N(addr, i, j) (addr ##_reg - 0x00441000 + (0x1000 * (i)) + (((j) / 4) * 0xA000) + (((j) % 4) * 0x400))
+#define RDMA_SSIU_I_N(addr, i, j) (addr ##_reg - 0x00441000 + (0x1000 * (i)) + (((j) / 4) * 0xA000) + (((j) % 4) * 0x400) - (0x4000 * ((i) / 9) * ((j) / 4)))
 #define RDMA_SSIU_O_N(addr, i, j) RDMA_SSIU_I_N(addr, i, j)
 
-#define RDMA_SSIU_I_P(addr, i, j) (addr ##_reg - 0x00141000 + (0x1000 * (i)) + (((j) / 4) * 0xA000) + (((j) % 4) * 0x400))
+#define RDMA_SSIU_I_P(addr, i, j) (addr ##_reg - 0x00141000 + (0x1000 * (i)) + (((j) / 4) * 0xA000) + (((j) % 4) * 0x400) - (0x4000 * ((i) / 9) * ((j) / 4)))
 #define RDMA_SSIU_O_P(addr, i, j) RDMA_SSIU_I_P(addr, i, j)
 
 #define RDMA_SRC_I_N(addr, i)	(addr ##_reg - 0x00500000 + (0x400 * i))
-- 
2.23.0

