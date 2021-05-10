Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1C4D3785B3
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235531AbhEJLBP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:01:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:52740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234543AbhEJK4i (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:56:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6622261932;
        Mon, 10 May 2021 10:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643618;
        bh=4mxuqyCEXFXKOYcs/KXX/g+YKtyaSXxBm6esFdHtqic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YaTMvYdYHOP2mltc2t7WYixSWISpzPMFupucHnIcCOyA9O5CS7wlFwMvvJhO7tpBF
         LR5YB5+CiF2xX/YTHn0vVHfR0IeQAFhMhVcjH5dHFtWp7a2R4NDIegKoSgLshTU1rf
         bWrlpbdvRx7wyOACfpBE33MpfbqJHwe0316mArCQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Borislav Petkov <bp@suse.de>, Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 087/342] x86/boot: Add $(CLANG_FLAGS) to compressed KBUILD_CFLAGS
Date:   Mon, 10 May 2021 12:17:57 +0200
Message-Id: <20210510102012.989517335@linuxfoundation.org>
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

[ Upstream commit d5cbd80e302dfea59726c44c56ab7957f822409f ]

When cross compiling x86 on an ARM machine with clang, there are several
errors along the lines of:

  arch/x86/include/asm/string_64.h:27:10: error: invalid output constraint '=&c' in asm

This happens because the compressed boot Makefile reassigns KBUILD_CFLAGS
and drops the clang flags that set the target architecture ('--target=')
and the path to the GNU cross tools ('--prefix='), meaning that the host
architecture is targeted.

These flags are available as $(CLANG_FLAGS) from the main Makefile so
add them to the compressed boot folder's KBUILD_CFLAGS so that cross
compiling works as expected.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://lkml.kernel.org/r/20210326000435.4785-3-nathan@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/boot/compressed/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index e0bc3988c3fa..6e5522aebbbd 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -46,6 +46,7 @@ KBUILD_CFLAGS += -D__DISABLE_EXPORTS
 # Disable relocation relaxation in case the link is not PIE.
 KBUILD_CFLAGS += $(call as-option,-Wa$(comma)-mrelax-relocations=no)
 KBUILD_CFLAGS += -include $(srctree)/include/linux/hidden.h
+KBUILD_CFLAGS += $(CLANG_FLAGS)
 
 # sev-es.c indirectly inludes inat-table.h which is generated during
 # compilation and stored in $(objtree). Add the directory to the includes so
-- 
2.30.2



