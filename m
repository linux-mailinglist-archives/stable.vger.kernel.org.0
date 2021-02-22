Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D11732174B
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231488AbhBVMpn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:45:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:53428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231549AbhBVMnS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:43:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 172E064F36;
        Mon, 22 Feb 2021 12:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613997628;
        bh=OREBePYUtrVAVN/k0Ft5UqwIM8mdZxh9ofG37Uluz1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r2uv3MlnqkMe8tDK7707ZmWbZTbFJBwAVHWEnlnAaKYCsA6wPgtP5gKRsJ1pp1VjZ
         tei6Exgr3ldzFVzQycxLliYBZQYBYP/dPLA9kAb4E0Iv+YnCSysIcout7k0uQpM6xJ
         FTfl5l9p1Zp4fFalGQZp+4JgqsJJSvC8qaqX6EOg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, AC <achirvasub@gmail.com>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: [PATCH 4.4 21/35] x86/build: Disable CET instrumentation in the kernel for 32-bit too
Date:   Mon, 22 Feb 2021 13:36:17 +0100
Message-Id: <20210222121021.116192176@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121013.581198717@linuxfoundation.org>
References: <20210222121013.581198717@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

commit 256b92af784d5043eeb7d559b6d5963dcc2ecb10 upstream.

Commit

  20bf2b378729 ("x86/build: Disable CET instrumentation in the kernel")

disabled CET instrumentation which gets added by default by the Ubuntu
gcc9 and 10 by default, but did that only for 64-bit builds. It would
still fail when building a 32-bit target. So disable CET for all x86
builds.

Fixes: 20bf2b378729 ("x86/build: Disable CET instrumentation in the kernel")
Reported-by: AC <achirvasub@gmail.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
Tested-by: AC <achirvasub@gmail.com>
Link: https://lkml.kernel.org/r/YCCIgMHkzh/xT4ex@arch-chirva.localdomain
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/Makefile |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -61,6 +61,9 @@ endif
 KBUILD_CFLAGS += -mno-sse -mno-mmx -mno-sse2 -mno-3dnow
 KBUILD_CFLAGS += $(call cc-option,-mno-avx,)
 
+# Intel CET isn't enabled in the kernel
+KBUILD_CFLAGS += $(call cc-option,-fcf-protection=none)
+
 ifeq ($(CONFIG_X86_32),y)
         BITS := 32
         UTS_MACHINE := i386
@@ -137,9 +140,6 @@ else
         KBUILD_CFLAGS += -mno-red-zone
         KBUILD_CFLAGS += -mcmodel=kernel
 
-	# Intel CET isn't enabled in the kernel
-	KBUILD_CFLAGS += $(call cc-option,-fcf-protection=none)
-
         # -funit-at-a-time shrinks the kernel .text considerably
         # unfortunately it makes reading oopses harder.
         KBUILD_CFLAGS += $(call cc-option,-funit-at-a-time)


