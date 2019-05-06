Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB7514EF7
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727424AbfEFOhj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:37:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:58386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726946AbfEFOhg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:37:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11B3621479;
        Mon,  6 May 2019 14:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153455;
        bh=DmHmbU3AzP84s+PL91C4nDMowyLRZYOkoJ+z5IWsmoo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GWX0aNDAqwDtnqkfC2SZm4irrB/yJm6esgDxc4NRFiGjAb53UZOCccppWpGlDYfyW
         3NlgsC63LZOmK/+4jWDyAx6c+XyJdXWnF3jrnrzhjeu88iyCsUR/UkJ464HYVdWRGa
         1RWQqmT20NPh5sdPj7PxhAZdfGT0C9LrusQ8tvj8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiada Wang <jiada_wang@mentor.com>,
        Timo Wischer <twischer@de.adit-jv.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.0 095/122] ASoC: rsnd: gen: fix SSI9 4/5/6/7 busif related register address
Date:   Mon,  6 May 2019 16:32:33 +0200
Message-Id: <20190506143103.352183878@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143054.670334917@linuxfoundation.org>
References: <20190506143054.670334917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiada Wang <jiada_wang@mentor.com>

commit 8af6c521cc236534093f9e744cfa004314bfe5ae upstream.

Currently each SSI unit 's busif mode/adinr/dalign address is
registered by: (in busif4 case)
RSND_GEN_M_REG(SSI_BUSIF4_MODE, 0x500, 0x80)
RSND_GEN_M_REG(SSI_BUSIF4_ADINR,0x504, 0x80)
RSND_GEN_M_REG(SSI_BUSIF4_DALIGN, 0x508, 0x80)

But according to user manual 41.1.4 Register Configuration
ssi9 4/5/6/7 busif mode/adinr/dalign register address
( SSI9-[4/5/6/7]_BUSIF_[MODE/ADINR/DALIGN] )
are out of this rule.

This patch registers ssi9 4/5/6/7 mode/adinr/dalign register
as single register, and access these registers in case of
SSI9 BUSIF 4/5/6/7.

Fixes: commit 8c9d75033340 ("ASoC: rsnd: ssiu: Support BUSIF other than BUSIF0")
Signed-off-by: Jiada Wang <jiada_wang@mentor.com>
Signed-off-by: Timo Wischer <twischer@de.adit-jv.com>
Acked-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/sh/rcar/gen.c  |   24 ++++++++++++++++++++++++
 sound/soc/sh/rcar/rsnd.h |   27 +++++++++++++++++++++++++++
 sound/soc/sh/rcar/ssiu.c |   24 +++++++++++-------------
 3 files changed, 62 insertions(+), 13 deletions(-)

