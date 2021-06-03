Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5945939A708
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 19:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231633AbhFCRKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 13:10:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:41344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231548AbhFCRKB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 13:10:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2FD2613F8;
        Thu,  3 Jun 2021 17:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740096;
        bh=2pXrZQ+w0kUNd95luNNtVdcwC/XYQEB9W6Mxs8RIM44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UZo3o9LJ+RTsKX0HTShp95UX4zwB/2ks5ni20Ufhm4AYNxYsOcGFmEob5adViDyey
         20yTS4+kb1Fzh3M95nrXd65S1o9yzMEDOXxKhmDKIe9zvTODSwpWvdJ9n6GRaviyT8
         lc4ILnZPeuNOWgK6JqTHm1n76811zGMNFm62jW9AAM2UMWpcgRwSsMIumH0JNZ2Mwg
         GtXTbqaO13+Wosg0+3+5nfP3JRD4SbOCGDH5KdNn+zmUhO9qBP/C/yD1Tz+2czAqq3
         418BHzS4fMAX8x9z1AECy/IVB6J00GG3FLUsP5eOs6BS1pxstNrBEbejyiJXvYKiQD
         WdvjZ6I+6qcgQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Candle Sun <candlesea@gmail.com>,
        Fangrui Song <maskray@google.com>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>, linux-kbuild@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.12 34/43] Makefile: LTO: have linker check -Wframe-larger-than
Date:   Thu,  3 Jun 2021 13:07:24 -0400
Message-Id: <20210603170734.3168284-34-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170734.3168284-1-sashal@kernel.org>
References: <20210603170734.3168284-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index a20afcb7d2bf..476ab5b3adc2 100644
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

