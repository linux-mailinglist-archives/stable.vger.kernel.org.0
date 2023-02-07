Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37EF168D906
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232511AbjBGNPL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:15:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232743AbjBGNO6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:14:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8E8E39CE6
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:14:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60EC161407
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:14:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 696EFC433EF;
        Tue,  7 Feb 2023 13:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775664;
        bh=yODYoomYLSG7wDzK37aG1jVPn7/sOiRsU6VT8mS+KSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K3Py0ddhMmAlzz9v8J0QOJeQMpJpSXogsLUSOryjZZw59qfxQGaghPBCmVDWFnoS6
         uXhyge6yBwpOvOLg0XDeV3nRW4SuYxQMKf/5ZyHZGBPNKOIQw28sO5d+NhbDaeccGR
         nsZ9shI06OucB+S6QqyqRK+lPNObMqvQEwuIxcZo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dokyung Song <dokyungs@yonsei.ac.kr>,
        Jisoo Jang <jisoo.jang@yonsei.ac.kr>,
        Minsuk Kang <linuxlovemin@yonsei.ac.kr>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 5.15 117/120] wifi: brcmfmac: Check the count value of channel spec to prevent out-of-bounds reads
Date:   Tue,  7 Feb 2023 13:58:08 +0100
Message-Id: <20230207125623.765174136@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Minsuk Kang <linuxlovemin@yonsei.ac.kr>

commit 4920ab131b2dbae7464b72bdcac465d070254209 upstream.

This patch fixes slab-out-of-bounds reads in brcmfmac that occur in
brcmf_construct_chaninfo() and brcmf_enable_bw40_2g() when the count
value of channel specifications provided by the device is greater than
the length of 'list->element[]', decided by the size of the 'list'
allocated with kzalloc(). The patch adds checks that make the functions
free the buffer and return -EINVAL if that is the case. Note that the
negative return is handled by the caller, brcmf_setup_wiphybands() or
brcmf_cfg80211_attach().

Found by a modified version of syzkaller.

Crash Report from brcmf_construct_chaninfo():
==================================================================
BUG: KASAN: slab-out-of-bounds in brcmf_setup_wiphybands+0x1238/0x1430
Read of size 4 at addr ffff888115f24600 by task kworker/0:2/1896

CPU: 0 PID: 1896 Comm: kworker/0:2 Tainted: G        W  O      5.14.0+ #132
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
Workqueue: usb_hub_wq hub_event
Call Trace:
 dump_stack_lvl+0x57/0x7d
 print_address_description.constprop.0.cold+0x93/0x334
 kasan_report.cold+0x83/0xdf
 brcmf_setup_wiphybands+0x1238/0x1430
 brcmf_cfg80211_attach+0x2118/0x3fd0
 brcmf_attach+0x389/0xd40
 brcmf_usb_probe+0x12de/0x1690
 usb_probe_interface+0x25f/0x710
 really_probe+0x1be/0xa90
 __driver_probe_device+0x2ab/0x460
 driver_probe_device+0x49/0x120
 __device_attach_driver+0x18a/0x250
 bus_for_each_drv+0x123/0x1a0
 __device_attach+0x207/0x330
 bus_probe_device+0x1a2/0x260
 device_add+0xa61/0x1ce0
 usb_set_configuration+0x984/0x1770
 usb_generic_driver_probe+0x69/0x90
 usb_probe_device+0x9c/0x220
 really_probe+0x1be/0xa90
 __driver_probe_device+0x2ab/0x460
 driver_probe_device+0x49/0x120
 __device_attach_driver+0x18a/0x250
 bus_for_each_drv+0x123/0x1a0
 __device_attach+0x207/0x330
 bus_probe_device+0x1a2/0x260
 device_add+0xa61/0x1ce0
 usb_new_device.cold+0x463/0xf66
 hub_event+0x10d5/0x3330
 process_one_work+0x873/0x13e0
 worker_thread+0x8b/0xd10
 kthread+0x379/0x450
 ret_from_fork+0x1f/0x30

