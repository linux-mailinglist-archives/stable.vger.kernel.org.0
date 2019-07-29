Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABD80799AE
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729458AbfG2TYN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:24:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:36418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729452AbfG2TYL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:24:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10EE42070B;
        Mon, 29 Jul 2019 19:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564428250;
        bh=e1qs+ioypLgGdvKj2f16B/R8pllIlpDGzR/4OVXgcG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jItDKl6oRICVGdHxtnztMOs9h8HUUsAu/Stok3OciBEexhE6LyoEk6lOFDanrEFH9
         ZVKSjvHU7OtiD0Lp0fhsRt7EP9lBFb0ab+HFy/FG+MLG5PNeeVf4fyzVWUWzMHa5D4
         YUMStZERc/FV+Y8K87zJUV8kWGBQsZg1Gv17LXdE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Fangrui Song <maskray@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        Peter Smith <peter.smith@linaro.org>
Subject: [PATCH 4.14 003/293] arm64/efi: Mark __efistub_stext_offset as an absolute symbol explicitly
Date:   Mon, 29 Jul 2019 21:18:14 +0200
Message-Id: <20190729190820.605423017@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
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
index 40f9f0b078a4..12af2ba8d558 100644
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



