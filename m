Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 256A54D4A66
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 15:54:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243431AbiCJO1f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:27:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243588AbiCJO0j (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:26:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 433D655BE6;
        Thu, 10 Mar 2022 06:22:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E30261B33;
        Thu, 10 Mar 2022 14:22:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1718DC340E8;
        Thu, 10 Mar 2022 14:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646922144;
        bh=+KiLqnFc/JOlPhhx2sGptnR9bGJ54+ME3X2f13TPR5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fFbZ41aEUWsMG1NG/up1OK/GTCkff0Q8H/OdKZPMwtw3C75xGVzw1qsu8sNAO0BAC
         2WXOo8zPLm8Tfmh3iXEcDeX2/2a0JoKxh3PVbof4GmK0xytg03b2ItfmPpmaMdXoLA
         GqTf2RYSzVPQcd8ko0FWAqBJjQmGIlLQOnhaj96E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 20/33] ARM: fix co-processor register typo
Date:   Thu, 10 Mar 2022 15:18:47 +0100
Message-Id: <20220310140808.340304980@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140807.749164737@linuxfoundation.org>
References: <20220310140807.749164737@linuxfoundation.org>
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

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

commit 33970b031dc4653cc9dc80f2886976706c4c8ef1 upstream.

In the recent Spectre BHB patches, there was a typo that is only
exposed in certain configurations: mcr p15,0,XX,c7,r5,4 should have
been mcr p15,0,XX,c7,c5,4

Reported-by: kernel test robot <lkp@intel.com>
Fixes: b9baf5c8c5c3 ("ARM: Spectre-BHB workaround")
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/include/asm/assembler.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/include/asm/assembler.h
+++ b/arch/arm/include/asm/assembler.h
@@ -116,7 +116,7 @@
 	.endm
 
 	.macro	isb, args
-	mcr	p15, 0, r0, c7, r5, 4
+	mcr	p15, 0, r0, c7, c5, 4
 	.endm
 #endif
 


