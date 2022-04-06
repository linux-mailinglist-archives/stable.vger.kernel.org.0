Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFA2B4F69CE
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 21:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbiDFT27 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 15:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231781AbiDFT2E (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 15:28:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58EC229DDE4;
        Wed,  6 Apr 2022 11:28:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA15361B89;
        Wed,  6 Apr 2022 18:28:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00448C385A3;
        Wed,  6 Apr 2022 18:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649269737;
        bh=q3zfy1D/zTvBXz8x60TgszD+hJxiyQnrn5eE5C3kSBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QX2j7v/saI7MwjmgFY0k0DEak4+oWYctEPYwNbzB3GYJzPmY6M5HnOs7RaiTXtm6v
         dsIwBYftQSFcV1IO+IWlhY3cZryk6fIvv748VRmhQoqUNKLPYJBk9XOyJiAUpOptgo
         HUQ+DxZdxLv+reBzKFxl2LRv63DWg27148zcDY18=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 4.9 28/43] arm64: entry: Move the trampoline data page before the text page
Date:   Wed,  6 Apr 2022 20:26:37 +0200
Message-Id: <20220406182437.498299417@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220406182436.675069715@linuxfoundation.org>
References: <20220406182436.675069715@linuxfoundation.org>
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

commit c091fb6ae059cda563b2a4d93fdbc548ef34e1d6 upstream.

The trampoline code has a data page that holds the address of the vectors,
which is unmapped when running in user-space. This ensures that with
CONFIG_RANDOMIZE_BASE, the randomised address of the kernel can't be
discovered until after the kernel has been mapped.

If the trampoline text page is extended to include multiple sets of
vectors, it will be larger than a single page, making it tricky to
find the data page without knowing the size of the trampoline text
pages, which will vary with PAGE_SIZE.

Move the data page to appear before the text page. This allows the
data page to be found without knowing the size of the trampoline text
pages. 'tramp_vectors' is used to refer to the beginning of the
.entry.tramp.text section, do that explicitly.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
[ removed SDEI for backport ]
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/fixmap.h |    2 +-
 arch/arm64/kernel/entry.S       |    7 ++++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

--- a/arch/arm64/include/asm/fixmap.h
+++ b/arch/arm64/include/asm/fixmap.h
@@ -53,8 +53,8 @@ enum fixed_addresses {
 	FIX_TEXT_POKE0,
 
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
-	FIX_ENTRY_TRAMP_DATA,
 	FIX_ENTRY_TRAMP_TEXT,
+	FIX_ENTRY_TRAMP_DATA,
 #define TRAMP_VALIAS		(__fix_to_virt(FIX_ENTRY_TRAMP_TEXT))
 #endif /* CONFIG_UNMAP_KERNEL_AT_EL0 */
 	__end_of_permanent_fixed_addresses,
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -918,6 +918,11 @@ __ni_sys_trace:
 	 */
 	.endm
 
+	.macro tramp_data_page	dst
+	adr	\dst, .entry.tramp.text
+	sub	\dst, \dst, PAGE_SIZE
+	.endm
+
 	.macro tramp_ventry, regsize = 64
 	.align	7
 1:
@@ -934,7 +939,7 @@ __ni_sys_trace:
 2:
 	tramp_map_kernel	x30
 #ifdef CONFIG_RANDOMIZE_BASE
-	adr	x30, tramp_vectors + PAGE_SIZE
+	tramp_data_page		x30
 	isb
 	ldr	x30, [x30]
 #else


