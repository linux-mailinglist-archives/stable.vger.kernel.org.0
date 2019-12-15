Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 581F911F9DE
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 18:48:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbfLORrO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 12:47:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:40806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726232AbfLORrO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Dec 2019 12:47:14 -0500
Received: from localhost (unknown [73.61.17.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0ADDB206E0;
        Sun, 15 Dec 2019 17:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576432033;
        bh=NWsSgfibUg+77rfCc2Cdb+FwAbfGoiUw9ildHZc3BQw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pyjvaw/sl1LZGAhAtqz3xRBcyviGK0BNn8eqbh5sbShjgQ51jTJwcUu/GFmjYYktD
         Dr6GSKjcbHy2QQCtgq4feQTKg0OpkgKG8kR2Q3yTWp37Q0qluSSWsZFKMOjFGiSSMA
         jPId+XgrWqcELULA87F3XJMRIha9HSGSXlN0sB/I=
Date:   Sun, 15 Dec 2019 12:47:11 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     mika.westerberg@linux.intel.com, mathias.nyman@linux.intel.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] xhci: Fix memory leak in
 xhci_add_in_port()" failed to apply to 4.14-stable tree
Message-ID: <20191215174711.GG18043@sasha-vm>
References: <157640192510189@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <157640192510189@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 15, 2019 at 10:25:25AM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.14-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From ce91f1a43b37463f517155bdfbd525eb43adbd1a Mon Sep 17 00:00:00 2001
>From: Mika Westerberg <mika.westerberg@linux.intel.com>
>Date: Wed, 11 Dec 2019 16:20:02 +0200
>Subject: [PATCH] xhci: Fix memory leak in xhci_add_in_port()
>
>When xHCI is part of Alpine or Titan Ridge Thunderbolt controller and
>the xHCI device is hot-removed as a result of unplugging a dock for
>example, the driver leaks memory it allocates for xhci->usb3_rhub.psi
>and xhci->usb2_rhub.psi in xhci_add_in_port() as reported by kmemleak:
>
>unreferenced object 0xffff922c24ef42f0 (size 16):
>  comm "kworker/u16:2", pid 178, jiffies 4294711640 (age 956.620s)
>  hex dump (first 16 bytes):
>    21 00 0c 00 12 00 dc 05 23 00 e0 01 00 00 00 00  !.......#.......
>  backtrace:
>    [<000000007ac80914>] xhci_mem_init+0xcf8/0xeb7
>    [<0000000001b6d775>] xhci_init+0x7c/0x160
>    [<00000000db443fe3>] xhci_gen_setup+0x214/0x340
>    [<00000000fdffd320>] xhci_pci_setup+0x48/0x110
>    [<00000000541e1e03>] usb_add_hcd.cold+0x265/0x747
>    [<00000000ca47a56b>] usb_hcd_pci_probe+0x219/0x3b4
>    [<0000000021043861>] xhci_pci_probe+0x24/0x1c0
>    [<00000000b9231f25>] local_pci_probe+0x3d/0x70
>    [<000000006385c9d7>] pci_device_probe+0xd0/0x150
>    [<0000000070241068>] really_probe+0xf5/0x3c0
>    [<0000000061f35c0a>] driver_probe_device+0x58/0x100
>    [<000000009da11198>] bus_for_each_drv+0x79/0xc0
>    [<000000009ce45f69>] __device_attach+0xda/0x160
>    [<00000000df201aaf>] pci_bus_add_device+0x46/0x70
>    [<0000000088a1bc48>] pci_bus_add_devices+0x27/0x60
>    [<00000000ad9ee708>] pci_bus_add_devices+0x52/0x60
>unreferenced object 0xffff922c24ef3318 (size 8):
>  comm "kworker/u16:2", pid 178, jiffies 4294711640 (age 956.620s)
>  hex dump (first 8 bytes):
>    34 01 05 00 35 41 0a 00                          4...5A..
>  backtrace:
>    [<000000007ac80914>] xhci_mem_init+0xcf8/0xeb7
>    [<0000000001b6d775>] xhci_init+0x7c/0x160
>    [<00000000db443fe3>] xhci_gen_setup+0x214/0x340
>    [<00000000fdffd320>] xhci_pci_setup+0x48/0x110
>    [<00000000541e1e03>] usb_add_hcd.cold+0x265/0x747
>    [<00000000ca47a56b>] usb_hcd_pci_probe+0x219/0x3b4
>    [<0000000021043861>] xhci_pci_probe+0x24/0x1c0
>    [<00000000b9231f25>] local_pci_probe+0x3d/0x70
>    [<000000006385c9d7>] pci_device_probe+0xd0/0x150
>    [<0000000070241068>] really_probe+0xf5/0x3c0
>    [<0000000061f35c0a>] driver_probe_device+0x58/0x100
>    [<000000009da11198>] bus_for_each_drv+0x79/0xc0
>    [<000000009ce45f69>] __device_attach+0xda/0x160
>    [<00000000df201aaf>] pci_bus_add_device+0x46/0x70
>    [<0000000088a1bc48>] pci_bus_add_devices+0x27/0x60
>    [<00000000ad9ee708>] pci_bus_add_devices+0x52/0x60
>
>Fix this by calling kfree() for the both psi objects in
>xhci_mem_cleanup().

Context changes due to missing:

	bcaa9d5c5900 ("xhci: Create new structures to store xhci port information")

Fixed up and queued up for 4.14 - 4.4.

-- 
Thanks,
Sasha
