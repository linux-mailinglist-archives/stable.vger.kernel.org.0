Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81C7A321789
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:52:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbhBVMtg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:49:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:56564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231492AbhBVMpo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:45:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A40DF64E84;
        Mon, 22 Feb 2021 12:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613997709;
        bh=OREBePYUtrVAVN/k0Ft5UqwIM8mdZxh9ofG37Uluz1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AadOFcTHMMvlE39ehYEMP/UodVeU3hYJViEGKxaaRxVy+oB5bRmqDunl9UVrmYA7/
         hMraPwRQEQAkh/rukSi/hfCrVQObK87vh4BLX95jZXztyzSPkDpWd5qtjYLkilJyq6
         u5aHE3RvNx+4gh44QjIwSvObDwO/UfSIptYhWGCQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, AC <achirvasub@gmail.com>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: [PATCH 4.9 35/49] x86/build: Disable CET instrumentation in the kernel for 32-bit too
Date:   Mon, 22 Feb 2021 13:36:33 +0100
Message-Id: <20210222121027.537898402@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121022.546148341@linuxfoundation.org>
References: <20210222121022.546148341@linuxfoundation.org>
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


