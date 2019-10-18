Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3E0DD3C2
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732236AbfJRWTq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:19:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:39034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732163AbfJRWG5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:06:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBFC222459;
        Fri, 18 Oct 2019 22:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436416;
        bh=uTy1kjyuPAGz2wZWF8FBRTZHEkVSNj5vNXv4AoaQbpI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QH6A0pEl+r0J6XMEAyYwZdzGRfvx9egO6yXZUv17N2UUo//3gSd3HU5Tl4hpZik/K
         mmJt12ufGhn2LOALP4CtQ4GggTaX40Gx7zo/voNueYazrlHswJm0J0kc0qTMhlTakq
         MnyN+NR6KTScSL8AQpG8uO95RVczklvVrKv9agWo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnaldo Carvalho de Melo <acme@redhat.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 060/100] perf annotate: Propagate the symbol__annotate() error return
Date:   Fri, 18 Oct 2019 18:04:45 -0400
Message-Id: <20191018220525.9042-60-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220525.9042-1-sashal@kernel.org>
References: <20191018220525.9042-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 211f493b611eef012841f795166c38ec7528738d ]

We were just returning -1 in symbol__annotate() when symbol__annotate()
failed, propagate its error as it is used later to pass to
symbol__strerror_disassemble() to present a error message to the user,
that in some cases were getting:

  "Invalid -1 error code"

Fix it to propagate the error.

Reported-by: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
Cc: Will Deacon <will@kernel.org>
Link: https://lkml.kernel.org/n/tip-0tj89rs9g7nbcyd5skadlvuu@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/annotate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index b4946ef48b621..83a3ad4256c5b 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -2757,7 +2757,7 @@ int symbol__annotate2(struct symbol *sym, struct map *map, struct perf_evsel *ev
 
 out_free_offsets:
 	zfree(&notes->offsets);
-	return -1;
+	return err;
 }
 
 #define ANNOTATION__CFG(n) \
-- 
2.20.1

