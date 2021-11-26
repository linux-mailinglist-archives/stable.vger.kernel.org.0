Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02BF045E4D3
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 03:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357998AbhKZChU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 21:37:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:48206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244286AbhKZCfR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 21:35:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CBF261181;
        Fri, 26 Nov 2021 02:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637893925;
        bh=7Y6x205BDUFgAZRQgyrD2j4b6+OUapip8rPatiemWc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iYhyb2zXXA2tGtz+HsnYK1khlmWil5EuyrPT8wQ8GtNOc4h0I9TnqxlZPEh6Fc71Q
         5OyXkeKqjg3I+AycPG424NKrwOtUkbc10IBpEtKfbz2XFg6zTdq/EZ2MXIYPFvBWGE
         sNO0BbbejzOB2LDWPl/NAolUXiZszLC9m6iQPErMGvCsrgMFmGEZWTKC/BKHof/cRm
         RbJg2B4Ko5rK48+BOyUYLrStGRr1+mCX3ZWeMW3DTZ1bgmQ8ShqqOvp26XFq5zJq6g
         Ctc/FZSviZzH/AO8V+S3afsr1zO6GP8PgUwOOwJRZkYqGiAPgnOrzZU5OZEbm7/77g
         RDZAbxM8/cGLA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, leobras.c@gmail.com,
        fbarrat@linux.ibm.com, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.15 04/39] powerpc/pseries/ddw: Do not try direct mapping with persistent memory and one window
Date:   Thu, 25 Nov 2021 21:31:21 -0500
Message-Id: <20211126023156.441292-4-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023156.441292-1-sashal@kernel.org>
References: <20211126023156.441292-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

