Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A51D12C65F
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731055AbfL2RqU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:46:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:55992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731052AbfL2RqT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:46:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90A88206DB;
        Sun, 29 Dec 2019 17:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641579;
        bh=uFNxM7/O65MW/lOtCWv+XHBpUX/dWkTOHmXneIeUm0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m2M8jPFfhRpDCPRTfJioySQdhOrr2B5GDGDOhQmwvBTWoM+ga4fNkVEp1PEMmeJJo
         IEocHu4FmN3NX7z3am7HOc2x87hExyeQRZRsfH+vaJ+/MZB5iC9I+BbLGrMQE2QC3a
         F4URahW+nAXDI/mc1/6wEH9sh1OKUeie0YnQJ8rQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        ci_notify@linaro.org, Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 124/434] crypto: aegis128/simd - build 32-bit ARM for v8 architecture explicitly
Date:   Sun, 29 Dec 2019 18:22:57 +0100
Message-Id: <20191229172709.933326081@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

[ Upstream commit 830536770f968ab33ece123b317e252c269098db ]

Now that the Clang compiler has taken it upon itself to police the
compiler command line, and reject combinations for arguments it views
as incompatible, the AEGIS128 no longer builds correctly, and errors
out like this:

  clang-10: warning: ignoring extension 'crypto' because the 'armv7-a'
  architecture does not support it [-Winvalid-command-line-argument]

So let's switch to armv8-a instead, which matches the crypto-neon-fp-armv8
FPU profile we specify. Since neither were actually supported by GCC
versions before 4.8, let's tighten the Kconfig dependencies as well so
we won't run into errors when building with an ancient compiler.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Reported-by: <ci_notify@linaro.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 9e524044d312..29472fb795f3 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -309,6 +309,7 @@ config CRYPTO_AEGIS128
 config CRYPTO_AEGIS128_SIMD
 	bool "Support SIMD acceleration for AEGIS-128"
 	depends on CRYPTO_AEGIS128 && ((ARM || ARM64) && KERNEL_MODE_NEON)
+	depends on !ARM || CC_IS_CLANG || GCC_VERSION >= 40800
 	default y
 
 config CRYPTO_AEGIS128_AESNI_SSE2
-- 
2.20.1



