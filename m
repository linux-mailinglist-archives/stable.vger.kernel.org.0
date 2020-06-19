Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92B7C200E58
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391480AbgFSPGn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:06:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:35822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391466AbgFSPGk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:06:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E428C21941;
        Fri, 19 Jun 2020 15:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579198;
        bh=0+DLGt+CGgxkGYV7uJFiu4OSTtQMN8sdwvYFUCTU5pg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HpABcXJpaM/7fzAsvLsPysRVoFWawhdQLp7l3kBWmTixc7IjnHeCo7keJsp2tplDm
         p6YW+E2tplzLoG8mfYCHU4QLc0l1zPFXNexUbOca200CyT3RiwaiXrJVL65sGzRds9
         JtM36zePQPEy7bxwXsB+X5ftT4QAeT5tsfB2YBXY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brad Love <brad@nextdimension.cc>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 044/261] media: dvbdev: Fix tuner->demod media controller link
Date:   Fri, 19 Jun 2020 16:30:55 +0200
Message-Id: <20200619141652.040000826@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brad Love <brad@nextdimension.cc>

[ Upstream commit 9f984cacf4f4d53fd8a3f44d7f13528b81c1f6a8 ]

Fixes bug exposed by:

[a3fbc2e6bb0: media: mc-entity.c: use WARN_ON, validate link pads]

The dvbdev incorrectly requests a tuner sink pad to connect to a demux
sink pad. The media controller failure percolates back and the dvb device
creation fails. Fix this by requesting a tuner source pad. Instead of
forcing that pad to be index zero, check if a negative integer error
is returned. A note is added that first source pad found is chosen.

Affected bridges cx231xx and em28xx printed the below warning[s]
when a variety of media controller dvb enabled devices were connected.
The warning returns an error causing all affected devices to fail DVB
device creation.

