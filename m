Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4B4E4D4ABA
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 15:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243724AbiCJOb5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:31:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343645AbiCJObI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:31:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1E479F6F3;
        Thu, 10 Mar 2022 06:27:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C50B2B825F3;
        Thu, 10 Mar 2022 14:27:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA9BFC340E8;
        Thu, 10 Mar 2022 14:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646922428;
        bh=LVgMR7x7f/QGb4kjXXLf2lRP8FRdGB7xZ81j3KSgT2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xQzDYlRL9qCIM5Nl/MA+riV+yz22xOamp9CYc2HroVpM5wBtpznE2G0Yd3MYGHD/0
         cWgnpTCDT15b8BLTS82P+ZJygllE/FnTuJmjushNy0v8af+6zi0d7XUgZbIyXFhylR
         x1uFYY8PY0nkJEFJrxxDd7ErpManWmvPRuMhQwYo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 5.4 15/33] ARM: use LOADADDR() to get load address of sections
Date:   Thu, 10 Mar 2022 15:19:16 +0100
Message-Id: <20220310140809.192322676@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140808.741682643@linuxfoundation.org>
References: <20220310140808.741682643@linuxfoundation.org>
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
 arch/arm/kernel/vmlinux.lds.h |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

--- a/arch/arm/kernel/vmlinux.lds.h
+++ b/arch/arm/kernel/vmlinux.lds.h
@@ -25,6 +25,11 @@
 #define ARM_MMU_DISCARD(x)	x
 #endif
 
+/* Set start/end symbol names to the LMA for the section */
+#define ARM_LMA(sym, section)						\
+	sym##_start = LOADADDR(section);				\
+	sym##_end = LOADADDR(section) + SIZEOF(section)
+
 #define PROC_INFO							\
 		. = ALIGN(4);						\
 		__proc_info_begin = .;					\
@@ -100,19 +105,19 @@
  * only thing that matters is their relative offsets
  */
 #define ARM_VECTORS							\
-	__vectors_start = .;						\
+	__vectors_lma = .;						\
 	.vectors 0xffff0000 : AT(__vectors_start) {			\
 		*(.vectors)						\
 	}								\
-	. = __vectors_start + SIZEOF(.vectors);				\
-	__vectors_end = .;						\
+	ARM_LMA(__vectors, .vectors);					\
+	. = __vectors_lma + SIZEOF(.vectors);				\
 									\
-	__stubs_start = .;						\
-	.stubs ADDR(.vectors) + 0x1000 : AT(__stubs_start) {		\
+	__stubs_lma = .;						\
+	.stubs ADDR(.vectors) + 0x1000 : AT(__stubs_lma) {		\
 		*(.stubs)						\
 	}								\
-	. = __stubs_start + SIZEOF(.stubs);				\
-	__stubs_end = .;						\
+	ARM_LMA(__stubs, .stubs);					\
+	. = __stubs_lma + SIZEOF(.stubs);				\
 									\
 	PROVIDE(vector_fiq_offset = vector_fiq - ADDR(.vectors));
 


