Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A25AD31BCA2
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbhBOPcm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:32:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:45566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231221AbhBOPbS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:31:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 297CF64E9A;
        Mon, 15 Feb 2021 15:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613402969;
        bh=61DR1XBeTsw7rAnwTBEmMAQ0YsdQEW5wBadwXUFrbo4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O4Rb3To9XCJjjRMrMlp6D0vhz2H09RZeBB/fb33yqZDIFwltyDW/hgN5AOAPBkcp0
         6nJ1Imot2+/O/AWtkmYs1/TEsYuka0swxYq2mXCCqrHlc6X96g/lW8LtHMsYRWZTdM
         SM8Wu14b9NMXtDVKSBMlXCu7bhWbjlyONGAtO+DE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, AC <achirvasub@gmail.com>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 38/60] x86/build: Disable CET instrumentation in the kernel for 32-bit too
Date:   Mon, 15 Feb 2021 16:27:26 +0100
Message-Id: <20210215152716.579239293@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152715.401453874@linuxfoundation.org>
References: <20210215152715.401453874@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

[ Upstream commit 256b92af784d5043eeb7d559b6d5963dcc2ecb10 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/Makefile | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index b5e3bfd4facea..8ca3cf7c5ec97 100644
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
@@ -131,9 +134,6 @@ else
 
         KBUILD_CFLAGS += -mno-red-zone
         KBUILD_CFLAGS += -mcmodel=kernel
-
-	# Intel CET isn't enabled in the kernel
-	KBUILD_CFLAGS += $(call cc-option,-fcf-protection=none)
 endif
 
 ifdef CONFIG_X86_X32
-- 
2.27.0



