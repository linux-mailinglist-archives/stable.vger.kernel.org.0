Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0D284C3455
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 19:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232537AbiBXSKL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Feb 2022 13:10:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbiBXSKK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Feb 2022 13:10:10 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D2131E6952;
        Thu, 24 Feb 2022 10:09:39 -0800 (PST)
Received: from integral2.. (unknown [36.78.50.60])
        by gnuweeb.org (Postfix) with ESMTPSA id F2A237E2A3;
        Thu, 24 Feb 2022 18:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1645726178;
        bh=fQ7yWSmUmNGgta8pPPpdWD21dq5EbkzWZGN4fe3AJWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SmpHCmsZ397u9Gf4qpj7lqWmqdWL56tmeNuikhpi8UmTYyauGz0+DOTrMhFG9wJcs
         dDNLO3jd+OH/H8MbI3ZUMLa2dpcbpY8HbMI+KA21qtwJ0vYFDy3cFvG5DWCTlLagPK
         I+xmjz0BJNd41pl9TeWgvqmm5puSPsc/I33scVqe6yNIqyWiji4qovhU9Dl4kUnc8R
         iK+T0CdfkTvLmzlavDdCwj/wAlkA2n5svOcLoXtxS4Y79LvGN8LOmgUu8LVVY89f5k
         DrBah9dVH6AwTIWXSg0hImk2YIcFh+0oJT3PGUVj/c9lPFq0cmmhfKshifwMGT/Rey
         Udmx8aacFP2Zw==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Daniel Baluta <daniel.baluta@nxp.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Keyon Jie <yang.jie@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Takashi Iwai <tiwai@suse.com>, stable@vger.kernel.org,
        sound-open-firmware@alsa-project.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] ASoC: SOF: Intel: Fix NULL ptr dereference when ENOMEM
Date:   Fri, 25 Feb 2022 01:08:50 +0700
Message-Id: <20220224180850.34592-1-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220224145124.15985-1-ammarfaizi2@gnuweeb.org>
References: <20220224145124.15985-1-ammarfaizi2@gnuweeb.org> <cfe9e583-e20a-f1d6-2a81-2538ca3ca054@linux.intel.com> <Yhe/3rELNfFOdU4L@sirena.org.uk> <04e79b9c-ccb1-119a-c2e2-34c8ca336215@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Do not call snd_dma_free_pages() when snd_dma_alloc_pages() returns
-ENOMEM because it leads to a NULL pointer dereference bug.

