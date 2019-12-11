Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 191BB11B77C
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731097AbfLKPMU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:12:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:33684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731088AbfLKPMU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:12:20 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 779C72173E;
        Wed, 11 Dec 2019 15:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077139;
        bh=HWaKh99dgegX7bql7xsnkCTH6WXDUuvRMl6i0onbLW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a/J9yW1qPZgW+2DNC2OQSrS7jfN+aC5k1UKlIc/X7s7XOHnVQWwfdMLXh4y41NV70
         76EV6k8T4Ds0oy/kEBdurT5Sa/bg2r0iA95P7KrhIRsUmyyIkBjENs8a75aYue3RAJ
         rZaUSJrTNqRkY1fADVmXSFz8wktse5OPwQdcmCdg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linux-api@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 026/134] selftests/powerpc: Fixup clobbers for TM tests
Date:   Wed, 11 Dec 2019 10:10:02 -0500
Message-Id: <20191211151150.19073-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211151150.19073-1-sashal@kernel.org>
References: <20191211151150.19073-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit a02cbc7ffe529ed58b6bbe54652104fc2c88bd77 ]

Some of our TM (Transactional Memory) tests, list "r1" (the stack
pointer) as a clobbered register.

GCC >= 9 doesn't accept this, and the build breaks:

  ptrace-tm-spd-tar.c: In function 'tm_spd_tar':
  ptrace-tm-spd-tar.c:31:2: error: listing the stack pointer register 'r1' in a clobber list is deprecated [-Werror=deprecated]
     31 |  asm __volatile__(
        |  ^~~
  ptrace-tm-spd-tar.c:31:2: note: the value of the stack pointer after an 'asm' statement must be the same as it was before the statement

We do have some fairly large inline asm blocks in these tests, and
some of them do change the value of r1. However they should all return
to C with the value in r1 restored, so I think it's legitimate to say
r1 is not clobbered.

As Segher points out, the r1 clobbers may have been added because of
the use of `or 1,1,1`, however that doesn't actually clobber r1.

Segher also points out that some of these tests do clobber LR, because
they call functions, and that is not listed in the clobbers, so add
that where appropriate.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20191029095324.14669-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/powerpc/ptrace/ptrace-tm-spd-tar.c | 2 +-
 tools/testing/selftests/powerpc/ptrace/ptrace-tm-spd-vsx.c | 4 ++--
 tools/testing/selftests/powerpc/ptrace/ptrace-tm-tar.c     | 2 +-
 tools/testing/selftests/powerpc/ptrace/ptrace-tm-vsx.c     | 4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/powerpc/ptrace/ptrace-tm-spd-tar.c b/tools/testing/selftests/powerpc/ptrace/ptrace-tm-spd-tar.c
index 25e23e73c72e6..2ecfa1158e2bc 100644
--- a/tools/testing/selftests/powerpc/ptrace/ptrace-tm-spd-tar.c
+++ b/tools/testing/selftests/powerpc/ptrace/ptrace-tm-spd-tar.c
@@ -73,7 +73,7 @@ trans:
 		[sprn_texasr]"i"(SPRN_TEXASR), [tar_1]"i"(TAR_1),
 		[dscr_1]"i"(DSCR_1), [tar_2]"i"(TAR_2), [dscr_2]"i"(DSCR_2),
 		[tar_3]"i"(TAR_3), [dscr_3]"i"(DSCR_3)
-		: "memory", "r0", "r1", "r3", "r4", "r5", "r6"
+		: "memory", "r0", "r3", "r4", "r5", "r6", "lr"
 		);
 
 	/* TM failed, analyse */
diff --git a/tools/testing/selftests/powerpc/ptrace/ptrace-tm-spd-vsx.c b/tools/testing/selftests/powerpc/ptrace/ptrace-tm-spd-vsx.c
index f603fe5a445b3..6f7fb51f08099 100644
--- a/tools/testing/selftests/powerpc/ptrace/ptrace-tm-spd-vsx.c
+++ b/tools/testing/selftests/powerpc/ptrace/ptrace-tm-spd-vsx.c
@@ -74,8 +74,8 @@ trans:
 		"3: ;"
 		: [res] "=r" (result), [texasr] "=r" (texasr)
 		: [sprn_texasr] "i"  (SPRN_TEXASR)
-		: "memory", "r0", "r1", "r3", "r4",
-		"r7", "r8", "r9", "r10", "r11"
+		: "memory", "r0", "r3", "r4",
+		  "r7", "r8", "r9", "r10", "r11", "lr"
 		);
 
 	if (result) {
diff --git a/tools/testing/selftests/powerpc/ptrace/ptrace-tm-tar.c b/tools/testing/selftests/powerpc/ptrace/ptrace-tm-tar.c
index e0d37f07bdeba..46ef378a15ecc 100644
--- a/tools/testing/selftests/powerpc/ptrace/ptrace-tm-tar.c
+++ b/tools/testing/selftests/powerpc/ptrace/ptrace-tm-tar.c
@@ -62,7 +62,7 @@ trans:
 		[sprn_ppr]"i"(SPRN_PPR), [sprn_texasr]"i"(SPRN_TEXASR),
 		[tar_1]"i"(TAR_1), [dscr_1]"i"(DSCR_1), [tar_2]"i"(TAR_2),
 		[dscr_2]"i"(DSCR_2), [cptr1] "b" (&cptr[1])
-		: "memory", "r0", "r1", "r3", "r4", "r5", "r6"
+		: "memory", "r0", "r3", "r4", "r5", "r6"
 		);
 
 	/* TM failed, analyse */
diff --git a/tools/testing/selftests/powerpc/ptrace/ptrace-tm-vsx.c b/tools/testing/selftests/powerpc/ptrace/ptrace-tm-vsx.c
index 8027457b97b7c..70ca01234f79c 100644
--- a/tools/testing/selftests/powerpc/ptrace/ptrace-tm-vsx.c
+++ b/tools/testing/selftests/powerpc/ptrace/ptrace-tm-vsx.c
@@ -62,8 +62,8 @@ trans:
 		"3: ;"
 		: [res] "=r" (result), [texasr] "=r" (texasr)
 		: [sprn_texasr] "i"  (SPRN_TEXASR), [cptr1] "b" (&cptr[1])
-		: "memory", "r0", "r1", "r3", "r4",
-		"r7", "r8", "r9", "r10", "r11"
+		: "memory", "r0", "r3", "r4",
+		  "r7", "r8", "r9", "r10", "r11", "lr"
 		);
 
 	if (result) {
-- 
2.20.1

