Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B26194D48FA
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 15:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243124AbiCJOPS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:15:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243073AbiCJOO6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:14:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5421EF94F5;
        Thu, 10 Mar 2022 06:12:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 024EAB82670;
        Thu, 10 Mar 2022 14:12:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D200C340E8;
        Thu, 10 Mar 2022 14:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646921519;
        bh=X16joH9fZDCYNrDYqgmCgmFINl4xn8rfr8maBQfJ+UE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nF9743N8t3xZhKf9AFnrQH8bYVJ0Ahn+eiliWP+nK76M+BgwPf1YNAw19d7SFUwkJ
         lvhUz+fM/YoEQKvH+z4bztX9nu29kAnYuGhkckXUmCdW6kNlrf+nmYMRPC/yw4J2GI
         kXL3HEGrg9bzy153jd/ikhhHDV61KfpZVnwt/IoU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.16 38/53] ARM: fix co-processor register typo
Date:   Thu, 10 Mar 2022 15:09:43 +0100
Message-Id: <20220310140812.928309923@linuxfoundation.org>
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
@@ -113,7 +113,7 @@
 	.endm
 
 	.macro	isb, args
-	mcr	p15, 0, r0, c7, r5, 4
+	mcr	p15, 0, r0, c7, c5, 4
 	.endm
 #endif
 


