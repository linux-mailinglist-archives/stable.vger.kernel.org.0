Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46C623785B4
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235536AbhEJLBP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:01:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:52794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234552AbhEJK4j (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:56:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D111C6199E;
        Mon, 10 May 2021 10:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643621;
        bh=8tgUsdn4HF1BGHa0LfXohhQMOdZ30Xjhil89P8jwuBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uElQqKsICw3+UO3+famINSZKY1ef/ErrkQeePpXJ5U1kcF2qweuSIUX8VJu0UmHlC
         dtlsBW8FsaFuymcyg1Qb+8V/hWVSc9ZYr/bIANF4ElTKEHVMWAFX2Ow4ELd6+eIT4l
         I29mZbRI1Q1QDcipn/V3X5Zc4l/doJhreFtEvH80=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Borislav Petkov <bp@suse.de>, Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 088/342] efi/libstub: Add $(CLANG_FLAGS) to x86 flags
Date:   Mon, 10 May 2021 12:17:58 +0200
Message-Id: <20210510102013.020823374@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 58d746c119dfa28e72fc35aacaf3d2a3ac625cd0 ]

When cross compiling x86 on an ARM machine with clang, there are several
errors along the lines of:

  arch/x86/include/asm/page_64.h:52:7: error: invalid output constraint '=D' in asm

This happens because the x86 flags in the EFI stub are not derived from
KBUILD_CFLAGS like the other architectures are and the clang flags that
set the target architecture ('--target=') and the path to the GNU cross
tools ('--prefix=') are not present, meaning that the host architecture
is targeted.

These flags are available as $(CLANG_FLAGS) from the main Makefile so
add them to the cflags for x86 so that cross compiling works as expected.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://lkml.kernel.org/r/20210326000435.4785-4-nathan@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/libstub/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index 8a94388e38b3..a2ae9c3b9579 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -13,7 +13,8 @@ cflags-$(CONFIG_X86)		+= -m$(BITS) -D__KERNEL__ \
 				   -Wno-pointer-sign \
 				   $(call cc-disable-warning, address-of-packed-member) \
 				   $(call cc-disable-warning, gnu) \
-				   -fno-asynchronous-unwind-tables
+				   -fno-asynchronous-unwind-tables \
+				   $(CLANG_FLAGS)
 
 # arm64 uses the full KBUILD_CFLAGS so it's necessary to explicitly
 # disable the stackleak plugin
-- 
2.30.2



