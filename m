Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E37B15E9F6E
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235305AbiIZKZd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235598AbiIZKYW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:24:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 785854D4F2;
        Mon, 26 Sep 2022 03:17:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 182EA60B7E;
        Mon, 26 Sep 2022 10:17:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CB43C433D6;
        Mon, 26 Sep 2022 10:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187454;
        bh=6AUgvhBWZ4qO//g19Nt+ah5iKNNnDXtGxjr6VosGyaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yeNjtZn+0G48XGu/nvVto/1IQZFU8fGZSZduf9SxKw+qDdgSvgSaZj3UVC7kEJn14
         3Gkhnm7wAuZMFjpqFLVHHG34diD5zgmVzMS0ZmyFYDXIsQRaS9gMYHE09z82/X6GFr
         XTCr5/bpboHZmFXG0dd1rfdDCJaTHDLFcn07msD0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 13/58] ALSA: hda/sigmatel: Keep power up while beep is enabled
Date:   Mon, 26 Sep 2022 12:11:32 +0200
Message-Id: <20220926100741.895021418@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100741.430882406@linuxfoundation.org>
References: <20220926100741.430882406@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 414d38ba871092aeac4ed097ac4ced89486646f7 ]

It seems that the beep playback doesn't work well on IDT codec devices
when the codec auto-pm is enabled.  Keep the power on while the beep
switch is enabled.

Link: https://bugzilla.suse.com/show_bug.cgi?id=1200544
Link: https://lore.kernel.org/r/20220904072750.26164-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_sigmatel.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/sound/pci/hda/patch_sigmatel.c b/sound/pci/hda/patch_sigmatel.c
index 85c33f528d7b..2f6e4e3afd8f 100644
--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -222,6 +222,7 @@ struct sigmatel_spec {
 
 	/* beep widgets */
 	hda_nid_t anabeep_nid;
+	bool beep_power_on;
 
 	/* SPDIF-out mux */
 	const char * const *spdif_labels;
@@ -4463,6 +4464,26 @@ static int stac_suspend(struct hda_codec *codec)
 	stac_shutup(codec);
 	return 0;
 }
+
+static int stac_check_power_status(struct hda_codec *codec, hda_nid_t nid)
+{
+	struct sigmatel_spec *spec = codec->spec;
+	int ret = snd_hda_gen_check_power_status(codec, nid);
+
+#ifdef CONFIG_SND_HDA_INPUT_BEEP
+	if (nid == spec->gen.beep_nid && codec->beep) {
+		if (codec->beep->enabled != spec->beep_power_on) {
+			spec->beep_power_on = codec->beep->enabled;
+			if (spec->beep_power_on)
+				snd_hda_power_up_pm(codec);
+			else
+				snd_hda_power_down_pm(codec);
+		}
+		ret |= spec->beep_power_on;
+	}
+#endif
+	return ret;
+}
 #else
 #define stac_suspend		NULL
 #endif /* CONFIG_PM */
@@ -4475,6 +4496,7 @@ static const struct hda_codec_ops stac_patch_ops = {
 	.unsol_event = snd_hda_jack_unsol_event,
 #ifdef CONFIG_PM
 	.suspend = stac_suspend,
+	.check_power_status = stac_check_power_status,
 #endif
 	.reboot_notify = stac_shutup,
 };
-- 
2.35.1



