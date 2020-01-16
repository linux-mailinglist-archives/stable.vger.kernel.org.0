Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C11813E1EC
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:54:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729277AbgAPQwV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:52:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:35368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727008AbgAPQwV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:52:21 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DD8B2073A;
        Thu, 16 Jan 2020 16:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193540;
        bh=ZiZ6TkumCmKhw6ZAr6uKRo1tFs4kdys3f6UhWm76PA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i0cttr4VSnItIHMZ85QwbkvMTIDoiALQYU2jHlndCgDzYBdj/NLaL8Z3aDVpsI+70
         A49m78/g06U2Hv+KkpZUiNwiHvy+5piPHg9kdSudMWlVjfLwDRDRvq0zaV1nKufaPJ
         49CyKUQb/ayDPYVGl3XQTvB6DCUicrhaD3Sj9bO4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.4 099/205] powerpc/security: Fix debugfs data leak on 32-bit
Date:   Thu, 16 Jan 2020 11:41:14 -0500
Message-Id: <20200116164300.6705-99-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 3b05a1e517e1a8cfda4866ec31d28b2bc4fee4c4 ]

"powerpc_security_features" is "unsigned long", i.e. 32-bit or 64-bit,
depending on the platform (PPC_FSL_BOOK3E or PPC_BOOK3S_64).  Hence
casting its address to "u64 *", and calling debugfs_create_x64() is
wrong, and leaks 32-bit of nearby data to userspace on 32-bit platforms.

While all currently defined SEC_FTR_* security feature flags fit in
32-bit, they all have "ULL" suffixes to make them 64-bit constants.
Hence fix the leak by changing the type of "powerpc_security_features"
(and the parameter types of its accessors) to "u64".  This also allows
to drop the cast.

Fixes: 398af571128fe75f ("powerpc/security: Show powerpc_security_features in debugfs")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20191021142309.28105-1-geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/security_features.h | 8 ++++----
 arch/powerpc/kernel/security.c               | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/include/asm/security_features.h b/arch/powerpc/include/asm/security_features.h
index ccf44c135389..7c05e95a5c44 100644
--- a/arch/powerpc/include/asm/security_features.h
+++ b/arch/powerpc/include/asm/security_features.h
@@ -9,7 +9,7 @@
 #define _ASM_POWERPC_SECURITY_FEATURES_H
 
 
-extern unsigned long powerpc_security_features;
+extern u64 powerpc_security_features;
 extern bool rfi_flush;
 
 /* These are bit flags */
@@ -24,17 +24,17 @@ void setup_stf_barrier(void);
 void do_stf_barrier_fixups(enum stf_barrier_type types);
 void setup_count_cache_flush(void);
 
-static inline void security_ftr_set(unsigned long feature)
+static inline void security_ftr_set(u64 feature)
 {
 	powerpc_security_features |= feature;
 }
 
-static inline void security_ftr_clear(unsigned long feature)
+static inline void security_ftr_clear(u64 feature)
 {
 	powerpc_security_features &= ~feature;
 }
 
-static inline bool security_ftr_enabled(unsigned long feature)
+static inline bool security_ftr_enabled(u64 feature)
 {
 	return !!(powerpc_security_features & feature);
 }
diff --git a/arch/powerpc/kernel/security.c b/arch/powerpc/kernel/security.c
index d341b464f23c..1740a66cea84 100644
--- a/arch/powerpc/kernel/security.c
+++ b/arch/powerpc/kernel/security.c
@@ -16,7 +16,7 @@
 #include <asm/setup.h>
 
 
-unsigned long powerpc_security_features __read_mostly = SEC_FTR_DEFAULT;
+u64 powerpc_security_features __read_mostly = SEC_FTR_DEFAULT;
 
 enum count_cache_flush_type {
 	COUNT_CACHE_FLUSH_NONE	= 0x1,
@@ -109,7 +109,7 @@ device_initcall(barrier_nospec_debugfs_init);
 static __init int security_feature_debugfs_init(void)
 {
 	debugfs_create_x64("security_features", 0400, powerpc_debugfs_root,
-			   (u64 *)&powerpc_security_features);
+			   &powerpc_security_features);
 	return 0;
 }
 device_initcall(security_feature_debugfs_init);
-- 
2.20.1

