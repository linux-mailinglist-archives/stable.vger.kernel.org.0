Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 421E34D3377
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 17:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234058AbiCIQMg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:12:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236098AbiCIQJg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:09:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E30712AD7;
        Wed,  9 Mar 2022 08:07:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 062DBB82220;
        Wed,  9 Mar 2022 16:07:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 443E9C340EF;
        Wed,  9 Mar 2022 16:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646842044;
        bh=KCX8P+H2W0agVF1iCpkDtDeNldgE0W8QeXXKrS24w74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tI52vrl0ifJF7wF5sHo1Bznb4PmghYHpTEG3Vt1cQvnhuUwhPb5MCi0CwEGV92F91
         3RuQKGj3TPvTJ/6RjFpKlgWd9+orrwuzNFUrYF/yzt9pIuT1DJZF6AJ+MflESIoZek
         6DN6yiFSaFxqIY0Hiz63ngSvTwaO81pYQYVQwDzQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 5.15 21/43] arm64: entry.S: Add ventry overflow sanity checks
Date:   Wed,  9 Mar 2022 17:00:05 +0100
Message-Id: <20220309155900.351257001@linuxfoundation.org>
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
@@ -37,6 +37,7 @@
 
 	.macro kernel_ventry, el:req, ht:req, regsize:req, label:req
 	.align 7
+.Lventry_start\@:
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
 	.if	\el == 0
 alternative_if ARM64_UNMAP_KERNEL_AT_EL0
@@ -95,6 +96,7 @@ alternative_else_nop_endif
 	mrs	x0, tpidrro_el0
 #endif
 	b	el\el\ht\()_\regsize\()_\label
+.org .Lventry_start\@ + 128	// Did we overflow the ventry slot?
 	.endm
 
 	.macro tramp_alias, dst, sym
@@ -662,6 +664,7 @@ alternative_else_nop_endif
 	add	x30, x30, #(1b - tramp_vectors)
 	isb
 	ret
+.org 1b + 128	// Did we overflow the ventry slot?
 	.endm
 
 	.macro tramp_exit, regsize = 64


