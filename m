Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99EEB60FE0B
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236842AbiJ0RBm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:01:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236807AbiJ0RBk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:01:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D9F31911D5;
        Thu, 27 Oct 2022 10:01:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A799BB82716;
        Thu, 27 Oct 2022 17:01:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F414EC433C1;
        Thu, 27 Oct 2022 17:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890093;
        bh=9Ab+7kjacFVu0GE7LCnthBKvDfAV+vHoprFlEc2CDkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xu9Kdzr45EmB0MYUCfUYep9a0KhIcmZLvGrqHjmCJuakXgwT0En0Myj4J7w+mhb00
         4oSggMrjUhC62hVeWNfjfP5PNgNGObWcwd4Bihj+Lo2dXyxF5Z8D10dg7lJDc7V4Ye
         o0pBySKZu7dhehWLfgKi+8shxS+6qDTIezVfpgCk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Evgenii Stepanov <eugenis@google.com>
Subject: [PATCH 5.15 02/79] arm64/mm: Consolidate TCR_EL1 fields
Date:   Thu, 27 Oct 2022 18:55:00 +0200
Message-Id: <20221027165055.004242716@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.917467648@linuxfoundation.org>
References: <20221027165054.917467648@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anshuman Khandual <anshuman.khandual@arm.com>

commit e921da6bc7cac5f0e8458fe5df18ae08eb538f54 upstream.

This renames and moves SYS_TCR_EL1_TCMA1 and SYS_TCR_EL1_TCMA0 definitions
into pgtable-hwdef.h thus consolidating all TCR fields in a single header.
This does not cause any functional change.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Link: https://lore.kernel.org/r/1643121513-21854-1-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Cc: Evgenii Stepanov <eugenis@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/pgtable-hwdef.h |    2 ++
 arch/arm64/include/asm/sysreg.h        |    4 ----
 arch/arm64/mm/proc.S                   |    2 +-
 3 files changed, 3 insertions(+), 5 deletions(-)

--- a/arch/arm64/include/asm/pgtable-hwdef.h
+++ b/arch/arm64/include/asm/pgtable-hwdef.h
@@ -273,6 +273,8 @@
 #define TCR_NFD1		(UL(1) << 54)
 #define TCR_E0PD0		(UL(1) << 55)
 #define TCR_E0PD1		(UL(1) << 56)
+#define TCR_TCMA0		(UL(1) << 57)
+#define TCR_TCMA1		(UL(1) << 58)
 
 /*
  * TTBR.
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -1094,10 +1094,6 @@
 #define CPACR_EL1_ZEN_EL0EN	(BIT(17)) /* enable EL0 access, if EL1EN set */
 #define CPACR_EL1_ZEN		(CPACR_EL1_ZEN_EL1EN | CPACR_EL1_ZEN_EL0EN)
 
-/* TCR EL1 Bit Definitions */
-#define SYS_TCR_EL1_TCMA1	(BIT(58))
-#define SYS_TCR_EL1_TCMA0	(BIT(57))
-
 /* GCR_EL1 Definitions */
 #define SYS_GCR_EL1_RRND	(BIT(16))
 #define SYS_GCR_EL1_EXCL_MASK	0xffffUL
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -46,7 +46,7 @@
 #endif
 
 #ifdef CONFIG_KASAN_HW_TAGS
-#define TCR_MTE_FLAGS SYS_TCR_EL1_TCMA1 | TCR_TBI1 | TCR_TBID1
+#define TCR_MTE_FLAGS TCR_TCMA1 | TCR_TBI1 | TCR_TBID1
 #else
 /*
  * The mte_zero_clear_page_tags() implementation uses DC GZVA, which relies on


