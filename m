Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB1CD467869
	for <lists+stable@lfdr.de>; Fri,  3 Dec 2021 14:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241102AbhLCNfm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Dec 2021 08:35:42 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54958 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242575AbhLCNfm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Dec 2021 08:35:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13D1BB82743
        for <stable@vger.kernel.org>; Fri,  3 Dec 2021 13:32:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49A10C53FC7;
        Fri,  3 Dec 2021 13:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638538335;
        bh=EH+tJJtocx0utjgOWPfPxTvZYsJL2IsYSu7oH5NCMkw=;
        h=Subject:To:From:Date:From;
        b=QHQ1DOEghk3TYzWINEXgg+mNd23l8EUbrZmrSWkOb+Rmr5ul61FRs2JnKzqyUrBp9
         33AwJPLZTUW/IU8bkUofE2u6jhDSI/J0kHB03xpxUyT25iH8nPs8FJnSnP40/uYGCy
         dcB/dCK2sSI/3M9tB4KKJhwr/c078sDIHLjphJXw=
Subject: patch "misc: rtsx: Avoid mangling IRQ during runtime PM" added to char-misc-linus
To:     kai.heng.feng@canonical.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 03 Dec 2021 14:32:13 +0100
Message-ID: <16385383332123@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    misc: rtsx: Avoid mangling IRQ during runtime PM

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 0edeb8992db8e7de9b8fe3164ace9a4356b17021 Mon Sep 17 00:00:00 2001
From: Kai-Heng Feng <kai.heng.feng@canonical.com>
Date: Fri, 26 Nov 2021 08:32:44 +0800
Subject: misc: rtsx: Avoid mangling IRQ during runtime PM

After commit 5b4258f6721f ("misc: rtsx: rts5249 support runtime PM"), when the
rtsx controller is runtime suspended, bring CPUs offline and back online, the
runtime resume of the controller will fail:

[   47.319391] smpboot: CPU 1 is now offline
[   47.414140] x86: Booting SMP configuration:
[   47.414147] smpboot: Booting Node 0 Processor 1 APIC 0x2
[   47.571334] smpboot: CPU 2 is now offline
[   47.686055] smpboot: Booting Node 0 Processor 2 APIC 0x4
[   47.808174] smpboot: CPU 3 is now offline
[   47.878146] smpboot: Booting Node 0 Processor 3 APIC 0x6
[   48.003679] smpboot: CPU 4 is now offline
[   48.086187] smpboot: Booting Node 0 Processor 4 APIC 0x1
[   48.239627] smpboot: CPU 5 is now offline
[   48.326059] smpboot: Booting Node 0 Processor 5 APIC 0x3
[   48.472193] smpboot: CPU 6 is now offline
[   48.574181] smpboot: Booting Node 0 Processor 6 APIC 0x5
[   48.743375] smpboot: CPU 7 is now offline
[   48.838047] smpboot: Booting Node 0 Processor 7 APIC 0x7
[   48.965447] __common_interrupt: 1.35 No irq handler for vector
[   51.174065] mmc0: error -110 doing runtime resume
[   54.978088] I/O error, dev mmcblk0, sector 21479 op 0x1:(WRITE) flags 0x0 phys_seg 11 prio class 0
[   54.978108] Buffer I/O error on dev mmcblk0p1, logical block 19431, lost async page write
[   54.978129] Buffer I/O error on dev mmcblk0p1, logical block 19432, lost async page write
[   54.978134] Buffer I/O error on dev mmcblk0p1, logical block 19433, lost async page write
[   54.978137] Buffer I/O error on dev mmcblk0p1, logical block 19434, lost async page write
[   54.978141] Buffer I/O error on dev mmcblk0p1, logical block 19435, lost async page write
[   54.978145] Buffer I/O error on dev mmcblk0p1, logical block 19436, lost async page write
[   54.978148] Buffer I/O error on dev mmcblk0p1, logical block 19437, lost async page write
[   54.978152] Buffer I/O error on dev mmcblk0p1, logical block 19438, lost async page write
[   54.978155] Buffer I/O error on dev mmcblk0p1, logical block 19439, lost async page write
[   54.978160] Buffer I/O error on dev mmcblk0p1, logical block 19440, lost async page write
[   54.978244] mmc0: card aaaa removed
[   54.978452] FAT-fs (mmcblk0p1): FAT read failed (blocknr 4257)

There's interrupt immediately raised on rtsx_pci_write_register() in
runtime resume routine, but the IRQ handler hasn't registered yet.

So we can either move rtsx_pci_write_register() after rtsx_pci_acquire_irq(),
or just stop mangling IRQ on runtime PM. Choose the latter to save some
CPU cycles.

Fixes: 5b4258f6721f ("misc: rtsx: rts5249 support runtime PM")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
BugLink: https://bugs.launchpad.net/bugs/1951784
Link: https://lore.kernel.org/r/20211126003246.1068770-1-kai.heng.feng@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/cardreader/rtsx_pcr.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/misc/cardreader/rtsx_pcr.c b/drivers/misc/cardreader/rtsx_pcr.c
index 8c72eb590f79..6ac509c1821c 100644
--- a/drivers/misc/cardreader/rtsx_pcr.c
+++ b/drivers/misc/cardreader/rtsx_pcr.c
@@ -1803,8 +1803,6 @@ static int rtsx_pci_runtime_suspend(struct device *device)
 	mutex_lock(&pcr->pcr_mutex);
 	rtsx_pci_power_off(pcr, HOST_ENTER_S3);
 
-	free_irq(pcr->irq, (void *)pcr);
-
 	mutex_unlock(&pcr->pcr_mutex);
 
 	pcr->is_runtime_suspended = true;
@@ -1825,8 +1823,6 @@ static int rtsx_pci_runtime_resume(struct device *device)
 	mutex_lock(&pcr->pcr_mutex);
 
 	rtsx_pci_write_register(pcr, HOST_SLEEP_STATE, 0x03, 0x00);
-	rtsx_pci_acquire_irq(pcr);
-	synchronize_irq(pcr->irq);
 
 	if (pcr->ops->fetch_vendor_settings)
 		pcr->ops->fetch_vendor_settings(pcr);
-- 
2.34.1


