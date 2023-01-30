Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C84A6804BB
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 05:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231702AbjA3EFc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Jan 2023 23:05:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbjA3EFb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Jan 2023 23:05:31 -0500
X-Greylist: delayed 600 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 29 Jan 2023 20:05:29 PST
Received: from trent.utfs.org (trent.utfs.org [94.185.90.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A16A10E8;
        Sun, 29 Jan 2023 20:05:29 -0800 (PST)
Received: from localhost (localhost [IPv6:::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by trent.utfs.org (Postfix) with ESMTPS id 3F8785F76C;
        Mon, 30 Jan 2023 04:46:02 +0100 (CET)
Date:   Mon, 30 Jan 2023 04:46:02 +0100 (CET)
From:   Christian Kujau <lists@nerdbynature.de>
To:     linux-kernel@vger.kernel.org
cc:     stable@vger.kernel.org
Subject: External USB disks not recognized with v6.1.8 when using Xen
Message-ID: <4fe9541e-4d4c-2b2a-f8c8-2d34a7284930@nerdbynature.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[CC stable as I only tested the stable tree for now]

I'm running a current Alpine Linux with linux-edge-6.1.8-r0 installed on a 
Lenovo Thinkpad L540 where an external disk enclosure with two disks is 
attached via USB. The Alpine Linux kernel appears to track Linux stable 
and is more or less vanilla. Also, the machine boots into Xen 4.17.0 and 
then starts a few headless VMs, nothing too exotic here.

But when updating from Linux 6.1.1 to 6.1.8, the disks from the external 
enclosure did not show up. Unplug, replug, no dice, and this is 100% 
reproducable. dmesg has new these lines now:

+ioremap error for 0xf2520000-0xf2530000, requested 0x2, got 0x0
+ioremap error for 0xf2520000-0xf2530000, requested 0x2, got 0x0
+xhci_hcd 0000:00:14.0: init 0000:00:14.0 fail, -14
+ioremap error for 0xfed1f000-0xfed20000, requested 0x2, got 0x0
+iTCO_wdt iTCO_wdt.1.auto: ioremap failed for resource [mem 0xfed1f410-0xfed1f414]

I'm not sure if the ioremap error is related here (booted with 
early_ioremap_debug but then dmesg was filled with WARNINGS for both 
versions, so I disabled it again), but that xhci_hcd error looks 
suspicious.

Curiously 6.1.8 works just fine when NOT booted via Xen. I booted into 
Xen + vanilla 6.1.8 now and was able to reproduce this issue. Xen + 
vanilla 6.1.1 works fine.

From v6.1.1 to v6.1.8 there's only one commit in drivers/xen, but 54 
commits in drivers/usb. Compiling takes time because the distribution 
kernel has almost everything enabled and I still need to cut down enabled 
options to be able to attempt a git biset in a reasonable time, but I 
still wanted to report this, maybe someone has an idea about this.

Full dmesg and lshw outputs: https://nerdbynature.de/bits/usb_v6.1.8/

Thanks,
Christian.

PS: I found this workaround on the interwebs[0] to force the USB ports 
of that machine to USB 2.0 and then the missing disks magically appear:

$ lspci -nn | grep -i usb
00:14.0 USB controller [0c03]: Intel Corporation 8 Series/C220 Series Chipset Family USB xHCI [8086:8c31] (rev 05)  <=== !!!
00:1a.0 USB controller [0c03]: Intel Corporation 8 Series/C220 Series Chipset Family USB EHCI #2 [8086:8c2d] (rev 05)
00:1d.0 USB controller [0c03]: Intel Corporation 8 Series/C220 Series Chipset Family USB EHCI #1 [8086:8c26] (rev 05)

$ setpci -H1 -d 8086:8c31 d8.l=0
$ setpci -H1 -d 8086:8c31 d0.l=0

$ dmesg 
usb 1-1.3: new full-speed USB device number 3 using ehci-pci
usb 2-1.3: new high-speed USB device number 3 using ehci-pci
usb 1-1.3: New USB device found, idVendor=138a, idProduct=0011, bcdDevice=0.78
usb 1-1.3: New USB device strings: Mfr=0, Product=0, SerialNumber=1
usb 1-1.3: SerialNumber: aa32bf84ed47
usb 1-1.5: new full-speed USB device number 4 using ehci-pci
usb 2-1.3: New USB device found, idVendor=1e91, idProduct=a3a8, bcdDevice=2.07
usb 2-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=5
usb 2-1.3: Product: Elite Pro Dual
usb 2-1.3: Manufacturer: OWC
usb 2-1.3: SerialNumber: RANDOM__1E359879645F
usb 2-1.3: UAS is ignored for this device, using usb-storage instead
usb-storage 2-1.3:1.0: USB Mass Storage device detected
usb-storage 2-1.3:1.0: Quirks match for vid 1e91 pid a3a8: 800000
scsi host5: usb-storage 2-1.3:1.0
usb 1-1.5: New USB device found, idVendor=8087, idProduct=07dc, bcdDevice=0.01
usb 1-1.5: New USB device strings: Mfr=0, Product=0, SerialNumber=0
Bluetooth: hci0: Legacy ROM 2.5 revision 8.0 build 1 week 45 2013
Bluetooth: hci0: Intel Bluetooth firmware file: intel/ibt-hw-37.7.10-fw-1.80.1.2d.d.bseq
usb 1-1.6: new high-speed USB device number 5 using ehci-pci
usb 1-1.6: New USB device found, idVendor=04f2, idProduct=b398, bcdDevice=39.98
usb 1-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-1.6: Product: Integrated Camera
usb 1-1.6: Manufacturer: Vimicro corp.
Bluetooth: hci0: Intel BT fw patch 0x2a completed & activated
scsi 5:0:0:0: Direct-Access     ElitePro Dual U3FW-1      0207 PQ: 0 ANSI: 6
scsi 5:0:0:1: Direct-Access     ElitePro Dual U3FW-2      0207 PQ: 0 ANSI: 6
sd 5:0:0:0: [sdc] Very big device. Trying to use READ CAPACITY(16).
sd 5:0:0:0: [sdc] 7814037168 512-byte logical blocks: (4.00 TB/3.64 TiB)
sd 5:0:0:1: [sdd] Very big device. Trying to use READ CAPACITY(16).
sd 5:0:0:1: [sdd] 7814037168 512-byte logical blocks: (4.00 TB/3.64 TiB)
sd 5:0:0:1: [sdd] Write Protect is off
sd 5:0:0:1: [sdd] Mode Sense: 47 00 10 08
sd 5:0:0:0: [sdc] Write Protect is off
sd 5:0:0:0: [sdc] Mode Sense: 47 00 10 08
sd 5:0:0:0: [sdc] No Caching mode page found
sd 5:0:0:0: [sdc] Assuming drive cache: write through
sd 5:0:0:1: [sdd] No Caching mode page found
sd 5:0:0:1: [sdd] Assuming drive cache: write through
sd 5:0:0:0: [sdc] Attached SCSI disk
sd 5:0:0:1: [sdd] Attached SCSI disk

$ lsblk /dev/sd[cd]
NAME MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sdc    8:32   0  3.6T  0 disk 
sdd    8:48   0  3.6T  0 disk 


[0] https://superuser.com/a/875863/218574
-- 
BOFH excuse #135:

You put the disk in upside down.
