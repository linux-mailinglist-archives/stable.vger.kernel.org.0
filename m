Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A59204D4B1D
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 15:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244510AbiCJOd3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:33:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245076AbiCJOaG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:30:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE8AA160FE5;
        Thu, 10 Mar 2022 06:25:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7127761CF0;
        Thu, 10 Mar 2022 14:24:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EC78C340E8;
        Thu, 10 Mar 2022 14:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646922286;
        bh=wl6HBnhpwKS+JR4VuT7rhMipb3Fa6aCKKhyiO/sl5rg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ag0z5Jrx0YoPzdFOQhnYopl2t3PQMyhiJVnQYLbga+fNuf1T49mGV3/nNKXewRUUQ
         CpxrT7I0J2txEyQ8LdKiAQSwFM64FaFqZsfjTeHxxSJrjEbHWdz5rz1jqgYv0KeyVZ
         SyxJa76f+Wy2QSW3LWzP7GGPPrnVxLxiHfvbaReQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 5.10 30/58] arm64: entry: Move trampoline macros out of ifdefd section
Date:   Thu, 10 Mar 2022 15:18:50 +0100
Message-Id: <20220310140813.734626881@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140812.869208747@linuxfoundation.org>
References: <20220310140812.869208747@linuxfoundation.org>
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
@@ -778,12 +778,6 @@ SYM_CODE_END(ret_to_user)
 
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
@@ -879,6 +873,11 @@ alternative_else_nop_endif
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


