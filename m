Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 539B74D3331
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 17:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234926AbiCIQMu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:12:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234587AbiCIQLY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:11:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 820D4142359;
        Wed,  9 Mar 2022 08:09:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1AE42617C2;
        Wed,  9 Mar 2022 16:09:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE22C340E8;
        Wed,  9 Mar 2022 16:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646842165;
        bh=Mml45n5zWOY5XUlvrM0ABUbDBgc/vQ9ckQ54OR4R62A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JbCRhhEWnofBDWr51pltrPEdqmE5/5oU/gBjB8Ll/GIXSjvQHpd05l2bk3gSIgKFp
         06iuEvNhIdSIbuW4SA8w4Ziv5iJS430fb3iiAvs9bPjZNlJsZftSDo29lGoGbYtVd2
         F+3jlVXOqp0981JQ/MRu0zdBLlKzs8pxXfps/fmA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 5.16 20/37] arm64: entry: Make the trampoline cleanup optional
Date:   Wed,  9 Mar 2022 17:00:21 +0100
Message-Id: <20220309155859.674639567@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309155859.086952723@linuxfoundation.org>
References: <20220309155859.086952723@linuxfoundation.org>
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

commit d739da1694a0eaef0358a42b76904b611539b77b upstream.

Subsequent patches will add additional sets of vectors that use
the same tricks as the kpti vectors to reach the full-fat vectors.
The full-fat vectors contain some cleanup for kpti that is patched
in by alternatives when kpti is in use. Once there are additional
vectors, the cleanup will be needed in more cases.

But on big/little systems, the cleanup would be harmful if no
trampoline vector were in use. Instead of forcing CPUs that don't
need a trampoline vector to use one, make the trampoline cleanup
optional.

Entry at the top of the vectors will skip the cleanup. The trampoline
vectors can then skip the first instruction, triggering the cleanup
to run.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/entry.S |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -40,14 +40,18 @@
 .Lventry_start\@:
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
 	.if	\el == 0
-alternative_if ARM64_UNMAP_KERNEL_AT_EL0
+	/*
+	 * This must be the first instruction of the EL0 vector entries. It is
+	 * skipped by the trampoline vectors, to trigger the cleanup.
+	 */
+	b	.Lskip_tramp_vectors_cleanup\@
 	.if	\regsize == 64
 	mrs	x30, tpidrro_el0
 	msr	tpidrro_el0, xzr
 	.else
 	mov	x30, xzr
 	.endif
-alternative_else_nop_endif
+.Lskip_tramp_vectors_cleanup\@:
 	.endif
 #endif
 
@@ -661,7 +665,7 @@ alternative_if_not ARM64_WORKAROUND_CAVI
 	prfm	plil1strm, [x30, #(1b - tramp_vectors)]
 alternative_else_nop_endif
 	msr	vbar_el1, x30
-	add	x30, x30, #(1b - tramp_vectors)
+	add	x30, x30, #(1b - tramp_vectors + 4)
 	isb
 	ret
 .org 1b + 128	// Did we overflow the ventry slot?