--- a/sound/soc/sh/rcar/gen.c
+++ b/sound/soc/sh/rcar/gen.c
@@ -255,6 +255,30 @@ static int rsnd_gen2_probe(struct rsnd_p
 		RSND_GEN_M_REG(SSI_MODE,		0xc,	0x80),
 		RSND_GEN_M_REG(SSI_CTRL,		0x10,	0x80),
 		RSND_GEN_M_REG(SSI_INT_ENABLE,		0x18,	0x80),
+		RSND_GEN_S_REG(SSI9_BUSIF0_MODE,	0x48c),
+		RSND_GEN_S_REG(SSI9_BUSIF0_ADINR,	0x484),
+		RSND_GEN_S_REG(SSI9_BUSIF0_DALIGN,	0x488),
+		RSND_GEN_S_REG(SSI9_BUSIF1_MODE,	0x4a0),
+		RSND_GEN_S_REG(SSI9_BUSIF1_ADINR,	0x4a4),
+		RSND_GEN_S_REG(SSI9_BUSIF1_DALIGN,	0x4a8),
+		RSND_GEN_S_REG(SSI9_BUSIF2_MODE,	0x4c0),
+		RSND_GEN_S_REG(SSI9_BUSIF2_ADINR,	0x4c4),
+		RSND_GEN_S_REG(SSI9_BUSIF2_DALIGN,	0x4c8),
+		RSND_GEN_S_REG(SSI9_BUSIF3_MODE,	0x4e0),
+		RSND_GEN_S_REG(SSI9_BUSIF3_ADINR,	0x4e4),
+		RSND_GEN_S_REG(SSI9_BUSIF3_DALIGN,	0x4e8),
+		RSND_GEN_S_REG(SSI9_BUSIF4_MODE,	0xd80),
+		RSND_GEN_S_REG(SSI9_BUSIF4_ADINR,	0xd84),
+		RSND_GEN_S_REG(SSI9_BUSIF4_DALIGN,	0xd88),
+		RSND_GEN_S_REG(SSI9_BUSIF5_MODE,	0xda0),
+		RSND_GEN_S_REG(SSI9_BUSIF5_ADINR,	0xda4),
+		RSND_GEN_S_REG(SSI9_BUSIF5_DALIGN,	0xda8),
+		RSND_GEN_S_REG(SSI9_BUSIF6_MODE,	0xdc0),
+		RSND_GEN_S_REG(SSI9_BUSIF6_ADINR,	0xdc4),
+		RSND_GEN_S_REG(SSI9_BUSIF6_DALIGN,	0xdc8),
+		RSND_GEN_S_REG(SSI9_BUSIF7_MODE,	0xde0),
+		RSND_GEN_S_REG(SSI9_BUSIF7_ADINR,	0xde4),
+		RSND_GEN_S_REG(SSI9_BUSIF7_DALIGN,	0xde8),
 	};
 
 	static const struct rsnd_regmap_field_conf conf_scu[] = {
--- a/sound/soc/sh/rcar/rsnd.h
+++ b/sound/soc/sh/rcar/rsnd.h
@@ -191,6 +191,30 @@ enum rsnd_reg {
 	SSI_SYS_STATUS7,
 	HDMI0_SEL,
 	HDMI1_SEL,
+	SSI9_BUSIF0_MODE,
+	SSI9_BUSIF1_MODE,
+	SSI9_BUSIF2_MODE,
+	SSI9_BUSIF3_MODE,
+	SSI9_BUSIF4_MODE,
+	SSI9_BUSIF5_MODE,
+	SSI9_BUSIF6_MODE,
+	SSI9_BUSIF7_MODE,
+	SSI9_BUSIF0_ADINR,
+	SSI9_BUSIF1_ADINR,
+	SSI9_BUSIF2_ADINR,
+	SSI9_BUSIF3_ADINR,
+	SSI9_BUSIF4_ADINR,
+	SSI9_BUSIF5_ADINR,
+	SSI9_BUSIF6_ADINR,
+	SSI9_BUSIF7_ADINR,
+	SSI9_BUSIF0_DALIGN,
+	SSI9_BUSIF1_DALIGN,
+	SSI9_BUSIF2_DALIGN,
+	SSI9_BUSIF3_DALIGN,
+	SSI9_BUSIF4_DALIGN,
+	SSI9_BUSIF5_DALIGN,
+	SSI9_BUSIF6_DALIGN,
+	SSI9_BUSIF7_DALIGN,
 
 	/* SSI */
 	SSICR,
@@ -209,6 +233,9 @@ enum rsnd_reg {
 #define SSI_BUSIF_MODE(i)	(SSI_BUSIF0_MODE + (i))
 #define SSI_BUSIF_ADINR(i)	(SSI_BUSIF0_ADINR + (i))
 #define SSI_BUSIF_DALIGN(i)	(SSI_BUSIF0_DALIGN + (i))
+#define SSI9_BUSIF_MODE(i)	(SSI9_BUSIF0_MODE + (i))
+#define SSI9_BUSIF_ADINR(i)	(SSI9_BUSIF0_ADINR + (i))
+#define SSI9_BUSIF_DALIGN(i)	(SSI9_BUSIF0_DALIGN + (i))
 #define SSI_SYS_STATUS(i)	(SSI_SYS_STATUS0 + (i))
 
 
--- a/sound/soc/sh/rcar/ssiu.c
+++ b/sound/soc/sh/rcar/ssiu.c
@@ -181,28 +181,26 @@ static int rsnd_ssiu_init_gen2(struct rs
 	if (rsnd_ssi_use_busif(io)) {
 		int id = rsnd_mod_id(mod);
 		int busif = rsnd_mod_id_sub(mod);
+		enum rsnd_reg adinr_reg, mode_reg, dalign_reg;
 
-		/*
-		 * FIXME
-		 *
-		 * We can't support SSI9-4/5/6/7, because its address is
-		 * out of calculation rule
-		 */
 		if ((id == 9) && (busif >= 4)) {
-			struct device *dev = rsnd_priv_to_dev(priv);
-
-			dev_err(dev, "This driver doesn't support SSI%d-%d, so far",
-				id, busif);
+			adinr_reg = SSI9_BUSIF_ADINR(busif);
+			mode_reg = SSI9_BUSIF_MODE(busif);
+			dalign_reg = SSI9_BUSIF_DALIGN(busif);
+		} else {
+			adinr_reg = SSI_BUSIF_ADINR(busif);
+			mode_reg = SSI_BUSIF_MODE(busif);
+			dalign_reg = SSI_BUSIF_DALIGN(busif);
 		}
 
-		rsnd_mod_write(mod, SSI_BUSIF_ADINR(busif),
+		rsnd_mod_write(mod, adinr_reg,
 			       rsnd_get_adinr_bit(mod, io) |
 			       (rsnd_io_is_play(io) ?
 				rsnd_runtime_channel_after_ctu(io) :
 				rsnd_runtime_channel_original(io)));
-		rsnd_mod_write(mod, SSI_BUSIF_MODE(busif),
+		rsnd_mod_write(mod, mode_reg,
 			       rsnd_get_busif_shift(io, mod) | 1);
-		rsnd_mod_write(mod, SSI_BUSIF_DALIGN(busif),
+		rsnd_mod_write(mod, dalign_reg,
 			       rsnd_get_dalign(mod, io));
 	}
 


