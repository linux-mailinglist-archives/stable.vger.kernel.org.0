Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1EB18B5DB
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:22:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730056AbgCSNWJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:22:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:47148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729778AbgCSNWI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:22:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE71E208D6;
        Thu, 19 Mar 2020 13:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624127;
        bh=q1ZJfqZkpoH40GqRMjB4mYTdZMps4c9CnvYPqZJ7INI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tbI5v9DDcEhtYaRq21+3L/HA4G4zaeJbTpRgJmtSzjLZxAwcBiD+QOeufbdWu6D8y
         QV9buRFBq28KIvwgZRPGw+YjeSNEm/S6GUrGPItSslgsEAZLWNCWubU166owBpyxXt
         X5Xde+U1tjCeQYo1M/FbyZ2rFnphv4Gf6wyGhDtw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Victor Kamensky <kamensky@cisco.com>,
        Paul Burton <paulburton@kernel.org>,
        linux-mips@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        bruce.ashfield@gmail.com, richard.purdie@linuxfoundation.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 16/60] mips: vdso: add build time check that no jalr t9 calls left
Date:   Thu, 19 Mar 2020 14:03:54 +0100
Message-Id: <20200319123924.238277162@linuxfoundation.org>
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

[ Upstream commit 976c23af3ee5bd3447a7bfb6c356ceb4acf264a6 ]

vdso shared object cannot have GOT based PIC 'jalr t9' calls
because nobody set GOT table in vdso. Contributing into vdso
.o files are compiled in PIC mode and as result for internal
static functions calls compiler will generate 'jalr t9'
instructions. Those are supposed to be converted into PC
relative 'bal' calls by linker when relocation are processed.

Mips global GOT entries do have dynamic relocations and they
will be caught by cmd_vdso_check Makefile rule. Static PIC
calls go through mips local GOT entries that do not have
dynamic relocations. For those 'jalr t9' calls could be present
but without dynamic relocations and they need to be converted
to 'bal' calls by linker.

Add additional build time check to make sure that no 'jalr t9'
slip through because of some toolchain misconfiguration that
prevents 'jalr t9' to 'bal' conversion.

Signed-off-by: Victor Kamensky <kamensky@cisco.com>
Signed-off-by: Paul Burton <paulburton@kernel.org>
Cc: linux-mips@vger.kernel.org
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: James Hogan <jhogan@kernel.org>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: bruce.ashfield@gmail.com
Cc: richard.purdie@linuxfoundation.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/vdso/Makefile | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/mips/vdso/Makefile b/arch/mips/vdso/Makefile
index b6b1eb638fb14..08c835d48520b 100644
--- a/arch/mips/vdso/Makefile
+++ b/arch/mips/vdso/Makefile
@@ -92,12 +92,18 @@ CFLAGS_REMOVE_vdso.o = -pg
 GCOV_PROFILE := n
 UBSAN_SANITIZE := n
 
+# Check that we don't have PIC 'jalr t9' calls left
+quiet_cmd_vdso_mips_check = VDSOCHK $@
+      cmd_vdso_mips_check = if $(OBJDUMP) --disassemble $@ | egrep -h "jalr.*t9" > /dev/null; \
+		       then (echo >&2 "$@: PIC 'jalr t9' calls are not supported"; \
+			     rm -f $@; /bin/false); fi
+
 #
 # Shared build commands.
 #
 
 quiet_cmd_vdsold_and_vdso_check = LD      $@
-      cmd_vdsold_and_vdso_check = $(cmd_vdsold); $(cmd_vdso_check)
+      cmd_vdsold_and_vdso_check = $(cmd_vdsold); $(cmd_vdso_check); $(cmd_vdso_mips_check)
 
 quiet_cmd_vdsold = VDSO    $@
       cmd_vdsold = $(CC) $(c_flags) $(VDSO_LDFLAGS) \
-- 
2.20.1



