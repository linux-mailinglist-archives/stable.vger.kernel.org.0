Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71F661576D8
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729588AbgBJMzs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:55:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:44774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730065AbgBJMlr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:41:47 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A56942051A;
        Mon, 10 Feb 2020 12:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338506;
        bh=yKxXZCEWEyVJfBRsifezw75Wp5z4MBzqhmrtJyiaQCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z7OkLCe19GhjSII8iON+Ityt5Tvb4ceE1pk9VMPyn9bxzVZmLRc8MKvn6A1tqdd1g
         7jO9iyQTxZyRqUNtsfHYBjL8cTIWZbhf5QB6Tuc7G7dfWHvcdsAN83ELqv4mBh89je
         vqP2uUjrT9woqfgnPE2IH9N/z7EfT6HEjqZ2K98A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.5 308/367] ASoC: Intel: skl_hda_dsp_common: Fix global-out-of-bounds bug
Date:   Mon, 10 Feb 2020 04:33:41 -0800
Message-Id: <20200210122451.809677117@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cezary Rojewski <cezary.rojewski@intel.com>

commit 15adb20f64c302b31e10ad50f22bb224052ce1df upstream.

Definitions for idisp snd_soc_dai_links within skl_hda_dsp_common are
missing platform component. Add it to address following bug reported by
KASAN:

[   10.538502] BUG: KASAN: global-out-of-bounds in skl_hda_audio_probe+0x13a/0x2b0 [snd_soc_skl_hda_dsp]
[   10.538509] Write of size 8 at addr ffffffffc0606840 by task systemd-udevd/299
(...)
[   10.538519] Call Trace:
[   10.538524]  dump_stack+0x62/0x95
[   10.538528]  print_address_description+0x2f5/0x3b0
[   10.538532]  ? skl_hda_audio_probe+0x13a/0x2b0 [snd_soc_skl_hda_dsp]
[   10.538535]  __kasan_report+0x134/0x191
[   10.538538]  ? skl_hda_audio_probe+0x13a/0x2b0 [snd_soc_skl_hda_dsp]
[   10.538542]  ? skl_hda_audio_probe+0x13a/0x2b0 [snd_soc_skl_hda_dsp]
[   10.538544]  kasan_report+0x12/0x20
[   10.538546]  __asan_store8+0x57/0x90
[   10.538550]  skl_hda_audio_probe+0x13a/0x2b0 [snd_soc_skl_hda_dsp]
[   10.538553]  platform_drv_probe+0x51/0xb0
[   10.538556]  really_probe+0x311/0x600
[   10.538559]  driver_probe_device+0x87/0x1b0
[   10.538562]  device_driver_attach+0x8f/0xa0
[   10.538565]  ? device_driver_attach+0xa0/0xa0
[   10.538567]  __driver_attach+0x102/0x1a0
[   10.538569]  ? device_driver_attach+0xa0/0xa0
[   10.538572]  bus_for_each_dev+0xe8/0x160
[   10.538574]  ? subsys_dev_iter_exit+0x10/0x10
[   10.538577]  ? preempt_count_sub+0x18/0xc0
[   10.538580]  ? _raw_write_unlock+0x1f/0x40
[   10.538582]  driver_attach+0x2b/0x30
[   10.538585]  bus_add_driver+0x251/0x340
[   10.538588]  driver_register+0xd3/0x1c0
[   10.538590]  __platform_driver_register+0x6c/0x80
[   10.538592]  ? 0xffffffffc03e8000
[   10.538595]  skl_hda_audio_init+0x1c/0x1000 [snd_soc_skl_hda_dsp]
[   10.538598]  do_one_initcall+0xd0/0x36a
[   10.538600]  ? trace_event_raw_event_initcall_finish+0x160/0x160
[   10.538602]  ? kasan_unpoison_shadow+0x36/0x50
[   10.538605]  ? __kasan_kmalloc+0xcc/0xe0
[   10.538607]  ? kasan_unpoison_shadow+0x36/0x50
[   10.538609]  ? kasan_poison_shadow+0x2f/0x40
[   10.538612]  ? __asan_register_globals+0x65/0x80
[   10.538615]  do_init_module+0xf9/0x36f
[   10.538619]  load_module+0x398e/0x4590
[   10.538625]  ? module_frob_arch_sections+0x20/0x20
[   10.538628]  ? __kasan_check_write+0x14/0x20
[   10.538630]  ? kernel_read+0x9a/0xc0
[   10.538632]  ? __kasan_check_write+0x14/0x20
[   10.538634]  ? kernel_read_file+0x1d3/0x3c0
[   10.538638]  ? cap_capable+0xca/0x110
[   10.538642]  __do_sys_finit_module+0x190/0x1d0
[   10.538644]  ? __do_sys_finit_module+0x190/0x1d0
[   10.538646]  ? __x64_sys_init_module+0x50/0x50
[   10.538649]  ? expand_files+0x380/0x380
[   10.538652]  ? __kasan_check_write+0x14/0x20
[   10.538654]  ? fput_many+0x20/0xc0
[   10.538658]  __x64_sys_finit_module+0x43/0x50
[   10.538660]  do_syscall_64+0xce/0x700
[   10.538662]  ? syscall_return_slowpath+0x230/0x230
[   10.538665]  ? __do_page_fault+0x51e/0x640
[   10.538668]  ? __kasan_check_read+0x11/0x20
[   10.538670]  ? prepare_exit_to_usermode+0xc7/0x200
[   10.538673]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: a78959f407e6 ("ASoC: Intel: skl_hda_dsp_common: use modern dai_link style")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20200122181254.22801-1-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/intel/boards/skl_hda_dsp_common.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

