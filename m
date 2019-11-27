Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BBD110BC05
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:17:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727682AbfK0VRr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:17:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:42942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732615AbfK0VMY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:12:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7BEF21850;
        Wed, 27 Nov 2019 21:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574889143;
        bh=KamOJ0k99dLB3F5Z9KJH8d9epqyB7CNyLPOeg5wb4vQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U7ygRyqSIFA/ejKRU37VzNNwNcoM+U1fyuo93f2kqr1k2DRPvaeRxFx5VxivJ2yKr
         lzaUYFtbvOMOPe/TlojhwBApAQk+MwGcPndEGaQ5CTxL/u7YrpbKvv+c5PGrJGXKyM
         gqU3+vWIgjWJR2qXIeO+/M0rMUrREDJHC6Fn3u10=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        "Christopher M. Riedl" <cmr@informatik.wtf>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Daniel Axtens <dja@axtens.net>
Subject: [PATCH 5.3 93/95] powerpc/64s: support nospectre_v2 cmdline option
Date:   Wed, 27 Nov 2019 21:32:50 +0100
Message-Id: <20191127203001.996994315@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202845.651587549@linuxfoundation.org>
References: <20191127202845.651587549@linuxfoundation.org>
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
 
@@ -114,7 +114,7 @@ static __init int security_feature_debug
 device_initcall(security_feature_debugfs_init);
 #endif /* CONFIG_DEBUG_FS */
 
-#ifdef CONFIG_PPC_FSL_BOOK3E
+#if defined(CONFIG_PPC_FSL_BOOK3E) || defined(CONFIG_PPC_BOOK3S_64)
 static int __init handle_nospectre_v2(char *p)
 {
 	no_spectrev2 = true;
@@ -122,6 +122,9 @@ static int __init handle_nospectre_v2(ch
 	return 0;
 }
 early_param("nospectre_v2", handle_nospectre_v2);
+#endif /* CONFIG_PPC_FSL_BOOK3E || CONFIG_PPC_BOOK3S_64 */
+
+#ifdef CONFIG_PPC_FSL_BOOK3E
 void setup_spectre_v2(void)
 {
 	if (no_spectrev2 || cpu_mitigations_off())
@@ -399,7 +402,17 @@ static void toggle_count_cache_flush(boo
 
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


