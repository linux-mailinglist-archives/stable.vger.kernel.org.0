Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC90A12F195
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 00:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727352AbgABWMB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:12:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:50736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726170AbgABWMA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:12:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07E5221582;
        Thu,  2 Jan 2020 22:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003119;
        bh=IdDUBqAqVgl8ZMFxB7Nj1Rorr+DJaeIFP02b/wDQi2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e9H3S7Uev4aF5ExXamBa/EdMH5yx6tGxaZ2ayMTVxIwDKZpyj9YMqDaTllubGBw13
         LDNirvTCSMbDAY6fQF98FjaPJCi1Jdq7uv31Xyenv+45nr2XzGnoQsQKDLhgTdg9gv
         pAO1/ocgfk5hmU2JduQuGF1yyN2yx13sgKYebsmE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 027/191] selftests/powerpc: Fixup clobbers for TM tests
Date:   Thu,  2 Jan 2020 23:05:09 +0100
Message-Id: <20200102215832.881707221@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 25e23e73c72e..2ecfa1158e2b 100644
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
index f603fe5a445b..6f7fb51f0809 100644
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
index e0d37f07bdeb..46ef378a15ec 100644
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
index 8027457b97b7..70ca01234f79 100644
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



