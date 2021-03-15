Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 216F533BA76
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232071AbhCOOJS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:09:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:50102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234504AbhCOODq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:03:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6C6664EE3;
        Mon, 15 Mar 2021 14:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615817025;
        bh=LhpoZ0uUhZh39UDjgMmZOu5gqIsck3d/R/PafC0L0CM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JzCiHcsljwFXzuyWLJ4NeHPTPTSv/0matAbNQCl6g5BJt6PCzEQ4PhwwCOZO2DjGW
         FcSHpQlpa1CVgQxALUdSLcq+exVXGy/Ewm1Nlaa/jIyDTNWQZ5ipyHH6i8nQNrcgP3
         xjfS7wJJzX+4m25HZmrvCqihabj6WCvXeBoUQb2s=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        David Hildenbrand <david@redhat.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Faiyaz Mohammed <faiyazm@codeaurora.org>,
        Baoquan He <bhe@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aslan Bakirov <aslan@fb.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 265/306] memblock: fix section mismatch warning
Date:   Mon, 15 Mar 2021 14:55:28 +0100
Message-Id: <20210315135516.595578150@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 34dc2efb39a231280fd6696a59bbe712bf3c5c4a ]

The inlining logic in clang-13 is rewritten to often not inline some
functions that were inlined by all earlier compilers.

In case of the memblock interfaces, this exposed a harmless bug of a
missing __init annotation:

WARNING: modpost: vmlinux.o(.text+0x507c0a): Section mismatch in reference from the function memblock_bottom_up() to the variable .meminit.data:memblock
The function memblock_bottom_up() references
the variable __meminitdata memblock.
This is often because memblock_bottom_up lacks a __meminitdata
annotation or the annotation of memblock is wrong.

Interestingly, these annotations were present originally, but got removed
with the explanation that the __init annotation prevents the function from
getting inlined.  I checked this again and found that while this is the
case with clang, gcc (version 7 through 10, did not test others) does
inline the functions regardless.

As the previous change was apparently intended to help the clang builds,
reverting it to help the newer clang versions seems appropriate as well.
gcc builds don't seem to care either way.

Link: https://lkml.kernel.org/r/20210225133808.2188581-1-arnd@kernel.org
Fixes: 5bdba520c1b3 ("mm: memblock: drop __init from memblock functions to make it inline")
Reference: 2cfb3665e864 ("include/linux/memblock.h: add __init to memblock_set_bottom_up()")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Faiyaz Mohammed <faiyazm@codeaurora.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Aslan Bakirov <aslan@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/memblock.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index b93c44b9121e..7643d2dfa959 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -460,7 +460,7 @@ static inline void memblock_free_late(phys_addr_t base, phys_addr_t size)
 /*
  * Set the allocation direction to bottom-up or top-down.
  */
-static inline void memblock_set_bottom_up(bool enable)
+static inline __init void memblock_set_bottom_up(bool enable)
 {
 	memblock.bottom_up = enable;
 }
@@ -470,7 +470,7 @@ static inline void memblock_set_bottom_up(bool enable)
  * if this is true, that said, memblock will allocate memory
  * in bottom-up direction.
  */
-static inline bool memblock_bottom_up(void)
+static inline __init bool memblock_bottom_up(void)
 {
 	return memblock.bottom_up;
 }
-- 
2.30.1



