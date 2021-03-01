Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D11D5328542
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235632AbhCAQwB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:52:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:45654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235355AbhCAQoM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:44:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C367761606;
        Mon,  1 Mar 2021 16:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616223;
        bh=OBykguHPmKIID2/SOxF2uz7dxthQahirxaLl56x7cOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e6ywied1IKEtU1XNwr3GWYJRmUtCSEl1rM4Ser73Ny9/23kqanDrIApsJcbP6Eo8X
         7HDRlNbvKgMF/CplpWPSEcE+V+jmFutRAXwGF8P5oG+tabHvV08zYMDEbTiuZZLvdD
         yxdZGXE9ExG2rXUPi/07rbpUKcrLa4/O80coYdds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolas Boichat <drinkcat@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Quentin Perret <qperret@google.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 077/176] of/fdt: Make sure no-map does not remove already reserved regions
Date:   Mon,  1 Mar 2021 17:12:30 +0100
Message-Id: <20210301161024.795437769@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161020.931630716@linuxfoundation.org>
References: <20210301161020.931630716@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Boichat <drinkcat@chromium.org>

[ Upstream commit 8a5a75e5e9e55de1cef5d83ca3589cb4899193ef ]

If the device tree is incorrectly configured, and attempts to
define a "no-map" reserved memory that overlaps with the kernel
data/code, the kernel would crash quickly after boot, with no
obvious clue about the nature of the issue.

For example, this would happen if we have the kernel mapped at
these addresses (from /proc/iomem):
40000000-41ffffff : System RAM
  40080000-40dfffff : Kernel code
  40e00000-411fffff : reserved
  41200000-413e0fff : Kernel data

And we declare a no-map shared-dma-pool region at a fixed address
within that range:
mem_reserved: mem_region {
	compatible = "shared-dma-pool";
	reg = <0 0x40000000 0 0x01A00000>;
	no-map;
};

To fix this, when removing memory regions at early boot (which is
what "no-map" regions do), we need to make sure that the memory
is not already reserved. If we do, __reserved_mem_reserve_reg
will throw an error:
[    0.000000] OF: fdt: Reserved memory: failed to reserve memory
   for node 'mem_region': base 0x0000000040000000, size 26 MiB
and the code that will try to use the region should also fail,
later on.

We do not do anything for non-"no-map" regions, as memblock
explicitly allows reserved regions to overlap, and the commit
that this fixes removed the check for that precise reason.

[ qperret: fixed conflicts caused by the usage of memblock_mark_nomap ]

Fixes: 094cb98179f19b7 ("of/fdt: memblock_reserve /memreserve/ regions in the case of partial overlap")
Signed-off-by: Nicolas Boichat <drinkcat@chromium.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Quentin Perret <qperret@google.com>
Link: https://lore.kernel.org/r/20210115114544.1830068-3-qperret@google.com
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/fdt.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 6df66fcefbb40..3f58812d02d9f 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -1212,8 +1212,16 @@ int __init __weak early_init_dt_mark_hotplug_memory_arch(u64 base, u64 size)
 int __init __weak early_init_dt_reserve_memory_arch(phys_addr_t base,
 					phys_addr_t size, bool nomap)
 {
-	if (nomap)
+	if (nomap) {
+		/*
+		 * If the memory is already reserved (by another region), we
+		 * should not allow it to be marked nomap.
+		 */
+		if (memblock_is_region_reserved(base, size))
+			return -EBUSY;
+
 		return memblock_mark_nomap(base, size);
+	}
 	return memblock_reserve(base, size);
 }
 
-- 
2.27.0



