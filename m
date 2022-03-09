Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C76AD4D3335
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 17:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234819AbiCIQMZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:12:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236195AbiCIQJl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:09:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C56AFB6D27;
        Wed,  9 Mar 2022 08:08:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 610E561644;
        Wed,  9 Mar 2022 16:08:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E9E1C340E8;
        Wed,  9 Mar 2022 16:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646842086;
        bh=BQM6yHpMDK0Tpuk2e3Gr783l4lRRVOUjiG3mBdAMFjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l1a1RY+a16Wo1yK915I/4EWlhJIpz482WFiUMC/uVVEf4IALuEhlNEUhGXtDh+msQ
         BuRWn/Y1LiHoUlIe/xIaFz6YoX586VoidR9EJU3HNDWnnXolEstEFBGISxF51iURbt
         /5C77FI380KkBAOT+xQbtTwstKYWaEUzpzDymqVA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 5.15 29/43] arm64: entry: Move trampoline macros out of ifdefd section
Date:   Wed,  9 Mar 2022 17:00:13 +0100
Message-Id: <20220309155900.579232688@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309155859.734715884@linuxfoundation.org>
References: <20220309155859.734715884@linuxfoundation.org>
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
 arch/arm64/kernel/entry.S |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -608,12 +608,6 @@ SYM_CODE_END(ret_to_user)
 
 	.popsection				// .entry.text
 
-#ifdef CONFIG_UNMAP_KERNEL_AT_EL0
-/*
- * Exception vectors trampoline.
- */
-	.pushsection ".entry.tramp.text", "ax"
-
 	// Move from tramp_pg_dir to swapper_pg_dir
 	.macro tramp_map_kernel, tmp
 	mrs	\tmp, ttbr1_el1
@@ -709,6 +703,11 @@ alternative_else_nop_endif
 	.endr
 	.endm
 
+#ifdef CONFIG_UNMAP_KERNEL_AT_EL0
+/*
+ * Exception vectors trampoline.
+ */
+	.pushsection ".entry.tramp.text", "ax"
 	.align	11
 SYM_CODE_START_NOALIGN(tramp_vectors)
 	generate_tramp_vector


