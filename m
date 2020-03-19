Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7F8518B6F2
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728263AbgCSNaM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:30:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:46986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728927AbgCSNWC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:22:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A54420724;
        Thu, 19 Mar 2020 13:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624120;
        bh=2+JddXm05lMAvMt7a5HtaUlUsXMzX06xKsrUO7VAvF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ye9CSkUKT/3f+pmUOp0MLi/8cCcc5kR+VhrkJIONf/x22DSMN/CB9qO9XNX1ERdT1
         cEGjXqNoXmfHk52OPIc8lUUgI3hfpE00A26hebthUwePtFCwB5i9nppcZ/5Grc0Jbh
         aVlKP9zyQWKQO5uIm51PS4NmLMYJLrmf1npNKQGg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bruce Ashfield <bruce.ashfield@gmail.com>,
        Victor Kamensky <kamensky@cisco.com>,
        Paul Burton <paulburton@kernel.org>,
        linux-mips@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        richard.purdie@linuxfoundation.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 14/60] mips: vdso: fix jalr t9 crash in vdso code
Date:   Thu, 19 Mar 2020 14:03:52 +0100
Message-Id: <20200319123923.535642309@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123919.441695203@linuxfoundation.org>
References: <20200319123919.441695203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Victor Kamensky <kamensky@cisco.com>

[ Upstream commit d3f703c4359ff06619b2322b91f69710453e6b6d ]

Observed that when kernel is built with Yocto mips64-poky-linux-gcc,
and mips64-poky-linux-gnun32-gcc toolchain, resulting vdso contains
'jalr t9' instructions in its code and since in vdso case nobody
sets GOT table code crashes when instruction reached. On other hand
observed that when kernel is built mips-poky-linux-gcc toolchain, the
same 'jalr t9' instruction are replaced with PC relative function
calls using 'bal' instructions.

The difference boils down to -mrelax-pic-calls and -mexplicit-relocs
gcc options that gets different default values depending on gcc
target triplets and corresponding binutils. -mrelax-pic-calls got
enabled by default only in mips-poky-linux-gcc case. MIPS binutils
ld relies on R_MIPS_JALR relocation to convert 'jalr t9' into 'bal'
and such relocation is generated only if -mrelax-pic-calls option
is on.

Please note 'jalr t9' conversion to 'bal' can happen only to static
functions. These static PIC calls use mips local GOT entries that
are supposed to be filled with start of DSO value by run-time linker
(missing in VDSO case) and they do not have dynamic relocations.
Global mips GOT entries must have dynamic relocations and they should
be prevented by cmd_vdso_check Makefile rule.

Solution call out -mrelax-pic-calls and -mexplicit-relocs options
explicitly while compiling MIPS vdso code. That would get correct
and consistent between different toolchains behaviour.

Reported-by: Bruce Ashfield <bruce.ashfield@gmail.com>
Signed-off-by: Victor Kamensky <kamensky@cisco.com>
Signed-off-by: Paul Burton <paulburton@kernel.org>
Cc: linux-mips@vger.kernel.org
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: James Hogan <jhogan@kernel.org>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: richard.purdie@linuxfoundation.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/vdso/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/vdso/Makefile b/arch/mips/vdso/Makefile
index 996a934ece7d6..3fa4bbe1bae53 100644
--- a/arch/mips/vdso/Makefile
+++ b/arch/mips/vdso/Makefile
@@ -29,6 +29,7 @@ endif
 cflags-vdso := $(ccflags-vdso) \
 	$(filter -W%,$(filter-out -Wa$(comma)%,$(KBUILD_CFLAGS))) \
 	-O3 -g -fPIC -fno-strict-aliasing -fno-common -fno-builtin -G 0 \
+	-mrelax-pic-calls -mexplicit-relocs \
 	-fno-stack-protector -fno-jump-tables -DDISABLE_BRANCH_PROFILING \
 	$(call cc-option, -fno-asynchronous-unwind-tables) \
 	$(call cc-option, -fno-stack-protector)
-- 
2.20.1



