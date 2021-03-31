Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69C9A34CAA3
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234664AbhC2IjV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:39:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:54738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234973AbhC2Ihs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:37:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5295B61580;
        Mon, 29 Mar 2021 08:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617007067;
        bh=5x0KH8zIlb7Ip2blmdQLhK9UoQYyr2+nHpC8RdR1KsE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VVA6MYNWUA5z5DW138LhWqC+w70x6J+sVt5TR5mK8mhgnnlFVG4j5XcVqsHNAoFbi
         DHuZXYJqjoUqex251ypt+uN6ihYQr31kAfXN91DLSsS1x67+0086q9y1088+3MPiDE
         XtlVnFdOHjHiGmAqxtvaVG9PBAAxi48GyUIM1slE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Rapoport <rppt@linux.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        kernel test robot <lkp@intel.com>,
        David Hildenbrand <david@redhat.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 210/254] mm: memblock: fix section mismatch warning again
Date:   Mon, 29 Mar 2021 09:58:46 +0200
Message-Id: <20210329075639.990770018@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>

[ Upstream commit a024b7c2850dddd01e65b8270f0971deaf272f27 ]

Commit 34dc2efb39a2 ("memblock: fix section mismatch warning") marked
memblock_bottom_up() and memblock_set_bottom_up() as __init, but they
could be referenced from non-init functions like
memblock_find_in_range_node() on architectures that enable
CONFIG_ARCH_KEEP_MEMBLOCK.

For such builds kernel test robot reports:

   WARNING: modpost: vmlinux.o(.text+0x74fea4): Section mismatch in reference from the function memblock_find_in_range_node() to the function .init.text:memblock_bottom_up()
   The function memblock_find_in_range_node() references the function __init memblock_bottom_up().
   This is often because memblock_find_in_range_node lacks a __init  annotation or the annotation of memblock_bottom_up is wrong.

Replace __init annotations with __init_memblock annotations so that the
appropriate section will be selected depending on
CONFIG_ARCH_KEEP_MEMBLOCK.

Link: https://lore.kernel.org/lkml/202103160133.UzhgY0wt-lkp@intel.com
Link: https://lkml.kernel.org/r/20210316171347.14084-1-rppt@kernel.org
Fixes: 34dc2efb39a2 ("memblock: fix section mismatch warning")
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/memblock.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 7643d2dfa959..4ce9c8f9e684 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -460,7 +460,7 @@ static inline void memblock_free_late(phys_addr_t base, phys_addr_t size)
 /*
  * Set the allocation direction to bottom-up or top-down.
  */
-static inline __init void memblock_set_bottom_up(bool enable)
+static inline __init_memblock void memblock_set_bottom_up(bool enable)
 {
 	memblock.bottom_up = enable;
 }
@@ -470,7 +470,7 @@ static inline __init void memblock_set_bottom_up(bool enable)
  * if this is true, that said, memblock will allocate memory
  * in bottom-up direction.
  */
-static inline __init bool memblock_bottom_up(void)
+static inline __init_memblock bool memblock_bottom_up(void)
 {
 	return memblock.bottom_up;
 }
-- 
2.30.1



