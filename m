Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6168C19AFE5
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387428AbgDAQWE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:22:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:45040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387434AbgDAQWD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:22:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF37020658;
        Wed,  1 Apr 2020 16:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758123;
        bh=r+e9qHmInOQJ47PfeFDi1mAZiHipiVuBXvckxLYW3bU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fu5I0QpEMWlh+X+u4JfRvUOkQ+nxHPJN5G1Jhw+N64uY2/Lb6PyReW7x3mmR1z49F
         vb1GlDBDTRlAYxqPAY9ZMH/noB7GMdCyw6KSgSh9ZPsBfFDTvenFueXZ0TIO0pCbeJ
         b8v7CSBV8vQyyOTtgbjPbwg1B1tJ/ntRA4idXj8w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        Ilie Halip <ilie.halip@gmail.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.4 19/27] arm64: alternative: fix build with clang integrated assembler
Date:   Wed,  1 Apr 2020 18:17:47 +0200
Message-Id: <20200401161431.059776937@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161414.352722470@linuxfoundation.org>
References: <20200401161414.352722470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilie Halip <ilie.halip@gmail.com>

commit 6f5459da2b8736720afdbd67c4bd2d1edba7d0e3 upstream.

Building an arm64 defconfig with clang's integrated assembler, this error
occurs:
    <instantiation>:2:2: error: unrecognized instruction mnemonic
     _ASM_EXTABLE 9999b, 9f
     ^
    arch/arm64/mm/cache.S:50:1: note: while in macro instantiation
    user_alt 9f, "dc cvau, x4", "dc civac, x4", 0
    ^

While GNU as seems fine with case-sensitive macro instantiations, clang
doesn't, so use the actual macro name (_asm_extable) as in the rest of
the file.

Also checked that the generated assembly matches the GCC output.

Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Fixes: 290622efc76e ("arm64: fix "dc cvau" cache operation on errata-affected core")
Link: https://github.com/ClangBuiltLinux/linux/issues/924
Signed-off-by: Ilie Halip <ilie.halip@gmail.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/asm/alternative.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/include/asm/alternative.h
+++ b/arch/arm64/include/asm/alternative.h
@@ -221,7 +221,7 @@ alternative_endif
 
 .macro user_alt, label, oldinstr, newinstr, cond
 9999:	alternative_insn "\oldinstr", "\newinstr", \cond
-	_ASM_EXTABLE 9999b, \label
+	_asm_extable 9999b, \label
 .endm
 
 /*


