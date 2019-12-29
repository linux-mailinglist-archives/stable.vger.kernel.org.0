Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B148412C6E2
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732090AbfL2Rva (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:51:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:36810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731771AbfL2Rv2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:51:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C21820718;
        Sun, 29 Dec 2019 17:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641887;
        bh=xlc7THDxqHOy7omFyY3ozdfR6uXdFyOw7hRsO3wCTyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1tAF5pXJqwcjxBkfp6g0F4nneIQcSRUirygO0C+BqikVjkQytsOy61Mi8LRf1bxp7
         Bd9KNRztvlOnHcabRnPzEVn0DctZmn6D5XPyp4rMRFgzn53bPferUhcRP3aWHn0ztu
         rjdTpq+z/+9hBjh5UzZXETsDEosJzNRLK0HgYU00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 253/434] perf tools: Fix cross compile for ARM64
Date:   Sun, 29 Dec 2019 18:25:06 +0100
Message-Id: <20191229172718.726560429@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Garry <john.garry@huawei.com>

[ Upstream commit 71f699078b154fcb1c9162fd0208ada9ce532ffc ]

Currently when cross compiling perf tool for ARM64 on my x86 machine I
get this error:

  arch/arm64/util/sym-handling.c:9:10: fatal error: gelf.h: No such file or directory
   #include <gelf.h>

For the build, libelf is reported off:

  Auto-detecting system features:
  ...
  ...                        libelf: [ OFF ]

Indeed, test-libelf is not built successfully:

  more ./build/feature/test-libelf.make.output
  test-libelf.c:2:10: fatal error: libelf.h: No such file or directory
   #include <libelf.h>
          ^~~~~~~~~~
  compilation terminated.

I have no such problems natively compiling on ARM64, and I did not
previously have this issue for cross compiling. Fix by relocating the
gelf.h include.

Signed-off-by: John Garry <john.garry@huawei.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Link: http://lore.kernel.org/lkml/1573045254-39833-1-git-send-email-john.garry@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/arch/arm64/util/sym-handling.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/arch/arm64/util/sym-handling.c b/tools/perf/arch/arm64/util/sym-handling.c
index 5df788985130..8dfa3e5229f1 100644
--- a/tools/perf/arch/arm64/util/sym-handling.c
+++ b/tools/perf/arch/arm64/util/sym-handling.c
@@ -6,9 +6,10 @@
 
 #include "symbol.h" // for the elf__needs_adjust_symbols() prototype
 #include <stdbool.h>
-#include <gelf.h>
 
 #ifdef HAVE_LIBELF_SUPPORT
+#include <gelf.h>
+
 bool elf__needs_adjust_symbols(GElf_Ehdr ehdr)
 {
 	return ehdr.e_type == ET_EXEC ||
-- 
2.20.1



