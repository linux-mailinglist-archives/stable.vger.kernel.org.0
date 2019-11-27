Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 655A010BDC6
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:31:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730630AbfK0VbZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:31:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:44846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730861AbfK0Uyl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:54:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DD632086A;
        Wed, 27 Nov 2019 20:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888080;
        bh=TjK6ymxqY67uPx9haMeBRwGjjLaIwExRBNJ32pxvHWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HoXdTob+Rr5I2YhRKwdE0nJ1O+ETBn2cVS+j2blkIVJVZrnC6RKH1bnwfGcIHu+ZJ
         RVZQlmATEj5esdDB+dmyXZUFhzLsrods2b8mmgBBV2YxRr7AK2vtt8UyxSLrVZm722
         GA1g1hwN3TzBszWTmh03hbHjWKUEnjP0RB/Oo34g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        "Christopher M. Riedl" <cmr@informatik.wtf>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Daniel Axtens <dja@axtens.net>
Subject: [PATCH 4.14 208/211] powerpc/64s: support nospectre_v2 cmdline option
Date:   Wed, 27 Nov 2019 21:32:21 +0100
Message-Id: <20191127203113.169509874@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Christopher M. Riedl" <cmr@informatik.wtf>

commit d8f0e0b073e1ec52a05f0c2a56318b47387d2f10 upstream.

Add support for disabling the kernel implemented spectre v2 mitigation
(count cache flush on context switch) via the nospectre_v2 and
mitigations=off cmdline options.

Suggested-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Christopher M. Riedl <cmr@informatik.wtf>
Reviewed-by: Andrew Donnellan <ajd@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190524024647.381-1-cmr@informatik.wtf
Signed-off-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/security.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

--- a/arch/powerpc/kernel/security.c
+++ b/arch/powerpc/kernel/security.c
@@ -28,7 +28,7 @@ static enum count_cache_flush_type count
 bool barrier_nospec_enabled;
 static bool no_nospec;
 static bool btb_flush_enabled;
-#ifdef CONFIG_PPC_FSL_BOOK3E
+#if defined(CONFIG_PPC_FSL_BOOK3E) || defined(CONFIG_PPC_BOOK3S_64)
 static bool no_spectrev2;
 #endif
 
@@ -106,7 +106,7 @@ static __init int barrier_nospec_debugfs
 device_initcall(barrier_nospec_debugfs_init);
 #endif /* CONFIG_DEBUG_FS */
 
-#ifdef CONFIG_PPC_FSL_BOOK3E
+#if defined(CONFIG_PPC_FSL_BOOK3E) || defined(CONFIG_PPC_BOOK3S_64)
 static int __init handle_nospectre_v2(char *p)
 {
 	no_spectrev2 = true;
@@ -114,6 +114,9 @@ static int __init handle_nospectre_v2(ch
 	return 0;
 }
 early_param("nospectre_v2", handle_nospectre_v2);
+#endif /* CONFIG_PPC_FSL_BOOK3E || CONFIG_PPC_BOOK3S_64 */
+
+#ifdef CONFIG_PPC_FSL_BOOK3E
 void setup_spectre_v2(void)
 {
 	if (no_spectrev2 || cpu_mitigations_off())
@@ -391,7 +394,17 @@ static void toggle_count_cache_flush(boo
 
 void setup_count_cache_flush(void)
 {
-	toggle_count_cache_flush(true);
+	bool enable = true;
+
+	if (no_spectrev2 || cpu_mitigations_off()) {
+		if (security_ftr_enabled(SEC_FTR_BCCTRL_SERIALISED) ||
+		    security_ftr_enabled(SEC_FTR_COUNT_CACHE_DISABLED))
+			pr_warn("Spectre v2 mitigations not under software control, can't disable\n");
+
+		enable = false;
+	}
+
+	toggle_count_cache_flush(enable);
 }
 
 #ifdef CONFIG_DEBUG_FS


