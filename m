Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24BA338303D
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237420AbhEQOZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:25:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:37616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237496AbhEQOXQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:23:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1671613D9;
        Mon, 17 May 2021 14:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260741;
        bh=aNYXZWoSOlAOk+ZWWwQMbgpvI5lokByWOB6Vs2dTSIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jFdLHy1KkuL6kjRF0zfezafBAR5uro/KNa73PbV8hmC+UkS5uMgUqijScJAm7dT5T
         p/Z04FgdIR640VFiAKXZSJ+jxOyNvJSnGH1ENWljmVlrvK/V2hZVUMtGyQBjukJpKC
         A22abk4IXgKTDfQT1RkBoeDtTlvKUhNuhalnz+Ew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Fangrui Song <maskray@google.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 184/363] riscv: Select HAVE_DYNAMIC_FTRACE when -fpatchable-function-entry is available
Date:   Mon, 17 May 2021 16:00:50 +0200
Message-Id: <20210517140308.809286639@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit adebc8817b5c975d598ac379bbdf67a7a5186ade ]

clang prior to 13.0.0 does not support -fpatchable-function-entry for
RISC-V.

clang: error: unsupported option '-fpatchable-function-entry=8' for target 'riscv64-unknown-linux-gnu'

To avoid this error, only select HAVE_DYNAMIC_FTRACE when this option is
not available.

Fixes: afc76b8b8011 ("riscv: Using PATCHABLE_FUNCTION_ENTRY instead of MCOUNT")
Link: https://github.com/ClangBuiltLinux/linux/issues/1268
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Fangrui Song <maskray@google.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 4515a10c5d22..d9522fc35ca5 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -227,7 +227,7 @@ config ARCH_RV64I
 	bool "RV64I"
 	select 64BIT
 	select ARCH_SUPPORTS_INT128 if CC_HAS_INT128 && GCC_VERSION >= 50000
-	select HAVE_DYNAMIC_FTRACE if MMU
+	select HAVE_DYNAMIC_FTRACE if MMU && $(cc-option,-fpatchable-function-entry=8)
 	select HAVE_DYNAMIC_FTRACE_WITH_REGS if HAVE_DYNAMIC_FTRACE
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_FUNCTION_GRAPH_TRACER
-- 
2.30.2



