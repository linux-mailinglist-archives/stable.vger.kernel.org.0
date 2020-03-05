Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83D8E17AD0C
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 18:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbgCERN2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 12:13:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:38908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726650AbgCERN1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Mar 2020 12:13:27 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 016EC20870;
        Thu,  5 Mar 2020 17:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583428407;
        bh=5iPR7XCLsazQnaDrcx+zT2BH4J3il51Isf+Aw05JtG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PI8C1xyCw6UrWmS9ffswNMbPa4dKTI4bKgFUYA8nNOnxn+70/Y6WAiw43AcBm2aUb
         ljHX5rAUPLAI8EHHfU4NVPoVlkBUG56w3OSmv+s3mRVODN77o5exRm3iOE3X0inLOw
         2FGQX4isncVOy9OpOEgm4hRkYbt1eh3tK8Pez8mE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Victor Kamensky <kamensky@cisco.com>,
        Paul Burton <paulburton@kernel.org>,
        linux-mips@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        bruce.ashfield@gmail.com, richard.purdie@linuxfoundation.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.5 12/67] mips: vdso: add build time check that no 'jalr t9' calls left
Date:   Thu,  5 Mar 2020 12:12:13 -0500
Message-Id: <20200305171309.29118-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200305171309.29118-1-sashal@kernel.org>
References: <20200305171309.29118-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index e8585a22b925c..bfb65b2d57c7f 100644
--- a/arch/mips/vdso/Makefile
+++ b/arch/mips/vdso/Makefile
@@ -93,12 +93,18 @@ GCOV_PROFILE := n
 UBSAN_SANITIZE := n
 KCOV_INSTRUMENT := n
 
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

