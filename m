Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A31C54C3253
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 17:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbiBXQ4T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Feb 2022 11:56:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbiBXQ4S (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Feb 2022 11:56:18 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6949322B19;
        Thu, 24 Feb 2022 08:55:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645721748; x=1677257748;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Kdc/kDi85eSZ30AnLl4On+fGpv6QGUrLsr/hZs2QuMg=;
  b=agZdMY7r2jnFb3cQuZ7ea3mKkR5b6fyUOJyZ2D7z1L5SrhBBrgt0X9CM
   Up+SCYXNK+xLJCH2+LPKakMpYRaHyRnU9NOH7L8IbSsC1vTFXuh224rxl
   IbweJQYd5sXWuZUJiHUapMStM9h1i6u2FtybjUFJaYgqd3b1yKeE+4Tqt
   QWvOu4bkO1BSVsk7EhN1B8PK/M+rVH0iIPx40TAIV45sMY9vmGtw3smLG
   k+p5hCOd/8DMQdYLAe0GrbHPTsLfqurIYtBUlcqIaX7IDF8lPmBfOPWBS
   Yde9fzJNbc9IuEWM/TboLUCyh0Emy27jTQd+ByK8/PiACy++lEJTQCCXc
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10268"; a="249866076"
X-IronPort-AV: E=Sophos;i="5.90,134,1643702400"; 
   d="scan'208";a="249866076"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 08:53:52 -0800
X-IronPort-AV: E=Sophos;i="5.90,134,1643702400"; 
   d="scan'208";a="707520237"
Received: from mmendonp-mobl.gar.corp.intel.com (HELO [10.252.43.7]) ([10.252.43.7])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 08:53:47 -0800
Message-ID: <cfe9e583-e20a-f1d6-2a81-2538ca3ca054@linux.intel.com>
Date:   Thu, 24 Feb 2022 18:53:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH] ASoC: SOF: Intel: Fix NULL ptr dereference when ENOMEM
Content-Language: en-US
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Mark Brown <broonie@kernel.org>
Cc:     Daniel Baluta <daniel.baluta@nxp.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Keyon Jie <yang.jie@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Takashi Iwai <tiwai@suse.com>, stable@vger.kernel.org,
        sound-open-firmware@alsa-project.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
References: <20220224145124.15985-1-ammarfaizi2@gnuweeb.org>
From:   =?UTF-8?Q?P=c3=a9ter_Ujfalusi?= <peter.ujfalusi@linux.intel.com>
In-Reply-To: <20220224145124.15985-1-ammarfaizi2@gnuweeb.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 24/02/2022 16:51, Ammar Faizi wrote:
> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
>=20
> Do not call snd_dma_free_pages() when snd_dma_alloc_pages() returns
> -ENOMEM because it leads to a NULL pointer dereference bug.

Reviewed-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

> The dmesg says:
>=20
>   <6>[109482.497835][T138537] usb 1-2: Manufacturer: SIGMACHIP
>   <6>[109482.502506][T138537] input: SIGMACHIP USB Keyboard as /devices=
/pci0000:00/0000:00:14.0/usb1/1-2/1-2:1.0/0003:1C4F:0002.000D/input/input=
34
>   <6>[109482.558976][T138537] hid-generic 0003:1C4F:0002.000D: input,hi=
draw1: USB HID v1.10 Keyboard [SIGMACHIP USB Keyboard] on usb-0000:00:14.=
0-2/input0
>   <6>[109482.561653][T138537] input: SIGMACHIP USB Keyboard Consumer Co=
ntrol as /devices/pci0000:00/0000:00:14.0/usb1/1-2/1-2:1.1/0003:1C4F:0002=
=2E000E/input/input35
>   <6>[109482.615490][T138537] input: SIGMACHIP USB Keyboard System Cont=
rol as /devices/pci0000:00/0000:00:14.0/usb1/1-2/1-2:1.1/0003:1C4F:0002.0=
00E/input/input36
>   <6>[109482.615643][T138537] hid-generic 0003:1C4F:0002.000E: input,hi=
draw2: USB HID v1.10 Device [SIGMACHIP USB Keyboard] on usb-0000:00:14.0-=
2/input1
>   <4>[110102.335460][T140985] rtw_8822ce 0000:01:00.0: timed out to flu=
sh queue 1
>   <3>[118575.730928][ T1387] sof-audio-pci-intel-tgl 0000:00:1f.3: erro=
r: memory alloc failed: -12

