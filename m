Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDC7D3783A9
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232535AbhEJKq5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:46:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:59362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232913AbhEJKos (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:44:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F16E461574;
        Mon, 10 May 2021 10:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642847;
        bh=8tgUsdn4HF1BGHa0LfXohhQMOdZ30Xjhil89P8jwuBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kf+QhZKV9of3rpMbqu+LW/nx27CEgM6gUx5y1A4T5wYcRH8YZIKxFY/KgkyZ2GWm2
         DFPzRWFVoE4ZIcTJkQdDR08WzCseLaZ0UwcEwTJbX3LNquW9YTjryERFFoY4wxXhsV
         KnBuZraSkKbfA9CktpeglSG2YsnyjuTqIM2umscA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Borislav Petkov <bp@suse.de>, Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 075/299] efi/libstub: Add $(CLANG_FLAGS) to x86 flags
Date:   Mon, 10 May 2021 12:17:52 +0200
Message-Id: <20210510102007.404325257@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
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



