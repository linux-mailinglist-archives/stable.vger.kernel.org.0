Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 283B84803F3
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 20:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231951AbhL0TGY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 14:06:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232429AbhL0TFi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 14:05:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1AAC061761;
        Mon, 27 Dec 2021 11:05:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06FE2B81131;
        Mon, 27 Dec 2021 19:05:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D78C6C36AEC;
        Mon, 27 Dec 2021 19:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640631935;
        bh=4qpmFydKkkK4TJB8qvvtnVLt0+jcEbNxX4zgoqoeefs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OHPLYCakMtp3e3uhvmTrLjnJUhFl36dLjj9eHU0SmRNiC/kHIN15791oAS+Qg7fUo
         5C5I0O+a7fNfwyS8P5kM1j1ichIARmF43icr9XNu4+AqPCf0LR2AAcHX6dfsDipVUx
         g0dkHZPIcWlrZnSGLRbvBUqHMMarwHaT1xHDWqCbm9UN/w/nMuT7eCVq5qbKR1ZQZb
         WtliYbpRficIXeO6vDaOSvBikvYUvpFZ2dRxtgHPvOc159gLg/I4xoQHaGlijBjsZ+
         G45jEN2KNcv+mBTKNk2Whz14Oj1nQzL0Bmj7HCrp0XOXrS/qRmR/C/HqQUyA35fKSW
         B/eacQafg++hw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jackie Liu <liuyun01@kylinos.cn>, k2ci <kernel-bot@kylinos.cn>,
        Mike Rapoport <rppt@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org
Subject: [PATCH AUTOSEL 5.10 14/14] memblock: fix memblock_phys_alloc() section mismatch error
Date:   Mon, 27 Dec 2021 14:04:52 -0500
Message-Id: <20211227190452.1042714-14-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227190452.1042714-1-sashal@kernel.org>
References: <20211227190452.1042714-1-sashal@kernel.org>
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
index 1a8d25f2e0412..3baea2ef33fbb 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -387,8 +387,8 @@ phys_addr_t memblock_alloc_range_nid(phys_addr_t size,
 				      phys_addr_t end, int nid, bool exact_nid);
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

