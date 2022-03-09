Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2CFE4D3282
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 17:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234178AbiCIQCk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:02:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234130AbiCIQCd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:02:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1F7C17F68A;
        Wed,  9 Mar 2022 08:01:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D08661674;
        Wed,  9 Mar 2022 16:01:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57784C340E8;
        Wed,  9 Mar 2022 16:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646841686;
        bh=a/dB2UmD78+I6BqAfk2Y/X4e14BkMc2n+CsySWaMTLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fto8OmoYXWSPy1UzZoTtzJD2Zagsmy/2KjK2eXQQ3vb4iDjo1vFqz+ntDvdikW/20
         GEOzvbmlRC3kgzHgF3or9SyFB7CbjpDSh2IO3SJXmzrJtX/JI/NSBgJ5emPJxI4tnC
         1Bfv0CrHAROmw+GA643Yne29+IXXc2SSBLN/iHKc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 4.9 21/24] ARM: use LOADADDR() to get load address of sections
Date:   Wed,  9 Mar 2022 16:59:34 +0100
Message-Id: <20220309155856.924148773@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309155856.295480966@linuxfoundation.org>
References: <20220309155856.295480966@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>

commit 8d9d651ff2270a632e9dc497b142db31e8911315 upstream.

Use the linker's LOADADDR() macro to get the load address of the
sections, and provide a macro to set the start and end symbols.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/kernel/vmlinux-xip.lds.S |   19 ++++++++++++-------
 arch/arm/kernel/vmlinux.lds.S     |   19 ++++++++++++-------
 2 files changed, 24 insertions(+), 14 deletions(-)

--- a/arch/arm/kernel/vmlinux-xip.lds.S
+++ b/arch/arm/kernel/vmlinux-xip.lds.S
@@ -12,6 +12,11 @@
 #include <asm/memory.h>
 #include <asm/page.h>
 
+/* Set start/end symbol names to the LMA for the section */
+#define ARM_LMA(sym, section)						\
+	sym##_start = LOADADDR(section);				\
+	sym##_end = LOADADDR(section) + SIZEOF(section)
+
 #define PROC_INFO							\
 	. = ALIGN(4);							\
 	VMLINUX_SYMBOL(__proc_info_begin) = .;				\
@@ -148,19 +153,19 @@ SECTIONS
 	 * The vectors and stubs are relocatable code, and the
 	 * only thing that matters is their relative offsets
 	 */
-	__vectors_start = .;
+	__vectors_lma = .;
 	.vectors 0xffff0000 : AT(__vectors_start) {
 		*(.vectors)
 	}
-	. = __vectors_start + SIZEOF(.vectors);
-	__vectors_end = .;
+	ARM_LMA(__vectors, .vectors);
+	. = __vectors_lma + SIZEOF(.vectors);
 
-	__stubs_start = .;
-	.stubs ADDR(.vectors) + 0x1000 : AT(__stubs_start) {
+	__stubs_lma = .;
+	.stubs ADDR(.vectors) + 0x1000 : AT(__stubs_lma) {
 		*(.stubs)
 	}
-	. = __stubs_start + SIZEOF(.stubs);
-	__stubs_end = .;
+	ARM_LMA(__stubs, .stubs);
+	. = __stubs_lma + SIZEOF(.stubs);
 
 	PROVIDE(vector_fiq_offset = vector_fiq - ADDR(.vectors));
 
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -14,6 +14,11 @@
 #include <asm/page.h>
 #include <asm/pgtable.h>
 
+/* Set start/end symbol names to the LMA for the section */
+#define ARM_LMA(sym, section)						\
+	sym##_start = LOADADDR(section);				\
+	sym##_end = LOADADDR(section) + SIZEOF(section)
+
 #define PROC_INFO							\
 	. = ALIGN(4);							\
 	VMLINUX_SYMBOL(__proc_info_begin) = .;				\
@@ -169,19 +174,19 @@ SECTIONS
 	 * The vectors and stubs are relocatable code, and the
 	 * only thing that matters is their relative offsets
 	 */
-	__vectors_start = .;
+	__vectors_lma = .;
 	.vectors 0xffff0000 : AT(__vectors_start) {
 		*(.vectors)
 	}
-	. = __vectors_start + SIZEOF(.vectors);
-	__vectors_end = .;
+	ARM_LMA(__vectors, .vectors);
+	. = __vectors_lma + SIZEOF(.vectors);
 
-	__stubs_start = .;
-	.stubs ADDR(.vectors) + 0x1000 : AT(__stubs_start) {
+	__stubs_lma = .;
+	.stubs ADDR(.vectors) + 0x1000 : AT(__stubs_lma) {
 		*(.stubs)
 	}
-	. = __stubs_start + SIZEOF(.stubs);
-	__stubs_end = .;
+	ARM_LMA(__stubs, .stubs);
+	. = __stubs_lma + SIZEOF(.stubs);
 
 	PROVIDE(vector_fiq_offset = vector_fiq - ADDR(.vectors));
 


