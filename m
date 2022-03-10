Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 968FC4D4C19
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 16:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244772AbiCJOd6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:33:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343918AbiCJOb3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:31:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CFADD21C2;
        Thu, 10 Mar 2022 06:28:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28F5561C0A;
        Thu, 10 Mar 2022 14:28:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B754C340F3;
        Thu, 10 Mar 2022 14:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646922497;
        bh=X16joH9fZDCYNrDYqgmCgmFINl4xn8rfr8maBQfJ+UE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UJdnXMUpxhgL8BSoMl0xAf16MLCv9w3mTl6O0mGBhaw2QP8vutIeuI1eQt95afHT1
         7sJ8ASn5/4JrV5aDya251iomziDgLntyFoJQYsO7ko7YbUnClkgt07cgrAqapuHqWE
         RqDH8MzDtbmGdj2nk/2OlOb8BGJtOE2P7K4vOyDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 19/33] ARM: fix co-processor register typo
Date:   Thu, 10 Mar 2022 15:19:20 +0100
Message-Id: <20220310140809.307197938@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140808.741682643@linuxfoundation.org>
References: <20220310140808.741682643@linuxfoundation.org>
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
 


