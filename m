Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08E8B11B2D0
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388498AbfLKPiu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:38:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:49546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388495AbfLKPit (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:38:49 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 552F22467C;
        Wed, 11 Dec 2019 15:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576078729;
        bh=6ox/KYmu3jjPyzt+7WRXYPOKE+EiNlw1SrM83RmeAaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aLV5+/gkGSXmtyuU8Atypp8eODczjzyM+noPQBoIG+ngoldOwJQGJoR6eKVM+4h3Z
         pXpt0fpmrn3MsRT70GET9NTK9T9xJQaIU/ycjk3iC3taHmiNRXhg+hW/+A6fMvKrr6
         wAjZDI5mMoBafWkIiMrQrIsolunlsTZ5VfHVfkfI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 33/37] perf regs: Make perf_reg_name() return "unknown" instead of NULL
Date:   Wed, 11 Dec 2019 10:38:09 -0500
Message-Id: <20191211153813.24126-33-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211153813.24126-1-sashal@kernel.org>
References: <20191211153813.24126-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 679d6e4939622..e6324397b295b 100644
--- a/tools/perf/util/perf_regs.h
+++ b/tools/perf/util/perf_regs.h
@@ -26,7 +26,7 @@ int perf_reg_value(u64 *valp, struct regs_dump *regs, int id);
 
 static inline const char *perf_reg_name(int id __maybe_unused)
 {
-	return NULL;
+	return "unknown";
 }
 
 static inline int perf_reg_value(u64 *valp __maybe_unused,
-- 
2.20.1

