Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 982D9147ACD
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729508AbgAXJiZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:38:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:35544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbgAXJiZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:38:25 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4EC120709;
        Fri, 24 Jan 2020 09:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858704;
        bh=QDKSUapnYTJV9YDZiQ2dSpHwPO9fJ6OQJzfqRcimlso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=InsFftzaufCSfOTfyU5QaUkEMzqgCsHjAtL0IsCPEkIfyS/Tz4fXlapXqLI2HbqUA
         9D3bDNhRzUl2eFdzPsRrZWAyq6Q1XHfKMp5qNyNv3EjxEvIndVV/eauI1vkda5WW5u
         SDxhyZD5t7OEmnfo5WvFS+qtESKEESTLkyto63sE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 019/102] powerpc/security: Fix debugfs data leak on 32-bit
Date:   Fri, 24 Jan 2020 10:30:20 +0100
Message-Id: <20200124092809.069364174@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092806.004582306@linuxfoundation.org>
References: <20200124092806.004582306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit 3b05a1e517e1a8cfda4866ec31d28b2bc4fee4c4 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/security_features.h |    8 ++++----
 arch/powerpc/kernel/security.c               |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

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
--- a/arch/powerpc/kernel/security.c
+++ b/arch/powerpc/kernel/security.c
@@ -16,7 +16,7 @@
 #include <asm/setup.h>
 
 
-unsigned long powerpc_security_features __read_mostly = SEC_FTR_DEFAULT;
+u64 powerpc_security_features __read_mostly = SEC_FTR_DEFAULT;
 
 enum count_cache_flush_type {
 	COUNT_CACHE_FLUSH_NONE	= 0x1,
@@ -109,7 +109,7 @@ device_initcall(barrier_nospec_debugfs_i
 static __init int security_feature_debugfs_init(void)
 {
 	debugfs_create_x64("security_features", 0400, powerpc_debugfs_root,
-			   (u64 *)&powerpc_security_features);
+			   &powerpc_security_features);
 	return 0;
 }
 device_initcall(security_feature_debugfs_init);


