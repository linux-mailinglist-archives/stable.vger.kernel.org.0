Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8656B3FA8
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 13:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbjCJMuk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 07:50:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCJMuj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 07:50:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86811F6008;
        Fri, 10 Mar 2023 04:50:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24FF461564;
        Fri, 10 Mar 2023 12:50:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6ECEC433A0;
        Fri, 10 Mar 2023 12:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678452637;
        bh=BqKhyq61XLwE5zjXHgnp77pAKVfvsJyOg3BEBwYYKxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=amlGisrBByhHrXBn8pVJVwrdDZkhK5wNLSB7fzsPwKi9VAjTRFeruuAb96JhcK1xt
         H5zAQtT8VQb2ryy4X5JRI1usJP+50PUz6v6ZzUWmuiJz+EW+PM20+Ug3jSOxzicahS
         WZ/O6D/NFNkFfoB8788oaNVWaPGOAzJ7TkBnIn16tRVJZ/rM/pvBMnzI+nhxSD+5dY
         jwQtUqJEYxrDdXMskG4F4D5ahFNOVnC9eGjya8bgq2Ba2yQEauLWhhhVs7lFw5R7gv
         pqvt3tY2ifWA5zIbF+oHoSaDD0iUPWiVpZ+WqAfrDJli9N+ibqVQ5u7edxrdPIJcl3
         X+sV2cDeF/eIA==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-efi@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Peter Jones <pjones@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kees Cook <keescook@chromium.org>, stable@vger.kernel.org
Subject: [PATCH 3/3] arm64: efi: Set NX compat flag in PE/COFF header
Date:   Fri, 10 Mar 2023 13:50:26 +0100
Message-Id: <20230310125026.3390928-4-ardb@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310125026.3390928-1-ardb@kernel.org>
References: <20230310125026.3390928-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1551; i=ardb@kernel.org; h=from:subject; bh=BqKhyq61XLwE5zjXHgnp77pAKVfvsJyOg3BEBwYYKxs=; b=owGbwMvMwCFmkMcZplerG8N4Wi2JIYVbfeKfc9H9FbbW/f4d58wbDv5k/lnixXqAyz8tlk3a9 PPaAOWOUhYGMQ4GWTFFFoHZf9/tPD1RqtZ5lizMHFYmkCEMXJwCMJGdNxn+l2RP+Np1rzGuv+L5 Mq4n4n/VucVLji8VXqenqHRmt2qtPyNDw9Sg+iNNKpHuiZNKRaYyX9jtPa2wWnzLsbeP/25Vm/C XHwA=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 arch/arm64/kernel/efi-header.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/efi-header.S b/arch/arm64/kernel/efi-header.S
index 28d8a5dca5f12978..d731b4655df8eb27 100644
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
-- 
2.39.2

