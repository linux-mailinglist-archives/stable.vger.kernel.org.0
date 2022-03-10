Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 807D84D490D
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 15:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243153AbiCJOQT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:16:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232870AbiCJOPU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:15:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B207912A92;
        Thu, 10 Mar 2022 06:12:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7AA4261BD1;
        Thu, 10 Mar 2022 14:12:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD04C340EB;
        Thu, 10 Mar 2022 14:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646921549;
        bh=iG4dGyVQTtgev5VOsQ8d1I4SvBWcNj19Mn9JiAy+Rwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U3LhPc4BxE461jzFRWLeY0xN+LlYXk7QKOOAiiWZy4tJr7Hp0rO4WOG+vEahZ+QQG
         ArNB0S75DmboI1rlC1RMq2zAQ8GBT+2JMKPj2sgJAIqfl+En5P1fZtJHMF0Px8V0lH
         jHmj/xVKbadeiINJjGfud3+rikdxtjpZhpisKDwU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 5.16 11/53] ARM: use LOADADDR() to get load address of sections
Date:   Thu, 10 Mar 2022 15:09:16 +0100
Message-Id: <20220310140812.159413437@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140811.832630727@linuxfoundation.org>
References: <20220310140811.832630727@linuxfoundation.org>
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
 arch/arm/include/asm/vmlinux.lds.h |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

--- a/arch/arm/include/asm/vmlinux.lds.h
+++ b/arch/arm/include/asm/vmlinux.lds.h
@@ -26,6 +26,11 @@
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
@@ -110,19 +115,19 @@
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
 