Allocated by task 1896:
 kasan_save_stack+0x1b/0x40
 __kasan_kmalloc+0x7c/0x90
 kmem_cache_alloc_trace+0x19e/0x330
 brcmf_setup_wiphybands+0x290/0x1430
 brcmf_cfg80211_attach+0x2118/0x3fd0
 brcmf_attach+0x389/0xd40
 brcmf_usb_probe+0x12de/0x1690
 usb_probe_interface+0x25f/0x710
 really_probe+0x1be/0xa90
 __driver_probe_device+0x2ab/0x460
 driver_probe_device+0x49/0x120
 __device_attach_driver+0x18a/0x250
 bus_for_each_drv+0x123/0x1a0
 __device_attach+0x207/0x330
 bus_probe_device+0x1a2/0x260
 device_add+0xa61/0x1ce0
 usb_set_configuration+0x984/0x1770
 usb_generic_driver_probe+0x69/0x90
 usb_probe_device+0x9c/0x220
 really_probe+0x1be/0xa90
 __driver_probe_device+0x2ab/0x460
 driver_probe_device+0x49/0x120
 __device_attach_driver+0x18a/0x250
 bus_for_each_drv+0x123/0x1a0
 __device_attach+0x207/0x330
 bus_probe_device+0x1a2/0x260
 device_add+0xa61/0x1ce0
 usb_new_device.cold+0x463/0xf66
 hub_event+0x10d5/0x3330
 process_one_work+0x873/0x13e0
 worker_thread+0x8b/0xd10
 kthread+0x379/0x450
 ret_from_fork+0x1f/0x30

The buggy address belongs to the object at ffff888115f24000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 1536 bytes inside of
 2048-byte region [ffff888115f24000, ffff888115f24800)

Memory state around the buggy address:
 ffff888115f24500: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff888115f24580: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff888115f24600: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                   ^
 ffff888115f24680: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888115f24700: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================

Crash Report from brcmf_enable_bw40_2g():
==================================================================
BUG: KASAN: slab-out-of-bounds in brcmf_cfg80211_attach+0x3d11/0x3fd0
Read of size 4 at addr ffff888103787600 by task kworker/0:2/1896

CPU: 0 PID: 1896 Comm: kworker/0:2 Tainted: G        W  O      5.14.0+ #132
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
Workqueue: usb_hub_wq hub_event
Call Trace:
 dump_stack_lvl+0x57/0x7d
 print_address_description.constprop.0.cold+0x93/0x334
 kasan_report.cold+0x83/0xdf
 brcmf_cfg80211_attach+0x3d11/0x3fd0
 brcmf_attach+0x389/0xd40
 brcmf_usb_probe+0x12de/0x1690
 usb_probe_interface+0x25f/0x710
 really_probe+0x1be/0xa90
 __driver_probe_device+0x2ab/0x460
 driver_probe_device+0x49/0x120
 __device_attach_driver+0x18a/0x250
 bus_for_each_drv+0x123/0x1a0
 __device_attach+0x207/0x330
 bus_probe_device+0x1a2/0x260
 device_add+0xa61/0x1ce0
 usb_set_configuration+0x984/0x1770
 usb_generic_driver_probe+0x69/0x90
 usb_probe_device+0x9c/0x220
 really_probe+0x1be/0xa90
 __driver_probe_device+0x2ab/0x460
 driver_probe_device+0x49/0x120
 __device_attach_driver+0x18a/0x250
 bus_for_each_drv+0x123/0x1a0
 __device_attach+0x207/0x330
 bus_probe_device+0x1a2/0x260
 device_add+0xa61/0x1ce0
 usb_new_device.cold+0x463/0xf66
 hub_event+0x10d5/0x3330
 process_one_work+0x873/0x13e0
 worker_thread+0x8b/0xd10
 kthread+0x379/0x450
 ret_from_fork+0x1f/0x30

