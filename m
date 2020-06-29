Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA7820DD37
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbgF2Shm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 14:37:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:56780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726792AbgF2Sfu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6F792474B;
        Mon, 29 Jun 2020 15:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444067;
        bh=nxQPReT5CsxhTe9XvxHds6kja+wQYf7gUZh3P42/gH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vTTdXl187cHTHEBzMIv5Bt/Wu29uBMTKeXM8wB0+YiDAW75iQveNjGszAGEca65WF
         yln9EnQnTmoyTc+LIj4KOGbUQimI752ygXP/NfzY6lX253nJTNg92e1OmLc+0qrnma
         w3t0us216QmYJn3w2Ac3tHttXQ6Og4eARpTIuXZU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Harish <harish@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 176/265] selftests/powerpc: Fix build failure in ebb tests
Date:   Mon, 29 Jun 2020 11:16:49 -0400
Message-Id: <20200629151818.2493727-177-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harish <harish@linux.ibm.com>

[ Upstream commit 896066aa0685af3434637998b76218c2045142a8 ]

We use OUTPUT directory as TMPOUT for checking no-pie option.

Since commit f2f02ebd8f38 ("kbuild: improve cc-option to clean up all
temporary files") when building powerpc/ from selftests directory, the
OUTPUT directory points to powerpc/pmu/ebb/ and gets removed when
checking for -no-pie option in try-run routine, subsequently build
fails with the following:

  $ make -C powerpc
  ...
  TARGET=ebb; BUILD_TARGET=$OUTPUT/$TARGET; mkdir -p $BUILD_TARGET; make OUTPUT=$BUILD_TARGET -k -C $TARGET all
  make[2]: Entering directory '/home/linux-master/tools/testing/selftests/powerpc/pmu/ebb'
  make[2]: *** No rule to make target 'Makefile'.
  make[2]: Failed to remake makefile 'Makefile'.
  make[2]: *** No rule to make target 'ebb.c', needed by '/home/linux-master/tools/testing/selftests/powerpc/pmu/ebb/reg_access_test'.
  make[2]: *** No rule to make target 'ebb_handler.S', needed by '/home/linux-master/tools/testing/selftests/powerpc/pmu/ebb/reg_access_test'.
  make[2]: *** No rule to make target 'trace.c', needed by '/home/linux-master/tools/testing/selftests/powerpc/pmu/ebb/reg_access_test'.
  make[2]: *** No rule to make target 'busy_loop.S', needed by '/home/linux-master/tools/testing/selftests/powerpc/pmu/ebb/reg_access_test'.
  make[2]: Target 'all' not remade because of errors.

Fix this by adding a suffix to the OUTPUT directory so that the
failure is avoided.

Fixes: 9686813f6e9d ("selftests/powerpc: Fix try-run when source tree is not writable")
Signed-off-by: Harish <harish@linux.ibm.com>
[mpe: Mention that commit that triggered the breakage]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200625165721.264904-1-harish@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/powerpc/pmu/ebb/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/powerpc/pmu/ebb/Makefile b/tools/testing/selftests/powerpc/pmu/ebb/Makefile
index ca35dd8848b0a..af3df79d8163f 100644
--- a/tools/testing/selftests/powerpc/pmu/ebb/Makefile
+++ b/tools/testing/selftests/powerpc/pmu/ebb/Makefile
@@ -7,7 +7,7 @@ noarg:
 # The EBB handler is 64-bit code and everything links against it
 CFLAGS += -m64
 
-TMPOUT = $(OUTPUT)/
+TMPOUT = $(OUTPUT)/TMPDIR/
 # Toolchains may build PIE by default which breaks the assembly
 no-pie-option := $(call try-run, echo 'int main() { return 0; }' | \
         $(CC) -Werror $(KBUILD_CPPFLAGS) $(CC_OPTION_CFLAGS) -no-pie -x c - -o "$$TMP", -no-pie)
-- 
2.25.1

