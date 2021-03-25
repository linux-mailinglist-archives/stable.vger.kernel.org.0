Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC60349C6A
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 23:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbhCYWi5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 18:38:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:49170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231277AbhCYWi1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 18:38:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED2CA61A38;
        Thu, 25 Mar 2021 22:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616711907;
        bh=73VsQ5V66Z2i7UXDiahsIQeBPPsxjN8due9MczLEMgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dRF7V82Cjx0UE7OpHE9CYFwTxnGorcqrArlaxwiXw09aA7xjV84Mh7qKkbMlVA55G
         zVeSjr8BjzfGh0UVaOFX+nLpdD91EeWEW2+85FV4GjRn6YM0ckCbk/4Hpq7iQXS83r
         w0zNmMm3rW4SDn5QMH6X3jJRJbK8vmTBISf4iKs4g1HlxdM9Pg+NZziOuinvQ5fxb6
         gIFK1bSKKv2xGuzWzoj5OrcisVPSbd7BDVEfw6C2sIBnYbOFIwucs1Zg+pHwQpFpgA
         /2c5XgMc/8Y1Y3ZQubBkMKMBs4BZAkaXq56HAkSRmxbJzjh6o7cfeimQ4MUs3B2h+1
         34GnFcvzYGQ1A==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Cc:     linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nathan Chancellor <nathan@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 1/3] scripts/recordmcount.pl: Fix RISC-V regex for clang
Date:   Thu, 25 Mar 2021 15:38:05 -0700
Message-Id: <20210325223807.2423265-2-nathan@kernel.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210325223807.2423265-1-nathan@kernel.org>
References: <20210325223807.2423265-1-nathan@kernel.org>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Clang can generate R_RISCV_CALL_PLT relocations to _mcount:

$ llvm-objdump -dr build/riscv/init/main.o | rg mcount
                000000000000000e:  R_RISCV_CALL_PLT     _mcount
                000000000000004e:  R_RISCV_CALL_PLT     _mcount

After this, the __start_mcount_loc section is properly generated and
function tracing still works.

Cc: stable@vger.kernel.org
Link: https://github.com/ClangBuiltLinux/linux/issues/1331
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
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
2.31.0

