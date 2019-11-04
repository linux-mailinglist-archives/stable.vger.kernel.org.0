Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9DBEEE86
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389440AbfKDWPY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:15:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:37832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388396AbfKDWGH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:06:07 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3099820650;
        Mon,  4 Nov 2019 22:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905166;
        bh=7duB7oODTX8w4GpIVinanna0tcK5zRXrUUR8iZN821M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XEbY/M5t/z1tj4z+nT4P4ocUydE7z+GxkroZZaw2vk+dsufXcu84I2+sxrqrKcJ8O
         14D7CeOZt/jHneKozxQN0fyG7uio65+IzQN/eGBuN9Lp80MMO0vhAKt2gUXuxSZa3z
         XbXc1rOBmvtAbb5p3yiAn7Q6W27twXrDz11xObBc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 013/163] perf tools: Propagate get_cpuid() error
Date:   Mon,  4 Nov 2019 22:43:23 +0100
Message-Id: <20191104212141.418276447@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit f67001a4a08eb124197ed4376941e1da9cf94b42 ]

For consistency, propagate the exact cause for get_cpuid() to have
failed.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: https://lkml.kernel.org/n/tip-9ig269f7ktnhh99g4l15vpu2@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/arch/powerpc/util/header.c | 3 ++-
 tools/perf/arch/s390/util/header.c    | 9 +++++----
 tools/perf/arch/x86/util/header.c     | 3 ++-
 tools/perf/builtin-kvm.c              | 7 ++++---
 4 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/tools/perf/arch/powerpc/util/header.c b/tools/perf/arch/powerpc/util/header.c
index 0b242664f5ea7..e46be9ef5a688 100644
--- a/tools/perf/arch/powerpc/util/header.c
+++ b/tools/perf/arch/powerpc/util/header.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <sys/types.h>
+#include <errno.h>
 #include <unistd.h>
 #include <stdio.h>
 #include <stdlib.h>
@@ -31,7 +32,7 @@ get_cpuid(char *buffer, size_t sz)
 		buffer[nb-1] = '\0';
 		return 0;
 	}
-	return -1;
+	return ENOBUFS;
 }
 
 char *
diff --git a/tools/perf/arch/s390/util/header.c b/tools/perf/arch/s390/util/header.c
index 8b0b018d896ab..7933f6871c818 100644
--- a/tools/perf/arch/s390/util/header.c
+++ b/tools/perf/arch/s390/util/header.c
@@ -8,6 +8,7 @@
  */
 
 #include <sys/types.h>
+#include <errno.h>
 #include <unistd.h>
 #include <stdio.h>
 #include <string.h>
@@ -54,7 +55,7 @@ int get_cpuid(char *buffer, size_t sz)
 
 	sysinfo = fopen(SYSINFO, "r");
 	if (sysinfo == NULL)
-		return -1;
+		return errno;
 
 	while ((read = getline(&line, &line_sz, sysinfo)) != -1) {
 		if (!strncmp(line, SYSINFO_MANU, strlen(SYSINFO_MANU))) {
@@ -89,7 +90,7 @@ int get_cpuid(char *buffer, size_t sz)
 
 	/* Missing manufacturer, type or model information should not happen */
 	if (!manufacturer[0] || !type[0] || !model[0])
-		return -1;
+		return EINVAL;
 
 	/*
 	 * Scan /proc/service_levels and return the CPU-MF counter facility
@@ -133,14 +134,14 @@ skip_sysinfo:
 	else
 		nbytes = snprintf(buffer, sz, "%s,%s,%s", manufacturer, type,
 				  model);
-	return (nbytes >= sz) ? -1 : 0;
+	return (nbytes >= sz) ? ENOBUFS : 0;
 }
 
 char *get_cpuid_str(struct perf_pmu *pmu __maybe_unused)
 {
 	char *buf = malloc(128);
 
-	if (buf && get_cpuid(buf, 128) < 0)
+	if (buf && get_cpuid(buf, 128))
 		zfree(&buf);
 	return buf;
 }
diff --git a/tools/perf/arch/x86/util/header.c b/tools/perf/arch/x86/util/header.c
index af9a9f2600be4..a089af60906a0 100644
--- a/tools/perf/arch/x86/util/header.c
+++ b/tools/perf/arch/x86/util/header.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <sys/types.h>
+#include <errno.h>
 #include <unistd.h>
 #include <stdio.h>
 #include <stdlib.h>
@@ -57,7 +58,7 @@ __get_cpuid(char *buffer, size_t sz, const char *fmt)
 		buffer[nb-1] = '\0';
 		return 0;
 	}
-	return -1;
+	return ENOBUFS;
 }
 
 int
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index b33c834891208..44ff3ea1da23f 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -699,14 +699,15 @@ static int process_sample_event(struct perf_tool *tool,
 
 static int cpu_isa_config(struct perf_kvm_stat *kvm)
 {
-	char buf[64], *cpuid;
+	char buf[128], *cpuid;
 	int err;
 
 	if (kvm->live) {
 		err = get_cpuid(buf, sizeof(buf));
 		if (err != 0) {
-			pr_err("Failed to look up CPU type\n");
-			return err;
+			pr_err("Failed to look up CPU type: %s\n",
+			       str_error_r(err, buf, sizeof(buf)));
+			return -err;
 		}
 		cpuid = buf;
 	} else
-- 
2.20.1



