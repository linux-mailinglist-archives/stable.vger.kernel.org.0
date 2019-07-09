Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCF3E63B1F
	for <lists+stable@lfdr.de>; Tue,  9 Jul 2019 20:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729319AbfGISdU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jul 2019 14:33:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:55072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729311AbfGISdT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jul 2019 14:33:19 -0400
Received: from quaco.ghostprotocols.net (unknown [179.97.35.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99D61214AF;
        Tue,  9 Jul 2019 18:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562697198;
        bh=fDZbMwjg6rYu7jprZLww4XnXl8EckXxuaj91Q1Y8GPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K9X4rWoIN+uCWiLqIF7tBW1wfjBtBr/6c+awV07N+HzTY405keS4mJTIFGE2u90C4
         cA4DyOx3fqgC8XoBkxF2lWshtX6g43bE8GWtbIQrYMxgG2Y0Hdq2XYxYA/Xt4ptccG
         xzBH1ZhBQLLEO6smVAsNNkKI7j7rq6HT8X77I7/A=
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Clark Williams <williams@redhat.com>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Song Liu <songliubraving@fb.com>,
        David Carrillo Cisneros <davidca@fb.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, kernel-team@fb.com,
        stable@vger.kernel.org
Subject: [PATCH 23/25] perf script: Assume native_arch for pipe mode
Date:   Tue,  9 Jul 2019 15:31:24 -0300
Message-Id: <20190709183126.30257-24-acme@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190709183126.30257-1-acme@kernel.org>
References: <20190709183126.30257-1-acme@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Song Liu <songliubraving@fb.com>

In pipe mode, session->header.env.arch is not populated until the events
are processed. Therefore, the following command crashes:

   perf record -o - | perf script

(gdb) bt

It fails when we try to compare env.arch against uts.machine:

        if (!strcmp(uts.machine, session->header.env.arch) ||
            (!strcmp(uts.machine, "x86_64") &&
             !strcmp(session->header.env.arch, "i386")))
                native_arch = true;

In pipe mode, it is tricky to find env.arch at this stage. To keep it
simple, let's just assume native_arch is always true for pipe mode.

Reported-by: David Carrillo Cisneros <davidca@fb.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: kernel-team@fb.com
Cc: stable@vger.kernel.org #v5.1+
Fixes: 3ab481a1cfe1 ("perf script: Support insn output for normal samples")
Link: http://lkml.kernel.org/r/20190621014438.810342-1-songliubraving@fb.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-script.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index b3536820f9a8..79367087bd18 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -3752,7 +3752,8 @@ int cmd_script(int argc, const char **argv)
 		goto out_delete;
 
 	uname(&uts);
-	if (!strcmp(uts.machine, session->header.env.arch) ||
+	if (data.is_pipe ||  /* assume pipe_mode indicates native_arch */
+	    !strcmp(uts.machine, session->header.env.arch) ||
 	    (!strcmp(uts.machine, "x86_64") &&
 	     !strcmp(session->header.env.arch, "i386")))
 		native_arch = true;
-- 
2.21.0

