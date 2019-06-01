Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 676FB32136
	for <lists+stable@lfdr.de>; Sun,  2 Jun 2019 01:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbfFAXxl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 19:53:41 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:33760 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbfFAXxl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 Jun 2019 19:53:41 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id D444327652;
        Sat,  1 Jun 2019 19:53:37 -0400 (EDT)
Date:   Sun, 2 Jun 2019 09:53:47 +1000 (AEST)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Kangjie Lu <kjlu@umn.edu>
cc:     Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Aditya Pakki <pakki001@umn.edu>,
        Rob Herring <robh@kernel.org>, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH AUTOSEL 4.4 44/56] video: imsttfb: fix potential NULL
 pointer dereferences
In-Reply-To: <20190601161929.GA5028@kroah.com>
Message-ID: <alpine.LNX.2.21.1906020944570.8@nippy.intranet>
References: <20190601132600.27427-1-sashal@kernel.org> <20190601132600.27427-44-sashal@kernel.org> <20190601161929.GA5028@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 1 Jun 2019, Greg Kroah-Hartman wrote:

> On Sat, Jun 01, 2019 at 09:25:48AM -0400, Sasha Levin wrote:

> > From: Kangjie Lu <kjlu@umn.edu>
> > 
> > [ Upstream commit 1d84353d205a953e2381044953b7fa31c8c9702d ]
> > ...
> 
> Why only 4.4.y?  Shouldn't this be queued up for everything or none?
> 
> thanks,
> 
> greg k-h
> 

Also, why not check the result of the other ioremap calls? (I should have 
checked that when this first crossed my inbox...)

From 1d84353d205a953e2381044953b7fa31c8c9702d Mon Sep 17 00:00:00 2001
From: Kangjie Lu <kjlu@umn.edu>
Date: Mon, 1 Apr 2019 17:46:58 +0200
Subject: [PATCH] video: imsttfb: fix potential NULL pointer dereferences

In case ioremap fails, the fix releases resources and returns
-ENOMEM to avoid NULL pointer dereferences.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
Cc: Aditya Pakki <pakki001@umn.edu>
Cc: Finn Thain <fthain@telegraphics.com.au>
Cc: Rob Herring <robh@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[b.zolnierkie: minor patch summary fixup]
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

diff --git a/drivers/video/fbdev/imsttfb.c b/drivers/video/fbdev/imsttfb.c
index 4b9615e4ce74..35bba3c2036d 100644
--- a/drivers/video/fbdev/imsttfb.c
+++ b/drivers/video/fbdev/imsttfb.c
@@ -1515,6 +1515,11 @@ static int imsttfb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	info->fix.smem_start = addr;
 	info->screen_base = (__u8 *)ioremap(addr, par->ramdac == IBM ?
 					    0x400000 : 0x800000);
+	if (!info->screen_base) {
+		release_mem_region(addr, size);
+		framebuffer_release(info);
+		return -ENOMEM;
+	}
 	info->fix.mmio_start = addr + 0x800000;
 	par->dc_regs = ioremap(addr + 0x800000, 0x1000);
 	par->cmap_regs_phys = addr + 0x840000;

