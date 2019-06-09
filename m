Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23B183A991
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388668AbfFIRKv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:10:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:39980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388205AbfFIRCN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:02:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8580206C3;
        Sun,  9 Jun 2019 17:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099732;
        bh=P8WAO2Ji7lWjW//kaUmahcMFJEYZAyIOHJry0WDpX3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TUaiPN/9qIGsbEp5yaYsI5RhKmXMP/HlZi5cI1mWycmTTXxJo8XmH3Hqp5UownbpD
         0BvI0LW8K5pwG+D/uC/1OniBNIbuvxNM1kkcsI/IuvEm6cK3IUOC9xE2r6Nyz4b9bb
         mODuhi3XY6+5CHaU1tDfZwnEpERYo14OMkywsIBY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Borislav Petkov <bp@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        clang-built-linux@googlegroups.com, x86-ml <x86@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 147/241] x86/build: Keep local relocations with ld.lld
Date:   Sun,  9 Jun 2019 18:41:29 +0200
Message-Id: <20190609164152.022646166@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 7c21383f3429dd70da39c0c7f1efa12377a47ab6 ]

The LLVM linker (ld.lld) defaults to removing local relocations, which
causes KASLR boot failures. ld.bfd and ld.gold already handle this
correctly. This adds the explicit instruction "--discard-none" during
the link phase. There is no change in output for ld.bfd and ld.gold,
but ld.lld now produces an image with all the needed relocations.

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: clang-built-linux@googlegroups.com
Cc: x86-ml <x86@kernel.org>
Link: https://lkml.kernel.org/r/20190404214027.GA7324@beast
Link: https://github.com/ClangBuiltLinux/linux/issues/404
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index e26560cd18444..00e0226634fa9 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -47,7 +47,7 @@ export REALMODE_CFLAGS
 export BITS
 
 ifdef CONFIG_X86_NEED_RELOCS
-        LDFLAGS_vmlinux := --emit-relocs
+        LDFLAGS_vmlinux := --emit-relocs --discard-none
 endif
 
 #
-- 
2.20.1



