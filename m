Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54E76CAB57
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387734AbfJCRUk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 13:20:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:44704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389584AbfJCQSO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:18:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB5DD20700;
        Thu,  3 Oct 2019 16:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119493;
        bh=J857V+s2eCUvaCpjWd7tdKg18VSQm5KUn4SWhVl283w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gqgvqyqbYVOnLsEZsjq1Ljwm17LRZg00qHPrPaOREa2UcHhDv4za92LlZWSFYwkUO
         U9olaUWRYhnaDmKjbA3xSbkZh+fpeztjaLdCqL5ueQqQqJZ7NJSU2OLS8ARe5Hde2p
         WC5rfVJS7hhUkkGsWoFqJugMXOBTxPyj7YKQK0xY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 086/211] tools headers: Fixup bitsperlong per arch includes
Date:   Thu,  3 Oct 2019 17:52:32 +0200
Message-Id: <20191003154506.593413964@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
References: <20191003154447.010950442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 42fc2e9ef9603a7948aaa4ffd8dfb94b30294ad8 ]

We were getting the file by luck, from one of the paths in -I, fix it to
get it from the proper place:

  $ cd tools/include/uapi/asm/
  [acme@quaco asm]$ grep include bitsperlong.h
  #include "../../arch/x86/include/uapi/asm/bitsperlong.h"
  #include "../../arch/arm64/include/uapi/asm/bitsperlong.h"
  #include "../../arch/powerpc/include/uapi/asm/bitsperlong.h"
  #include "../../arch/s390/include/uapi/asm/bitsperlong.h"
  #include "../../arch/sparc/include/uapi/asm/bitsperlong.h"
  #include "../../arch/mips/include/uapi/asm/bitsperlong.h"
  #include "../../arch/ia64/include/uapi/asm/bitsperlong.h"
  #include "../../arch/riscv/include/uapi/asm/bitsperlong.h"
  #include "../../arch/alpha/include/uapi/asm/bitsperlong.h"
  #include <asm-generic/bitsperlong.h>
  $ ls -la ../../arch/x86/include/uapi/asm/bitsperlong.h
  ls: cannot access '../../arch/x86/include/uapi/asm/bitsperlong.h': No such file or directory
  $ ls -la ../../../arch/*/include/uapi/asm/bitsperlong.h
  -rw-rw-r--. 1 237 ../../../arch/alpha/include/uapi/asm/bitsperlong.h
  -rw-rw-r--. 1 841 ../../../arch/arm64/include/uapi/asm/bitsperlong.h
  -rw-rw-r--. 1 966 ../../../arch/hexagon/include/uapi/asm/bitsperlong.h
  -rw-rw-r--. 1 234 ../../../arch/ia64/include/uapi/asm/bitsperlong.h
  -rw-rw-r--. 1 100 ../../../arch/microblaze/include/uapi/asm/bitsperlong.h
  -rw-rw-r--. 1 244 ../../../arch/mips/include/uapi/asm/bitsperlong.h
  -rw-rw-r--. 1 352 ../../../arch/parisc/include/uapi/asm/bitsperlong.h
  -rw-rw-r--. 1 312 ../../../arch/powerpc/include/uapi/asm/bitsperlong.h
  -rw-rw-r--. 1 353 ../../../arch/riscv/include/uapi/asm/bitsperlong.h
  -rw-rw-r--. 1 292 ../../../arch/s390/include/uapi/asm/bitsperlong.h
  -rw-rw-r--. 1 323 ../../../arch/sparc/include/uapi/asm/bitsperlong.h
  -rw-rw-r--. 1 320 ../../../arch/x86/include/uapi/asm/bitsperlong.h
  $

Found while fixing some other problem, before it was escaping the
tools/ chroot and using stuff in the kernel sources:

    CC       /tmp/build/perf/util/find_bit.o
In file included from /git/linux/tools/include/../../arch/x86/include/uapi/asm/bitsperlong.h:11,
                 from /git/linux/tools/include/uapi/asm/bitsperlong.h:3,
                 from /git/linux/tools/include/linux/bits.h:6,
                 from /git/linux/tools/include/linux/bitops.h:13,
                 from ../lib/find_bit.c:17:

  # cd /git/linux/tools/include/../../arch/x86/include/uapi/asm/
  # pwd
  /git/linux/arch/x86/include/uapi/asm
  #

Now it is getting the one we want it to, i.e. the one inside tools/:

    CC       /tmp/build/perf/util/find_bit.o
  In file included from /git/linux/tools/arch/x86/include/uapi/asm/bitsperlong.h:11,
                   from /git/linux/tools/include/linux/bits.h:6,
                   from /git/linux/tools/include/linux/bitops.h:13,

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: https://lkml.kernel.org/n/tip-8f8cfqywmf6jk8a3ucr0ixhu@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/uapi/asm/bitsperlong.h | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/tools/include/uapi/asm/bitsperlong.h b/tools/include/uapi/asm/bitsperlong.h
index 57aaeaf8e1920..edba4d93e9e6a 100644
--- a/tools/include/uapi/asm/bitsperlong.h
+++ b/tools/include/uapi/asm/bitsperlong.h
@@ -1,22 +1,22 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #if defined(__i386__) || defined(__x86_64__)
-#include "../../arch/x86/include/uapi/asm/bitsperlong.h"
+#include "../../../arch/x86/include/uapi/asm/bitsperlong.h"
 #elif defined(__aarch64__)
-#include "../../arch/arm64/include/uapi/asm/bitsperlong.h"
+#include "../../../arch/arm64/include/uapi/asm/bitsperlong.h"
 #elif defined(__powerpc__)
-#include "../../arch/powerpc/include/uapi/asm/bitsperlong.h"
+#include "../../../arch/powerpc/include/uapi/asm/bitsperlong.h"
 #elif defined(__s390__)
-#include "../../arch/s390/include/uapi/asm/bitsperlong.h"
+#include "../../../arch/s390/include/uapi/asm/bitsperlong.h"
 #elif defined(__sparc__)
-#include "../../arch/sparc/include/uapi/asm/bitsperlong.h"
+#include "../../../arch/sparc/include/uapi/asm/bitsperlong.h"
 #elif defined(__mips__)
-#include "../../arch/mips/include/uapi/asm/bitsperlong.h"
+#include "../../../arch/mips/include/uapi/asm/bitsperlong.h"
 #elif defined(__ia64__)
-#include "../../arch/ia64/include/uapi/asm/bitsperlong.h"
+#include "../../../arch/ia64/include/uapi/asm/bitsperlong.h"
 #elif defined(__riscv)
-#include "../../arch/riscv/include/uapi/asm/bitsperlong.h"
+#include "../../../arch/riscv/include/uapi/asm/bitsperlong.h"
 #elif defined(__alpha__)
-#include "../../arch/alpha/include/uapi/asm/bitsperlong.h"
+#include "../../../arch/alpha/include/uapi/asm/bitsperlong.h"
 #else
 #include <asm-generic/bitsperlong.h>
 #endif
-- 
2.20.1



