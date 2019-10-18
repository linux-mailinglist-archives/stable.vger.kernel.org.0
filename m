Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 858C0DD186
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727255AbfJRWDn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:03:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:35136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727166AbfJRWDl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:03:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B51920679;
        Fri, 18 Oct 2019 22:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436220;
        bh=WD4dEYGfx+vDqZ++erXNFlqFoVPlAJ90CR+pwNc7X8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IjFsrJRUUa7NzXnDTvdsm3TI0Cr+EUwX3yYuORBY7plDfl9JMBsKwZNH2LxATGpzT
         TZvO8b7JZ32qNTVoa06XbLdC3E/xWy8scPxHDfd66FmCJGcq2tkAjiICEeKvIHeMnm
         i7WDKC65pLbgepmPkf+xDEHynTeRePFdKvb24cV8=
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
Subject: [PATCH AUTOSEL 5.3 10/89] perf annotate: Fix the signedness of failure returns
Date:   Fri, 18 Oct 2019 18:02:05 -0400
Message-Id: <20191018220324.8165-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220324.8165-1-sashal@kernel.org>
References: <20191018220324.8165-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 28f4417c3333940b242af03d90214f713bbef232 ]

Callers of symbol__annotate() expect a errno value or some other
extended error value range in symbol__strerror_disassemble() to
convert to a proper error string, fix it when propagating a failure to
find the arch specific annotation routines via arch__find(arch_name).

Reported-by: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
Cc: Will Deacon <will@kernel.org>
Link: https://lkml.kernel.org/n/tip-o0k6dw7cas0vvmjjvgsyvu1i@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/annotate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 6d9642c082e52..2dac51e9e4180 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -2069,7 +2069,7 @@ int symbol__annotate(struct symbol *sym, struct map *map,
 
 	args.arch = arch = arch__find(arch_name);
 	if (arch == NULL)
-		return -ENOTSUP;
+		return ENOTSUP;
 
 	if (parch)
 		*parch = arch;
-- 
2.20.1

