Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2302D4DC653
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 13:50:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233868AbiCQMvL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 08:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233875AbiCQMus (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 08:50:48 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA96B1F1268;
        Thu, 17 Mar 2022 05:48:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B529ACE2340;
        Thu, 17 Mar 2022 12:48:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9871C340EF;
        Thu, 17 Mar 2022 12:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647521325;
        bh=Je/pA2Sy+kXVvNl4bpYDV7LbuIOUj5G9SKzbyZ809nI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oZUILlLUEYTGycSWsbkWPvqA4m+x9J/z7yIgsrgAQ/wdOydZSMmPapYxtBvSgSesL
         MdY0a4gUsDk90xp0dfusEO5ADlnkpoMEtCt2vJRuCNNGBXmNik4TbrvGxvuLT3ugKF
         EZTw4vmzFrtjaQslPDleBpMTh4oWV5CAXXYFilWA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 07/43] arm64: entry.S: Add ventry overflow sanity checks
Date:   Thu, 17 Mar 2022 13:45:18 +0100
Message-Id: <20220317124527.880404363@linuxfoundation.org>
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

commit 4330e2c5c04c27bebf89d34e0bc14e6943413067 upstream.

Subsequent patches add even more code to the ventry slots.
Ensure kernels that overflow a ventry slot don't get built.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/entry.S | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index db137746c6fa..98991aa9d0b1 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -59,6 +59,7 @@
 
 	.macro kernel_ventry, el, label, regsize = 64
 	.align 7
+.Lventry_start\@:
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
 alternative_if ARM64_UNMAP_KERNEL_AT_EL0
 	.if	\el == 0
@@ -116,6 +117,7 @@ alternative_else_nop_endif
 	mrs	x0, tpidrro_el0
 #endif
 	b	el\()\el\()_\label
+.org .Lventry_start\@ + 128	// Did we overflow the ventry slot?
 	.endm
 
 	.macro tramp_alias, dst, sym
@@ -1080,6 +1082,7 @@ alternative_else_nop_endif
 	add	x30, x30, #(1b - tramp_vectors)
 	isb
 	ret
+.org 1b + 128	// Did we overflow the ventry slot?
 	.endm
 
 	.macro tramp_exit, regsize = 64
-- 
2.34.1



