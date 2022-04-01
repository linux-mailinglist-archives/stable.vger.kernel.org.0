Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4BE4EE85B
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 08:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245572AbiDAGjS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 02:39:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245567AbiDAGix (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 02:38:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AA37262D42;
        Thu, 31 Mar 2022 23:37:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C16B1B823E7;
        Fri,  1 Apr 2022 06:37:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EF91C2BBE4;
        Fri,  1 Apr 2022 06:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648795020;
        bh=NHCYVgMKZyxPvn7xelmJphkre9IBISbvC3oACIVsBqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bAfpFhQ9wfNZCrscd4peTz9KktZ32LQQV030cxh1/BFuV+EqmGOorq5hatdyeWv09
         ofuuzkpT1kF+lg0+tBusOlIouJ0qqGFXQBAw3LB4n42WVZxZX94oEy497G9ENBBmEb
         5Y7L9Vqj0RzpEdiONDGPcBfzvaqkBWqNV38qeN60=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 4.14 15/27] arm64: entry: Move trampoline macros out of ifdefd section
Date:   Fri,  1 Apr 2022 08:36:25 +0200
Message-Id: <20220401063624.665094578@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220401063624.232282121@linuxfoundation.org>
References: <20220401063624.232282121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morse <james.morse@arm.com>

commit 13d7a08352a83ef2252aeb464a5e08dfc06b5dfd upstream.

The macros for building the kpti trampoline are all behind
CONFIG_UNMAP_KERNEL_AT_EL0, and in a region that outputs to the
.entry.tramp.text section.

Move the macros out so they can be used to generate other kinds of
trampoline. Only the symbols need to be guarded by
CONFIG_UNMAP_KERNEL_AT_EL0 and appear in the .entry.tramp.text section.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/entry.S |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -985,12 +985,7 @@ __ni_sys_trace:
 
 	.popsection				// .entry.text
 
-#ifdef CONFIG_UNMAP_KERNEL_AT_EL0
-/*
- * Exception vectors trampoline.
- */
-	.pushsection ".entry.tramp.text", "ax"
-
+	// Move from tramp_pg_dir to swapper_pg_dir
 	.macro tramp_map_kernel, tmp
 	mrs	\tmp, ttbr1_el1
 	sub	\tmp, \tmp, #(SWAPPER_DIR_SIZE + RESERVED_TTBR0_SIZE)
@@ -1081,6 +1076,11 @@ alternative_insn isb, nop, ARM64_WORKARO
 	.endr
 	.endm
 
+#ifdef CONFIG_UNMAP_KERNEL_AT_EL0
+/*
+ * Exception vectors trampoline.
+ */
+	.pushsection ".entry.tramp.text", "ax"
 	.align	11
 ENTRY(tramp_vectors)
 	generate_tramp_vector


