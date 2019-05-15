Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C800C1F1D4
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730544AbfEOLzm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:55:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:55800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730785AbfEOLSV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:18:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92467206BF;
        Wed, 15 May 2019 11:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919101;
        bh=J+nK/4lcna/xPxlZvuEpylB8TdIZIaAJLF4+tVeBSWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y6mYe2IHPKKJxzPxedyT6C33/HWitkdskH2iGYi8kT/Rts1PeE6Suq+svMfD7BxYM
         ESZydsbWaTREqldn6YrxWzA2JC9oA3zDbjdAxqEVKSLmS6MrT9qgEJq56K1r7y6zWD
         1R8D1ChRWOeGG/sQd3gjL3IglcD6Z4c6oS2O+oqc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Joel Stanley <joel@jms.id.au>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: [PATCH 4.14 068/115] powerpc: remove old GCC version checks
Date:   Wed, 15 May 2019 12:55:48 +0200
Message-Id: <20190515090704.423340712@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090659.123121100@linuxfoundation.org>
References: <20190515090659.123121100@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f2910f0e6835339e6ce82cef22fa15718b7e3bfa ]

GCC 4.6 is the minimum supported now.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 arch/powerpc/Makefile | 31 ++-----------------------------
 1 file changed, 2 insertions(+), 29 deletions(-)

diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
index 7452e50f4d1f8..0f04c878113ef 100644
--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -396,36 +396,9 @@ archprepare: checkbin
 # to stdout and these checks are run even on install targets.
 TOUT	:= .tmp_gas_check
 
-# Check gcc and binutils versions:
-# - gcc-3.4 and binutils-2.14 are a fatal combination
-# - Require gcc 4.0 or above on 64-bit
-# - gcc-4.2.0 has issues compiling modules on 64-bit
+# Check toolchain versions:
+# - gcc-4.6 is the minimum kernel-wide version so nothing required.
 checkbin:
-	@if test "$(cc-name)" != "clang" \
-	    && test "$(cc-version)" = "0304" ; then \
-		if ! /bin/echo mftb 5 | $(AS) -v -mppc -many -o $(TOUT) >/dev/null 2>&1 ; then \
-			echo -n '*** ${VERSION}.${PATCHLEVEL} kernels no longer build '; \
-			echo 'correctly with gcc-3.4 and your version of binutils.'; \
-			echo '*** Please upgrade your binutils or downgrade your gcc'; \
-			false; \
-		fi ; \
-	fi
-	@if test "$(cc-name)" != "clang" \
-	    && test "$(cc-version)" -lt "0400" \
-	    && test "x${CONFIG_PPC64}" = "xy" ; then \
-                echo -n "Sorry, GCC v4.0 or above is required to build " ; \
-                echo "the 64-bit powerpc kernel." ; \
-                false ; \
-        fi
-	@if test "$(cc-name)" != "clang" \
-	    && test "$(cc-fullversion)" = "040200" \
-	    && test "x${CONFIG_MODULES}${CONFIG_PPC64}" = "xyy" ; then \
-		echo -n '*** GCC-4.2.0 cannot compile the 64-bit powerpc ' ; \
-		echo 'kernel with modules enabled.' ; \
-		echo -n '*** Please use a different GCC version or ' ; \
-		echo 'disable kernel modules' ; \
-		false ; \
-	fi
 	@if test "x${CONFIG_CPU_LITTLE_ENDIAN}" = "xy" \
 	    && $(LD) --version | head -1 | grep ' 2\.24$$' >/dev/null ; then \
 		echo -n '*** binutils 2.24 miscompiles weak symbols ' ; \
-- 
2.20.1



