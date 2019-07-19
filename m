Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95CCF6DFCC
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbfGSEhh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:37:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:59672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728936AbfGSD7z (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 23:59:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39E8C21851;
        Fri, 19 Jul 2019 03:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563508793;
        bh=NFNOPqgRupv5wuwZdzjSPWTtOvTz7dM27LOeXW3PWjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vZnO7a1YobK7uECS1q0omEchaRTcv9z02YCKv/dUw4YnDRgODIJZnyVsMlfRKRnKc
         oEP+tSlj3xiwkO0xQyC0sC74b7F6m70q2g+V5MoV91sg1v1/fr3loNLfxB/8UFbAAZ
         M6am83UH5RVFezCLRYnh49oh+a5+EOC24f6mWA2M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qian Cai <cai@lca.pw>, Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.2 092/171] powerpc/cacheflush: fix variable set but not used
Date:   Thu, 18 Jul 2019 23:55:23 -0400
Message-Id: <20190719035643.14300-92-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719035643.14300-1-sashal@kernel.org>
References: <20190719035643.14300-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

[ Upstream commit 04db3ede40ae4fc23a5c4237254c4a53bbe4c1f2 ]

The powerpc's flush_cache_vmap() is defined as a macro and never use
both of its arguments, so it will generate a compilation warning,

lib/ioremap.c: In function 'ioremap_page_range':
lib/ioremap.c:203:16: warning: variable 'start' set but not used
[-Wunused-but-set-variable]

Fix it by making it an inline function.

Signed-off-by: Qian Cai <cai@lca.pw>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/cacheflush.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/cacheflush.h b/arch/powerpc/include/asm/cacheflush.h
index 74d60cfe8ce5..fd318f7c3eed 100644
--- a/arch/powerpc/include/asm/cacheflush.h
+++ b/arch/powerpc/include/asm/cacheflush.h
@@ -29,9 +29,12 @@
  * not expect this type of fault. flush_cache_vmap is not exactly the right
  * place to put this, but it seems to work well enough.
  */
-#define flush_cache_vmap(start, end)		do { asm volatile("ptesync" ::: "memory"); } while (0)
+static inline void flush_cache_vmap(unsigned long start, unsigned long end)
+{
+	asm volatile("ptesync" ::: "memory");
+}
 #else
-#define flush_cache_vmap(start, end)		do { } while (0)
+static inline void flush_cache_vmap(unsigned long start, unsigned long end) { }
 #endif
 
 #define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
-- 
2.20.1

