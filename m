Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 724D74EE881
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 08:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242890AbiDAGk6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 02:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245625AbiDAGkj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 02:40:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 307D0265EA2;
        Thu, 31 Mar 2022 23:37:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC4DD61166;
        Fri,  1 Apr 2022 06:37:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC0BC340EE;
        Fri,  1 Apr 2022 06:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648795062;
        bh=414OsYhcHiLq33cLt18rvojc+oh3UKjWGtO30u65hwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c5eFM82/FuxmKz0hrLP1cUJP+2pIjw7Ai42D7aT6eTix3Nr3gTm7iZwBWzoa5OCur
         yRxcJWLuI/D56f3y7y+cDTkR20fwoytT55EU5uSRjKc0W1j5CVmAHx95n6u+6v/PJd
         cSrBiax1syMNccf6AQXhOhNhav8NwBKIo1e0+zJg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 4.14 09/27] arm64: entry.S: Add ventry overflow sanity checks
Date:   Fri,  1 Apr 2022 08:36:19 +0200
Message-Id: <20220401063624.498215631@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220401063624.232282121@linuxfoundation.org>
References: <20220401063624.232282121@linuxfoundation.org>
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
@@ -74,6 +74,7 @@
 
 	.macro kernel_ventry, el, label, regsize = 64
 	.align 7
+.Lventry_start\@:
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
 alternative_if ARM64_UNMAP_KERNEL_AT_EL0
 	.if	\el == 0
@@ -131,6 +132,7 @@ alternative_else_nop_endif
 	mrs	x0, tpidrro_el0
 #endif
 	b	el\()\el\()_\label
+.org .Lventry_start\@ + 128	// Did we overflow the ventry slot?
 	.endm
 
 	.macro tramp_alias, dst, sym
@@ -1036,6 +1038,7 @@ alternative_insn isb, nop, ARM64_WORKARO
 	add	x30, x30, #(1b - tramp_vectors)
 	isb
 	ret
+.org 1b + 128	// Did we overflow the ventry slot?
 	.endm
 
 	.macro tramp_exit, regsize = 64


