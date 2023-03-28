Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D28266CC34E
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233331AbjC1OxA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:53:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233354AbjC1Own (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:52:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13A61DBF6
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:52:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22873B81BBF
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:52:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB7EC433EF;
        Tue, 28 Mar 2023 14:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015151;
        bh=s3bRgndL89e/1bOnmRYGS/2HTbSB7Igb/vaP0Vnr+ec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z0twptOEheYlhwekAKi8NaOPtYx9oQpe2BHmimDFoyIARDwdLDRfi50+jXcMDrMVN
         geBydIcFon4d9Su3M+48B/H0JnzOy/mSqpTP+bgBVTq/D0/npEKTS4EnnyOHXIetLM
         wgQ2R8kN6D6NuGSOIZkOxi1tAt72byjk+GwSXlHU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.2 184/240] arm64: efi: Set NX compat flag in PE/COFF header
Date:   Tue, 28 Mar 2023 16:42:27 +0200
Message-Id: <20230328142627.301399999@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit 3c66bb1918c262dd52fb4221a8d372619c5da70a upstream.

The PE/COFF header has a NX compat flag which informs the firmware that
the application does not rely on memory regions being mapped with both
executable and writable permissions at the same time.

This is typically used by the firmware to decide whether it can set the
NX attribute on all allocations it returns, but going forward, it may be
used to enforce a policy that only permits applications with the NX flag
set to be loaded to begin wiht in some configurations, e.g., when Secure
Boot is in effect.

Even though the arm64 version of the EFI stub may relocate the kernel
before executing it, it always did so after disabling the MMU, and so we
were always in line with what the NX compat flag conveys, we just never
bothered to set it.

So let's set the flag now.

Cc: <stable@vger.kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/efi-header.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/kernel/efi-header.S
+++ b/arch/arm64/kernel/efi-header.S
@@ -66,7 +66,7 @@
 	.long	.Lefi_header_end - .L_head		// SizeOfHeaders
 	.long	0					// CheckSum
 	.short	IMAGE_SUBSYSTEM_EFI_APPLICATION		// Subsystem
-	.short	0					// DllCharacteristics
+	.short	IMAGE_DLL_CHARACTERISTICS_NX_COMPAT	// DllCharacteristics
 	.quad	0					// SizeOfStackReserve
 	.quad	0					// SizeOfStackCommit
 	.quad	0					// SizeOfHeapReserve


