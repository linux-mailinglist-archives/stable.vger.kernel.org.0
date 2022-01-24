Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72BF4499C0F
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1576213AbiAXV7J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:59:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573880AbiAXVqs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:46:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27799C08B4CE;
        Mon, 24 Jan 2022 12:32:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9FDDE6157D;
        Mon, 24 Jan 2022 20:32:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 877D5C340E5;
        Mon, 24 Jan 2022 20:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056346;
        bh=oFIl2lMl4yMt8gerjJ+NCCv4bVevmsWfQhKTrOw/WJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HvLC/q5i1AWyJhSXadqc2sp1+lNWSlTDgO/Sex18iHV7tQC/OXFzFwv5ksmoIqOsC
         QU+fVQ3rc/1Blnc5Kf8EbiEqc4wMBMyQEkuq+wuOEeqtHMyI56HS6kU0vSadLP7Q/1
         21FU90gzZSHPOBZA3nq+E0qEFOPHSgw9zCtX1Hd8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Rapoport <rppt@kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        Nicolas Boichat <drinkcat@chromium.org>,
        Quentin Perret <qperret@google.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 453/846] of/fdt: Dont worry about non-memory region overlap for no-map
Date:   Mon, 24 Jan 2022 19:39:30 +0100
Message-Id: <20220124184116.611818964@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>

[ Upstream commit da17d6905d29ddcdc04b2fdc37ed8cf1e8437cc8 ]

In commit 8a5a75e5e9e5 ("of/fdt: Make sure no-map does not remove
already reserved regions") we returned -EBUSY when trying to mark
regions as no-map when they intersect with reserved memory. The goal was
to find bad no-map reserved memory DT nodes that would unmap the kernel
text/data sections.

The problem is the reserved memory check will still trigger if the DT
has a /memreserve/ that completely subsumes the no-map memory carveouts
in the reserved memory node _and_ that region is also not part of the
memory reg property. For example in sc7180.dtsi we have the following
reserved-memory and memory node:

      memory@80000000 {
          /* We expect the bootloader to fill in the size */
          reg = <0 0x80000000 0 0>;
      };

      smem_mem: memory@80900000 {
              reg = <0x0 0x80900000 0x0 0x200000>;
              no-map;
      };

and the memreserve filled in by the bootloader is

      /memreserve/ 0x80800000 0x400000;

while the /memory node is transformed into

      memory@80000000 {
          /* The bootloader fills in the size, and adds another region */
          reg = <0 0x80000000 0 0x00800000>,
                <0 0x80c00000 0 0x7f200000>;
      };

The smem region is doubly reserved via /memreserve/ and by not being
part of the /memory reg property. This leads to the following warning
printed at boot.

 OF: fdt: Reserved memory: failed to reserve memory for node 'memory@80900000': base 0x0000000080900000, size 2 MiB

Otherwise nothing really goes wrong because the smem region is not going
to be mapped by the kernel's direct linear mapping given that it isn't
part of the memory node. Therefore, let's only consider this to be a
problem if we're trying to mark a region as no-map and it is actually
memory that we're intending to keep out of the kernel's direct mapping
but it's already been reserved.

Acked-by: Mike Rapoport <rppt@kernel.org>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Nicolas Boichat <drinkcat@chromium.org>
Cc: Quentin Perret <qperret@google.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Fixes: 8a5a75e5e9e5 ("of/fdt: Make sure no-map does not remove already reserved regions")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20220107194233.2793146-1-swboyd@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/fdt.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 32e5e782d43da..59a7a9ee58ef7 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -482,9 +482,11 @@ static int __init early_init_dt_reserve_memory_arch(phys_addr_t base,
 	if (nomap) {
 		/*
 		 * If the memory is already reserved (by another region), we
-		 * should not allow it to be marked nomap.
+		 * should not allow it to be marked nomap, but don't worry
+		 * if the region isn't memory as it won't be mapped.
 		 */
-		if (memblock_is_region_reserved(base, size))
+		if (memblock_overlaps_region(&memblock.memory, base, size) &&
+		    memblock_is_region_reserved(base, size))
 			return -EBUSY;
 
 		return memblock_mark_nomap(base, size);
-- 
2.34.1



