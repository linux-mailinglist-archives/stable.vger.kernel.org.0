Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E091373C56
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405496AbfGXUCZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:02:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:52110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392243AbfGXUCY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 16:02:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA4CB206BA;
        Wed, 24 Jul 2019 20:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998543;
        bh=W+A3HzL8frahF/4NuTWlyBvv3yQCjtHeV+jsA0nVNHg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yWP18rkb9N4gb/iOe0jPgbN5qGtfnqeq8nzBsbEFIeZct0pi5f5QA8AH7ONNOboeJ
         CMuSPZpSnZJYDqf5+5SJ6qz1LzokX3f26+HU1dL1wkaLuIBWhhLRkXyFsjyctb8vQf
         Tdvc6dLtrB8+BjA5Gq/KiHeXqTEAkY9g8+6Fujcc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Fangrui Song <maskray@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        Peter Smith <peter.smith@linaro.org>
Subject: [PATCH 4.19 003/271] arm64/efi: Mark __efistub_stext_offset as an absolute symbol explicitly
Date:   Wed, 24 Jul 2019 21:17:52 +0200
Message-Id: <20190724191655.533901343@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit aa69fb62bea15126e744af2e02acc0d6cf3ed4da ]

After r363059 and r363928 in LLVM, a build using ld.lld as the linker
with CONFIG_RANDOMIZE_BASE enabled fails like so:

ld.lld: error: relocation R_AARCH64_ABS32 cannot be used against symbol
__efistub_stext_offset; recompile with -fPIC

Fangrui and Peter figured out that ld.lld is incorrectly considering
__efistub_stext_offset as a relative symbol because of the order in
which symbols are evaluated. _text is treated as an absolute symbol
and stext is a relative symbol, making __efistub_stext_offset a
relative symbol.

Adding ABSOLUTE will force ld.lld to evalute this expression in the
right context and does not change ld.bfd's behavior. ld.lld will
need to be fixed but the developers do not see a quick or simple fix
without some research (see the linked issue for further explanation).
Add this simple workaround so that ld.lld can continue to link kernels.

Link: https://github.com/ClangBuiltLinux/linux/issues/561
Link: https://github.com/llvm/llvm-project/commit/025a815d75d2356f2944136269aa5874721ec236
Link: https://github.com/llvm/llvm-project/commit/249fde85832c33f8b06c6b4ac65d1c4b96d23b83
Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Debugged-by: Fangrui Song <maskray@google.com>
Debugged-by: Peter Smith <peter.smith@linaro.org>
Suggested-by: Fangrui Song <maskray@google.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
[will: add comment]
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/image.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/image.h b/arch/arm64/kernel/image.h
index 8da289dc843a..eff6a564ab80 100644
--- a/arch/arm64/kernel/image.h
+++ b/arch/arm64/kernel/image.h
@@ -73,7 +73,11 @@
 
 #ifdef CONFIG_EFI
 
-__efistub_stext_offset = stext - _text;
+/*
+ * Use ABSOLUTE() to avoid ld.lld treating this as a relative symbol:
+ * https://github.com/ClangBuiltLinux/linux/issues/561
+ */
+__efistub_stext_offset = ABSOLUTE(stext - _text);
 
 /*
  * The EFI stub has its own symbol namespace prefixed by __efistub_, to
-- 
2.20.1