[  253.138332] ------------[ cut here ]------------
[  253.138339] WARNING: CPU: 0 PID: 1550 at drivers/media/mc/mc-entity.c:669 media_create_pad_link+0x1e0/0x200 [mc]
[  253.138339] Modules linked in: si2168 em28xx_dvb(+) em28xx si2157 lgdt3306a cx231xx_dvb dvb_core cx231xx_alsa cx25840 cx231xx tveeprom cx2341x i2c_mux videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 videobuf2_common videodev mc ir_rc5_decoder rc_hauppauge mceusb rc_core eda
c_mce_amd kvm nls_iso8859_1 crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel crypto_simd cryptd glue_helper efi_pstore wmi_bmof k10temp asix usbnet mii nouveau snd_hda_codec_realtek snd_hda_codec_generic input_leds ledtrig_audio snd_hda_codec_hdmi mxm_wmi snd_hda_in
tel video snd_intel_dspcfg ttm snd_hda_codec drm_kms_helper snd_hda_core drm snd_hwdep snd_seq_midi snd_seq_midi_event i2c_algo_bit snd_pcm snd_rawmidi fb_sys_fops snd_seq syscopyarea sysfillrect snd_seq_device sysimgblt snd_timer snd soundcore ccp mac_hid sch_fq_codel parport_p
c ppdev lp parport ip_tables x_tables autofs4 vfio_pci irqbypass vfio_virqfd vfio_iommu_type1 vfio hid_generic usbhid hid i2c_piix4 ahci libahci wmi gpio_amdpt
[  253.138370]  gpio_generic
[  253.138372] CPU: 0 PID: 1550 Comm: modprobe Tainted: G        W         5.7.0-rc2+ #181
[  253.138373] Hardware name: MSI MS-7A39/B350M GAMING PRO (MS-7A39), BIOS 2.G0 04/27/2018
[  253.138376] RIP: 0010:media_create_pad_link+0x1e0/0x200 [mc]
[  253.138378] Code: 26 fd ff ff 44 8b 4d d0 eb d9 0f 0b 41 b9 ea ff ff ff 44 89 c8 c3 0f 0b 41 b9 ea ff ff ff eb f2 0f 0b 41 b9 ea ff ff ff eb e8 <0f> 0b 41 b9 ea ff ff ff eb af 0f 0b 41 b9 ea ff ff ff eb a5 66 90
[  253.138379] RSP: 0018:ffffb9ecc0ee7a78 EFLAGS: 00010246
[  253.138380] RAX: ffff943f706c99d8 RBX: 0000000000000000 RCX: 0000000000000000
[  253.138381] RDX: ffff943f613e0180 RSI: 0000000000000000 RDI: ffff943f706c9958
[  253.138381] RBP: ffffb9ecc0ee7ab0 R08: 0000000000000001 R09: ffff943f613e0180
[  253.138382] R10: ffff943f613e0180 R11: ffff943f706c9400 R12: 0000000000000000
[  253.138383] R13: 0000000000000001 R14: ffff943f706c9958 R15: 0000000000000001
[  253.138384] FS:  00007f3cd29ba540(0000) GS:ffff943f8ec00000(0000) knlGS:0000000000000000
[  253.138385] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  253.138385] CR2: 000055f7de0ca830 CR3: 00000003dd208000 CR4: 00000000003406f0
[  253.138386] Call Trace:
[  253.138392]  media_create_pad_links+0x104/0x1b0 [mc]
[  253.138397]  dvb_create_media_graph+0x350/0x5f0 [dvb_core]
[  253.138402]  em28xx_dvb_init+0x5ea/0x2600 [em28xx_dvb]
[  253.138408]  em28xx_register_extension+0x63/0xc0 [em28xx]
[  253.138410]  ? 0xffffffffc039c000
[  253.138412]  em28xx_dvb_register+0x15/0x1000 [em28xx_dvb]
[  253.138416]  do_one_initcall+0x71/0x250
[  253.138418]  ? do_init_module+0x27/0x22e
[  253.138421]  ? _cond_resched+0x1a/0x50
[  253.138423]  ? kmem_cache_alloc_trace+0x1ec/0x270
[  253.138425]  ? __vunmap+0x1e3/0x240
[  253.138427]  do_init_module+0x5f/0x22e
[  253.138430]  load_module+0x2525/0x2d40
[  253.138436]  __do_sys_finit_module+0xe5/0x120
[  253.138438]  ? __do_sys_finit_module+0xe5/0x120
[  253.138442]  __x64_sys_finit_module+0x1a/0x20
[  253.138443]  do_syscall_64+0x57/0x1b0
[  253.138445]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  253.138446] RIP: 0033:0x7f3cd24dc839
[  253.138448] Code: 00 f3 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 1f f6 2c 00 f7 d8 64 89 01 48
[  253.138449] RSP: 002b:00007ffe4fc514d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
[  253.138450] RAX: ffffffffffffffda RBX: 000055a9237f63f0 RCX: 00007f3cd24dc839
[  253.138451] RDX: 0000000000000000 RSI: 000055a922c3ad2e RDI: 0000000000000000
[  253.138451] RBP: 000055a922c3ad2e R08: 0000000000000000 R09: 0000000000000000
[  253.138452] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[  253.138453] R13: 000055a9237f5550 R14: 0000000000040000 R15: 000055a9237f63f0
[  253.138456] ---[ end trace a60f19c54aa96ec4 ]---