Allocated by task 1896:
 kasan_save_stack+0x1b/0x40
 __kasan_kmalloc+0x7c/0x90
 kmem_cache_alloc_trace+0x19e/0x330
 brcmf_cfg80211_attach+0x3302/0x3fd0
 brcmf_attach+0x389/0xd40
 brcmf_usb_probe+0x12de/0x1690
 usb_probe_interface+0x25f/0x710
 really_probe+0x1be/0xa90
 __driver_probe_device+0x2ab/0x460
 driver_probe_device+0x49/0x120
 __device_attach_driver+0x18a/0x250
 bus_for_each_drv+0x123/0x1a0
 __device_attach+0x207/0x330
 bus_probe_device+0x1a2/0x260
 device_add+0xa61/0x1ce0
 usb_set_configuration+0x984/0x1770
 usb_generic_driver_probe+0x69/0x90
 usb_probe_device+0x9c/0x220
 really_probe+0x1be/0xa90
 __driver_probe_device+0x2ab/0x460
 driver_probe_device+0x49/0x120
 __device_attach_driver+0x18a/0x250
 bus_for_each_drv+0x123/0x1a0
 __device_attach+0x207/0x330
 bus_probe_device+0x1a2/0x260
 device_add+0xa61/0x1ce0
 usb_new_device.cold+0x463/0xf66
 hub_event+0x10d5/0x3330
 process_one_work+0x873/0x13e0
 worker_thread+0x8b/0xd10
 kthread+0x379/0x450
 ret_from_fork+0x1f/0x30

The buggy address belongs to the object at ffff888103787000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 1536 bytes inside of
 2048-byte region [ffff888103787000, ffff888103787800)

Memory state around the buggy address:
 ffff888103787500: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff888103787580: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff888103787600: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                   ^
 ffff888103787680: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888103787700: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================

Reported-by: Dokyung Song <dokyungs@yonsei.ac.kr>
Reported-by: Jisoo Jang <jisoo.jang@yonsei.ac.kr>
Reported-by: Minsuk Kang <linuxlovemin@yonsei.ac.kr>
Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Minsuk Kang <linuxlovemin@yonsei.ac.kr>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20221116142952.518241-1-linuxlovemin@yonsei.ac.kr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c |   17 ++++++++++++
 1 file changed, 17 insertions(+)

--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -90,6 +90,9 @@
 #define BRCMF_ASSOC_PARAMS_FIXED_SIZE \
 	(sizeof(struct brcmf_assoc_params_le) - sizeof(u16))
 
+#define BRCMF_MAX_CHANSPEC_LIST \
+	(BRCMF_DCMD_MEDLEN / sizeof(__le32) - 1)
+
 static bool check_vif_up(struct brcmf_cfg80211_vif *vif)
 {
 	if (!test_bit(BRCMF_VIF_STATUS_READY, &vif->sme_state)) {
@@ -6557,6 +6560,13 @@ static int brcmf_construct_chaninfo(stru
 			band->channels[i].flags = IEEE80211_CHAN_DISABLED;
 
 	total = le32_to_cpu(list->count);
+	if (total > BRCMF_MAX_CHANSPEC_LIST) {
+		bphy_err(drvr, "Invalid count of channel Spec. (%u)\n",
+			 total);
+		err = -EINVAL;
+		goto fail_pbuf;
+	}
+
 	for (i = 0; i < total; i++) {
 		ch.chspec = (u16)le32_to_cpu(list->element[i]);
 		cfg->d11inf.decchspec(&ch);
@@ -6702,6 +6712,13 @@ static int brcmf_enable_bw40_2g(struct b
 		band = cfg_to_wiphy(cfg)->bands[NL80211_BAND_2GHZ];
 		list = (struct brcmf_chanspec_list *)pbuf;
 		num_chan = le32_to_cpu(list->count);
+		if (num_chan > BRCMF_MAX_CHANSPEC_LIST) {
+			bphy_err(drvr, "Invalid count of channel Spec. (%u)\n",
+				 num_chan);
+			kfree(pbuf);
+			return -EINVAL;
+		}
+
 		for (i = 0; i < num_chan; i++) {
 			ch.chspec = (u16)le32_to_cpu(list->element[i]);
 			cfg->d11inf.decchspec(&ch);


