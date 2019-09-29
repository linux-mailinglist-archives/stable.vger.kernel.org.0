Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA369C1581
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 16:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729022AbfI2ODE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 10:03:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:45980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729223AbfI2ODE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 10:03:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61EC42082F;
        Sun, 29 Sep 2019 14:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765782;
        bh=W61FvMDGsXhj8Wt/qrnVpS4AYOYtcgJoz+NCppik44c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jz/AtvQKxe3op4hDfmd4k9i/mcs9OC8QvjswzcOiEFcpTIdqc9d3gxVB73YEYP/lr
         riA0GPiqkBcYVIOo3Op55zwjGKm1QKt4VMbh7DVl35qcW5dbK2HYQjXo9SmhtGAVsH
         bA7+VTZ9TRRpyddZA4u0ikzvWu/nIa84Zz1nTaAY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH 5.3 12/25] HID: logitech-dj: Fix crash when initial logi_dj_recv_query_paired_devices fails
Date:   Sun, 29 Sep 2019 15:56:15 +0200
Message-Id: <20190929135013.523411767@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929135006.127269625@linuxfoundation.org>
References: <20190929135006.127269625@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 8ccff2843fb4e6d9d26e5ae9ffe9840b38b92638 upstream.

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
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-logitech-dj.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -1734,14 +1734,14 @@ static int logi_dj_probe(struct hid_devi
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


