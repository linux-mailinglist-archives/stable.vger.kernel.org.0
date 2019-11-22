Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C221F1060DA
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 06:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728531AbfKVFwZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:52:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:58114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728519AbfKVFwY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:52:24 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 703A520717;
        Fri, 22 Nov 2019 05:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401943;
        bh=B86OaxNtTQFhZOlp+ie1sa1q2newj9M5PkzFAV6EL4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F4i6kCWEOxNPDihtaDzM92QeBVMcdFtFd9Dc5tAYucchiL/+WJJ/9zwnkxjKZI8I0
         rluqgRsdAgah609fVUMH+YYI8hPz/ZZN51rTQvwJXzTwByuDJK5cwpkvmuzhBgqKRQ
         iMBS8IoYqEZ+1AlwvYniC5mUIcKnI46aSuVC1LiQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qian Cai <cai@gmx.us>, Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 167/219] drivers/base/platform.c: kmemleak ignore a known leak
Date:   Fri, 22 Nov 2019 00:48:19 -0500
Message-Id: <20191122054911.1750-160-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@gmx.us>

[ Upstream commit 967d3010df8b6f6f9aa95c198edc5fe3646ebf36 ]

unreferenced object 0xffff808ec6dc5a80 (size 128):
  comm "swapper/0", pid 1, jiffies 4294938063 (age 2560.530s)
  hex dump (first 32 bytes):
    ff ff ff ff 00 00 00 00 6b 6b 6b 6b 6b 6b 6b 6b  ........kkkkkkkk
    6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
  backtrace:
    [<00000000476dcf8c>] kmem_cache_alloc_trace+0x430/0x500
    [<000000004f708d37>] platform_device_register_full+0xbc/0x1e8
    [<000000006c2a7ec7>] acpi_create_platform_device+0x370/0x450
    [<00000000ef135642>] acpi_default_enumeration+0x34/0x78
    [<000000003bd9a052>] acpi_bus_attach+0x2dc/0x3e0
    [<000000003cf4f7f2>] acpi_bus_attach+0x108/0x3e0
    [<000000003cf4f7f2>] acpi_bus_attach+0x108/0x3e0
    [<000000002968643e>] acpi_bus_scan+0xb0/0x110
    [<0000000010dd0bd7>] acpi_scan_init+0x1a8/0x410
    [<00000000965b3c5a>] acpi_init+0x408/0x49c
    [<00000000ed4b9fe2>] do_one_initcall+0x178/0x7f4
    [<00000000a5ac5a74>] kernel_init_freeable+0x9d4/0xa9c
    [<0000000070ea6c15>] kernel_init+0x18/0x138
    [<00000000fb8fff06>] ret_from_fork+0x10/0x1c
    [<0000000041273a0d>] 0xffffffffffffffff

Then, faddr2line pointed out this line,

/*
 * This memory isn't freed when the device is put,
 * I don't have a nice idea for that though.  Conceptually
 * dma_mask in struct device should not be a pointer.
 * See http://thread.gmane.org/gmane.linux.kernel.pci/9081
 */
pdev->dev.dma_mask =
	kmalloc(sizeof(*pdev->dev.dma_mask), GFP_KERNEL);

Since this leak has existed for more than 8 years and it does not
reference other parts of the memory, let kmemleak ignore it, so users
don't need to waste time reporting this in the future.

Link: http://lkml.kernel.org/r/20181206160751.36211-1-cai@gmx.us
Signed-off-by: Qian Cai <cai@gmx.us>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/platform.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index dff82a3c2caa9..e9be1f56929af 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -26,6 +26,7 @@
 #include <linux/clk/clk-conf.h>
 #include <linux/limits.h>
 #include <linux/property.h>
+#include <linux/kmemleak.h>
 
 #include "base.h"
 #include "power/power.h"
@@ -525,6 +526,8 @@ struct platform_device *platform_device_register_full(
 		if (!pdev->dev.dma_mask)
 			goto err;
 
+		kmemleak_ignore(pdev->dev.dma_mask);
+
 		*pdev->dev.dma_mask = pdevinfo->dma_mask;
 		pdev->dev.coherent_dma_mask = pdevinfo->dma_mask;
 	}
-- 
2.20.1

