Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 840CB59BD71
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 12:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233406AbiHVKQs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 06:16:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232331AbiHVKQr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 06:16:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B05331900B
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 03:16:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C3FB60FC7
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 10:16:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57AB5C433C1;
        Mon, 22 Aug 2022 10:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661163405;
        bh=1+CeR0RwKNGRLjqcgZXEu5+2VgvwDB3mGPoQvfiPj+4=;
        h=Subject:To:Cc:From:Date:From;
        b=HM1jc1qLxz8GSxVamt8coxqH2SJcp1QNMZcNHGoMDVZu25E+XwNSekKELEj5ecKA4
         zUaq+038sSXhWLqns9sOqCfX7c8AyeLNdW+aMbCYyX0cUhNWxzjI6A862S4EBYPkcb
         1u6IujTTJn37bRZIgWwtpH3UcvJObeWaqr6nP3g8=
Subject: FAILED: patch "[PATCH] ASoC: SOF: Intel: hda: Fix potential buffer overflow by" failed to apply to 5.15-stable tree
To:     tiwai@suse.de, broonie@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Aug 2022 12:16:35 +0200
Message-ID: <1661163395208115@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 94c1ceb043c1a002de9649bb630c8e8347645982 Mon Sep 17 00:00:00 2001
From: Takashi Iwai <tiwai@suse.de>
Date: Mon, 1 Aug 2022 18:54:20 +0200
Subject: [PATCH] ASoC: SOF: Intel: hda: Fix potential buffer overflow by
 snprintf()

snprintf() returns the would-be-filled size when the string overflows
the given buffer size, hence using this value may result in the buffer
overflow (although it's unrealistic).

This patch replaces with a safer version, scnprintf() for papering
over such a potential issue.

Fixes: 29c8e4398f02 ("ASoC: SOF: Intel: hda: add extended rom status dump to error log")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20220801165420.25978-4-tiwai@suse.de
Signed-off-by: Mark Brown <broonie@kernel.org>

diff --git a/sound/soc/sof/intel/hda.c b/sound/soc/sof/intel/hda.c
index 8639ea63a10d..6d4ecbe14adf 100644
--- a/sound/soc/sof/intel/hda.c
+++ b/sound/soc/sof/intel/hda.c
@@ -574,7 +574,7 @@ static void hda_dsp_dump_ext_rom_status(struct snd_sof_dev *sdev, const char *le
 	chip = get_chip_info(sdev->pdata);
 	for (i = 0; i < HDA_EXT_ROM_STATUS_SIZE; i++) {
 		value = snd_sof_dsp_read(sdev, HDA_DSP_BAR, chip->rom_status_reg + i * 0x4);
-		len += snprintf(msg + len, sizeof(msg) - len, " 0x%x", value);
+		len += scnprintf(msg + len, sizeof(msg) - len, " 0x%x", value);
 	}
 
 	dev_printk(level, sdev->dev, "extended rom status: %s", msg);

