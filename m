Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0ED23714E9
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 14:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234043AbhECMCh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 08:02:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:37066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233869AbhECMCG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 08:02:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDD8C6135C;
        Mon,  3 May 2021 12:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620043273;
        bh=KcV3atBkyaamldW6+LBiV4kpn3j58jfa6Pt0wZ6TVDU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kD75+WhQumA4j6priBMUCGx0nMCeSnO+/QkzbXsNSbsxyIpAB9KKkyK6yaLw3pfy7
         dqyekchbjOBDVlqlkbFGcJQyuGCpvmuqbMjC0jiZ8OM9fWrQhskbfJnGNPkyRrOsln
         R3jyekW5YAnQYWChvaJnQWdQUOmT1k0Y4AEiuOk0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kangjie Lu <kjlu@umn.edu>, Aditya Pakki <pakki001@umn.edu>,
        Finn Thain <fthain@telegraphics.com.au>,
        Rob Herring <robh@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 66/69] Revert "video: imsttfb: fix potential NULL pointer dereferences"
Date:   Mon,  3 May 2021 13:57:33 +0200
Message-Id: <20210503115736.2104747-67-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
References: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: Rob Herring <robh@kernel.org>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Fixes: 1d84353d205a ("video: imsttfb: fix potential NULL pointer dereferences")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/imsttfb.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/video/fbdev/imsttfb.c b/drivers/video/fbdev/imsttfb.c
index 3ac053b88495..e04411701ec8 100644
--- a/drivers/video/fbdev/imsttfb.c
+++ b/drivers/video/fbdev/imsttfb.c
@@ -1512,11 +1512,6 @@ static int imsttfb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
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
-- 
2.31.1

