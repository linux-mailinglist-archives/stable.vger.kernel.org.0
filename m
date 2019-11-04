Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6F9BEEF42
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388258AbfKDV7e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:59:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:56792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388236AbfKDV7d (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:59:33 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A9E520650;
        Mon,  4 Nov 2019 21:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904772;
        bh=rckOy+noUaIRbbw85JVOz4Xrjqu1JqPoLzR+uruJCPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l39nW4QIDMrlc3duINPmWWEBceS21hKq3E3mu5Kqz9JMSFlXGRWYrADvGLGSnkk0e
         JBlPDXhP/NmlHTgIrMOlTDfAVF0hzDUyZ7fEKINdoNNtmBsny33cGDQBrnWOpiUDAK
         lPMVOnsdZ7CO1ydiKDrGp195G6++oEeg0TfOHNnA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 065/149] perf tools: Propagate get_cpuid() error
Date:   Mon,  4 Nov 2019 22:44:18 +0100
Message-Id: <20191104212141.295860501@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
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
index 163b92f339980..cc72554c362a1 100644
--- a/tools/perf/arch/s390/util/header.c
+++ b/tools/perf/arch/s390/util/header.c
@@ -11,6 +11,7 @@
  */
 
 #include <sys/types.h>
+#include <errno.h>
 #include <unistd.h>
 #include <stdio.h>
 #include <string.h>
@@ -56,7 +57,7 @@ int get_cpuid(char *buffer, size_t sz)
 
 	sysinfo = fopen(SYSINFO, "r");
 	if (sysinfo == NULL)
-		return -1;
+		return errno;
 
 	while ((read = getline(&line, &line_sz, sysinfo)) != -1) {
 		if (!strncmp(line, SYSINFO_MANU, strlen(SYSINFO_MANU))) {
@@ -91,7 +92,7 @@ int get_cpuid(char *buffer, size_t sz)
 
 	/* Missing manufacturer, type or model information should not happen */
 	if (!manufacturer[0] || !type[0] || !model[0])
-		return -1;
+		return EINVAL;
 
 	/*
 	 * Scan /proc/service_levels and return the CPU-MF counter facility
@@ -135,14 +136,14 @@ skip_sysinfo:
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
index fb0d71afee8bb..2a5daec6fb8b0 100644
--- a/tools/perf/arch/x86/util/header.c
+++ b/tools/perf/arch/x86/util/header.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <sys/types.h>
+#include <errno.h>
 #include <unistd.h>
 #include <stdio.h>
 #include <stdlib.h>
@@ -56,7 +57,7 @@ __get_cpuid(char *buffer, size_t sz, const char *fmt)
 		buffer[nb-1] = '\0';
 		return 0;
 	}
-	return -1;
+	return ENOBUFS;
 }
 
 int
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 2b1ef704169f2..952e2228f6c60 100644
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



