Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08CCA3A6380
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235398AbhFNLN6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:13:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:42526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234717AbhFNLLz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:11:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FCDA61951;
        Mon, 14 Jun 2021 10:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667684;
        bh=ROxKfwcxodE0zhvauAbH2Wq6lyAIhtvHimFSA8eXLvA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JRi6odW9pNYr0QBFWAg7XPnCLruJIsJf04TkL+vKmZZcgScMKp1iJBXV3U28aIy9e
         G9tWyYVq7AFLK81jslNy4zTxp4B5MoIZOysOJun9hcgWo4ZVCoxlXArx09AwDzeYmh
         uoAGf6Q6Ahx+b+1bsAN5IJxrfwpiFGFDuVSaTtYw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>,
        Candle Sun <candlesea@gmail.com>,
        Fangrui Song <maskray@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 035/173] Makefile: LTO: have linker check -Wframe-larger-than
Date:   Mon, 14 Jun 2021 12:26:07 +0200
Message-Id: <20210614102659.317088098@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>

[ Upstream commit 24845dcb170e16b3100bd49743687648c71387ae ]

-Wframe-larger-than= requires stack frame information, which the
frontend cannot provide. This diagnostic is emitted late during
compilation once stack frame size is available.

When building with LTO, the frontend simply lowers C to LLVM IR and does
not have stack frame information, so it cannot emit this diagnostic.
When the linker drives LTO, it restarts optimizations and lowers LLVM IR
to object code. At that point, it has stack frame information but
doesn't know to check for a specific max stack frame size.

I consider this a bug in LLVM that we need to fix. There are some
details we're working out related to LTO such as which value to use when
there are multiple different values specified per TU, or how to
propagate these to compiler synthesized routines properly, if at all.

Until it's fixed, ensure we don't miss these. At that point we can wrap
this in a compiler version guard or revert this based on the minimum
support version of Clang.

The error message is not generated during link:
  LTO     vmlinux.o
ld.lld: warning: stack size limit exceeded (8224) in foobarbaz

Cc: Sami Tolvanen <samitolvanen@google.com>
Reported-by: Candle Sun <candlesea@gmail.com>
Suggested-by: Fangrui Song <maskray@google.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20210312010942.1546679-1-ndesaulniers@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Makefile b/Makefile
index ebc02c56db03..358a2b103de9 100644
--- a/Makefile
+++ b/Makefile
@@ -912,6 +912,11 @@ CC_FLAGS_LTO	+= -fvisibility=hidden
 
 # Limit inlining across translation units to reduce binary size
 KBUILD_LDFLAGS += -mllvm -import-instr-limit=5
+
+# Check for frame size exceeding threshold during prolog/epilog insertion.
+ifneq ($(CONFIG_FRAME_WARN),0)
+KBUILD_LDFLAGS	+= -plugin-opt=-warn-stack-size=$(CONFIG_FRAME_WARN)
+endif
 endif
 
 ifdef CONFIG_LTO
-- 
2.30.2



