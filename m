Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 345434DC605
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 13:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233729AbiCQMsP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 08:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233736AbiCQMsN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 08:48:13 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E98E21EDA1B;
        Thu, 17 Mar 2022 05:46:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4ACC1CE2331;
        Thu, 17 Mar 2022 12:46:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 647ADC340E9;
        Thu, 17 Mar 2022 12:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647521207;
        bh=xZN9NwYg0jpH9YWHF+IxdrhZLLyIkURN06b25Bjx/nk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j2AwM+kU7nE8KSk+x0yd90lC4cI0ma4eAu/DhGuYUtZ8jcue3AZHG9iUK8CICQOWM
         yuS+DyPjCLln73sMCNIs1YGJKsyakg/enBjl8h8lf2L54YTfAKHBx2282pM/swbua7
         UpV0MzPikQIYCbbiHLhNltAAerTUnS00EPN0Lc44=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 13/43] arm64: entry: Move trampoline macros out of ifdefd section
Date:   Thu, 17 Mar 2022 13:45:24 +0100
Message-Id: <20220317124528.045253339@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220317124527.672236844@linuxfoundation.org>
References: <20220317124527.672236844@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/entry.S | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 09c78d6781a7..a2ec7ef24402 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -1025,12 +1025,6 @@ ENDPROC(el0_svc)
 
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
@@ -1126,6 +1120,11 @@ alternative_else_nop_endif
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
-- 
2.34.1



