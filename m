Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E81F94C396C
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 00:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbiBXW7Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Feb 2022 17:59:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231147AbiBXW7Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Feb 2022 17:59:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B0851795C2;
        Thu, 24 Feb 2022 14:58:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9B01B829E4;
        Thu, 24 Feb 2022 22:58:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF8D9C340E9;
        Thu, 24 Feb 2022 22:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645743530;
        bh=Ylg6A2P9HZB+ZRH08pcA374lndxYB6JOfvnhC/W0Gm8=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=TJTIOpOJd/1FUXvJYxVpfh3zS8f8vTJFA6Ewi6yHdq6QYHqBJ0vA9GZi0i5AAzSkv
         iGQRn9fr8liJtomTo3MKyEth2Uhwibo6I62yVsNUBSMf9dqENx6gv8poXOY75Qxp96
         e6CnEZwcXhhUofOPyVBD+UslL1WPFRNDMn5sbuXwuAAuqHf3uNf/PVVf4sO7C+hEjC
         Gd++cN7LD7rTfAPmO0mBoGw+d9NINPbdhb98ZYfXF54x2Y1R1t4wQEVtYRPqqQSzRO
         dzf2/95iaj69Z+OybpiU0cN2WQAgySexl1NFWa93oRFDA7fUaWbSgAjna2+x7OCKkp
         Wjw5KinSZyGvw==
From:   Mark Brown <broonie@kernel.org>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Keyon Jie <yang.jie@linux.intel.com>, stable@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        alsa-devel@alsa-project.org, Rander Wang <rander.wang@intel.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Daniel Baluta <daniel.baluta@nxp.com>,
        sound-open-firmware@alsa-project.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>
In-Reply-To: <20220224180850.34592-1-ammarfaizi2@gnuweeb.org>
References: <20220224145124.15985-1-ammarfaizi2@gnuweeb.org> <cfe9e583-e20a-f1d6-2a81-2538ca3ca054@linux.intel.com> <Yhe/3rELNfFOdU4L@sirena.org.uk> <04e79b9c-ccb1-119a-c2e2-34c8ca336215@linux.intel.com> <20220224180850.34592-1-ammarfaizi2@gnuweeb.org>
Subject: Re: [PATCH v2] ASoC: SOF: Intel: Fix NULL ptr dereference when ENOMEM
Message-Id: <164574352749.3982297.13673052813926855452.b4-ty@kernel.org>
Date:   Thu, 24 Feb 2022 22:58:47 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
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

