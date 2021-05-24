Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB4F938EDA5
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233746AbhEXPkS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:40:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:56262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233767AbhEXPiW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:38:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42B9C61429;
        Mon, 24 May 2021 15:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870407;
        bh=iLjv2BpjEpxLxEfUWOFHpbFCb3/nWsauqU8ooJ9BEsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r0jgo2iz/zRpw9zJpw87KeA3w1zVtVFkaZCEE0gSRUBkPkloXYfGofuy3/VLpcTMo
         bynwHyfPTRDNNkqRt9164W3uGHWZyVL0z/MJp2DlyCASuk87XgqLOUlFu1e9bb9ewD
         shgQljBbD4WNJSNBHUsaTSeMPLEDRgyJ0t9rsCUw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Aditya Pakki <pakki001@umn.edu>,
        Finn Thain <fthain@telegraphics.com.au>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 4.14 20/37] Revert "video: imsttfb: fix potential NULL pointer dereferences"
Date:   Mon, 24 May 2021 17:25:24 +0200
Message-Id: <20210524152324.871453534@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152324.199089755@linuxfoundation.org>
References: <20210524152324.199089755@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit ed04fe8a0e87d7b5ea17d47f4ac9ec962b24814a upstream.

This reverts commit 1d84353d205a953e2381044953b7fa31c8c9702d.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, this commit was found to be incorrect for the reasons
below, so it must be reverted.  It will be fixed up "correctly" in a
later kernel change.

The original commit here, while technically correct, did not fully
handle all of the reported issues that the commit stated it was fixing,
so revert it until it can be "fixed" fully.

Note, ioremap() probably will never fail for old hardware like this, and
if anyone actually used this hardware (a PowerMac era PCI display card),
they would not be using fbdev anymore.

Cc: Kangjie Lu <kjlu@umn.edu>
Cc: Aditya Pakki <pakki001@umn.edu>
Cc: Finn Thain <fthain@telegraphics.com.au>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Fixes: 1d84353d205a ("video: imsttfb: fix potential NULL pointer dereferences")
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210503115736.2104747-67-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/imsttfb.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/video/fbdev/imsttfb.c
+++ b/drivers/video/fbdev/imsttfb.c
@@ -1516,11 +1516,6 @@ static int imsttfb_probe(struct pci_dev
 	info->fix.smem_start = addr;
 	info->screen_base = (__u8 *)ioremap(addr, par->ramdac == IBM ?
 					    0x400000 : 0x800000);
-	if (!info->screen_base) {
-		release_mem_region(addr, size);
-		framebuffer_release(info);
-		return -ENOMEM;
-	}
 	info->fix.mmio_start = addr + 0x800000;
 	par->dc_regs = ioremap(addr + 0x800000, 0x1000);
 	par->cmap_regs_phys = addr + 0x840000;