The dmesg says:

  [ T1387] sof-audio-pci-intel-tgl 0000:00:1f.3: error: memory alloc failed: -12
  [ T1387] BUG: kernel NULL pointer dereference, address: 0000000000000000
  [ T1387] #PF: supervisor read access in kernel mode
  [ T1387] #PF: error_code(0x0000) - not-present page
  [ T1387] PGD 0 P4D 0
  [ T1387] Oops: 0000 [#1] PREEMPT SMP NOPTI
  [ T1387] CPU: 6 PID: 1387 Comm: alsa-sink-HDA A Tainted: G        W         5.17.0-rc4-superb-owl-00055-g80d47f5de5e3 #3 56590caeed02394520e20ca5a2059907eb2d5079
  [ T1387] Hardware name: HP HP Laptop 14s-dq2xxx/87FD, BIOS F.15 09/15/2021
  [ T1387] RIP: 0010:dma_free_noncontiguous+0x37/0x80
  [ T1387] Code: 8b 87 80 03 00 00 48 85 c0 75 07 48 8b 05 f9 39 2b 02 48 85 c0 74 13 4c 8b 48 28 4d 85 c9 74 0a 48 89 da 44 89 c1 5b 41 ff e1 <48> 8b 0b 48 8b 11 48 8b 49 10 48 83 e2 fc 48 81 c6 ff 0f 00 00 48
  [ T1387] RSP: 0000:ffffc90002b87770 EFLAGS: 00010246
  [ T1387] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
  [ T1387] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff888101db30d0
  [ T1387] RBP: 00000000fffffff4 R08: 0000000000000000 R09: 0000000000000000
  [ T1387] R10: 0000000000000000 R11: ffffc90002b874d0 R12: 0000000000000001
  [ T1387] R13: 0000000000058000 R14: ffff888105260c68 R15: ffff888105260828
  [ T1387] FS:  00007f42e2ffd640(0000) GS:ffff888466b80000(0000) knlGS:0000000000000000
  [ T1387] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [ T1387] CR2: 0000000000000000 CR3: 000000014acf0003 CR4: 0000000000770ee0
  [ T1387] PKRU: 55555554
  [ T1387] Call Trace:
  [ T1387]  <TASK>
  [ T1387]  cl_stream_prepare+0x10a/0x120 [snd_sof_intel_hda_common 146addf995b9279ae7f509621078cccbe4f875e1]
  [ T1387]  hda_dsp_cl_boot_firmware_iccmax+0x50/0xf0 [snd_sof_intel_hda_common 146addf995b9279ae7f509621078cccbe4f875e1]
  [ T1387]  snd_sof_run_firmware+0xb5/0x300 [snd_sof b83a5eaf64712c6f474ef3641062bb71902deae4]
  [ T1387]  sof_resume+0xb1/0x2c0 [snd_sof b83a5eaf64712c6f474ef3641062bb71902deae4]
  [ T1387]  ? pci_pme_active+0x1b4/0x220
  [ T1387]  pci_pm_runtime_resume+0xaa/0xe0
  [ T1387]  ? pci_pm_runtime_suspend+0x190/0x190
  [ T1387]  __rpm_callback+0x9c/0x320
  [ T1387]  ? pci_pm_runtime_suspend+0x190/0x190
  [ T1387]  ? pci_pm_runtime_suspend+0x190/0x190
  [ T1387]  rpm_resume+0x50d/0x690
  [ T1387]  __pm_runtime_resume+0x69/0x80
  [ T1387]  snd_soc_pcm_component_pm_runtime_get+0x60/0xe0 [snd_soc_core 6817f963f4c978c6ec831f778545ab4db1a1023f]
  [ T1387]  __soc_pcm_open+0x82/0x530 [snd_soc_core 6817f963f4c978c6ec831f778545ab4db1a1023f]
  [ T1387]  dpcm_be_dai_startup+0x14b/0x260 [snd_soc_core 6817f963f4c978c6ec831f778545ab4db1a1023f]
  [ T1387]  dpcm_fe_dai_startup+0x73/0x930 [snd_soc_core 6817f963f4c978c6ec831f778545ab4db1a1023f]
  [ T1387]  ? dpcm_add_paths+0x109/0x1b0 [snd_soc_core 6817f963f4c978c6ec831f778545ab4db1a1023f]
  [ T1387]  dpcm_fe_dai_open+0x74/0x160 [snd_soc_core 6817f963f4c978c6ec831f778545ab4db1a1023f]
  [ T1387]  snd_pcm_open_substream+0x56f/0x840 [snd_pcm 2213f8e36532d8bc92ec1ec574108b0385b1b13a]
  [ T1387]  snd_pcm_open+0xb3/0x1d0 [snd_pcm 2213f8e36532d8bc92ec1ec574108b0385b1b13a]
  [ T1387]  ? sched_dynamic_update+0x1a0/0x1a0
  [ T1387]  ? cd_forget+0x80/0x80
  [ T1387]  snd_pcm_playback_open+0x3c/0x60 [snd_pcm 2213f8e36532d8bc92ec1ec574108b0385b1b13a]
  [ T1387]  chrdev_open+0x1d3/0x200
  [ T1387]  ? cd_forget+0x80/0x80
  [ T1387]  do_dentry_open+0x254/0x370
  [ T1387]  path_openat+0x9e6/0xbc0
  [ T1387]  ? lock_release+0x230/0x300
  [ T1387]  ? snd_ctl_ioctl+0x759/0x900 [snd 1eb0a4959d3d3710c16836cd2838d885bf8f75a9]
  [ T1387]  do_filp_open+0x93/0x120
  [ T1387]  ? alloc_fd+0x147/0x180
  [ T1387]  ? _raw_spin_unlock+0x29/0x40
  [ T1387]  ? alloc_fd+0x147/0x180
  [ T1387]  do_sys_openat2+0x68/0x130
  [ T1387]  __x64_sys_openat+0x6f/0x80
  [ T1387]  do_syscall_64+0x3d/0xb0
  [ T1387]  ? exit_to_user_mode_prepare+0x2c/0x50
  [ T1387]  entry_SYSCALL_64_after_hwframe+0x44/0xae
  [ T1387] RIP: 0033:0x7f42ee19a6e4
  [ T1387] Code: 24 20 eb 8f 66 90 44 89 54 24 0c e8 16 d2 f7 ff 44 8b 54 24 0c 44 89 e2 48 89 ee 41 89 c0 bf 9c ff ff ff b8 01 01 00 00 0f 05 <48> 3d 00 f0 ff ff 77 34 44 89 c7 89 44 24 0c e8 58 d2 f7 ff 8b 44
  [ T1387] RSP: 002b:00007f42e2ffc620 EFLAGS: 00000293 ORIG_RAX: 0000000000000101
  [ T1387] RAX: ffffffffffffffda RBX: 0000000000080802 RCX: 00007f42ee19a6e4
  [ T1387] RDX: 0000000000080802 RSI: 00007f42e2ffc6c0 RDI: 00000000ffffff9c
  [ T1387] RBP: 00007f42e2ffc6c0 R08: 0000000000000000 R09: 00007f42e2ffc437
  [ T1387] R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000080802
  [ T1387] R13: 00007f42e8c3faa0 R14: 00007f42e2ffc6c0 R15: 0000000081204101
  [ T1387]  </TASK>

  [... snip linked modules ...]

  [ T1387] CR2: 0000000000000000
  [ T1387] ---[ end trace 0000000000000000 ]---
  [ T1387] RIP: 0010:dma_free_noncontiguous+0x37/0x80
  [ T1387] Code: 8b 87 80 03 00 00 48 85 c0 75 07 48 8b 05 f9 39 2b 02 48 85 c0 74 13 4c 8b 48 28 4d 85 c9 74 0a 48 89 da 44 89 c1 5b 41 ff e1 <48> 8b 0b 48 8b 11 48 8b 49 10 48 83 e2 fc 48 81 c6 ff 0f 00 00 48
  [ T1387] RSP: 0000:ffffc90002b87770 EFLAGS: 00010246
  [ T1387] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
  [ T1387] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff888101db30d0
  [ T1387] RBP: 00000000fffffff4 R08: 0000000000000000 R09: 0000000000000000
  [ T1387] R10: 0000000000000000 R11: ffffc90002b874d0 R12: 0000000000000001
  [ T1387] R13: 0000000000058000 R14: ffff888105260c68 R15: ffff888105260828
  [ T1387] FS:  00007f42e2ffd640(0000) GS:ffff888466b80000(0000) knlGS:0000000000000000
  [ T1387] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [ T1387] CR2: 0000000000000000 CR3: 000000014acf0003 CR4: 0000000000770ee0
  [ T1387] PKRU: 55555554

Cc: Daniel Baluta <daniel.baluta@nxp.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Cc: Keyon Jie <yang.jie@linux.intel.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Cc: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc: Rander Wang <rander.wang@intel.com>
Cc: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Cc: Takashi Iwai <tiwai@suse.com>
Fixes: d16046ffa6de040bf580a64d5f4d0aa18258a854 ("ASoC: SOF: Intel: Add Intel specific HDA firmware loader")
Cc: stable@vger.kernel.org # v5.2+
Cc: sound-open-firmware@alsa-project.org
Cc: alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org
Link: https://lore.kernel.org/lkml/cfe9e583-e20a-f1d6-2a81-2538ca3ca054@linux.intel.com/T/ # v1
Reviewed-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---

 v2:
   - Append Reviewed-by tag from Peter Ujfalusi.
   - Append Reviewed-by tag from Pierre-Louis Bossart.
   - Address comment from Mark Brown (strip irrelevant kernel log
     from the commit message).

 sound/soc/sof/intel/hda-loader.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/sound/soc/sof/intel/hda-loader.c b/sound/soc/sof/intel/hda-loader.c
index 33306d2023a7..9bbfdab8009d 100644
--- a/sound/soc/sof/intel/hda-loader.c
+++ b/sound/soc/sof/intel/hda-loader.c
@@ -47,7 +47,7 @@ static struct hdac_ext_stream *cl_stream_prepare(struct snd_sof_dev *sdev, unsig
 	ret = snd_dma_alloc_pages(SNDRV_DMA_TYPE_DEV_SG, &pci->dev, size, dmab);
 	if (ret < 0) {
 		dev_err(sdev->dev, "error: memory alloc failed: %d\n", ret);
-		goto error;
+		goto out_put;
 	}
 
 	hstream->period_bytes = 0;/* initialize period_bytes */
@@ -58,22 +58,23 @@ static struct hdac_ext_stream *cl_stream_prepare(struct snd_sof_dev *sdev, unsig
 		ret = hda_dsp_iccmax_stream_hw_params(sdev, dsp_stream, dmab, NULL);
 		if (ret < 0) {
 			dev_err(sdev->dev, "error: iccmax stream prepare failed: %d\n", ret);
-			goto error;
+			goto out_free;
 		}
 	} else {
 		ret = hda_dsp_stream_hw_params(sdev, dsp_stream, dmab, NULL);
 		if (ret < 0) {
 			dev_err(sdev->dev, "error: hdac prepare failed: %d\n", ret);
-			goto error;
+			goto out_free;
 		}
 		hda_dsp_stream_spib_config(sdev, dsp_stream, HDA_DSP_SPIB_ENABLE, size);
 	}
 
 	return dsp_stream;
 
-error:
-	hda_dsp_stream_put(sdev, direction, hstream->stream_tag);
+out_free:
 	snd_dma_free_pages(dmab);
+out_put:
+	hda_dsp_stream_put(sdev, direction, hstream->stream_tag);
 	return ERR_PTR(ret);
 }
 
-- 
2.32.0

