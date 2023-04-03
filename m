Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57DAF6D4876
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233390AbjDCO3A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233363AbjDCO27 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:28:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA885319B8
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:28:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BAD3061DD5
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:28:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBFFDC433D2;
        Mon,  3 Apr 2023 14:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532128;
        bh=qMACCk7Kc+T+YqMAOsy1DtcQPwSsW6AQLiVp3aEQjuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RaTZUtiWrzgvqsv8vfgsijZwd5zhAHmbGxv50RD2299nR3Rc4LHs2tW5QfTXSh0Kf
         JuaUxHfXWIJ6jp2R/h6lmcf2DJLT/CpqWlEfH3Q46Pikf4ESWoDd9iwcl22aT5CM/Q
         Hh055l0u9mKIYR1vPURy7fvTRD4VXWqy2+ZwG91o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 137/173] ALSA: ymfpci: Fix assignment in if condition
Date:   Mon,  3 Apr 2023 16:09:12 +0200
Message-Id: <20230403140418.909550737@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit e7daaeedb4f270126792ae216f406c1ba2b8f4d9 ]

PCI YMFPCI driver code contains lots of assignments in if condition,
which is a bad coding style that may confuse readers and occasionally
lead to bugs.

This patch is merely for coding-style fixes, no functional changes.

Link: https://lore.kernel.org/r/20210608140540.17885-53-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 6be2e7522eb5 ("ALSA: ymfpci: Fix BUG_ON in probe function")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/ymfpci/ymfpci.c      | 71 +++++++++++++++++++--------------
 sound/pci/ymfpci/ymfpci_main.c | 72 +++++++++++++++++++++++-----------
 2 files changed, 91 insertions(+), 52 deletions(-)

