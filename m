Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3A3DA0D1
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407436AbfJPWQB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:16:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:45804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437754AbfJPVzS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:55:18 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 297E121D7A;
        Wed, 16 Oct 2019 21:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262917;
        bh=c+80AyRjtEUyKEjVzvFoFL1js9MaBhs+Nw2cCytC8BE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t2Kh53J4inxbVr48w9XhdNk0w9gdKnnfF46we1/i/TwxQkTkMfmtsYF4QFq4N0xA+
         gkI/nKxRT9iPmSGjHej/0QVSYt6ZSfF2Thr9ZUpMny0AWhY02PpPjOMwEqlO0xp2l+
         TidMrRli42BICEehAFBqAdmMPQhRj9xk0kYh+FsM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Rogers <irogers@google.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Wang Nan <wangnan0@huawei.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4.9 77/92] perf llvm: Dont access out-of-scope array
Date:   Wed, 16 Oct 2019 14:50:50 -0700
Message-Id: <20191016214846.206485152@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214759.600329427@linuxfoundation.org>
References: <20191016214759.600329427@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ian Rogers <irogers@google.com>

commit 7d4c85b7035eb2f9ab217ce649dcd1bfaf0cacd3 upstream.

The 'test_dir' variable is assigned to the 'release' array which is
out-of-scope 3 lines later.

Extend the scope of the 'release' array so that an out-of-scope array
isn't accessed.

Bug detected by clang's address sanitizer.

Fixes: 07bc5c699a3d ("perf tools: Make fetch_kernel_version() publicly available")
Cc: stable@vger.kernel.org # v4.4+
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Wang Nan <wangnan0@huawei.com>
Link: http://lore.kernel.org/lkml/20190926220018.25402-1-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/util/llvm-utils.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/tools/perf/util/llvm-utils.c
+++ b/tools/perf/util/llvm-utils.c
@@ -220,14 +220,14 @@ static int detect_kbuild_dir(char **kbui
 	const char *prefix_dir = "";
 	const char *suffix_dir = "";
 
+	/* _UTSNAME_LENGTH is 65 */
+	char release[128];
+
 	char *autoconf_path;
 
 	int err;
 
 	if (!test_dir) {
-		/* _UTSNAME_LENGTH is 65 */
-		char release[128];
-
 		err = fetch_kernel_version(NULL, release,
 					   sizeof(release));
 		if (err)


