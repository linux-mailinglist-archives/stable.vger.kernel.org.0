Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95C58483281
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbiACO2X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:28:23 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58752 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234027AbiACO1V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:27:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 931C4B80EFF;
        Mon,  3 Jan 2022 14:27:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5970C36AEB;
        Mon,  3 Jan 2022 14:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220039;
        bh=jYraZydYRAFrKPlqIsWfLV9e+BjA3LqSdGtNtSNDx4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wHHKHzfpgiIUHQYHEsuZR7JLNmvYjDnaYBtzyWSof12wVT2o42YuMwAc1dMnpLOiQ
         Uhcxoq/C6YHpmMhCVwfb9Gd/gwfL91kFHDGmyZ+5YwjaY5tZf1rVdz9fvsDOW/bLU5
         iyCAxR+hHVLSpNIm/dKeRTB8B1vYkUsQE2kGsQNY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, k2ci <kernel-bot@kylinos.cn>,
        Mike Rapoport <rppt@kernel.org>,
        Jackie Liu <liuyun01@kylinos.cn>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 07/37] memblock: fix memblock_phys_alloc() section mismatch error
Date:   Mon,  3 Jan 2022 15:23:45 +0100
Message-Id: <20220103142052.108834388@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142051.883166998@linuxfoundation.org>
References: <20220103142051.883166998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



