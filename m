Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92E4CD9F72
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437767AbfJPVzT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:55:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:45834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437759AbfJPVzT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:55:19 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BB3520872;
        Wed, 16 Oct 2019 21:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262918;
        bh=LDZOW25CksuYhiJrj429Qcn7l6gHU+rXtoF0UIaiRyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0tS77SCkIz7cOskk55gyAesspOa4Cb2wlbd65gAmMMB+AfsciTJinvTOot3qOsgYG
         0V+Ry76hFeB47s6Nt41ZxUNDy8nTNQz0scTCvHhYcUqk4DyZCfu/u5GVOnfzZjjPdI
         Y9qbjFlKVuPlWGSQGqEB08xYecz/LCBQptTv/snI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Steve MacLean <Steve.MacLean@Microsoft.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Brian Robbins <brianrob@microsoft.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Eric Saint-Etienne <eric.saint.etienne@oracle.com>,
        John Keeping <john@metanate.com>,
        John Salem <josalem@microsoft.com>,
        Leo Yan <leo.yan@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Stephane Eranian <eranian@google.com>,
        Tom McDonald <thomas.mcdonald@microsoft.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4.9 78/92] perf inject jit: Fix JIT_CODE_MOVE filename
Date:   Wed, 16 Oct 2019 14:50:51 -0700
Message-Id: <20191016214846.371892544@linuxfoundation.org>
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

From: Steve MacLean <Steve.MacLean@microsoft.com>

commit b59711e9b0d22fd47abfa00602fd8c365cdd3ab7 upstream.

During perf inject --jit, JIT_CODE_MOVE records were injecting MMAP records
with an incorrect filename. Specifically it was missing the ".so" suffix.

Further the JIT_CODE_LOAD record were silently truncating the
jr->load.code_index field to 32 bits before generating the filename.

Make both records emit the same filename based on the full 64 bit
code_index field.

Fixes: 9b07e27f88b9 ("perf inject: Add jitdump mmap injection support")
Cc: stable@vger.kernel.org # v4.6+
Signed-off-by: Steve MacLean <Steve.MacLean@Microsoft.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Brian Robbins <brianrob@microsoft.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Eric Saint-Etienne <eric.saint.etienne@oracle.com>
Cc: John Keeping <john@metanate.com>
Cc: John Salem <josalem@microsoft.com>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom McDonald <thomas.mcdonald@microsoft.com>
Link: http://lore.kernel.org/lkml/BN8PR21MB1362FF8F127B31DBF4121528F7800@BN8PR21MB1362.namprd21.prod.outlook.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/util/jitdump.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -369,7 +369,7 @@ static int jit_repipe_code_load(struct j
 	size_t size;
 	u16 idr_size;
 	const char *sym;
-	uint32_t count;
+	uint64_t count;
 	int ret, csize;
 	pid_t pid, tid;
 	struct {
@@ -391,7 +391,7 @@ static int jit_repipe_code_load(struct j
 		return -1;
 
 	filename = event->mmap2.filename;
-	size = snprintf(filename, PATH_MAX, "%s/jitted-%d-%u.so",
+	size = snprintf(filename, PATH_MAX, "%s/jitted-%d-%" PRIu64 ".so",
 			jd->dir,
 			pid,
 			count);
@@ -493,7 +493,7 @@ static int jit_repipe_code_move(struct j
 		return -1;
 
 	filename = event->mmap2.filename;
-	size = snprintf(filename, PATH_MAX, "%s/jitted-%d-%"PRIu64,
+	size = snprintf(filename, PATH_MAX, "%s/jitted-%d-%" PRIu64 ".so",
 	         jd->dir,
 	         pid,
 		 jr->move.code_index);


