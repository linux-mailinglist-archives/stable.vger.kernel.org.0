Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBC54469D41
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:32:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239330AbhLFP2s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:28:48 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42672 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377535AbhLFPYj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:24:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E207C6132A;
        Mon,  6 Dec 2021 15:21:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6094C341C2;
        Mon,  6 Dec 2021 15:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804069;
        bh=7Y6x205BDUFgAZRQgyrD2j4b6+OUapip8rPatiemWc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mFYy5zKJUlbQF2W/ElOIuHtAJ13Z33LztyJl6RiWnuXXBdsMnqPu82jWTvPrUB11/
         CJpx+yrvsjtmDc6RYYBS62NdJmilnL03atYz/9A9gA+av9eke5qwaTFbnFXdmPZpPq
         Lvqg5GsHMAyW5xA3kNUVcU199R5wuTWsBT0sJBOY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 016/207] powerpc/pseries/ddw: Do not try direct mapping with persistent memory and one window
Date:   Mon,  6 Dec 2021 15:54:30 +0100
Message-Id: <20211206145610.766220868@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Kardashevskiy <aik@ozlabs.ru>

[ Upstream commit ad3976025b311cdeb822ad3e7a7554018cb0f83f ]

There is a possibility of having just one DMA window available with
a limited capacity which the existing code does not handle that well.
If the window is big enough for the system RAM but less than
MAX_PHYSMEM_BITS (which we want when persistent memory is present),
we create 1:1 window and leave persistent memory without DMA.

This disables 1:1 mapping entirely if there is persistent memory and
either:
- the huge DMA window does not cover the entire address space;
- the default DMA window is removed.

This relies on reverted 54fc3c681ded
("powerpc/pseries/ddw: Extend upper limit for huge DMA window for persistent memory")
to return the actual amount RAM in ddw_memory_hotplug_max() (posted
separately).

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20211108040320.3857636-4-aik@ozlabs.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/iommu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
index ad96d6e13d1f6..8322ca86d5acf 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -1356,8 +1356,10 @@ static bool enable_ddw(struct pci_dev *dev, struct device_node *pdn)
 		len = order_base_2(query.largest_available_block << page_shift);
 		win_name = DMA64_PROPNAME;
 	} else {
-		direct_mapping = true;
-		win_name = DIRECT64_PROPNAME;
+		direct_mapping = !default_win_removed ||
+			(len == MAX_PHYSMEM_BITS) ||
+			(!pmem_present && (len == max_ram_len));
+		win_name = direct_mapping ? DIRECT64_PROPNAME : DMA64_PROPNAME;
 	}
 
 	ret = create_ddw(dev, ddw_avail, &create, page_shift, len);
-- 
2.33.0