diff --git a/sound/pci/ymfpci/ymfpci.c b/sound/pci/ymfpci/ymfpci.c
index 9b0d18a7bf356..27fd10b976f77 100644
--- a/sound/pci/ymfpci/ymfpci.c
+++ b/sound/pci/ymfpci/ymfpci.c
@@ -78,7 +78,8 @@ static int snd_ymfpci_create_gameport(struct snd_ymfpci *chip, int dev,
 
 		if (io_port == 1) {
 			/* auto-detect */
-			if (!(io_port = pci_resource_start(chip->pci, 2)))
+			io_port = pci_resource_start(chip->pci, 2);
+			if (!io_port)
 				return -ENODEV;
 		}
 	} else {
@@ -87,7 +88,8 @@ static int snd_ymfpci_create_gameport(struct snd_ymfpci *chip, int dev,
 			for (io_port = 0x201; io_port <= 0x205; io_port++) {
 				if (io_port == 0x203)
 					continue;
-				if ((r = request_region(io_port, 1, "YMFPCI gameport")) != NULL)
+				r = request_region(io_port, 1, "YMFPCI gameport");
+				if (r)
 					break;
 			}
 			if (!r) {
@@ -108,10 +110,13 @@ static int snd_ymfpci_create_gameport(struct snd_ymfpci *chip, int dev,
 		}
 	}
 
-	if (!r && !(r = request_region(io_port, 1, "YMFPCI gameport"))) {
-		dev_err(chip->card->dev,
-			"joystick port %#x is in use.\n", io_port);
-		return -EBUSY;
+	if (!r) {
+		r = request_region(io_port, 1, "YMFPCI gameport");
+		if (!r) {
+			dev_err(chip->card->dev,
+				"joystick port %#x is in use.\n", io_port);
+			return -EBUSY;
+		}
 	}
 
 	chip->gameport = gp = gameport_allocate_port();
@@ -199,8 +204,9 @@ static int snd_card_ymfpci_probe(struct pci_dev *pci,
 			/* auto-detect */
 			fm_port[dev] = pci_resource_start(pci, 1);
 		}
-		if (fm_port[dev] > 0 &&
-		    (fm_res = request_region(fm_port[dev], 4, "YMFPCI OPL3")) != NULL) {
+		if (fm_port[dev] > 0)
+			fm_res = request_region(fm_port[dev], 4, "YMFPCI OPL3");
+		if (fm_res) {
 			legacy_ctrl |= YMFPCI_LEGACY_FMEN;
 			pci_write_config_word(pci, PCIR_DSXG_FMBASE, fm_port[dev]);
 		}
@@ -208,8 +214,9 @@ static int snd_card_ymfpci_probe(struct pci_dev *pci,
 			/* auto-detect */
 			mpu_port[dev] = pci_resource_start(pci, 1) + 0x20;
 		}
-		if (mpu_port[dev] > 0 &&
-		    (mpu_res = request_region(mpu_port[dev], 2, "YMFPCI MPU401")) != NULL) {
+		if (mpu_port[dev] > 0)
+			mpu_res = request_region(mpu_port[dev], 2, "YMFPCI MPU401");
+		if (mpu_res) {
 			legacy_ctrl |= YMFPCI_LEGACY_MEN;
 			pci_write_config_word(pci, PCIR_DSXG_MPU401BASE, mpu_port[dev]);
 		}
@@ -221,8 +228,9 @@ static int snd_card_ymfpci_probe(struct pci_dev *pci,
 		case 0x3a8: legacy_ctrl2 |= 3; break;
 		default: fm_port[dev] = 0; break;
 		}
-		if (fm_port[dev] > 0 &&
-		    (fm_res = request_region(fm_port[dev], 4, "YMFPCI OPL3")) != NULL) {
+		if (fm_port[dev] > 0)
+			fm_res = request_region(fm_port[dev], 4, "YMFPCI OPL3");
+		if (fm_res) {
 			legacy_ctrl |= YMFPCI_LEGACY_FMEN;
 		} else {
 			legacy_ctrl2 &= ~YMFPCI_LEGACY2_FMIO;
@@ -235,8 +243,9 @@ static int snd_card_ymfpci_probe(struct pci_dev *pci,
 		case 0x334: legacy_ctrl2 |= 3 << 4; break;
 		default: mpu_port[dev] = 0; break;
 		}
-		if (mpu_port[dev] > 0 &&
-		    (mpu_res = request_region(mpu_port[dev], 2, "YMFPCI MPU401")) != NULL) {
+		if (mpu_port[dev] > 0)
+			mpu_res = request_region(mpu_port[dev], 2, "YMFPCI MPU401");
+		if (mpu_res) {
 			legacy_ctrl |= YMFPCI_LEGACY_MEN;
 		} else {
 			legacy_ctrl2 &= ~YMFPCI_LEGACY2_MPUIO;
@@ -250,9 +259,8 @@ static int snd_card_ymfpci_probe(struct pci_dev *pci,
 	pci_read_config_word(pci, PCIR_DSXG_LEGACY, &old_legacy_ctrl);
 	pci_write_config_word(pci, PCIR_DSXG_LEGACY, legacy_ctrl);
 	pci_write_config_word(pci, PCIR_DSXG_ELEGACY, legacy_ctrl2);
-	if ((err = snd_ymfpci_create(card, pci,
-				     old_legacy_ctrl,
-			 	     &chip)) < 0) {
+	err = snd_ymfpci_create(card, pci, old_legacy_ctrl, &chip);
+	if (err  < 0) {
 		release_and_free_resource(mpu_res);
 		release_and_free_resource(fm_res);
 		goto free_card;
@@ -293,11 +301,12 @@ static int snd_card_ymfpci_probe(struct pci_dev *pci,
 		goto free_card;
 
 	if (chip->mpu_res) {
-		if ((err = snd_mpu401_uart_new(card, 0, MPU401_HW_YMFPCI,
-					       mpu_port[dev],
-					       MPU401_INFO_INTEGRATED |
-					       MPU401_INFO_IRQ_HOOK,
-					       -1, &chip->rawmidi)) < 0) {
+		err = snd_mpu401_uart_new(card, 0, MPU401_HW_YMFPCI,
+					  mpu_port[dev],
+					  MPU401_INFO_INTEGRATED |
+					  MPU401_INFO_IRQ_HOOK,
+					  -1, &chip->rawmidi);
+		if (err < 0) {
 			dev_warn(card->dev,
 				 "cannot initialize MPU401 at 0x%lx, skipping...\n",
 				 mpu_port[dev]);
@@ -306,18 +315,22 @@ static int snd_card_ymfpci_probe(struct pci_dev *pci,
 		}
 	}
 	if (chip->fm_res) {
-		if ((err = snd_opl3_create(card,
-					   fm_port[dev],
-					   fm_port[dev] + 2,
-					   OPL3_HW_OPL3, 1, &opl3)) < 0) {
+		err = snd_opl3_create(card,
+				      fm_port[dev],
+				      fm_port[dev] + 2,
+				      OPL3_HW_OPL3, 1, &opl3);
+		if (err < 0) {
 			dev_warn(card->dev,
 				 "cannot initialize FM OPL3 at 0x%lx, skipping...\n",
 				 fm_port[dev]);
 			legacy_ctrl &= ~YMFPCI_LEGACY_FMEN;
 			pci_write_config_word(pci, PCIR_DSXG_LEGACY, legacy_ctrl);
-		} else if ((err = snd_opl3_hwdep_new(opl3, 0, 1, NULL)) < 0) {
-			dev_err(card->dev, "cannot create opl3 hwdep\n");
-			goto free_card;
+		} else {
+			err = snd_opl3_hwdep_new(opl3, 0, 1, NULL);
+			if (err < 0) {
+				dev_err(card->dev, "cannot create opl3 hwdep\n");
+				goto free_card;
+			}
 		}
 	}
 
diff --git a/sound/pci/ymfpci/ymfpci_main.c b/sound/pci/ymfpci/ymfpci_main.c
index cacc6a9d14c8b..8fd0607698820 100644
--- a/sound/pci/ymfpci/ymfpci_main.c
+++ b/sound/pci/ymfpci/ymfpci_main.c
@@ -292,7 +292,8 @@ static void snd_ymfpci_pcm_interrupt(struct snd_ymfpci *chip, struct snd_ymfpci_
 	struct snd_ymfpci_pcm *ypcm;
 	u32 pos, delta;
 	
-	if ((ypcm = voice->ypcm) == NULL)
+	ypcm = voice->ypcm;
+	if (!ypcm)
 		return;
 	if (ypcm->substream == NULL)
 		return;
@@ -628,7 +629,8 @@ static int snd_ymfpci_playback_hw_params(struct snd_pcm_substream *substream,
 	struct snd_ymfpci_pcm *ypcm = runtime->private_data;
 	int err;
 
-	if ((err = snd_ymfpci_pcm_voice_alloc(ypcm, params_channels(hw_params))) < 0)
+	err = snd_ymfpci_pcm_voice_alloc(ypcm, params_channels(hw_params));
+	if (err < 0)
 		return err;
 	return 0;
 }
@@ -932,7 +934,8 @@ static int snd_ymfpci_playback_open(struct snd_pcm_substream *substream)
 	struct snd_ymfpci_pcm *ypcm;
 	int err;
 	
-	if ((err = snd_ymfpci_playback_open_1(substream)) < 0)
+	err = snd_ymfpci_playback_open_1(substream);
+	if (err < 0)
 		return err;
 	ypcm = runtime->private_data;
 	ypcm->output_front = 1;
@@ -954,7 +957,8 @@ static int snd_ymfpci_playback_spdif_open(struct snd_pcm_substream *substream)
 	struct snd_ymfpci_pcm *ypcm;
 	int err;
 	
-	if ((err = snd_ymfpci_playback_open_1(substream)) < 0)
+	err = snd_ymfpci_playback_open_1(substream);
+	if (err < 0)
 		return err;
 	ypcm = runtime->private_data;
 	ypcm->output_front = 0;
@@ -982,7 +986,8 @@ static int snd_ymfpci_playback_4ch_open(struct snd_pcm_substream *substream)
 	struct snd_ymfpci_pcm *ypcm;
 	int err;
 	
-	if ((err = snd_ymfpci_playback_open_1(substream)) < 0)
+	err = snd_ymfpci_playback_open_1(substream);
+	if (err < 0)
 		return err;
 	ypcm = runtime->private_data;
 	ypcm->output_front = 0;
@@ -1124,7 +1129,8 @@ int snd_ymfpci_pcm(struct snd_ymfpci *chip, int device)
 	struct snd_pcm *pcm;
 	int err;
 
-	if ((err = snd_pcm_new(chip->card, "YMFPCI", device, 32, 1, &pcm)) < 0)
+	err = snd_pcm_new(chip->card, "YMFPCI", device, 32, 1, &pcm);
+	if (err < 0)
 		return err;
 	pcm->private_data = chip;
 
@@ -1157,7 +1163,8 @@ int snd_ymfpci_pcm2(struct snd_ymfpci *chip, int device)
 	struct snd_pcm *pcm;
 	int err;
 
-	if ((err = snd_pcm_new(chip->card, "YMFPCI - PCM2", device, 0, 1, &pcm)) < 0)
+	err = snd_pcm_new(chip->card, "YMFPCI - PCM2", device, 0, 1, &pcm);
+	if (err < 0)
 		return err;
 	pcm->private_data = chip;
 
@@ -1190,7 +1197,8 @@ int snd_ymfpci_pcm_spdif(struct snd_ymfpci *chip, int device)
 	struct snd_pcm *pcm;
 	int err;
 
-	if ((err = snd_pcm_new(chip->card, "YMFPCI - IEC958", device, 1, 0, &pcm)) < 0)
+	err = snd_pcm_new(chip->card, "YMFPCI - IEC958", device, 1, 0, &pcm);
+	if (err < 0)
 		return err;
 	pcm->private_data = chip;
 
@@ -1230,7 +1238,8 @@ int snd_ymfpci_pcm_4ch(struct snd_ymfpci *chip, int device)
 	struct snd_pcm *pcm;
 	int err;
 
-	if ((err = snd_pcm_new(chip->card, "YMFPCI - Rear", device, 1, 0, &pcm)) < 0)
+	err = snd_pcm_new(chip->card, "YMFPCI - Rear", device, 1, 0, &pcm);
+	if (err < 0)
 		return err;
 	pcm->private_data = chip;
 
@@ -1785,7 +1794,8 @@ int snd_ymfpci_mixer(struct snd_ymfpci *chip, int rear_switch)
 		.read = snd_ymfpci_codec_read,
 	};
 
-	if ((err = snd_ac97_bus(chip->card, 0, &ops, chip, &chip->ac97_bus)) < 0)
+	err = snd_ac97_bus(chip->card, 0, &ops, chip, &chip->ac97_bus);
+	if (err < 0)
 		return err;
 	chip->ac97_bus->private_free = snd_ymfpci_mixer_free_ac97_bus;
 	chip->ac97_bus->no_vra = 1; /* YMFPCI doesn't need VRA */
@@ -1793,7 +1803,8 @@ int snd_ymfpci_mixer(struct snd_ymfpci *chip, int rear_switch)
 	memset(&ac97, 0, sizeof(ac97));
 	ac97.private_data = chip;
 	ac97.private_free = snd_ymfpci_mixer_free_ac97;
-	if ((err = snd_ac97_mixer(chip->ac97_bus, &ac97, &chip->ac97)) < 0)
+	err = snd_ac97_mixer(chip->ac97_bus, &ac97, &chip->ac97);
+	if (err < 0)
 		return err;
 
 	/* to be sure */
@@ -1801,7 +1812,8 @@ int snd_ymfpci_mixer(struct snd_ymfpci *chip, int rear_switch)
 			     AC97_EA_VRA|AC97_EA_VRM, 0);
 
 	for (idx = 0; idx < ARRAY_SIZE(snd_ymfpci_controls); idx++) {
-		if ((err = snd_ctl_add(chip->card, snd_ctl_new1(&snd_ymfpci_controls[idx], chip))) < 0)
+		err = snd_ctl_add(chip->card, snd_ctl_new1(&snd_ymfpci_controls[idx], chip));
+		if (err < 0)
 			return err;
 	}
 	if (chip->ac97->ext_id & AC97_EI_SDAC) {
@@ -1814,27 +1826,37 @@ int snd_ymfpci_mixer(struct snd_ymfpci *chip, int rear_switch)
 	/* add S/PDIF control */
 	if (snd_BUG_ON(!chip->pcm_spdif))
 		return -ENXIO;
-	if ((err = snd_ctl_add(chip->card, kctl = snd_ctl_new1(&snd_ymfpci_spdif_default, chip))) < 0)
+	kctl = snd_ctl_new1(&snd_ymfpci_spdif_default, chip);
+	err = snd_ctl_add(chip->card, kctl);
+	if (err < 0)
 		return err;
 	kctl->id.device = chip->pcm_spdif->device;
-	if ((err = snd_ctl_add(chip->card, kctl = snd_ctl_new1(&snd_ymfpci_spdif_mask, chip))) < 0)
+	kctl = snd_ctl_new1(&snd_ymfpci_spdif_mask, chip);
+	err = snd_ctl_add(chip->card, kctl);
+	if (err < 0)
 		return err;
 	kctl->id.device = chip->pcm_spdif->device;
-	if ((err = snd_ctl_add(chip->card, kctl = snd_ctl_new1(&snd_ymfpci_spdif_stream, chip))) < 0)
+	kctl = snd_ctl_new1(&snd_ymfpci_spdif_stream, chip);
+	err = snd_ctl_add(chip->card, kctl);
+	if (err < 0)
 		return err;
 	kctl->id.device = chip->pcm_spdif->device;
 	chip->spdif_pcm_ctl = kctl;
 
 	/* direct recording source */
-	if (chip->device_id == PCI_DEVICE_ID_YAMAHA_754 &&
-	    (err = snd_ctl_add(chip->card, kctl = snd_ctl_new1(&snd_ymfpci_drec_source, chip))) < 0)
-		return err;
+	if (chip->device_id == PCI_DEVICE_ID_YAMAHA_754) {
+		kctl = snd_ctl_new1(&snd_ymfpci_drec_source, chip);
+		err = snd_ctl_add(chip->card, kctl);
+		if (err < 0)
+			return err;
+	}
 
 	/*
 	 * shared rear/line-in
 	 */
 	if (rear_switch) {
-		if ((err = snd_ctl_add(chip->card, snd_ctl_new1(&snd_ymfpci_rear_shared, chip))) < 0)
+		err = snd_ctl_add(chip->card, snd_ctl_new1(&snd_ymfpci_rear_shared, chip));
+		if (err < 0)
 			return err;
 	}
 
@@ -1847,7 +1869,8 @@ int snd_ymfpci_mixer(struct snd_ymfpci *chip, int rear_switch)
 		kctl->id.device = chip->pcm->device;
 		kctl->id.subdevice = idx;
 		kctl->private_value = (unsigned long)substream;
-		if ((err = snd_ctl_add(chip->card, kctl)) < 0)
+		err = snd_ctl_add(chip->card, kctl);
+		if (err < 0)
 			return err;
 		chip->pcm_mixer[idx].left = 0x8000;
 		chip->pcm_mixer[idx].right = 0x8000;
@@ -1928,7 +1951,8 @@ int snd_ymfpci_timer(struct snd_ymfpci *chip, int device)
 	tid.card = chip->card->number;
 	tid.device = device;
 	tid.subdevice = 0;
-	if ((err = snd_timer_new(chip->card, "YMFPCI", &tid, &timer)) >= 0) {
+	err = snd_timer_new(chip->card, "YMFPCI", &tid, &timer);
+	if (err >= 0) {
 		strcpy(timer->name, "YMFPCI timer");
 		timer->private_data = chip;
 		timer->hw = snd_ymfpci_timer_hw;
@@ -2334,7 +2358,8 @@ int snd_ymfpci_create(struct snd_card *card,
 	*rchip = NULL;
 
 	/* enable PCI device */
-	if ((err = pci_enable_device(pci)) < 0)
+	err = pci_enable_device(pci);
+	if (err < 0)
 		return err;
 
 	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
@@ -2357,7 +2382,8 @@ int snd_ymfpci_create(struct snd_card *card,
 	pci_set_master(pci);
 	chip->src441_used = -1;
 
-	if ((chip->res_reg_area = request_mem_region(chip->reg_area_phys, 0x8000, "YMFPCI")) == NULL) {
+	chip->res_reg_area = request_mem_region(chip->reg_area_phys, 0x8000, "YMFPCI");
+	if (!chip->res_reg_area) {
 		dev_err(chip->card->dev,
 			"unable to grab memory region 0x%lx-0x%lx\n",
 			chip->reg_area_phys, chip->reg_area_phys + 0x8000 - 1);
-- 
2.39.2



