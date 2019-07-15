Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4754268C50
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 15:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731154AbfGONuu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 09:50:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:41214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732006AbfGONur (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 09:50:47 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12A142081C;
        Mon, 15 Jul 2019 13:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563198646;
        bh=mZuzzaQ2g/gnwR5ZhebMyXg/ozhVlkLLnQB4ohZKl5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RGnAZfaL1DcK5P9H0LI+wj3YjfLDSZRMIYUqe7B/kYu+6fwXzmPyxEl4a/zfMdG4O
         B4W8we89yRymxK7wnvmIu6Grutcum65WM+6lJDKhuf03Lx2uxcgq7KRrhTFTiCk9Bj
         gANfLYZn3q9EDbz9/1uAl1rIqRcUuRm4hUYmxrkI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ben Gainey <ben.gainey@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 069/249] perf jvmti: Address gcc string overflow warning for strncpy()
Date:   Mon, 15 Jul 2019 09:43:54 -0400
Message-Id: <20190715134655.4076-69-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

[ Upstream commit 279ab04dbea1370d2eac0f854270369ccaef8a44 ]

We are getting false positive gcc warning when we compile with gcc9 (9.1.1):

     CC       jvmti/libjvmti.o
   In file included from /usr/include/string.h:494,
                    from jvmti/libjvmti.c:5:
   In function ‘strncpy’,
       inlined from ‘copy_class_filename.constprop’ at jvmti/libjvmti.c:166:3:
   /usr/include/bits/string_fortified.h:106:10: error: ‘__builtin_strncpy’ specified bound depends on the length of the source argument [-Werror=stringop-overflow=]
     106 |   return __builtin___strncpy_chk (__dest, __src, __len, __bos (__dest));
         |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   jvmti/libjvmti.c: In function ‘copy_class_filename.constprop’:
   jvmti/libjvmti.c:165:26: note: length computed here
     165 |   size_t file_name_len = strlen(file_name);
         |                          ^~~~~~~~~~~~~~~~~
   cc1: all warnings being treated as errors

As per Arnaldo's suggestion use strlcpy(), which does the same thing and keeps
gcc silent.

Suggested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ben Gainey <ben.gainey@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/20190531131321.GB1281@krava
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/jvmti/libjvmti.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/jvmti/libjvmti.c b/tools/perf/jvmti/libjvmti.c
index aea7b1fe85aa..c441a34cb1c0 100644
--- a/tools/perf/jvmti/libjvmti.c
+++ b/tools/perf/jvmti/libjvmti.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/compiler.h>
+#include <linux/string.h>
 #include <sys/types.h>
 #include <stdio.h>
 #include <string.h>
@@ -162,8 +163,7 @@ copy_class_filename(const char * class_sign, const char * file_name, char * resu
 		result[i] = '\0';
 	} else {
 		/* fallback case */
-		size_t file_name_len = strlen(file_name);
-		strncpy(result, file_name, file_name_len < max_length ? file_name_len : max_length);
+		strlcpy(result, file_name, max_length);
 	}
 }
 
-- 
2.20.1

