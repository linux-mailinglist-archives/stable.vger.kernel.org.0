Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4B0D28A31
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387841AbfEWTKb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:10:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:43820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387840AbfEWTKa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:10:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3000E2133D;
        Thu, 23 May 2019 19:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558638629;
        bh=WfIGQv7eWebBiWA7Zns+qpoP3MKJ53BCw8ZlmGWu6GM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YFsconhvtpHMyFC+xHpTX3kzQTABFU+U/8WE4jL4sJs0OIZekdUfMEKd7zx5Lr4lW
         r01KMbjylUcGfBBYeqdA/4Q1QW0PljFvkwDCuBLUw+q2KMdEe20gsFFWyM578dU1FO
         d6euRz7g0/1mWKmgcLkVRrM+JOM8Iwg4XQ/6cJhI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jiri Olsa <jolsa@kernel.org>,
        linux-snps-arc@lists.infradead.org,
        Namhyung Kim <namhyung@kernel.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 50/53] perf bench numa: Add define for RUSAGE_THREAD if not present
Date:   Thu, 23 May 2019 21:06:14 +0200
Message-Id: <20190523181718.902300881@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181710.981455400@linuxfoundation.org>
References: <20190523181710.981455400@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit bf561d3c13423fc54daa19b5d49dc15fafdb7acc ]

While cross building perf to the ARC architecture on a fedora 30 host,
we were failing with:

      CC       /tmp/build/perf/bench/numa.o
  bench/numa.c: In function ‘worker_thread’:
  bench/numa.c:1261:12: error: ‘RUSAGE_THREAD’ undeclared (first use in this function); did you mean ‘SIGEV_THREAD’?
    getrusage(RUSAGE_THREAD, &rusage);
              ^~~~~~~~~~~~~
              SIGEV_THREAD
  bench/numa.c:1261:12: note: each undeclared identifier is reported only once for each function it appears in

[perfbuilder@60d5802468f6 perf]$ /arc_gnu_2019.03-rc1_prebuilt_uclibc_le_archs_linux_install/bin/arc-linux-gcc --version | head -1
arc-linux-gcc (ARCv2 ISA Linux uClibc toolchain 2019.03-rc1) 8.3.1 20190225
[perfbuilder@60d5802468f6 perf]$

Trying to reproduce a report by Vineet, I noticed that, with just
cross-built zlib and numactl libraries, I ended up with the above
failure.

So, since RUSAGE_THREAD is available as a define, check for that and
numactl libraries, I ended up with the above failure.

So, since RUSAGE_THREAD is available as a define in the system headers,
check if it is defined in the 'perf bench numa' sources and define it if
not.

Now it builds and I have to figure out if the problem reported by Vineet
only takes place if we have libelf or some other library available.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: linux-snps-arc@lists.infradead.org
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Link: https://lkml.kernel.org/n/tip-2wb4r1gir9xrevbpq7qp0amk@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/bench/numa.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/perf/bench/numa.c b/tools/perf/bench/numa.c
index ee9565a033f47..e58be7eeced83 100644
--- a/tools/perf/bench/numa.c
+++ b/tools/perf/bench/numa.c
@@ -35,6 +35,10 @@
 #include <numa.h>
 #include <numaif.h>
 
+#ifndef RUSAGE_THREAD
+# define RUSAGE_THREAD 1
+#endif
+
 /*
  * Regular printout to the terminal, supressed if -q is specified:
  */
-- 
2.20.1



