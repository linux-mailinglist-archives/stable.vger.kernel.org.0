Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0BA37D2A0
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353192AbhELSKy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:10:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:53024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236216AbhELSEo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 14:04:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9282461438;
        Wed, 12 May 2021 18:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842615;
        bh=VDysD30fRwug+xHWx7FdQENfFyUXpotZ39qTSFeyguk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p59cBW6au8YaSb+KUqPbTsNUyRSDTjmvmTt+GfKgfcO+JhET/PwrrVAAQ4uMCsJty
         sH+dGRo2dJTmJQhyKC90JgqjQEo9OjPS5IMKLnagiARrn6QnR53OI7v1zDJsIi7gCf
         c35FFDywNJogMmJr3adJ0IAsH1eycameYs3ErqCjG2FQPPUueuwc+jSTxevB/afLzB
         zOovn/hlR3VIbB86wvCB/QgVkDQo66XnfiL3nLQe5mpHIWck/gFnN9A8gq84TKbbwf
         1/XCgSDNAmpRaP7YKAcN5T3V+/1sVgsmFWd/bC6l+OJAK5pLPgbQnBX8MboX8uIAL4
         AkCUJAcv+9aRw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Fangrui Song <maskray@google.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-riscv@lists.infradead.org, clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.10 17/34] scripts/recordmcount.pl: Fix RISC-V regex for clang
Date:   Wed, 12 May 2021 14:02:48 -0400
Message-Id: <20210512180306.664925-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180306.664925-1-sashal@kernel.org>
References: <20210512180306.664925-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 2f095504f4b9cf75856d6a9cf90299cf75aa46c5 ]

Clang can generate R_RISCV_CALL_PLT relocations to _mcount:

$ llvm-objdump -dr build/riscv/init/main.o | rg mcount
                000000000000000e:  R_RISCV_CALL_PLT     _mcount
                000000000000004e:  R_RISCV_CALL_PLT     _mcount

After this, the __start_mcount_loc section is properly generated and
function tracing still works.

Link: https://github.com/ClangBuiltLinux/linux/issues/1331
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Fangrui Song <maskray@google.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/recordmcount.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 0bafed857e17..857d5b70b1a9 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -395,7 +395,7 @@ if ($arch eq "x86_64") {
     $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s_mcount\$";
 } elsif ($arch eq "riscv") {
     $function_regex = "^([0-9a-fA-F]+)\\s+<([^.0-9][0-9a-zA-Z_\\.]+)>:";
-    $mcount_regex = "^\\s*([0-9a-fA-F]+):\\sR_RISCV_CALL\\s_mcount\$";
+    $mcount_regex = "^\\s*([0-9a-fA-F]+):\\sR_RISCV_CALL(_PLT)?\\s_mcount\$";
     $type = ".quad";
     $alignment = 2;
 } elsif ($arch eq "nds32") {
-- 
2.30.2

