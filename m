Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A199637D251
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241566AbhELSIc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:08:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:50552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352174AbhELSCm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 14:02:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24C0461104;
        Wed, 12 May 2021 18:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842494;
        bh=m2noJKqKeW0U5wmwK56a/Dvf7G3056Cma/3oi2F6q9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MmlEYtWjD4JYuwCjXbjV56uxfdvJjxyHrYcNIB3xb4T7g2IHTz0WgEyMVWUq6CWZ0
         Z0GmcU5BcRFw0Mh7LxMX8n/iXgkDWLBGDR6CG1JxRzK2c2sb698VOo6VTGZtNGvEE8
         9FLQlwss9EGfEUkX9Pp8Dv9FJUE2H+f5yqh4ITlET4OBsDGcnvGLh3SH9wSV2t84M4
         qW7BWoHEmG8dNqDEswSN3lccuf7NU7nxyvJriPlVKmLd4O+pxMIH2gQGX1EkCwOyAT
         UamYnjblCxKQkO8chjAqh1TjF++u46OeOOHBJaqCsmBB4VoDdaYhsS02X4SovjTGGb
         F/XONOrW7M16w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Fangrui Song <maskray@google.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-riscv@lists.infradead.org, clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.12 20/37] scripts/recordmcount.pl: Fix RISC-V regex for clang
Date:   Wed, 12 May 2021 14:00:47 -0400
Message-Id: <20210512180104.664121-20-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180104.664121-1-sashal@kernel.org>
References: <20210512180104.664121-1-sashal@kernel.org>
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
index 867860ea57da..a36df04cfa09 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -392,7 +392,7 @@ if ($arch eq "x86_64") {
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

