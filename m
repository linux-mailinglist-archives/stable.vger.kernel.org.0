Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCE74D336C
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 17:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234594AbiCIQKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:10:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235439AbiCIQIv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:08:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD18418E43C;
        Wed,  9 Mar 2022 08:05:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B07BB8221D;
        Wed,  9 Mar 2022 16:05:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93D00C340E8;
        Wed,  9 Mar 2022 16:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646841923;
        bh=KehoIr6yz70C9INH4cXgl326hlvCsnsKZSidzApz9l8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kKiUw4cPKYHs8p3lw7aOw1PJBRiD97qfRLCN4lYgdiYTKG9VL6FokUqhU4LuEigEQ
         INz8tSiyUB+jS7uzB1JTgpTFJCKifeGPvqVufUUrb/87hns6qiCjnIOIYVO2B3GXNQ
         wgVuLMY7lVZfXwk776DCMjlTb24SZ5MKn0iPVBNs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 5.10 23/43] arm64: entry.S: Add ventry overflow sanity checks
Date:   Wed,  9 Mar 2022 16:59:56 +0100
Message-Id: <20220309155859.914656586@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309155859.239810747@linuxfoundation.org>
References: <20220309155859.239810747@linuxfoundation.org>
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

commit 4330e2c5c04c27bebf89d34e0bc14e6943413067 upstream.

Subsequent patches add even more code to the ventry slots.
Ensure kernels that overflow a ventry slot don't get built.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/entry.S |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -62,6 +62,7 @@
 
 	.macro kernel_ventry, el, label, regsize = 64
 	.align 7
+.Lventry_start\@:
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
 	.if	\el == 0
 alternative_if ARM64_UNMAP_KERNEL_AT_EL0
@@ -120,6 +121,7 @@ alternative_else_nop_endif
 	mrs	x0, tpidrro_el0
 #endif
 	b	el\()\el\()_\label
+.org .Lventry_start\@ + 128	// Did we overflow the ventry slot?
 	.endm
 
 	.macro tramp_alias, dst, sym
@@ -832,6 +834,7 @@ alternative_else_nop_endif
 	add	x30, x30, #(1b - tramp_vectors)
 	isb
 	ret
+.org 1b + 128	// Did we overflow the ventry slot?
 	.endm
 
 	.macro tramp_exit, regsize = 64


