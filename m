Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6765237D2C7
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237579AbhELSN3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:13:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:53578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353030AbhELSGm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 14:06:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28C106157F;
        Wed, 12 May 2021 18:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842670;
        bh=VDysD30fRwug+xHWx7FdQENfFyUXpotZ39qTSFeyguk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d5nP07AaFq2GSfzsiG7FhPMs5CFlzA0bnLo31OfzvE5VfCeYSU+XfQ0QhVqr25K/u
         fXlyF8tiN+vuZn53xxW9FJghAZQGWLmNY1k0reFfV9g/KoYYsBtgZar8QO6Fmfjry3
         ha2/jiqLPWSSwJ7eweSv7qMQvlMwde0z4AYVqwzezPp+f4DvOQPnMvfkdXegsnulKU
         Og72hem5Pu9BzfIDvRIb4jbcdBp9DgRQ6CiY8XVFudo5eL8AgBXsS/kPQitof8t8rs
         io+6sTXm6qDpdiDmBdzgFvTNwbmplXnAUK7gimukUtSau288BRMS4fdeSDsqL9VsXc
         TlAOvn+Yb+Hug==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Fangrui Song <maskray@google.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-riscv@lists.infradead.org, clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.4 12/23] scripts/recordmcount.pl: Fix RISC-V regex for clang
Date:   Wed, 12 May 2021 14:03:56 -0400
Message-Id: <20210512180408.665338-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180408.665338-1-sashal@kernel.org>
References: <20210512180408.665338-1-sashal@kernel.org>
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

