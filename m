Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 282B56494C
	for <lists+stable@lfdr.de>; Wed, 10 Jul 2019 17:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbfGJPCx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jul 2019 11:02:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:34616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727978AbfGJPCu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Jul 2019 11:02:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F988208C4;
        Wed, 10 Jul 2019 15:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562770969;
        bh=pbuYZD7Ly2DA5k2hqthPW1CIEpMrmSqlO5hz8/6W+sk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0dUig1LrAwhgYhgxFaMqciUY6uoDDcteKVWnWLbTaiA8Dm62TIGHWWENj8bS7ZmIC
         7AMaIzs8aZJLE4CmUDY96IC5OMZjD7RqSLLXZutoeQiIaDvHPMuI42PFPN6HpOcDhE
         GneJd/F61QmSl2a87bkL+t69A2TJf+iH7uHs35cg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Fangrui Song <maskray@google.com>,
        Peter Smith <peter.smith@linaro.org>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.1 04/11] arm64/efi: Mark __efistub_stext_offset as an absolute symbol explicitly
Date:   Wed, 10 Jul 2019 11:02:31 -0400
Message-Id: <20190710150240.6984-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190710150240.6984-1-sashal@kernel.org>
References: <20190710150240.6984-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

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
index 33f14e484040..b22e8ad071b1 100644
--- a/arch/arm64/kernel/image.h
+++ b/arch/arm64/kernel/image.h
@@ -78,7 +78,11 @@
 
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

