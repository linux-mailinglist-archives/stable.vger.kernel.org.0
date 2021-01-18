Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D70FA2FA416
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 16:06:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405523AbhARPGo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 10:06:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:37676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390379AbhARLmH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:42:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5235A2223E;
        Mon, 18 Jan 2021 11:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970086;
        bh=gFezr+KIW0FwbmW6quW+HsgiqZDNUoNWDftos+HnCcc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MsjAf+A1BdwGZloSWi+9XOSGgWIkZ/vTaCj7Oib5Or+a3aP6TkK4byb2vUPmwp+GO
         8kyL0PAk8bqqtL2s64iCS0PtfDG4IN0s2zpTnhlwtnTZZAO2qVJMg3gSC6JWAqbfZ+
         PGUi0e6stO/iUF+i8789LNzJ9ZjZJi2Im3Br4wdo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anders Roxell <anders.roxell@linaro.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.10 030/152] mips: lib: uncached: fix non-standard usage of variable sp
Date:   Mon, 18 Jan 2021 12:33:25 +0100
Message-Id: <20210118113354.223625171@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anders Roxell <anders.roxell@linaro.org>

commit 5b058973d3205578aa6c9a71392e072a11ca44ef upstream.

When building mips tinyconfig with clang the following warning show up:

arch/mips/lib/uncached.c:45:6: warning: variable 'sp' is uninitialized when used here [-Wuninitialized]
        if (sp >= (long)CKSEG0 && sp < (long)CKSEG2)
            ^~
arch/mips/lib/uncached.c:40:18: note: initialize the variable 'sp' to silence this warning
        register long sp __asm__("$sp");
                        ^
                         = 0
1 warning generated.

Rework to make an explicit inline move, instead of the non-standard use
of specifying registers for local variables. This is what's written
from the gcc-10 manual [1] about specifying registers for local
variables:

"6.47.5.2 Specifying Registers for Local Variables
.................................................
[...]

"The only supported use for this feature is to specify registers for
input and output operands when calling Extended 'asm' (*note Extended
Asm::).  [...]".

[1] https://docs.w3cub.com/gcc~10/local-register-variables
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
Reported-by: Nathan Chancellor <natechancellor@gmail.com>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/lib/uncached.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/mips/lib/uncached.c
+++ b/arch/mips/lib/uncached.c
@@ -37,10 +37,12 @@
  */
 unsigned long run_uncached(void *func)
 {
-	register long sp __asm__("$sp");
 	register long ret __asm__("$2");
 	long lfunc = (long)func, ufunc;
 	long usp;
+	long sp;
+
+	__asm__("move %0, $sp" : "=r" (sp));
 
 	if (sp >= (long)CKSEG0 && sp < (long)CKSEG2)
 		usp = CKSEG1ADDR(sp);


