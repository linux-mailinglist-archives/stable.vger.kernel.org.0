Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDB9732AFBE
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:30:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238797AbhCCA2e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:28:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:50444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1383839AbhCBMck (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:32:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 505A264FC9;
        Tue,  2 Mar 2021 11:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686382;
        bh=EN+8mv8T3yg6CH9bMuNhDmN22IweqqPq3XDER+/w9Ds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kIWdcC5rj5XUrh6pNlf2YIxwmvfgGkFX7q8t+Rm41+o3H5PnuykW/22oZNlgSR0z6
         YpQCDk7bQi2cKikeD9V+gMcBkREcqMxfluJrQ44BwTc6p7/7Z7dW3+iKlTWxfcmrJb
         ZJGv+pcX1xUR84OrxHSPfvvzn+a6zjRQrgSk5HKuUpeA2nX/lcE2xXhLkJWcfIF7Ug
         98prNrkIToNdAjGGEOaqfDkHptnSVz5n6mzFCVmabr3Z01ecHQZZOUwgyb7pt+t8n5
         WxIaz5m9h4muvlwrstambC0z8b9yavPgtFOl+0JfGFGRy7rqZbYi9t/Dl797JuQOSA
         Hex65Ki+X8Ydw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andreas Larsson <andreas@gaisler.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, sparclinux@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 4/8] sparc32: Limit memblock allocation to low memory
Date:   Tue,  2 Mar 2021 06:59:31 -0500
Message-Id: <20210302115935.63777-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115935.63777-1-sashal@kernel.org>
References: <20210302115935.63777-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Larsson <andreas@gaisler.com>

[ Upstream commit bda166930c37604ffa93f2425426af6921ec575a ]

Commit cca079ef8ac29a7c02192d2bad2ffe4c0c5ffdd0 changed sparc32 to use
memblocks instead of bootmem, but also made high memory available via
memblock allocation which does not work together with e.g. phys_to_virt
and can lead to kernel panic.

This changes back to only low memory being allocatable in the early
stages, now using memblock allocation.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/mm/init_32.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/sparc/mm/init_32.c b/arch/sparc/mm/init_32.c
index 3b7092d9ea8f..4abe4bf08377 100644
--- a/arch/sparc/mm/init_32.c
+++ b/arch/sparc/mm/init_32.c
@@ -240,6 +240,9 @@ unsigned long __init bootmem_init(unsigned long *pages_avail)
 	reserve_bootmem((bootmap_pfn << PAGE_SHIFT), size, BOOTMEM_DEFAULT);
 	*pages_avail -= PAGE_ALIGN(size) >> PAGE_SHIFT;
 
+	/* Only allow low memory to be allocated via memblock allocation */
+	memblock_set_current_limit(max_low_pfn << PAGE_SHIFT);
+
 	return max_pfn;
 }
 
-- 
2.30.1

