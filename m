Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 249C3767F2
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbfGZNlA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:41:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:47226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387625AbfGZNk6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:40:58 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EA4E22CB8;
        Fri, 26 Jul 2019 13:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148458;
        bh=+djP42l890PRgPpyfSuCFeOV38wuWwlVMb3pz0E+Mag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ELrxyKFQDLqS1N5c45EI7brqIhCoo9ezXaunRAkZNDL3vpyy6+ZfRXRWB1FAluPLh
         Qdjvq9/47PBveEgpJTgU/EAi6ElyHoYEJE8J/Ejb1B0gqRLDBR+qKeD1PMwz08kP7U
         3c31vM3g2rLrw6seYjiqD294n+lVi3mTgSjoQtxY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Roman Gushchin <guro@fb.com>,
        Shakeel Butt <shakeelb@google.com>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.2 51/85] mm/slab_common.c: work around clang bug #42570
Date:   Fri, 26 Jul 2019 09:39:01 -0400
Message-Id: <20190726133936.11177-51-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726133936.11177-1-sashal@kernel.org>
References: <20190726133936.11177-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit a07057dce2823e10d64a2b73cefbf09d8645efe9 ]

Clang gets rather confused about two variables in the same special
section when one of them is not initialized, leading to an assembler
warning later:

  /tmp/slab_common-18f869.s: Assembler messages:
  /tmp/slab_common-18f869.s:7526: Warning: ignoring changed section attributes for .data..ro_after_init

Adding an initialization to kmalloc_caches is rather silly here
but does avoid the issue.

Link: https://bugs.llvm.org/show_bug.cgi?id=42570
Link: http://lkml.kernel.org/r/20190712090455.266021-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: David Rientjes <rientjes@google.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/slab_common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 58251ba63e4a..cbd3411f644e 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1003,7 +1003,8 @@ struct kmem_cache *__init create_kmalloc_cache(const char *name,
 }
 
 struct kmem_cache *
-kmalloc_caches[NR_KMALLOC_TYPES][KMALLOC_SHIFT_HIGH + 1] __ro_after_init;
+kmalloc_caches[NR_KMALLOC_TYPES][KMALLOC_SHIFT_HIGH + 1] __ro_after_init =
+{ /* initialization for https://bugs.llvm.org/show_bug.cgi?id=42570 */ };
 EXPORT_SYMBOL(kmalloc_caches);
 
 /*
-- 
2.20.1

