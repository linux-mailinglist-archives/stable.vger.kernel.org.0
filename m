Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFD2F27036
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 22:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729506AbfEVTWD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:22:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:42686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730259AbfEVTWD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:22:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19A7B217D9;
        Wed, 22 May 2019 19:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558552921;
        bh=t8LzQfJiNP8lkaPps8PiasZHkLfcUJ+qmAwDHAqTvo4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zqG4a/xmxB66vPf8Sw5kiIKZW7khmNpE9TGpPSH2IIQFX9Bg1m9QL9F1pSYz6WMiQ
         HF4NBT8jK66+W5ALOQQ7Rfkwu4Y2hQI4b/zmy7cVcjY/H6RGrhGalwfixovngvBWJF
         IsXAlCAPMux+5qERqHh+R7nKd/7wXDFliZbME9KM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fei Yang <fei.yang@intel.com>,
        Manu Gautam <mgautam@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 031/375] usb: gadget: f_fs: don't free buffer prematurely
Date:   Wed, 22 May 2019 15:15:31 -0400
Message-Id: <20190522192115.22666-31-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192115.22666-1-sashal@kernel.org>
References: <20190522192115.22666-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fei Yang <fei.yang@intel.com>

[ Upstream commit 73103c7f958b99561555c3bd1bc1a0809e0b7d61 ]

The following kernel panic happens due to the io_data buffer gets deallocated
before the async io is completed. Add a check for the case where io_data buffer
should be deallocated by ffs_user_copy_worker.

[   41.663334] BUG: unable to handle kernel NULL pointer dereference at 0000000000000048
[   41.672099] #PF error: [normal kernel read fault]
[   41.677356] PGD 20c974067 P4D 20c974067 PUD 20c973067 PMD 0
[   41.683687] Oops: 0000 [#1] PREEMPT SMP
[   41.687976] CPU: 1 PID: 7 Comm: kworker/u8:0 Tainted: G     U            5.0.0-quilt-2e5dc0ac-00790-gd8c79f2-dirty #2
[   41.705309] Workqueue: adb ffs_user_copy_worker
[   41.705316] RIP: 0010:__vunmap+0x2a/0xc0
[   41.705318] Code: 0f 1f 44 00 00 48 85 ff 0f 84 87 00 00 00 55 f7 c7 ff 0f 00 00 48 89 e5 41 55 41 89 f5 41 54 53 48 89 fb 75 71 e8 56 d7 ff ff <4c> 8b 60 48 4d 85 e4 74 76 48 89 df e8 25 ff ff ff 45 85 ed 74 46
[   41.705320] RSP: 0018:ffffbc3a40053df0 EFLAGS: 00010286
[   41.705322] RAX: 0000000000000000 RBX: ffffbc3a406f1000 RCX: 0000000000000000
[   41.705323] RDX: 0000000000000001 RSI: 0000000000000001 RDI: 00000000ffffffff
[   41.705324] RBP: ffffbc3a40053e08 R08: 000000000001fb79 R09: 0000000000000037
[   41.705325] R10: ffffbc3a40053b68 R11: ffffbc3a40053cad R12: fffffffffffffff2
[   41.705326] R13: 0000000000000001 R14: 0000000000000000 R15: ffffffffffffffff
[   41.705328] FS:  0000000000000000(0000) GS:ffff9e2977a80000(0000) knlGS:0000000000000000
[   41.705329] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   41.705330] CR2: 0000000000000048 CR3: 000000020c994000 CR4: 00000000003406e0
[   41.705331] Call Trace:
[   41.705338]  vfree+0x50/0xb0
[   41.705341]  ffs_user_copy_worker+0xe9/0x1c0
[   41.705344]  process_one_work+0x19f/0x3e0
[   41.705348]  worker_thread+0x3f/0x3b0
[   41.829766]  kthread+0x12b/0x150
[   41.833371]  ? process_one_work+0x3e0/0x3e0
[   41.838045]  ? kthread_create_worker_on_cpu+0x70/0x70
[   41.843695]  ret_from_fork+0x3a/0x50
[   41.847689] Modules linked in: hci_uart bluetooth ecdh_generic rfkill_gpio dwc3_pci dwc3 snd_usb_audio mei_me tpm_crb snd_usbmidi_lib xhci_pci xhci_hcd mei tpm snd_hwdep cfg80211 snd_soc_skl snd_soc_skl_ipc snd_soc_sst_ipc snd_soc_sst_dsp snd_hda_ext_core snd_hda_core videobuf2_dma_sg crlmodule
[   41.876880] CR2: 0000000000000048
[   41.880584] ---[ end trace 2bc4addff0f2e673 ]---
[   41.891346] RIP: 0010:__vunmap+0x2a/0xc0
[   41.895734] Code: 0f 1f 44 00 00 48 85 ff 0f 84 87 00 00 00 55 f7 c7 ff 0f 00 00 48 89 e5 41 55 41 89 f5 41 54 53 48 89 fb 75 71 e8 56 d7 ff ff <4c> 8b 60 48 4d 85 e4 74 76 48 89 df e8 25 ff ff ff 45 85 ed 74 46
[   41.916740] RSP: 0018:ffffbc3a40053df0 EFLAGS: 00010286
[   41.922583] RAX: 0000000000000000 RBX: ffffbc3a406f1000 RCX: 0000000000000000
[   41.930563] RDX: 0000000000000001 RSI: 0000000000000001 RDI: 00000000ffffffff
[   41.938540] RBP: ffffbc3a40053e08 R08: 000000000001fb79 R09: 0000000000000037
[   41.946520] R10: ffffbc3a40053b68 R11: ffffbc3a40053cad R12: fffffffffffffff2
[   41.954502] R13: 0000000000000001 R14: 0000000000000000 R15: ffffffffffffffff
[   41.962482] FS:  0000000000000000(0000) GS:ffff9e2977a80000(0000) knlGS:0000000000000000
[   41.971536] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   41.977960] CR2: 0000000000000048 CR3: 000000020c994000 CR4: 00000000003406e0
[   41.985930] Kernel panic - not syncing: Fatal exception
[   41.991817] Kernel Offset: 0x16000000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[   42.009525] Rebooting in 10 seconds..
[   52.014376] ACPI MEMORY or I/O RESET_REG.

Fixes: 772a7a724f69 ("usb: gadget: f_fs: Allow scatter-gather buffers")
Signed-off-by: Fei Yang <fei.yang@intel.com>
Reviewed-by: Manu Gautam <mgautam@codeaurora.org>
Tested-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_fs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 20413c276c616..47be961f1bf3f 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1133,7 +1133,8 @@ static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
 error_mutex:
 	mutex_unlock(&epfile->mutex);
 error:
-	ffs_free_buffer(io_data);
+	if (ret != -EIOCBQUEUED) /* don't free if there is iocb queued */
+		ffs_free_buffer(io_data);
 	return ret;
 }
 
-- 
2.20.1

