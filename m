Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A79D480415
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 20:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233452AbhL0THO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 14:07:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232869AbhL0TGL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 14:06:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2742FC0613A1;
        Mon, 27 Dec 2021 11:06:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC35461169;
        Mon, 27 Dec 2021 19:06:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51156C36AEB;
        Mon, 27 Dec 2021 19:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640631970;
        bh=jYraZydYRAFrKPlqIsWfLV9e+BjA3LqSdGtNtSNDx4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nZ1ncT5rQmq/nfEICsZItoNSvbLrvENWw6/KdZr1NDR++rySrcK5UCPVogp1dIVfq
         APy7AOX1J1ayYGvra+rNqJW65LIO1p+7hBvkzCS24baBYOyAVtQMAs4ers2hkRaAw9
         5k6a5KOF+cfCgmODpQ7dQC6ekjwmMm75K9XIIPIDi0pDkOzpfTZ8WRU5zaliUBVLex
         jC7ppNM/SUraBx5dp/CeWCS1IW1lj7OPeqQbWHd2532txvzlEzD8tegA4DPO9kFjWq
         eGMFTLf54OObBUHA2u3JdKjZRrfPiDMEJY18j5Q3cxLSFBP/cJUQUWdHw+Cy2xZl7W
         0x4sLvmw1MnGw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jackie Liu <liuyun01@kylinos.cn>, k2ci <kernel-bot@kylinos.cn>,
        Mike Rapoport <rppt@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org
Subject: [PATCH AUTOSEL 5.4 9/9] memblock: fix memblock_phys_alloc() section mismatch error
Date:   Mon, 27 Dec 2021 14:05:36 -0500
Message-Id: <20211227190536.1042975-9-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227190536.1042975-1-sashal@kernel.org>
References: <20211227190536.1042975-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jackie Liu <liuyun01@kylinos.cn>

[ Upstream commit d7f55471db2719629f773c2d6b5742a69595bfd3 ]

Fix modpost Section mismatch error in memblock_phys_alloc()

[...]
WARNING: modpost: vmlinux.o(.text.unlikely+0x1dcc): Section mismatch in reference
from the function memblock_phys_alloc() to the function .init.text:memblock_phys_alloc_range()
The function memblock_phys_alloc() references
the function __init memblock_phys_alloc_range().
This is often because memblock_phys_alloc lacks a __init
annotation or the annotation of memblock_phys_alloc_range is wrong.

ERROR: modpost: Section mismatches detected.
Set CONFIG_SECTION_MISMATCH_WARN_ONLY=y to allow them.
[...]

memblock_phys_alloc() is a one-line wrapper, make it __always_inline to
avoid these section mismatches.

Reported-by: k2ci <kernel-bot@kylinos.cn>
Suggested-by: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
[rppt: slightly massaged changelog ]
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Link: https://lore.kernel.org/r/20211217020754.2874872-1-liu.yun@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/memblock.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index f491690d54c6c..64b971b2542d6 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -351,8 +351,8 @@ phys_addr_t memblock_phys_alloc_range(phys_addr_t size, phys_addr_t align,
 				      phys_addr_t start, phys_addr_t end);
 phys_addr_t memblock_phys_alloc_try_nid(phys_addr_t size, phys_addr_t align, int nid);
 
-static inline phys_addr_t memblock_phys_alloc(phys_addr_t size,
-					      phys_addr_t align)
+static __always_inline phys_addr_t memblock_phys_alloc(phys_addr_t size,
+						       phys_addr_t align)
 {
 	return memblock_phys_alloc_range(size, align, 0,
 					 MEMBLOCK_ALLOC_ACCESSIBLE);
-- 
2.34.1

