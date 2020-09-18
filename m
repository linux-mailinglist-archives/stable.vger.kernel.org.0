Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7CF26F1F3
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbgIRCHM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:07:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:57298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727880AbgIRCHM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:07:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39825238E3;
        Fri, 18 Sep 2020 02:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394831;
        bh=7gT6ozM3I5vn2TytL2fIvxIy5739xDMcFQvEshQMweQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zfj5z7rlE4FdQfDB70fcAaAWLI+dC6k2JKaADkTayH5fP7j+UYVIKbxaKWhOUmawN
         qqdd22tQBE7rnTq4ZBpfsgNpZo+tg+/YqgQRZs3slp6icFyLavFC+GRG/njiOdTORB
         yUDvZTcH3Twl/yctzAHSA5EjMFL3DvEkAbJ2rdBc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Igor Lubashev <ilubashe@akamai.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wei Li <liwei391@huawei.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 293/330] perf trace: Fix the selection for architectures to generate the errno name tables
Date:   Thu, 17 Sep 2020 22:00:33 -0400
Message-Id: <20200918020110.2063155-293-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ian Rogers <irogers@google.com>

[ Upstream commit 7597ce89b3ed239f7a3408b930d2a6c7a4c938a1 ]

Make the architecture test directory agree with the code comment.

Committer notes:

This was split from a larger patch.

The code was assuming the developer always worked from tools/perf/, so make sure we
do the test -d having $toolsdir/perf/arch/$arch, to match the intent expressed in the comment,
just above that loop.

Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alexios Zavras <alexios.zavras@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Igor Lubashev <ilubashe@akamai.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Wei Li <liwei391@huawei.com>
Link: http://lore.kernel.org/lkml/20200306071110.130202-4-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/trace/beauty/arch_errno_names.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/trace/beauty/arch_errno_names.sh b/tools/perf/trace/beauty/arch_errno_names.sh
index 22c9fc900c847..f8c44a85650be 100755
--- a/tools/perf/trace/beauty/arch_errno_names.sh
+++ b/tools/perf/trace/beauty/arch_errno_names.sh
@@ -91,7 +91,7 @@ EoHEADER
 # in tools/perf/arch
 archlist=""
 for arch in $(find $toolsdir/arch -maxdepth 1 -mindepth 1 -type d -printf "%f\n" | grep -v x86 | sort); do
-	test -d arch/$arch && archlist="$archlist $arch"
+	test -d $toolsdir/perf/arch/$arch && archlist="$archlist $arch"
 done
 
 for arch in x86 $archlist generic; do
-- 
2.25.1

