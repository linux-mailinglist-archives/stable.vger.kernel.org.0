Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32A634F6992
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 21:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbiDFTKL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 15:10:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbiDFTJu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 15:09:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A604E29689F;
        Wed,  6 Apr 2022 11:28:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E9F661B89;
        Wed,  6 Apr 2022 18:28:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A997C385A1;
        Wed,  6 Apr 2022 18:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649269717;
        bh=Goa4g0zbim0vnm+bp9tRkQHl3Ukj/fLPgZH3yx7JRis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aY9rEclhdfGKOVE0tftOjd2sX7USGbu7+jRNAPuPeqAbIQc6ofGRFA089KrAzwsYB
         ks1TH2a0BXN/acW/kEmrzLNMvRlX5w/buCTU5owr3nelDFrHlOFZqeztvZJlQXAwp3
         pgMGiRq91eT5S3P5i7L/PLVGgaQiCm1deLszKnSo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 4.9 31/43] arm64: entry: Move trampoline macros out of ifdefd section
Date:   Wed,  6 Apr 2022 20:26:40 +0200
Message-Id: <20220406182437.585030542@linuxfoundation.org>
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
@@ -896,12 +896,7 @@ __ni_sys_trace:
 
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
 	sub	\tmp, \tmp, #SWAPPER_DIR_SIZE
@@ -980,6 +975,11 @@ __ni_sys_trace:
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