On Fri, 25 Feb 2022 01:08:50 +0700, Ammar Faizi wrote:
> Do not call snd_dma_free_pages() when snd_dma_alloc_pages() returns
> -ENOMEM because it leads to a NULL pointer dereference bug.
> 
> The dmesg says:
> 
>   [ T1387] sof-audio-pci-intel-tgl 0000:00:1f.3: error: memory alloc failed: -12
>   [ T1387] BUG: kernel NULL pointer dereference, address: 0000000000000000
>   [ T1387] #PF: supervisor read access in kernel mode
>   [ T1387] #PF: error_code(0x0000) - not-present page
>   [ T1387] PGD 0 P4D 0
>   [ T1387] Oops: 0000 [#1] PREEMPT SMP NOPTI
>   [ T1387] CPU: 6 PID: 1387 Comm: alsa-sink-HDA A Tainted: G        W         5.17.0-rc4-superb-owl-00055-g80d47f5de5e3 #3 56590caeed02394520e20ca5a2059907eb2d5079
>   [ T1387] Hardware name: HP HP Laptop 14s-dq2xxx/87FD, BIOS F.15 09/15/2021
>   [ T1387] RIP: 0010:dma_free_noncontiguous+0x37/0x80
>   [ T1387] Code: 8b 87 80 03 00 00 48 85 c0 75 07 48 8b 05 f9 39 2b 02 48 85 c0 74 13 4c 8b 48 28 4d 85 c9 74 0a 48 89 da 44 89 c1 5b 41 ff e1 <48> 8b 0b 48 8b 11 48 8b 49 10 48 83 e2 fc 48 81 c6 ff 0f 00 00 48
>   [ T1387] RSP: 0000:ffffc90002b87770 EFLAGS: 00010246
>   [ T1387] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
>   [ T1387] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff888101db30d0
>   [ T1387] RBP: 00000000fffffff4 R08: 0000000000000000 R09: 0000000000000000
>   [ T1387] R10: 0000000000000000 R11: ffffc90002b874d0 R12: 0000000000000001
>   [ T1387] R13: 0000000000058000 R14: ffff888105260c68 R15: ffff888105260828
>   [ T1387] FS:  00007f42e2ffd640(0000) GS:ffff888466b80000(0000) knlGS:0000000000000000
>   [ T1387] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   [ T1387] CR2: 0000000000000000 CR3: 000000014acf0003 CR4: 0000000000770ee0
>   [ T1387] PKRU: 55555554
>   [ T1387] Call Trace:
>   [ T1387]  <TASK>
>   [ T1387]  cl_stream_prepare+0x10a/0x120 [snd_sof_intel_hda_common 146addf995b9279ae7f509621078cccbe4f875e1]
>   [ T1387]  hda_dsp_cl_boot_firmware_iccmax+0x50/0xf0 [snd_sof_intel_hda_common 146addf995b9279ae7f509621078cccbe4f875e1]
>   [ T1387]  snd_sof_run_firmware+0xb5/0x300 [snd_sof b83a5eaf64712c6f474ef3641062bb71902deae4]
>   [ T1387]  sof_resume+0xb1/0x2c0 [snd_sof b83a5eaf64712c6f474ef3641062bb71902deae4]
>   [ T1387]  ? pci_pme_active+0x1b4/0x220
>   [ T1387]  pci_pm_runtime_resume+0xaa/0xe0
>   [ T1387]  ? pci_pm_runtime_suspend+0x190/0x190
>   [ T1387]  __rpm_callback+0x9c/0x320
>   [ T1387]  ? pci_pm_runtime_suspend+0x190/0x190
>   [ T1387]  ? pci_pm_runtime_suspend+0x190/0x190
>   [ T1387]  rpm_resume+0x50d/0x690
>   [ T1387]  __pm_runtime_resume+0x69/0x80
>   [ T1387]  snd_soc_pcm_component_pm_runtime_get+0x60/0xe0 [snd_soc_core 6817f963f4c978c6ec831f778545ab4db1a1023f]
>   [ T1387]  __soc_pcm_open+0x82/0x530 [snd_soc_core 6817f963f4c978c6ec831f778545ab4db1a1023f]
>   [ T1387]  dpcm_be_dai_startup+0x14b/0x260 [snd_soc_core 6817f963f4c978c6ec831f778545ab4db1a1023f]
>   [ T1387]  dpcm_fe_dai_startup+0x73/0x930 [snd_soc_core 6817f963f4c978c6ec831f778545ab4db1a1023f]
>   [ T1387]  ? dpcm_add_paths+0x109/0x1b0 [snd_soc_core 6817f963f4c978c6ec831f778545ab4db1a1023f]
>   [ T1387]  dpcm_fe_dai_open+0x74/0x160 [snd_soc_core 6817f963f4c978c6ec831f778545ab4db1a1023f]
>   [ T1387]  snd_pcm_open_substream+0x56f/0x840 [snd_pcm 2213f8e36532d8bc92ec1ec574108b0385b1b13a]
>   [ T1387]  snd_pcm_open+0xb3/0x1d0 [snd_pcm 2213f8e36532d8bc92ec1ec574108b0385b1b13a]
>   [ T1387]  ? sched_dynamic_update+0x1a0/0x1a0
>   [ T1387]  ? cd_forget+0x80/0x80
>   [ T1387]  snd_pcm_playback_open+0x3c/0x60 [snd_pcm 2213f8e36532d8bc92ec1ec574108b0385b1b13a]
>   [ T1387]  chrdev_open+0x1d3/0x200
>   [ T1387]  ? cd_forget+0x80/0x80
>   [ T1387]  do_dentry_open+0x254/0x370
>   [ T1387]  path_openat+0x9e6/0xbc0
>   [ T1387]  ? lock_release+0x230/0x300
>   [ T1387]  ? snd_ctl_ioctl+0x759/0x900 [snd 1eb0a4959d3d3710c16836cd2838d885bf8f75a9]
>   [ T1387]  do_filp_open+0x93/0x120
>   [ T1387]  ? alloc_fd+0x147/0x180
>   [ T1387]  ? _raw_spin_unlock+0x29/0x40
>   [ T1387]  ? alloc_fd+0x147/0x180
>   [ T1387]  do_sys_openat2+0x68/0x130
>   [ T1387]  __x64_sys_openat+0x6f/0x80
>   [ T1387]  do_syscall_64+0x3d/0xb0
>   [ T1387]  ? exit_to_user_mode_prepare+0x2c/0x50
>   [ T1387]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>   [ T1387] RIP: 0033:0x7f42ee19a6e4
>   [ T1387] Code: 24 20 eb 8f 66 90 44 89 54 24 0c e8 16 d2 f7 ff 44 8b 54 24 0c 44 89 e2 48 89 ee 41 89 c0 bf 9c ff ff ff b8 01 01 00 00 0f 05 <48> 3d 00 f0 ff ff 77 34 44 89 c7 89 44 24 0c e8 58 d2 f7 ff 8b 44
>   [ T1387] RSP: 002b:00007f42e2ffc620 EFLAGS: 00000293 ORIG_RAX: 0000000000000101
>   [ T1387] RAX: ffffffffffffffda RBX: 0000000000080802 RCX: 00007f42ee19a6e4
>   [ T1387] RDX: 0000000000080802 RSI: 00007f42e2ffc6c0 RDI: 00000000ffffff9c
>   [ T1387] RBP: 00007f42e2ffc6c0 R08: 0000000000000000 R09: 00007f42e2ffc437
>   [ T1387] R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000080802
>   [ T1387] R13: 00007f42e8c3faa0 R14: 00007f42e2ffc6c0 R15: 0000000081204101
>   [ T1387]  </TASK>
> 
> [...]

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git for-linus

Thanks!

[1/1] ASoC: SOF: Intel: Fix NULL ptr dereference when ENOMEM
      commit: b7fb0ae09009d076964afe4c1a2bde1ee2bd88a9

All being well this means that it will be integrated into the linux-next
tree (usually sometime in the next 24 hours) and sent to Linus during
the next merge window (or sooner if it is a bug fix), however if
problems are discovered then the patch may be dropped or reverted.

You may get further e-mails resulting from automated or manual testing
and review of the tree, please engage with people reporting problems and
send followup patches addressing any issues that are reported if needed.

If any updates are required or you are submitting further changes they
should be sent as incremental updates against current git, existing
patches will not be replaced.

Please add any relevant lists and maintainers to the CCs when replying
to this mail.

Thanks,
Mark
