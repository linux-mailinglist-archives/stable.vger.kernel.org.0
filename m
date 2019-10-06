Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0F7CD75F
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 20:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728619AbfJFR15 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:27:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:53438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728607AbfJFR1x (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:27:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6FE6214D9;
        Sun,  6 Oct 2019 17:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570382873;
        bh=1gGCjJia8yEAWiHCMurLorhELpMT7PCKhoCa6fsupq0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f6gGuDP/efo5zbuVQgurbB5S0cX0bhQjT7zDYN9qHyLCSFrAxOYMOCBE/ZrbPFKkU
         HrQjwlroIovquCvh/m1TQQgRy6ejDyK9bB8Yc10yKbakAzTGROF3kgGvGxW+4oBTaq
         if9aUlUNViHmtttUQ+x4N/jIvsMymEJDcNINLpww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Rapoport <rppt@linux.ibm.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 41/68] ARM: 8903/1: ensure that usable memory in bank 0 starts from a PMD-aligned address
Date:   Sun,  6 Oct 2019 19:21:17 +0200
Message-Id: <20191006171127.366967464@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171108.150129403@linuxfoundation.org>
References: <20191006171108.150129403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Rapoport <mike.rapoport@gmail.com>

[ Upstream commit 00d2ec1e6bd82c0538e6dd3e4a4040de93ba4fef ]

The calculation of memblock_limit in adjust_lowmem_bounds() assumes that
bank 0 starts from a PMD-aligned address. However, the beginning of the
first bank may be NOMAP memory and the start of usable memory
will be not aligned to PMD boundary. In such case the memblock_limit will
be set to the end of the NOMAP region, which will prevent any memblock
allocations.

Mark the region between the end of the NOMAP area and the next PMD-aligned
address as NOMAP as well, so that the usable memory will start at
PMD-aligned address.

Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mm/mmu.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index e46a6a446cdd2..70e560cf8ca03 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -1175,6 +1175,22 @@ void __init adjust_lowmem_bounds(void)
 	 */
 	vmalloc_limit = (u64)(uintptr_t)vmalloc_min - PAGE_OFFSET + PHYS_OFFSET;
 
+	/*
+	 * The first usable region must be PMD aligned. Mark its start
+	 * as MEMBLOCK_NOMAP if it isn't
+	 */
+	for_each_memblock(memory, reg) {
+		if (!memblock_is_nomap(reg)) {
+			if (!IS_ALIGNED(reg->base, PMD_SIZE)) {
+				phys_addr_t len;
+
+				len = round_up(reg->base, PMD_SIZE) - reg->base;
+				memblock_mark_nomap(reg->base, len);
+			}
+			break;
+		}
+	}
+
 	for_each_memblock(memory, reg) {
 		phys_addr_t block_start = reg->base;
 		phys_addr_t block_end = reg->base + reg->size;
-- 
2.20.1