--- a/sound/soc/intel/boards/skl_hda_dsp_common.c
+++ b/sound/soc/intel/boards/skl_hda_dsp_common.c
@@ -41,16 +41,19 @@ int skl_hda_hdmi_add_pcm(struct snd_soc_
 	return 0;
 }
 
-SND_SOC_DAILINK_DEFS(idisp1,
-	DAILINK_COMP_ARRAY(COMP_CPU("iDisp1 Pin")),
+SND_SOC_DAILINK_DEF(idisp1_cpu,
+	DAILINK_COMP_ARRAY(COMP_CPU("iDisp1 Pin")));
+SND_SOC_DAILINK_DEF(idisp1_codec,
 	DAILINK_COMP_ARRAY(COMP_CODEC("ehdaudio0D2", "intel-hdmi-hifi1")));
 
-SND_SOC_DAILINK_DEFS(idisp2,
-	DAILINK_COMP_ARRAY(COMP_CPU("iDisp2 Pin")),
+SND_SOC_DAILINK_DEF(idisp2_cpu,
+	DAILINK_COMP_ARRAY(COMP_CPU("iDisp2 Pin")));
+SND_SOC_DAILINK_DEF(idisp2_codec,
 	DAILINK_COMP_ARRAY(COMP_CODEC("ehdaudio0D2", "intel-hdmi-hifi2")));
 
-SND_SOC_DAILINK_DEFS(idisp3,
-	DAILINK_COMP_ARRAY(COMP_CPU("iDisp3 Pin")),
+SND_SOC_DAILINK_DEF(idisp3_cpu,
+	DAILINK_COMP_ARRAY(COMP_CPU("iDisp3 Pin")));
+SND_SOC_DAILINK_DEF(idisp3_codec,
 	DAILINK_COMP_ARRAY(COMP_CODEC("ehdaudio0D2", "intel-hdmi-hifi3")));
 
 SND_SOC_DAILINK_DEF(analog_cpu,
@@ -83,21 +86,21 @@ struct snd_soc_dai_link skl_hda_be_dai_l
 		.id = 1,
 		.dpcm_playback = 1,
 		.no_pcm = 1,
-		SND_SOC_DAILINK_REG(idisp1),
+		SND_SOC_DAILINK_REG(idisp1_cpu, idisp1_codec, platform),
 	},
 	{
 		.name = "iDisp2",
 		.id = 2,
 		.dpcm_playback = 1,
 		.no_pcm = 1,
-		SND_SOC_DAILINK_REG(idisp2),
+		SND_SOC_DAILINK_REG(idisp2_cpu, idisp2_codec, platform),
 	},
 	{
 		.name = "iDisp3",
 		.id = 3,
 		.dpcm_playback = 1,
 		.no_pcm = 1,
-		SND_SOC_DAILINK_REG(idisp3),
+		SND_SOC_DAILINK_REG(idisp3_cpu, idisp3_codec, platform),
 	},
 	{
 		.name = "Analog Playback and Capture",


