Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB114D32EE
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 17:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234640AbiCIQKy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:10:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235551AbiCIQI4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:08:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1ECB18F207;
        Wed,  9 Mar 2022 08:06:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8DD5B82233;
        Wed,  9 Mar 2022 16:05:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AE34C340E8;
        Wed,  9 Mar 2022 16:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646841928;
        bh=PD8YDBuRBOII3aVAAcFtCX2cx+HFLHuZPpAQYmq1x+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2nt/fPF5e59d0hRaTvS8SgQHc4D+zYsEl1/+4Hx9S64mcHiuae3e00ZV040A4qE/9
         tq/wSs8XhJcaGSXYR7tNEduJyexziGUJ1JUp6nRLeZIJFuVGG0qjjekjDPXGclj/u5
         Tc4PVBDWMXzUYRpfok40G680uxzCy/af8fAFHHXY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 5.10 25/43] arm64: entry: Make the trampoline cleanup optional
Date:   Wed,  9 Mar 2022 16:59:58 +0100
Message-Id: <20220309155859.970545507@linuxfoundation.org>
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
@@ -65,14 +65,18 @@
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
 
@@ -831,7 +835,7 @@ alternative_if_not ARM64_WORKAROUND_CAVI
 	prfm	plil1strm, [x30, #(1b - tramp_vectors)]
 alternative_else_nop_endif
 	msr	vbar_el1, x30
-	add	x30, x30, #(1b - tramp_vectors)
+	add	x30, x30, #(1b - tramp_vectors + 4)
 	isb
 	ret
 .org 1b + 128	// Did we overflow the ventry slot?


