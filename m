Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E611C2B651C
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731986AbgKQNbB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:31:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:40228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731982AbgKQNa7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:30:59 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3F2F2078E;
        Tue, 17 Nov 2020 13:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619858;
        bh=73CQqDXq6SkVs6/tF88jSni1r9LR2A41sDLoqQL+AYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U8+sZOIA7lOf1QRX/YDWgt4ZU+Kk9khPDdDHqEeKKKrbn9GfTGpfLAB3DRGgGNw/r
         zjxdvsdKdEQU+2Ay0eSA+wae/uVRRXxxFFGDZXCCT4iydESypVnIGESKEmiP9FTjo3
         JqKVHml3UjdDz7brFxjbl1TkYypBaB5/SGCveUkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?=C5=81ukasz=20Majczak?= <lmajczak@google.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 007/255] ASoC: Intel: kbl_rt5663_max98927: Fix kabylake_ssp_fixup function
Date:   Tue, 17 Nov 2020 14:02:27 +0100
Message-Id: <20201117122139.292226791@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomasz Figa <tfiga@chromium.org>

[ Upstream commit 9fe9efd6924c9a62ebb759025bb8927e398f51f7 ]

This is a copy of commit 5c5f1baee85a ("ASoC: Intel:
kbl_rt5663_rt5514_max98927: Fix kabylake_ssp_fixup function") applied to
the kbl_rt5663_max98927 board file.

Original explanation of the change:

kabylake_ssp_fixup function uses snd_soc_dpcm to identify the
codecs DAIs. The HW parameters are changed based on the codec DAI of the
stream. The earlier approach to get snd_soc_dpcm was using container_of()
macro on snd_pcm_hw_params.

The structures have been modified over time and snd_soc_dpcm does not have
snd_pcm_hw_params as a reference but as a copy. This causes the current
driver to crash when used.

This patch changes the way snd_soc_dpcm is extracted. snd_soc_pcm_runtime
holds 2 dpcm instances (one for playback and one for capture). 2 codecs
on the SSP are dmic (capture) and speakers (playback). Based on the
stream direction, snd_soc_dpcm is extracted from snd_soc_pcm_runtime.

Fixes a boot crash on a HP Chromebook x2:

[   16.582225] BUG: kernel NULL pointer dereference, address: 0000000000000050
[   16.582231] #PF: supervisor read access in kernel mode
[   16.582233] #PF: error_code(0x0000) - not-present page
[   16.582234] PGD 0 P4D 0
[   16.582238] Oops: 0000 [#1] PREEMPT SMP PTI
[   16.582241] CPU: 0 PID: 1980 Comm: cras Tainted: G         C        5.4.58 #1
[   16.582243] Hardware name: HP Soraka/Soraka, BIOS Google_Soraka.10431.75.0 08/30/2018
[   16.582247] RIP: 0010:kabylake_ssp_fixup+0x19/0xbb [snd_soc_kbl_rt5663_max98927]
[   16.582250] Code: c6 6f c5 80 c0 44 89 f2 31 c0 e8 3e c9 4c d6 eb de 0f 1f 44 00 00 55 48 89 e5 41 57 41 56 53 48 89 f3 48 8b 46 c8 48 8b 4e d0 <48> 8b 49 10 4c 8b 78 10 4c 8b 31 4c 89 f7 48 c7 c6 4b c2 80 c0 e8
[   16.582252] RSP: 0000:ffffaf7e81e0b958 EFLAGS: 00010282
[   16.582254] RAX: ffffffff96f13e0d RBX: ffffaf7e81e0ba00 RCX: 0000000000000040
[   16.582256] RDX: ffffaf7e81e0ba00 RSI: ffffaf7e81e0ba00 RDI: ffffa3b208558028
[   16.582258] RBP: ffffaf7e81e0b970 R08: ffffa3b203b54160 R09: ffffaf7e81e0ba00
[   16.582259] R10: 0000000000000000 R11: ffffffffc080b345 R12: ffffa3b209fb6e00
[   16.582261] R13: ffffa3b1b1a47838 R14: ffffa3b1e6197f28 R15: ffffaf7e81e0ba00
[   16.582263] FS:  00007eb3f25aaf80(0000) GS:ffffa3b236a00000(0000) knlGS:0000000000000000
[   16.582265] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   16.582267] CR2: 0000000000000050 CR3: 0000000246bc8006 CR4: 00000000003606f0
[   16.582269] Call Trace:
[   16.582275]  snd_soc_link_be_hw_params_fixup+0x21/0x68
[   16.582278]  snd_soc_dai_hw_params+0x25/0x94
[   16.582282]  soc_pcm_hw_params+0x2d8/0x583
[   16.582288]  dpcm_be_dai_hw_params+0x172/0x29e
[   16.582291]  dpcm_fe_dai_hw_params+0x9f/0x12f
[   16.582295]  snd_pcm_hw_params+0x137/0x41c
[   16.582298]  snd_pcm_hw_params_user+0x3c/0x71
[   16.582301]  snd_pcm_common_ioctl+0x2c6/0x565
[   16.582304]  snd_pcm_ioctl+0x32/0x36
[   16.582307]  do_vfs_ioctl+0x506/0x783
[   16.582311]  ksys_ioctl+0x58/0x83
[   16.582313]  __x64_sys_ioctl+0x1a/0x1e
[   16.582316]  do_syscall_64+0x54/0x7e
[   16.582319]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   16.582322] RIP: 0033:0x7eb3f1886157
[   16.582324] Code: 8a 66 90 48 8b 05 11 dd 2b 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e1 dc 2b 00 f7 d8 64 89 01 48
[   16.582326] RSP: 002b:00007ffff7559818 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[   16.582329] RAX: ffffffffffffffda RBX: 00005acc9188b140 RCX: 00007eb3f1886157
[   16.582330] RDX: 00007ffff7559940 RSI: 00000000c2604111 RDI: 000000000000001e
[   16.582332] RBP: 00007ffff7559840 R08: 0000000000000004 R09: 0000000000000000
[   16.582333] R10: 0000000000000000 R11: 0000000000000246 R12: 000000000000bb80
[   16.582335] R13: 00005acc91702e80 R14: 00007ffff7559940 R15: 00005acc91702e80
[   16.582337] Modules linked in: rfcomm cmac algif_hash algif_skcipher af_alg uinput hid_google_hammer snd_soc_kbl_rt5663_max98927 snd_soc_hdac_hdmi snd_soc_dmic snd_soc_skl_ssp_clk snd_soc_skl snd_soc_sst_ipc snd_soc_sst_dsp snd_soc_hdac_hda snd_soc_acpi_intel_match snd_soc_acpi snd_hda_ext_core snd_intel_dspcfg snd_hda_codec snd_hwdep snd_hda_core ipu3_cio2 ipu3_imgu(C) videobuf2_v4l2 videobuf2_common videobuf2_dma_sg videobuf2_memops snd_soc_rt5663 snd_soc_max98927 snd_soc_rl6231 ov5670 ov13858 acpi_als v4l2_fwnode dw9714 fuse xt_MASQUERADE iio_trig_sysfs cros_ec_light_prox cros_ec_sensors cros_ec_sensors_core cros_ec_sensors_ring industrialio_triggered_buffer kfifo_buf industrialio cros_ec_sensorhub cdc_ether usbnet btusb btrtl btintel btbcm bluetooth ecdh_generic ecc lzo_rle lzo_compress iwlmvm zram iwl7000_mac80211 r8152 mii iwlwifi cfg80211 joydev
[   16.584243] gsmi: Log Shutdown Reason 0x03
[   16.584246] CR2: 0000000000000050
[   16.584248] ---[ end trace c8511d090c11edff ]---

