Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26C0E4F6999
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 21:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbiDFTLp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 15:11:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbiDFTLH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 15:11:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35C93282B33;
        Wed,  6 Apr 2022 11:28:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0E26B8253A;
        Wed,  6 Apr 2022 18:28:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3951CC385A3;
        Wed,  6 Apr 2022 18:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649269695;
        bh=F8uuznHn4+qQNfOl3xbyGgObdn518zMlTYxyggh8fRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z56bzeEkRWaXBFV2hL1gwvMSRRu7dNWBVOitZ1Ts8WRaK/Dg8HYiv3Ey5Spy4PVIp
         WMiKsRFgdsit2OjJqhWQWaxZhSZAKv8e7rtDoRp69PfxBnqouZXAQX6fV8BrhMQoXZ
         culIepix6twfOTl9zgGjndefy0adx1sg8jjbP+FI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 4.9 29/43] arm64: entry: Allow tramp_alias to access symbols after the 4K boundary
Date:   Wed,  6 Apr 2022 20:26:38 +0200
Message-Id: <20220406182437.527213548@linuxfoundation.org>
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

commit 6c5bf79b69f911560fbf82214c0971af6e58e682 upstream.

Systems using kpti enter and exit the kernel through a trampoline mapping
that is always mapped, even when the kernel is not. tramp_valias is a macro
to find the address of a symbol in the trampoline mapping.

Adding extra sets of vectors will expand the size of the entry.tramp.text
section to beyond 4K. tramp_valias will be unable to generate addresses
for symbols beyond 4K as it uses the 12 bit immediate of the add
instruction.

As there are now two registers available when tramp_alias is called,
use the extra register to avoid the 4K limit of the 12 bit immediate.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
[ Removed SDEI for backport ]
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/entry.S |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -97,9 +97,12 @@
 .org .Lventry_start\@ + 128	// Did we overflow the ventry slot?
 	.endm
 
-	.macro tramp_alias, dst, sym
+	.macro tramp_alias, dst, sym, tmp
 	mov_q	\dst, TRAMP_VALIAS
-	add	\dst, \dst, #(\sym - .entry.tramp.text)
+	adr_l	\tmp, \sym
+	add	\dst, \dst, \tmp
+	adr_l	\tmp, .entry.tramp.text
+	sub	\dst, \dst, \tmp
 	.endm
 
 	// This macro corrupts x0-x3. It is the caller's duty
@@ -254,10 +257,10 @@ alternative_else_nop_endif
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
 	bne	4f
 	msr	far_el1, x29
-	tramp_alias	x30, tramp_exit_native
+	tramp_alias	x30, tramp_exit_native, x29
 	br	x30
 4:
-	tramp_alias	x30, tramp_exit_compat
+	tramp_alias	x30, tramp_exit_compat, x29
 	br	x30
 #endif
 	.else


