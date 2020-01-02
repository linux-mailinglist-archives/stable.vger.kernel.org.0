Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F43E12F081
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728754AbgABWVL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:21:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:39786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728674AbgABWVJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:21:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABE9120866;
        Thu,  2 Jan 2020 22:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003668;
        bh=miIK85yk0a1NO2PCsbAMRy5Kn05eMMdekSaRaXVId84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XlduCR3gvf9kqvzNgV26nrCleyfa4s8imkaXonhhUR4X9kRBsrP/uT4fv+3teWoM0
         1Uem163mpZpaANooshivnf1hluSQj3wuoSRuoBayrDpsBtRsT3ZRXV7MimQQ1zVn5w
         oKxCQiSCgwstvoNY4UjgFSLEY2/gQPhdhMHI4PnY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 065/114] perf regs: Make perf_reg_name() return "unknown" instead of NULL
Date:   Thu,  2 Jan 2020 23:07:17 +0100
Message-Id: <20200102220035.632712594@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220029.183913184@linuxfoundation.org>
References: <20200102220029.183913184@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 5b596e0ff0e1852197d4c82d3314db5e43126bf7 ]

To avoid breaking the build on arches where this is not wired up, at
least all the other features should be made available and when using
this specific routine, the "unknown" should point the user/developer to
the need to wire this up on this particular hardware architecture.

Detected in a container mipsel debian cross build environment, where it
shows up as:

  In file included from /usr/mipsel-linux-gnu/include/stdio.h:867,
                   from /git/linux/tools/perf/lib/include/perf/cpumap.h:6,
                   from util/session.c:13:
  In function 'printf',
      inlined from 'regs_dump__printf' at util/session.c:1103:3,
      inlined from 'regs__printf' at util/session.c:1131:2:
  /usr/mipsel-linux-gnu/include/bits/stdio2.h:107:10: error: '%-5s' directive argument is null [-Werror=format-overflow=]
    107 |   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
        |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

cross compiler details:

  mipsel-linux-gnu-gcc (Debian 9.2.1-8) 9.2.1 20190909

Also on mips64:

  In file included from /usr/mips64-linux-gnuabi64/include/stdio.h:867,
                   from /git/linux/tools/perf/lib/include/perf/cpumap.h:6,
                   from util/session.c:13:
  In function 'printf',
      inlined from 'regs_dump__printf' at util/session.c:1103:3,
      inlined from 'regs__printf' at util/session.c:1131:2,
      inlined from 'regs_user__printf' at util/session.c:1139:3,
      inlined from 'dump_sample' at util/session.c:1246:3,
      inlined from 'machines__deliver_event' at util/session.c:1421:3:
  /usr/mips64-linux-gnuabi64/include/bits/stdio2.h:107:10: error: '%-5s' directive argument is null [-Werror=format-overflow=]
    107 |   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
        |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  In function 'printf',
      inlined from 'regs_dump__printf' at util/session.c:1103:3,
      inlined from 'regs__printf' at util/session.c:1131:2,
      inlined from 'regs_intr__printf' at util/session.c:1147:3,
      inlined from 'dump_sample' at util/session.c:1249:3,
      inlined from 'machines__deliver_event' at util/session.c:1421:3:
  /usr/mips64-linux-gnuabi64/include/bits/stdio2.h:107:10: error: '%-5s' directive argument is null [-Werror=format-overflow=]
    107 |   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
        |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

cross compiler details:

  mips64-linux-gnuabi64-gcc (Debian 9.2.1-8) 9.2.1 20190909

Fixes: 2bcd355b71da ("perf tools: Add interface to arch registers sets")
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: https://lkml.kernel.org/n/tip-95wjyv4o65nuaeweq31t7l1s@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/perf_regs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/perf_regs.h b/tools/perf/util/perf_regs.h
index c9319f8d17a6..f732e3af2bd4 100644
--- a/tools/perf/util/perf_regs.h
+++ b/tools/perf/util/perf_regs.h
@@ -34,7 +34,7 @@ int perf_reg_value(u64 *valp, struct regs_dump *regs, int id);
 
 static inline const char *perf_reg_name(int id __maybe_unused)
 {
-	return NULL;
+	return "unknown";
 }
 
 static inline int perf_reg_value(u64 *valp __maybe_unused,
-- 
2.20.1



