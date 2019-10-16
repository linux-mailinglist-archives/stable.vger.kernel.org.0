Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E952DA043
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406644AbfJPWJq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:09:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:50082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395477AbfJPV50 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:57:26 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8484721D7A;
        Wed, 16 Oct 2019 21:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263045;
        bh=0Ezjz9iLxP32YFSyq0qYZi3BTTaYEBdbc7fnqbjGPFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NWXSHd64+VVafqvIbad6lOFlmBs7/JE0l3c4OOvEn/mR9SXd/hU31WwP25U1mejns
         jxxj7TkIhPy+3yPLRe/bEWW+yebiN5pcbbKBndrlFzlHtk6YMppbGuK7E3l46dGE19
         yE5E5iaFgnqaCLwFjW8JuA/CVWyBEy0znvUp350E=
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
Subject: [PATCH 4.19 50/81] perf llvm: Dont access out-of-scope array
Date:   Wed, 16 Oct 2019 14:51:01 -0700
Message-Id: <20191016214840.491058425@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214805.727399379@linuxfoundation.org>
References: <20191016214805.727399379@linuxfoundation.org>
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
@@ -230,14 +230,14 @@ static int detect_kbuild_dir(char **kbui
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


