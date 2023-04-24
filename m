Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4E96D4877
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233392AbjDCO3C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233389AbjDCO3B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:29:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEFAC3500F
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:28:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5363A61DC8
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:28:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C9BC433EF;
        Mon,  3 Apr 2023 14:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532130;
        bh=zT5hLXeM+lb1YzxAgtlM5aDhaLChWKiDMHbnXx77sns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C+yJeA3ZCtxzfEuOk4jWxvSzHrjh4C3VeuBbnPDbVVhBKHWVWZJUhskHS7jlHdhos
         X9gcVpnEGPsGaygJgYX4ZoqCl2d5pV/2EmBJgx5KG0+eLaRflm0830P6AEUeToW8zB
         EWwkIMElWNtjp1j4UFHnY4qVVVVZF+dCHguMC9Lw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tasos Sahanidis <tasos@tasossah.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 138/173] ALSA: ymfpci: Fix BUG_ON in probe function
Date:   Mon,  3 Apr 2023 16:09:13 +0200
Message-Id: <20230403140418.940793999@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tasos Sahanidis <tasos@tasossah.com>

[ Upstream commit 6be2e7522eb529b41c16d459f33bbdbcddbf5c15 ]

The snd_dma_buffer.bytes field now contains the aligned size, which this
snd_BUG_ON() did not account for, resulting in the following:

[    9.625915] ------------[ cut here ]------------
[    9.633440] WARNING: CPU: 0 PID: 126 at sound/pci/ymfpci/ymfpci_main.c:2168 snd_ymfpci_create+0x681/0x698 [snd_ymfpci]
[    9.648926] Modules linked in: snd_ymfpci(+) snd_intel_dspcfg kvm(+) snd_intel_sdw_acpi snd_ac97_codec snd_mpu401_uart snd_opl3_lib irqbypass snd_hda_codec gameport snd_rawmidi crct10dif_pclmul crc32_pclmul cfg80211 snd_hda_core polyval_clmulni polyval_generic gf128mul snd_seq_device ghash_clmulni_intel snd_hwdep ac97_bus sha512_ssse3 rfkill snd_pcm aesni_intel tg3 snd_timer crypto_simd snd mxm_wmi libphy cryptd k10temp fam15h_power pcspkr soundcore sp5100_tco wmi acpi_cpufreq mac_hid dm_multipath sg loop fuse dm_mod bpf_preload ip_tables x_tables ext4 crc32c_generic crc16 mbcache jbd2 sr_mod cdrom ata_generic pata_acpi firewire_ohci crc32c_intel firewire_core xhci_pci crc_itu_t pata_via xhci_pci_renesas floppy
[    9.711849] CPU: 0 PID: 126 Comm: kworker/0:2 Not tainted 6.1.21-1-lts #1 08d2e5ece03136efa7c6aeea9a9c40916b1bd8da
[    9.722200] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./990FX Extreme4, BIOS P2.70 06/05/2014
[    9.732204] Workqueue: events work_for_cpu_fn
[    9.736580] RIP: 0010:snd_ymfpci_create+0x681/0x698 [snd_ymfpci]
[    9.742594] Code: 8c c0 4c 89 e2 48 89 df 48 c7 c6 92 c6 8c c0 e8 15 d0 e9 ff 48 83 c4 08 44 89 e8 5b 5d 41 5c 41 5d 41 5e 41 5f e9 d3 7a 33 e3 <0f> 0b e9 cb fd ff ff 41 bd fb ff ff ff eb db 41 bd f4 ff ff ff eb
[    9.761358] RSP: 0018:ffffab64804e7da0 EFLAGS: 00010287
[    9.766594] RAX: ffff8fa2df06c400 RBX: ffff8fa3073a8000 RCX: ffff8fa303fbc4a8
[    9.773734] RDX: ffff8fa2df06d000 RSI: 0000000000000010 RDI: 0000000000000020
[    9.780876] RBP: ffff8fa300b5d0d0 R08: ffff8fa3073a8e50 R09: 00000000df06bf00
[    9.788018] R10: ffff8fa2df06bf00 R11: 00000000df068200 R12: ffff8fa3073a8918
[    9.795159] R13: 0000000000000000 R14: 0000000000000080 R15: ffff8fa2df068200
[    9.802317] FS:  0000000000000000(0000) GS:ffff8fa9fec00000(0000) knlGS:0000000000000000
[    9.810414] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    9.816158] CR2: 000055febaf66500 CR3: 0000000101a2e000 CR4: 00000000000406f0
[    9.823301] Call Trace:
[    9.825747]  <TASK>
[    9.827889]  snd_card_ymfpci_probe+0x194/0x950 [snd_ymfpci b78a5fe64b5663a6390a909c67808567e3e73615]
[    9.837030]  ? finish_task_switch.isra.0+0x90/0x2d0
[    9.841918]  local_pci_probe+0x45/0x80
[    9.845680]  work_for_cpu_fn+0x1a/0x30
[    9.849431]  process_one_work+0x1c7/0x380
[    9.853464]  worker_thread+0x1af/0x390
[    9.857225]  ? rescuer_thread+0x3b0/0x3b0
[    9.861254]  kthread+0xde/0x110
[    9.864414]  ? kthread_complete_and_exit+0x20/0x20
[    9.869210]  ret_from_fork+0x22/0x30
[    9.872792]  </TASK>
[    9.874985] ---[ end trace 0000000000000000 ]---

Fixes: 5c1733e33c88 ("ALSA: memalloc: Align buffer allocations in page size")
Signed-off-by: Tasos Sahanidis <tasos@tasossah.com>
Link: https://lore.kernel.org/r/20230329032808.170403-1-tasos@tasossah.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/ymfpci/ymfpci_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/ymfpci/ymfpci_main.c b/sound/pci/ymfpci/ymfpci_main.c
index 8fd0607698820..0cd9b4029dab1 100644
--- a/sound/pci/ymfpci/ymfpci_main.c
+++ b/sound/pci/ymfpci/ymfpci_main.c
@@ -2164,7 +2164,7 @@ static int snd_ymfpci_memalloc(struct snd_ymfpci *chip)
 	chip->work_base = ptr;
 	chip->work_base_addr = ptr_addr;
 	
-	snd_BUG_ON(ptr + chip->work_size !=
+	snd_BUG_ON(ptr + PAGE_ALIGN(chip->work_size) !=
 		   chip->work_ptr.area + chip->work_ptr.bytes);
 
 	snd_ymfpci_writel(chip, YDSXGR_PLAYCTRLBASE, chip->bank_base_playback_addr);
-- 
2.39.2