Suggested-by: Łukasz Majczak <lmajczak@google.com>
Fixes: 2e5894d73789e ("ASoC: pcm: Add support for DAI multicodec")
Signed-off-by: Tomasz Figa <tfiga@chromium.org>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20201014141624.4143453-1-tfiga@chromium.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/kbl_rt5663_max98927.c | 39 ++++++++++++++++----
 1 file changed, 31 insertions(+), 8 deletions(-)

diff --git a/sound/soc/intel/boards/kbl_rt5663_max98927.c b/sound/soc/intel/boards/kbl_rt5663_max98927.c
index 3ea4602dfb3ee..9a4b3d0973f65 100644
--- a/sound/soc/intel/boards/kbl_rt5663_max98927.c
+++ b/sound/soc/intel/boards/kbl_rt5663_max98927.c
@@ -401,17 +401,40 @@ static int kabylake_ssp_fixup(struct snd_soc_pcm_runtime *rtd,
 	struct snd_interval *chan = hw_param_interval(params,
 			SNDRV_PCM_HW_PARAM_CHANNELS);
 	struct snd_mask *fmt = hw_param_mask(params, SNDRV_PCM_HW_PARAM_FORMAT);
-	struct snd_soc_dpcm *dpcm = container_of(
-			params, struct snd_soc_dpcm, hw_params);
-	struct snd_soc_dai_link *fe_dai_link = dpcm->fe->dai_link;
-	struct snd_soc_dai_link *be_dai_link = dpcm->be->dai_link;
+	struct snd_soc_dpcm *dpcm, *rtd_dpcm = NULL;
+
+	/*
+	 * The following loop will be called only for playback stream
+	 * In this platform, there is only one playback device on every SSP
+	 */
+	for_each_dpcm_fe(rtd, SNDRV_PCM_STREAM_PLAYBACK, dpcm) {
+		rtd_dpcm = dpcm;
+		break;
+	}
+
+	/*
+	 * This following loop will be called only for capture stream
+	 * In this platform, there is only one capture device on every SSP
+	 */
+	for_each_dpcm_fe(rtd, SNDRV_PCM_STREAM_CAPTURE, dpcm) {
+		rtd_dpcm = dpcm;
+		break;
+	}
+
+	if (!rtd_dpcm)
+		return -EINVAL;
+
+	/*
+	 * The above 2 loops are mutually exclusive based on the stream direction,
+	 * thus rtd_dpcm variable will never be overwritten
+	 */
 
 	/*
 	 * The ADSP will convert the FE rate to 48k, stereo, 24 bit
 	 */
-	if (!strcmp(fe_dai_link->name, "Kbl Audio Port") ||
-	    !strcmp(fe_dai_link->name, "Kbl Audio Headset Playback") ||
-	    !strcmp(fe_dai_link->name, "Kbl Audio Capture Port")) {
+	if (!strcmp(rtd_dpcm->fe->dai_link->name, "Kbl Audio Port") ||
+	    !strcmp(rtd_dpcm->fe->dai_link->name, "Kbl Audio Headset Playback") ||
+	    !strcmp(rtd_dpcm->fe->dai_link->name, "Kbl Audio Capture Port")) {
 		rate->min = rate->max = 48000;
 		chan->min = chan->max = 2;
 		snd_mask_none(fmt);
@@ -421,7 +444,7 @@ static int kabylake_ssp_fixup(struct snd_soc_pcm_runtime *rtd,
 	 * The speaker on the SSP0 supports S16_LE and not S24_LE.
 	 * thus changing the mask here
 	 */
-	if (!strcmp(be_dai_link->name, "SSP0-Codec"))
+	if (!strcmp(rtd_dpcm->be->dai_link->name, "SSP0-Codec"))
 		snd_mask_set_format(fmt, SNDRV_PCM_FORMAT_S16_LE);
 
 	return 0;
-- 
2.27.0



