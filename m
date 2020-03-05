Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A98CB17AC8A
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 18:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbgCEROh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 12:14:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:40842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727662AbgCEROg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Mar 2020 12:14:36 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A61A024655;
        Thu,  5 Mar 2020 17:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583428475;
        bh=q1ZJfqZkpoH40GqRMjB4mYTdZMps4c9CnvYPqZJ7INI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TVnRuwvR1Vxxwi/sWnCaApzmlaWt2rJoJ7T41Kbwd0f/gDbUBYnf+dS67VQyMy7LV
         lG++qds8jJvFADg5fzkA8Cu4sAr5TUe89/SSutiOipOnYZFK+Iaz9pS553NngOthsW
         hTfO3JK+agPXgJCOBGTpMvDRhf3w7othN6Iv3dug=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Victor Kamensky <kamensky@cisco.com>,
        Paul Burton <paulburton@kernel.org>,
        linux-mips@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        bruce.ashfield@gmail.com, richard.purdie@linuxfoundation.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 12/58] mips: vdso: add build time check that no 'jalr t9' calls left
Date:   Thu,  5 Mar 2020 12:13:33 -0500
Message-Id: <20200305171420.29595-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200305171420.29595-1-sashal@kernel.org>
References: <20200305171420.29595-1-sashal@kernel.org>
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

