Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91241C3B02
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 18:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730508AbfJAQlB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 12:41:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:52402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730503AbfJAQlA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 12:41:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0875205C9;
        Tue,  1 Oct 2019 16:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569948060;
        bh=kgzfr/vRrO0hm5BZsVAdICd2cayTt5lbLSD11QS0AvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H0ivQ6sx74z70wmqZ5/5DERn38fIJkPL0OfLTz/gp1y2lLH2D2k9GJo4UzI0dumBq
         Zd3V/WDe2GLztSwXySitnQQBDpApvFmVhHw2EZw0bdxdWT6tYegLEaGnDs5r5H4jyt
         DTSpiM3DcgQ81HBCkXvLLDk/ApDKtuOHTy4VZwfk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnaldo Carvalho de Melo <acme@redhat.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 59/71] perf unwind: Fix libunwind build failure on i386 systems
Date:   Tue,  1 Oct 2019 12:39:09 -0400
Message-Id: <20191001163922.14735-59-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001163922.14735-1-sashal@kernel.org>
References: <20191001163922.14735-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 26acf400d2dcc72c7e713e1f55db47ad92010cc2 ]

Naresh Kamboju reported, that on the i386 build pr_err()
doesn't get defined properly due to header ordering:

  perf-in.o: In function `libunwind__x86_reg_id':
  tools/perf/util/libunwind/../../arch/x86/util/unwind-libunwind.c:109:
  undefined reference to `pr_err'

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/arch/x86/util/unwind-libunwind.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/arch/x86/util/unwind-libunwind.c b/tools/perf/arch/x86/util/unwind-libunwind.c
index 05920e3edf7a7..47357973b55b2 100644
--- a/tools/perf/arch/x86/util/unwind-libunwind.c
+++ b/tools/perf/arch/x86/util/unwind-libunwind.c
@@ -1,11 +1,11 @@
 // SPDX-License-Identifier: GPL-2.0
 
 #include <errno.h>
+#include "../../util/debug.h"
 #ifndef REMOTE_UNWIND_LIBUNWIND
 #include <libunwind.h>
 #include "perf_regs.h"
 #include "../../util/unwind.h"
-#include "../../util/debug.h"
 #endif
 
 #ifdef HAVE_ARCH_X86_64_SUPPORT
-- 
2.20.1

