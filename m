Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 265ACDA070
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392909AbfJPWLb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:11:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:48746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395420AbfJPV4o (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:56:44 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6A0C21D7C;
        Wed, 16 Oct 2019 21:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263004;
        bh=9hytf46pxJZwWd1KZSS2LwMH+F/2nbwdUj2HF2HtH7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nO5dxg5rW9EMkQwoX1lhOCDyOR7G3Sgq5PBgFgGXPjZT7ghnOHv6ZTtcCtkZSieUs
         veF7Pdn5KHCQ0uRNEeh4g9hFawaOB334YQ3pbC3IoLV75iuX4JXJPrXx+Zn7k01/NY
         7BOD+ZFkniZzZ9D2f0n0qjc7vbZZ1tBn7oRZglrU=
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
Subject: [PATCH 4.14 44/65] perf llvm: Dont access out-of-scope array
Date:   Wed, 16 Oct 2019 14:50:58 -0700
Message-Id: <20191016214833.346302368@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214756.457746573@linuxfoundation.org>
References: <20191016214756.457746573@linuxfoundation.org>
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
@@ -225,14 +225,14 @@ static int detect_kbuild_dir(char **kbui
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


