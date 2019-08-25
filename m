Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41E169C4B9
	for <lists+stable@lfdr.de>; Sun, 25 Aug 2019 17:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727889AbfHYPfr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Aug 2019 11:35:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50730 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727186AbfHYPfr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 25 Aug 2019 11:35:47 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 260E0C057E9A;
        Sun, 25 Aug 2019 15:35:47 +0000 (UTC)
Received: from shalem.localdomain.com (ovpn-116-48.ams2.redhat.com [10.36.116.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BEB0F19C70;
        Sun, 25 Aug 2019 15:35:43 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-input@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] HID: logitech-dj: Fix crash when initial logi_dj_recv_query_paired_devices fails
Date:   Sun, 25 Aug 2019 17:35:42 +0200
Message-Id: <20190825153542.79245-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Sun, 25 Aug 2019 15:35:47 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Before this commit dj_probe would exit with an error if the initial
logi_dj_recv_query_paired_devices fails. The initial call may fail
when the receiver is connected through a kvm and the focus is away.

When the call fails this causes 2 problems:

1) dj_probe calls logi_dj_recv_query_paired_devices after calling
hid_device_io_start() so a HID report may have been received in between
and our delayedwork_callback may be running. It seems that the initial
logi_dj_recv_query_paired_devices failure happening with some KVMs triggers
this exact scenario, causing the work-queue to run on free-ed memory,
leading to:

 BUG: unable to handle page fault for address: 0000000000001e88
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 0 P4D 0
 Oops: 0000 [#1] SMP PTI
 CPU: 3 PID: 257 Comm: kworker/3:3 Tainted: G           OE     5.3.0-rc5+ #100
 Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./B150M Pro4S/D3, BIOS P7.10 12/06/2016
 Workqueue: events 0xffffffffc02ba200
 RIP: 0010:0xffffffffc02ba1bd
 Code: e8 e8 13 00 d8 48 89 c5 48 85 c0 74 4c 48 8b 7b 10 48 89 ea b9 07 00 00 00 41 b9 09 00 00 00 41 b8 01 00 00 00 be 10 00 00 00 <48> 8b 87 88 1e 00 00 48 8b 40 40 e8 b3 6b b4 d8 48 89 ef 41 89 c4
 RSP: 0018:ffffb760c046bdb8 EFLAGS: 00010286
 RAX: ffff935038ea4550 RBX: ffff935046778000 RCX: 0000000000000007
 RDX: ffff935038ea4550 RSI: 0000000000000010 RDI: 0000000000000000
 RBP: ffff935038ea4550 R08: 0000000000000001 R09: 0000000000000009
 R10: 000000000000e011 R11: 0000000000000001 R12: ffff9350467780e8
 R13: ffff935046778000 R14: 0000000000000000 R15: ffff935046778070
 FS:  0000000000000000(0000) GS:ffff935054e00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000001e88 CR3: 000000075a612002 CR4: 00000000003606e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 Call Trace:
  0xffffffffc02ba2f7
  ? process_one_work+0x1b1/0x560
  process_one_work+0x234/0x560
  worker_thread+0x50/0x3b0
  kthread+0x10a/0x140
  ? process_one_work+0x560/0x560
  ? kthread_park+0x80/0x80
  ret_from_fork+0x3a/0x50
 Modules linked in: vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) bnep vfat fat btusb btrtl btbcm btintel bluetooth intel_rapl_msr ecdh_generic rfkill ecc snd_usb_audio snd_usbmidi_lib intel_rapl_common snd_rawmidi mc x86_pkg_temp_thermal intel_powerclamp coretemp iTCO_wdt iTCO_vendor_support mei_wdt mei_hdcp ppdev kvm_intel kvm irqbypass crct10dif_pclmul crc32_generic crc32_pclmul snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic ledtrig_audio ghash_clmulni_intel intel_cstate snd_hda_intel snd_hda_codec intel_uncore snd_hda_core snd_hwdep intel_rapl_perf snd_seq snd_seq_device snd_pcm snd_timer intel_wmi_thunderbolt snd e1000e soundcore mxm_wmi i2c_i801 bfq mei_me mei intel_pch_thermal parport_pc parport acpi_pad binfmt_misc hid_lg_g15(E) hid_logitech_dj(E) i915 crc32c_intel i2c_algo_bit drm_kms_helper nvme nvme_core drm wmi video uas usb_storage i2c_dev
 CR2: 0000000000001e88
 ---[ end trace 1d3f8afdcfcbd842 ]---

2) Even if we were to fix 1. by making sure the work is stopped before
failing probe, failing probe is the wrong thing to do, we have
logi_dj_recv_queue_unknown_work to deal with the initial
logi_dj_recv_query_paired_devices failure.

Rather then error-ing out of the probe, causing the receiver to not work at
all we should rely on this, so that the attached devices will get properly
enumerated once the KVM focus is switched back.

Cc: stable@vger.kernel.org
Fixes: 74808f9115ce ("HID: logitech-dj: add support for non unifying receivers")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/hid/hid-logitech-dj.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index cc47f948c1d0..7badbaa18878 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -1734,14 +1734,14 @@ static int logi_dj_probe(struct hid_device *hdev,
 		if (retval < 0) {
 			hid_err(hdev, "%s: logi_dj_recv_query_paired_devices error:%d\n",
 				__func__, retval);
-			goto logi_dj_recv_query_paired_devices_failed;
+			/*
+			 * This can happen with a KVM, let the probe succeed,
+			 * logi_dj_recv_queue_unknown_work will retry later.
+			 */
 		}
 	}
 
-	return retval;
-
-logi_dj_recv_query_paired_devices_failed:
-	hid_hw_close(hdev);
+	return 0;
 
 llopen_failed:
 switch_to_dj_mode_fail:
-- 
2.23.0

