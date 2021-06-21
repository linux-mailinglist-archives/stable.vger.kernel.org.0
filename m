Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BAE23AF090
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbhFUQuY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:50:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:37532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232739AbhFUQr6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:47:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FFDA61414;
        Mon, 21 Jun 2021 16:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293235;
        bh=DpdsOizRZRHCAWcMf9zuFxLYtF6OIS/+YhzrZKAY7VM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zyFHsfM0eDS5XVllWMw5nzooKthijMPcV2QYR+Ydtq8BmHfgoWLB2lWi7XL5Xve43
         UymsAB54HVT6bYF7L5eSpaPEWnXPIhZaNWlIk+tn4CTjZM9hE/cSa+ucdJYLJHiCSV
         by0OqzNAHPCOHjYq+88QypYo4n3zJ8Oh0q99mQV4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tor Vic <torvic9@mailbox.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.12 148/178] Makefile: lto: Pass -warn-stack-size only on LLD < 13.0.0
Date:   Mon, 21 Jun 2021 18:16:02 +0200
Message-Id: <20210621154927.806773805@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tor Vic <torvic9@mailbox.org>

commit 0236526d76b87c1dc2cbe3eb31ae29be5b0ca151 upstream.

Since LLVM commit fc018eb, the '-warn-stack-size' flag has been dropped
[1], leading to the following error message when building with Clang-13
and LLD-13:

    ld.lld: error: -plugin-opt=-: ld.lld: Unknown command line argument
    '-warn-stack-size=2048'.  Try: 'ld.lld --help'
    ld.lld: Did you mean '--asan-stack=2048'?

In the same way as with commit 2398ce80152a ("x86, lto: Pass
-stack-alignment only on LLD < 13.0.0") , make '-warn-stack-size'
conditional on LLD < 13.0.0.

[1] https://reviews.llvm.org/D103928

Fixes: 24845dcb170e ("Makefile: LTO: have linker check -Wframe-larger-than")
Cc: stable@vger.kernel.org
Link: https://github.com/ClangBuiltLinux/linux/issues/1377
Signed-off-by: Tor Vic <torvic9@mailbox.org>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/7631bab7-a8ab-f884-ab54-f4198976125c@mailbox.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/Makefile
+++ b/Makefile
@@ -913,11 +913,14 @@ CC_FLAGS_LTO	+= -fvisibility=hidden
 # Limit inlining across translation units to reduce binary size
 KBUILD_LDFLAGS += -mllvm -import-instr-limit=5
 
-# Check for frame size exceeding threshold during prolog/epilog insertion.
+# Check for frame size exceeding threshold during prolog/epilog insertion
+# when using lld < 13.0.0.
 ifneq ($(CONFIG_FRAME_WARN),0)
+ifeq ($(shell test $(CONFIG_LLD_VERSION) -lt 130000; echo $$?),0)
 KBUILD_LDFLAGS	+= -plugin-opt=-warn-stack-size=$(CONFIG_FRAME_WARN)
 endif
 endif
+endif
 
 ifdef CONFIG_LTO
 KBUILD_CFLAGS	+= -fno-lto $(CC_FLAGS_LTO)


