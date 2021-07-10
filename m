Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 921143C3125
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234095AbhGJCkO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:40:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:58436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235894AbhGJCju (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:39:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E722561418;
        Sat, 10 Jul 2021 02:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884581;
        bh=HEIBJJApYYZzZSWhZnZhlesaWt2iUNUwso9VDYORhBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U7PbwKZyEyHskWJbcI/3h2OqzgViQGpUgfqGiyDzJaCYT9b0jF9g5qaBR4+6NuCPD
         x+kj8frFFbVWAXbb7Jf7wEObg/ynZ1fDrlln7sIqzgTPHWke5rXttYNoHNLaM9Okzo
         SQx0nuZ2Aevcr7TdTG2FnndgaqDlIIh4zpuU65NGkomMLoigSeaTmo9sdMuc6gZcqn
         w+xyY8lPZhAB8CP5X3K2j1C0zyySPAu6fRV1FTI8l9q6YFlEkqmrYn71+6vlMmZe6p
         OSamg33EgQ8+yzVGWBJdF1vNz/v87ga73sP09wSXpiwNFScDIMXa/wVUCpWmk9uYI3
         iLJ4z88Z9TcCA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geoff Levand <geoff@infradead.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.9 13/26] powerpc/ps3: Add dma_mask to ps3_dma_region
Date:   Fri,  9 Jul 2021 22:35:51 -0400
Message-Id: <20210710023604.3172486-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710023604.3172486-1-sashal@kernel.org>
References: <20210710023604.3172486-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geoff Levand <geoff@infradead.org>

[ Upstream commit 9733862e50fdba55e7f1554e4286fcc5302ff28e ]

Commit f959dcd6ddfd29235030e8026471ac1b022ad2b0 (dma-direct: Fix
potential NULL pointer dereference) added a null check on the
dma_mask pointer of the kernel's device structure.

Add a dma_mask variable to the ps3_dma_region structure and set
the device structure's dma_mask pointer to point to this new variable.

Fixes runtime errors like these:
# WARNING: Fixes tag on line 10 doesn't match correct format
# WARNING: Fixes tag on line 10 doesn't match correct format

  ps3_system_bus_match:349: dev=8.0(sb_01), drv=8.0(ps3flash): match
  WARNING: CPU: 0 PID: 1 at kernel/dma/mapping.c:151 .dma_map_page_attrs+0x34/0x1e0
  ps3flash sb_01: ps3stor_setup:193: map DMA region failed

Signed-off-by: Geoff Levand <geoff@infradead.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/562d0c9ea0100a30c3b186bcc7adb34b0bbd2cd7.1622746428.git.geoff@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/ps3.h  |  2 ++
 arch/powerpc/platforms/ps3/mm.c | 12 ++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/arch/powerpc/include/asm/ps3.h b/arch/powerpc/include/asm/ps3.h
index a19f831a4cc9..83a6d99e9994 100644
--- a/arch/powerpc/include/asm/ps3.h
+++ b/arch/powerpc/include/asm/ps3.h
@@ -83,6 +83,7 @@ struct ps3_dma_region_ops;
  * @bus_addr: The 'translated' bus address of the region.
  * @len: The length in bytes of the region.
  * @offset: The offset from the start of memory of the region.
+ * @dma_mask: Device dma_mask.
  * @ioid: The IOID of the device who owns this region
  * @chunk_list: Opaque variable used by the ioc page manager.
  * @region_ops: struct ps3_dma_region_ops - dma region operations
@@ -97,6 +98,7 @@ struct ps3_dma_region {
 	enum ps3_dma_region_type region_type;
 	unsigned long len;
 	unsigned long offset;
+	u64 dma_mask;
 
 	/* driver variables  (set by ps3_dma_region_create) */
 	unsigned long bus_addr;
diff --git a/arch/powerpc/platforms/ps3/mm.c b/arch/powerpc/platforms/ps3/mm.c
index 19bae78b1f25..76cbf1be9962 100644
--- a/arch/powerpc/platforms/ps3/mm.c
+++ b/arch/powerpc/platforms/ps3/mm.c
@@ -18,6 +18,7 @@
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+#include <linux/dma-mapping.h>
 #include <linux/kernel.h>
 #include <linux/export.h>
 #include <linux/memblock.h>
@@ -1132,6 +1133,7 @@ int ps3_dma_region_init(struct ps3_system_bus_device *dev,
 	enum ps3_dma_region_type region_type, void *addr, unsigned long len)
 {
 	unsigned long lpar_addr;
+	int result;
 
 	lpar_addr = addr ? ps3_mm_phys_to_lpar(__pa(addr)) : 0;
 
@@ -1143,6 +1145,16 @@ int ps3_dma_region_init(struct ps3_system_bus_device *dev,
 		r->offset -= map.r1.offset;
 	r->len = len ? len : _ALIGN_UP(map.total, 1 << r->page_size);
 
+	dev->core.dma_mask = &r->dma_mask;
+
+	result = dma_set_mask_and_coherent(&dev->core, DMA_BIT_MASK(32));
+
+	if (result < 0) {
+		dev_err(&dev->core, "%s:%d: dma_set_mask_and_coherent failed: %d\n",
+			__func__, __LINE__, result);
+		return result;
+	}
+
 	switch (dev->dev_type) {
 	case PS3_DEVICE_TYPE_SB:
 		r->region_ops =  (USE_DYNAMIC_DMA)
-- 
2.30.2

