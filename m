Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71AB02EF15
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732537AbfE3Dwh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:52:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:55842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731093AbfE3DTf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:19:35 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2442E248AE;
        Thu, 30 May 2019 03:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186375;
        bh=Gv/H9w26YDcwmv+8qt2Uilgf7kakDx6hJzrcUwNIk4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vzq3xVzzlzVSz/0+p4xKE1bSedd9VegYplGxZfHSlwwTbZh5eGvbsdftSkCXVfF41
         hyLsaAec4VH5QjWclmuBsL77+0Qwzlf5n4vxnH+A1Qj67XidDFIX4UkEYl+G6XMkA0
         FYo7r4vTUSGUGBw5bKR7wjozxa3VtzuLJTw2TvIU=
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
Subject: [PATCH 4.14 135/193] x86/build: Keep local relocations with ld.lld
Date:   Wed, 29 May 2019 20:06:29 -0700
Message-Id: <20190530030507.215882392@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030446.953835040@linuxfoundation.org>
References: <20190530030446.953835040@linuxfoundation.org>
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
index eb1f8f249dc35..b4c72da8a7adb 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -48,7 +48,7 @@ export REALMODE_CFLAGS
 export BITS
 
 ifdef CONFIG_X86_NEED_RELOCS
-        LDFLAGS_vmlinux := --emit-relocs
+        LDFLAGS_vmlinux := --emit-relocs --discard-none
 endif
 
 #
-- 
2.20.1



