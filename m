Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95719111E58
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729364AbfLCXBQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 18:01:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:51380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729169AbfLCW4Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:56:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A06F920865;
        Tue,  3 Dec 2019 22:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413783;
        bh=B86OaxNtTQFhZOlp+ie1sa1q2newj9M5PkzFAV6EL4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=acyhnVNYjNIdvcFWT9S9ZDKuqRsxUNZ0dNPXdCCfnsBXg8BEgvSwzrWNuWcsy/hT5
         sfhSkZmL1aEHYQ8lZPFu4tlzVIxj5O9fVHAMtQgCEEVmEyZxmjdWvlXC+sttlA0GPN
         4g5KtD3UQDMgctp9niJFYbnDjquSt+S8Hf6IYey0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@gmx.us>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 211/321] drivers/base/platform.c: kmemleak ignore a known leak
Date:   Tue,  3 Dec 2019 23:34:37 +0100
Message-Id: <20191203223438.098119676@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