Wow, I wonder what is going on that allocation fails...

>   <1>[118575.730948][ T1387] BUG: kernel NULL pointer dereference, addr=
ess: 0000000000000000
>   <1>[118575.730951][ T1387] #PF: supervisor read access in kernel mode=

>   <1>[118575.730953][ T1387] #PF: error_code(0x0000) - not-present page=

>   <6>[118575.730956][ T1387] PGD 0 P4D 0
>   <4>[118575.730960][ T1387] Oops: 0000 [#1] PREEMPT SMP NOPTI
>   <4>[118575.730965][ T1387] CPU: 6 PID: 1387 Comm: alsa-sink-HDA A Tai=
nted: G        W         5.17.0-rc4-superb-owl-00055-g80d47f5de5e3 #3 565=
90caeed02394520e20ca5a2059907eb2d5079
>   <4>[118575.730969][ T1387] Hardware name: HP HP Laptop 14s-dq2xxx/87F=
D, BIOS F.15 09/15/2021
>   <4>[118575.730972][ T1387] RIP: 0010:dma_free_noncontiguous+0x37/0x80=

>   <4>[118575.730979][ T1387] Code: 8b 87 80 03 00 00 48 85 c0 75 07 48 =
8b 05 f9 39 2b 02 48 85 c0 74 13 4c 8b 48 28 4d 85 c9 74 0a 48 89 da 44 8=
9 c1 5b 41 ff e1 <48> 8b 0b 48 8b 11 48 8b 49 10 48 83 e2 fc 48 81 c6 ff =
0f 00 00 48
>   <4>[118575.730982][ T1387] RSP: 0000:ffffc90002b87770 EFLAGS: 0001024=
6
>   <4>[118575.730986][ T1387] RAX: 0000000000000000 RBX: 000000000000000=
0 RCX: 0000000000000000
>   <4>[118575.730987][ T1387] RDX: 0000000000000000 RSI: 000000000000000=
0 RDI: ffff888101db30d0
>   <4>[118575.730989][ T1387] RBP: 00000000fffffff4 R08: 000000000000000=
0 R09: 0000000000000000
>   <4>[118575.730991][ T1387] R10: 0000000000000000 R11: ffffc90002b874d=
0 R12: 0000000000000001
>   <4>[118575.730993][ T1387] R13: 0000000000058000 R14: ffff888105260c6=
8 R15: ffff888105260828
>   <4>[118575.730995][ T1387] FS:  00007f42e2ffd640(0000) GS:ffff888466b=
80000(0000) knlGS:0000000000000000
>   <4>[118575.730998][ T1387] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008=
0050033
>   <4>[118575.731000][ T1387] CR2: 0000000000000000 CR3: 000000014acf000=
3 CR4: 0000000000770ee0
>   <4>[118575.731003][ T1387] PKRU: 55555554
>   <4>[118575.731005][ T1387] Call Trace:
>   <4>[118575.731009][ T1387]  <TASK>
>   <4>[118575.731016][ T1387]  cl_stream_prepare+0x10a/0x120 [snd_sof_in=
tel_hda_common 146addf995b9279ae7f509621078cccbe4f875e1]
>   <4>[118575.731027][ T1387]  hda_dsp_cl_boot_firmware_iccmax+0x50/0xf0=
 [snd_sof_intel_hda_common 146addf995b9279ae7f509621078cccbe4f875e1]
>   <4>[118575.731034][ T1387]  snd_sof_run_firmware+0xb5/0x300 [snd_sof =
b83a5eaf64712c6f474ef3641062bb71902deae4]
>   <4>[118575.731045][ T1387]  sof_resume+0xb1/0x2c0 [snd_sof b83a5eaf64=
712c6f474ef3641062bb71902deae4]
>   <4>[118575.731054][ T1387]  ? pci_pme_active+0x1b4/0x220
>   <4>[118575.731060][ T1387]  pci_pm_runtime_resume+0xaa/0xe0
>   <4>[118575.731064][ T1387]  ? pci_pm_runtime_suspend+0x190/0x190
>   <4>[118575.731067][ T1387]  __rpm_callback+0x9c/0x320
>   <4>[118575.731072][ T1387]  ? pci_pm_runtime_suspend+0x190/0x190
>   <4>[118575.731075][ T1387]  ? pci_pm_runtime_suspend+0x190/0x190
>   <4>[118575.731077][ T1387]  rpm_resume+0x50d/0x690
>   <4>[118575.731082][ T1387]  __pm_runtime_resume+0x69/0x80
>   <4>[118575.731085][ T1387]  snd_soc_pcm_component_pm_runtime_get+0x60=
/0xe0 [snd_soc_core 6817f963f4c978c6ec831f778545ab4db1a1023f]
>   <4>[118575.731102][ T1387]  __soc_pcm_open+0x82/0x530 [snd_soc_core 6=
817f963f4c978c6ec831f778545ab4db1a1023f]
>   <4>[118575.731114][ T1387]  dpcm_be_dai_startup+0x14b/0x260 [snd_soc_=
core 6817f963f4c978c6ec831f778545ab4db1a1023f]
>   <4>[118575.731128][ T1387]  dpcm_fe_dai_startup+0x73/0x930 [snd_soc_c=
ore 6817f963f4c978c6ec831f778545ab4db1a1023f]
>   <4>[118575.731139][ T1387]  ? dpcm_add_paths+0x109/0x1b0 [snd_soc_cor=
e 6817f963f4c978c6ec831f778545ab4db1a1023f]
>   <4>[118575.731152][ T1387]  dpcm_fe_dai_open+0x74/0x160 [snd_soc_core=
 6817f963f4c978c6ec831f778545ab4db1a1023f]
>   <4>[118575.731166][ T1387]  snd_pcm_open_substream+0x56f/0x840 [snd_p=
cm 2213f8e36532d8bc92ec1ec574108b0385b1b13a]
>   <4>[118575.731177][ T1387]  snd_pcm_open+0xb3/0x1d0 [snd_pcm 2213f8e3=
6532d8bc92ec1ec574108b0385b1b13a]
>   <4>[118575.731185][ T1387]  ? sched_dynamic_update+0x1a0/0x1a0
>   <4>[118575.731189][ T1387]  ? cd_forget+0x80/0x80
>   <4>[118575.731194][ T1387]  snd_pcm_playback_open+0x3c/0x60 [snd_pcm =
2213f8e36532d8bc92ec1ec574108b0385b1b13a]
>   <4>[118575.731201][ T1387]  chrdev_open+0x1d3/0x200
>   <4>[118575.731205][ T1387]  ? cd_forget+0x80/0x80
>   <4>[118575.731208][ T1387]  do_dentry_open+0x254/0x370
>   <4>[118575.731213][ T1387]  path_openat+0x9e6/0xbc0
>   <4>[118575.731218][ T1387]  ? lock_release+0x230/0x300
>   <4>[118575.731223][ T1387]  ? snd_ctl_ioctl+0x759/0x900 [snd 1eb0a495=
9d3d3710c16836cd2838d885bf8f75a9]
>   <4>[118575.731232][ T1387]  do_filp_open+0x93/0x120
>   <4>[118575.731237][ T1387]  ? alloc_fd+0x147/0x180
>   <4>[118575.731242][ T1387]  ? _raw_spin_unlock+0x29/0x40
>   <4>[118575.731246][ T1387]  ? alloc_fd+0x147/0x180
>   <4>[118575.731251][ T1387]  do_sys_openat2+0x68/0x130
>   <4>[118575.731255][ T1387]  __x64_sys_openat+0x6f/0x80
>   <4>[118575.731259][ T1387]  do_syscall_64+0x3d/0xb0
>   <4>[118575.731264][ T1387]  ? exit_to_user_mode_prepare+0x2c/0x50
>   <4>[118575.731267][ T1387]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>   <4>[118575.731271][ T1387] RIP: 0033:0x7f42ee19a6e4
>   <4>[118575.731274][ T1387] Code: 24 20 eb 8f 66 90 44 89 54 24 0c e8 =
16 d2 f7 ff 44 8b 54 24 0c 44 89 e2 48 89 ee 41 89 c0 bf 9c ff ff ff b8 0=
1 01 00 00 0f 05 <48> 3d 00 f0 ff ff 77 34 44 89 c7 89 44 24 0c e8 58 d2 =
f7 ff 8b 44
>   <4>[118575.731277][ T1387] RSP: 002b:00007f42e2ffc620 EFLAGS: 0000029=
3 ORIG_RAX: 0000000000000101
>   <4>[118575.731281][ T1387] RAX: ffffffffffffffda RBX: 000000000008080=
2 RCX: 00007f42ee19a6e4
>   <4>[118575.731283][ T1387] RDX: 0000000000080802 RSI: 00007f42e2ffc6c=
0 RDI: 00000000ffffff9c
>   <4>[118575.731284][ T1387] RBP: 00007f42e2ffc6c0 R08: 000000000000000=
0 R09: 00007f42e2ffc437
>   <4>[118575.731286][ T1387] R10: 0000000000000000 R11: 000000000000029=
3 R12: 0000000000080802
>   <4>[118575.731289][ T1387] R13: 00007f42e8c3faa0 R14: 00007f42e2ffc6c=
0 R15: 0000000081204101
>   <4>[118575.731293][ T1387]  </TASK>
>   <4>[118575.731294][ T1387] Modules linked in: ccm xt_CHECKSUM xt_MASQ=
UERADE xt_conntrack ipt_REJECT nf_reject_ipv4 xt_tcpudp nft_compat rfcomm=
 nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_table=
s nfnetlink bridge stp llc snd_soc_skl_hda_dsp snd_soc_hdac_hdmi snd_soc_=
intel_hda_dsp_common snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_cod=
ec_generic cmac algif_hash algif_skcipher af_alg bnep zram snd_soc_dmic s=
nd_sof_pci_intel_tgl snd_sof_intel_hda_common i915 nls_iso8859_1 snd_soc_=
hdac_hda snd_sof_intel_hda soundwire_intel soundwire_generic_allocation s=
oundwire_cadence snd_sof_pci snd_sof_xtensa_dsp rtw88_8822ce snd_sof rtw8=
8_8822c rtw88_pci snd_hda_ext_core rtw88_core snd_soc_acpi_intel_match in=
tel_tcc_cooling snd_soc_acpi x86_pkg_temp_thermal soundwire_bus intel_pow=
erclamp coretemp ledtrig_audio snd_soc_core mac80211 snd_compress ac97_bu=
s snd_pcm_dmaengine snd_hda_intel snd_intel_dspcfg snd_intel_sdw_acpi snd=
_hda_codec ttm snd_hda_core kvm_intel snd_hwdep btusb
>   <4>[118575.731347][ T1387]  drm_kms_helper snd_pcm uvcvideo btrtl btm=
tk btintel snd_seq_midi btbcm snd_seq_midi_event videobuf2_v4l2 snd_rawmi=
di mei_hdcp intel_rapl_msr videobuf2_vmalloc bluetooth cfg80211 kvm snd_s=
eq cec videobuf2_memops crct10dif_pclmul videobuf2_common rc_core ghash_c=
lmulni_intel aesni_intel snd_seq_device processor_thermal_device_pci_lega=
cy videodev i2c_algo_bit snd_timer processor_thermal_device fb_sys_fops p=
rocessor_thermal_rfim crypto_simd cryptd processor_thermal_mbox snd sysim=
gblt mei_me processor_thermal_rapl hp_wmi ecdh_generic syscopyarea mc int=
el_rapl_common platform_profile input_leds serio_raw sparse_keymap mei ec=
c sysfillrect wmi_bmof joydev hid_multitouch libarc4 soundcore efi_pstore=
 ee1004 intel_soc_dts_iosf int3400_thermal int3403_thermal mac_hid acpi_t=
hermal_rel int340x_thermal_zone acpi_pad dptf_pch_fivr sch_fq_codel msr d=
rm parport_pc ppdev lp parport ip_tables x_tables autofs4 btrfs xor raid6=
_pq libcrc32c usbhid nvme nvme_core hid_generic
>   <4>[118575.731410][ T1387]  i2c_i801 intel_lpss_pci crc32_pclmul xhci=
_pci intel_lpss i2c_smbus xhci_pci_renesas idma64 i2c_hid_acpi vmd i2c_hi=
d wmi hid video pinctrl_tigerlake
>   <4>[118575.731425][ T1387] CR2: 0000000000000000
>   <4>[118575.731428][ T1387] ---[ end trace 0000000000000000 ]---
>   <4>[118575.867259][ T1387] RIP: 0010:dma_free_noncontiguous+0x37/0x80=

>   <4>[118575.867273][ T1387] Code: 8b 87 80 03 00 00 48 85 c0 75 07 48 =
8b 05 f9 39 2b 02 48 85 c0 74 13 4c 8b 48 28 4d 85 c9 74 0a 48 89 da 44 8=
9 c1 5b 41 ff e1 <48> 8b 0b 48 8b 11 48 8b 49 10 48 83 e2 fc 48 81 c6 ff =
0f 00 00 48
>   <4>[118575.867277][ T1387] RSP: 0000:ffffc90002b87770 EFLAGS: 0001024=
6
>   <4>[118575.867282][ T1387] RAX: 0000000000000000 RBX: 000000000000000=
0 RCX: 0000000000000000
>   <4>[118575.867284][ T1387] RDX: 0000000000000000 RSI: 000000000000000=
0 RDI: ffff888101db30d0
>   <4>[118575.867286][ T1387] RBP: 00000000fffffff4 R08: 000000000000000=
0 R09: 0000000000000000
>   <4>[118575.867288][ T1387] R10: 0000000000000000 R11: ffffc90002b874d=
0 R12: 0000000000000001
>   <4>[118575.867290][ T1387] R13: 0000000000058000 R14: ffff888105260c6=
8 R15: ffff888105260828
>   <4>[118575.867292][ T1387] FS:  00007f42e2ffd640(0000) GS:ffff888466b=
80000(0000) knlGS:0000000000000000
>   <4>[118575.867295][ T1387] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008=
0050033
>   <4>[118575.867297][ T1387] CR2: 0000000000000000 CR3: 000000014acf000=
3 CR4: 0000000000770ee0
>   <4>[118575.867300][ T1387] PKRU: 55555554
>=20
> Cc: Daniel Baluta <daniel.baluta@nxp.com>
> Cc: Jaroslav Kysela <perex@perex.cz>
> Cc: Kai Vehmanen <kai.vehmanen@linux.intel.com>
> Cc: Keyon Jie <yang.jie@linux.intel.com>
> Cc: Liam Girdwood <lgirdwood@gmail.com>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
> Cc: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> Cc: Rander Wang <rander.wang@intel.com>
> Cc: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
> Cc: Takashi Iwai <tiwai@suse.com>
> Fixes: d16046ffa6de040bf580a64d5f4d0aa18258a854 ("ASoC: SOF: Intel: Add=
 Intel specific HDA firmware loader")
> Cc: stable@vger.kernel.org # v5.2+
> Cc: sound-open-firmware@alsa-project.org
> Cc: alsa-devel@alsa-project.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
> ---
>  sound/soc/sof/intel/hda-loader.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>=20
> diff --git a/sound/soc/sof/intel/hda-loader.c b/sound/soc/sof/intel/hda=
-loader.c
> index 33306d2023a7..9bbfdab8009d 100644
> --- a/sound/soc/sof/intel/hda-loader.c
> +++ b/sound/soc/sof/intel/hda-loader.c
> @@ -47,7 +47,7 @@ static struct hdac_ext_stream *cl_stream_prepare(stru=
ct snd_sof_dev *sdev, unsig
>  	ret =3D snd_dma_alloc_pages(SNDRV_DMA_TYPE_DEV_SG, &pci->dev, size, d=
mab);
>  	if (ret < 0) {
>  		dev_err(sdev->dev, "error: memory alloc failed: %d\n", ret);
> -		goto error;
> +		goto out_put;
>  	}
> =20
>  	hstream->period_bytes =3D 0;/* initialize period_bytes */
> @@ -58,22 +58,23 @@ static struct hdac_ext_stream *cl_stream_prepare(st=
ruct snd_sof_dev *sdev, unsig
>  		ret =3D hda_dsp_iccmax_stream_hw_params(sdev, dsp_stream, dmab, NULL=
);
>  		if (ret < 0) {
>  			dev_err(sdev->dev, "error: iccmax stream prepare failed: %d\n", ret=
);
> -			goto error;
> +			goto out_free;
>  		}
>  	} else {
>  		ret =3D hda_dsp_stream_hw_params(sdev, dsp_stream, dmab, NULL);
>  		if (ret < 0) {
>  			dev_err(sdev->dev, "error: hdac prepare failed: %d\n", ret);
> -			goto error;
> +			goto out_free;
>  		}
>  		hda_dsp_stream_spib_config(sdev, dsp_stream, HDA_DSP_SPIB_ENABLE, si=
ze);
>  	}
> =20
>  	return dsp_stream;
> =20
> -error:
> -	hda_dsp_stream_put(sdev, direction, hstream->stream_tag);
> +out_free:
>  	snd_dma_free_pages(dmab);
> +out_put:
> +	hda_dsp_stream_put(sdev, direction, hstream->stream_tag);
>  	return ERR_PTR(ret);
>  }
> =20
>=20
> base-commit: 23d04328444a8fa0ca060c5e532220dac8e8bc26

--=20
P=C3=A9ter
