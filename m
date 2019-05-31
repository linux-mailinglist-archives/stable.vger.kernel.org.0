Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 383B53083A
	for <lists+stable@lfdr.de>; Fri, 31 May 2019 07:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbfEaF7O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 May 2019 01:59:14 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:40374 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbfEaF7O (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 May 2019 01:59:14 -0400
Received: by mail-ed1-f68.google.com with SMTP id r18so11745353edo.7
        for <stable@vger.kernel.org>; Thu, 30 May 2019 22:59:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oRZZxg7tDoM8gwloKtClf27SzDwp8B7TsYDCaKJVOAE=;
        b=A8coVky0PFlp0UI9C/61TmFtN12f1QH8fwYv2NGftjQQxUimgrLpXsjGAr5Vz9njoE
         f6VL6r5IyYbPpTrfVPUWJm+XscQg/5LHgpU2PsHRnjiaerFyCWR1UVV1ne0Gc/LruHa+
         d4nMHTLA30dm1JvNLTwefm406y9HLjITprP2NyJ6GS0EJXPB2X9wrVZuCrC3+rFMyeSh
         g/tVPelBWFVYyhTa5a7Q+Y5vdIDxHCifNeOi1OJjsrzNIfEnaNicdfHGLOrnuS8gIma+
         H0aqJT4qtBRslD981ulgHPDByTVn96V0plKz6b0O+PMnsZKSZiQqNrlvjEIJ1dN7CFSE
         dJjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oRZZxg7tDoM8gwloKtClf27SzDwp8B7TsYDCaKJVOAE=;
        b=g4VX23I8xmMY0ISiZOtgOB67N864KdSxyP7xJ3/Z9yVia8SZv9TXlWegX87hVGqYgn
         IVAhT3GQKe9IV6XlnGNH9pxILa5SER2hQr8CO25rCxoG4Au/6u2Kay7tjJR5ow+Qi3IQ
         ZU1tOcbtgI1mxeMIPaDLdrSWTmIYya5hlAARqTqIb6PBpPrI4Bb9SDnL2bLe8+KDPE8n
         IDBL2pK1fR5zE/RdlCDUBEioAkGty7G+2XdYQQPy5cdIT1/wqbP1nT8qcTBXhri9GSow
         VaGKG24BnHv725ZIkwAQ94RTdVptJh091vClal2gSmDiORNdbDdq4tuMpkYTSOQFY9cf
         K7EA==
X-Gm-Message-State: APjAAAU5wJsX6Tl9jpwTcnfO6Be3DgfQkpbviDHB/lYk8YvmmYhwAkz5
        ByY7gqdiPaurOtq2HjioxT0=
X-Google-Smtp-Source: APXvYqwydF68k9oZlgXlENUUJSmOVSifJgfOokuR//G6+M/9o/jjI5qIldoEMdpM0EBOw0Xiy4x1PQ==
X-Received: by 2002:a05:6402:1505:: with SMTP id f5mr7033249edw.133.1559282352194;
        Thu, 30 May 2019 22:59:12 -0700 (PDT)
Received: from localhost.localdomain ([2a01:4f9:2b:2b15::2])
        by smtp.gmail.com with ESMTPSA id g47sm1311163edc.33.2019.05.30.22.59.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 22:59:11 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, clang-built-linux@googlegroups.com,
        "ndesaulniers@google.com" <ndesaulniers@google.com>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH 4.19] include/linux/compiler*.h: define asm_volatile_goto
Date:   Thu, 30 May 2019 22:56:34 -0700
Message-Id: <20190531055633.123516-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.22.0.rc2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "ndesaulniers@google.com" <ndesaulniers@google.com>

commit 8bd66d147c88bd441178c7b4c774ae5a185f19b8 upstream.

asm_volatile_goto should also be defined for other compilers that support
asm goto.

Fixes commit 815f0ddb346c ("include/linux/compiler*.h: make compiler-*.h
mutually exclusive").

Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---

Hi Greg and Sasha,

Please pick up this patch for 4.19. It turns out that commit
13aceef06adf ("arm64: jump_label.h: use asm_volatile_goto macro instead
of "asm goto"") was backported without this, which causes a build
failure on arm64. This wasn't uncovered until now because clang didn't
support asm goto so this code wasn't being compiled. Thankfully, that
should change very soon :)

 include/linux/compiler_types.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
index db192becfec4..c2ded31a4cec 100644
--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@ -151,6 +151,10 @@ struct ftrace_likely_data {
 #define __assume_aligned(a, ...)
 #endif
 
+#ifndef asm_volatile_goto
+#define asm_volatile_goto(x...) asm goto(x)
+#endif
+
 /* Are two types/vars the same type (ignoring qualifiers)? */
 #define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof(b))
 
-- 
2.22.0.rc2