[  234.915628] ------------[ cut here ]------------
[  234.915640] WARNING: CPU: 0 PID: 1502 at drivers/media/mc/mc-entity.c:669 media_create_pad_link+0x1e0/0x200 [mc]
[  234.915641] Modules linked in: si2157 lgdt3306a cx231xx_dvb(+) dvb_core cx231xx_alsa cx25840 cx231xx tveeprom cx2341x i2c_mux videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 videobuf2_common videodev mc ir_rc5_decoder rc_hauppauge mceusb rc_core edac_mce_amd kvm nls_iso8859
_1 crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel crypto_simd cryptd glue_helper efi_pstore wmi_bmof k10temp asix usbnet mii nouveau snd_hda_codec_realtek snd_hda_codec_generic input_leds ledtrig_audio snd_hda_codec_hdmi mxm_wmi snd_hda_intel video snd_intel_dspcf
g ttm snd_hda_codec drm_kms_helper snd_hda_core drm snd_hwdep snd_seq_midi snd_seq_midi_event i2c_algo_bit snd_pcm snd_rawmidi fb_sys_fops snd_seq syscopyarea sysfillrect snd_seq_device sysimgblt snd_timer snd soundcore ccp mac_hid sch_fq_codel parport_pc ppdev lp parport ip_tab
les x_tables autofs4 vfio_pci irqbypass vfio_virqfd vfio_iommu_type1 vfio hid_generic usbhid hid i2c_piix4 ahci libahci wmi gpio_amdpt gpio_generic
[  234.915700] CPU: 0 PID: 1502 Comm: modprobe Not tainted 5.7.0-rc2+ #181
[  234.915702] Hardware name: MSI MS-7A39/B350M GAMING PRO (MS-7A39), BIOS 2.G0 04/27/2018
[  234.915709] RIP: 0010:media_create_pad_link+0x1e0/0x200 [mc]
[  234.915712] Code: 26 fd ff ff 44 8b 4d d0 eb d9 0f 0b 41 b9 ea ff ff ff 44 89 c8 c3 0f 0b 41 b9 ea ff ff ff eb f2 0f 0b 41 b9 ea ff ff ff eb e8 <0f> 0b 41 b9 ea ff ff ff eb af 0f 0b 41 b9 ea ff ff ff eb a5 66 90
[  234.915714] RSP: 0018:ffffb9ecc1b6fa50 EFLAGS: 00010246
[  234.915717] RAX: ffff943f8c94a9d8 RBX: 0000000000000000 RCX: 0000000000000000
[  234.915719] RDX: ffff943f613e0900 RSI: 0000000000000000 RDI: ffff943f8c94a958
[  234.915721] RBP: ffffb9ecc1b6fa88 R08: 0000000000000001 R09: ffff943f613e0900
[  234.915723] R10: ffff943f613e0900 R11: ffff943f6b590c00 R12: 0000000000000000
[  234.915724] R13: 0000000000000001 R14: ffff943f8c94a958 R15: 0000000000000001
[  234.915727] FS:  00007f4ca3646540(0000) GS:ffff943f8ec00000(0000) knlGS:0000000000000000
[  234.915729] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  234.915731] CR2: 00007fff7a53ba18 CR3: 00000003da614000 CR4: 00000000003406f0
[  234.915733] Call Trace:
[  234.915745]  media_create_pad_links+0x104/0x1b0 [mc]
[  234.915756]  dvb_create_media_graph+0x350/0x5f0 [dvb_core]
[  234.915766]  dvb_init.part.4+0x691/0x1360 [cx231xx_dvb]
[  234.915780]  dvb_init+0x1a/0x20 [cx231xx_dvb]
[  234.915787]  cx231xx_register_extension+0x71/0xa0 [cx231xx]
[  234.915791]  ? 0xffffffffc042f000
[  234.915796]  cx231xx_dvb_register+0x15/0x1000 [cx231xx_dvb]
[  234.915802]  do_one_initcall+0x71/0x250
[  234.915807]  ? do_init_module+0x27/0x22e
[  234.915811]  ? _cond_resched+0x1a/0x50
[  234.915816]  ? kmem_cache_alloc_trace+0x1ec/0x270
[  234.915820]  ? __vunmap+0x1e3/0x240
[  234.915826]  do_init_module+0x5f/0x22e
[  234.915831]  load_module+0x2525/0x2d40
[  234.915848]  __do_sys_finit_module+0xe5/0x120
[  234.915850]  ? __do_sys_finit_module+0xe5/0x120
[  234.915862]  __x64_sys_finit_module+0x1a/0x20
[  234.915865]  do_syscall_64+0x57/0x1b0
[  234.915870]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  234.915872] RIP: 0033:0x7f4ca3168839
[  234.915876] Code: 00 f3 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 1f f6 2c 00 f7 d8 64 89 01 48
[  234.915878] RSP: 002b:00007ffcea3db3b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
[  234.915881] RAX: ffffffffffffffda RBX: 000055af22c29340 RCX: 00007f4ca3168839
[  234.915882] RDX: 0000000000000000 RSI: 000055af22c38390 RDI: 0000000000000001
[  234.915884] RBP: 000055af22c38390 R08: 0000000000000000 R09: 0000000000000000
[  234.915885] R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000000
[  234.915887] R13: 000055af22c29060 R14: 0000000000040000 R15: 0000000000000000
[  234.915896] ---[ end trace a60f19c54aa96ec3 ]---

Signed-off-by: Brad Love <brad@nextdimension.cc>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-core/dvbdev.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index 917fe034af37..032b6d7dd582 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -707,9 +707,10 @@ int dvb_create_media_graph(struct dvb_adapter *adap,
 	}
 
 	if (ntuner && ndemod) {
-		pad_source = media_get_pad_index(tuner, true,
+		/* NOTE: first found tuner source pad presumed correct */
+		pad_source = media_get_pad_index(tuner, false,
 						 PAD_SIGNAL_ANALOG);
-		if (pad_source)
+		if (pad_source < 0)
 			return -EINVAL;
 		ret = media_create_pad_links(mdev,
 					     MEDIA_ENT_F_TUNER,
-- 
2.25.1



