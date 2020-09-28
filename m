Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BFEF27B61C
	for <lists+stable@lfdr.de>; Mon, 28 Sep 2020 22:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgI1USG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 28 Sep 2020 16:18:06 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:28346 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726424AbgI1USG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Sep 2020 16:18:06 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-234-81R2NBfkOjCvBz5ghBtP7g-1; Mon, 28 Sep 2020 16:11:41 -0400
X-MC-Unique: 81R2NBfkOjCvBz5ghBtP7g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 512611074645;
        Mon, 28 Sep 2020 20:11:39 +0000 (UTC)
Received: from krava.redhat.com (ovpn-112-124.ams2.redhat.com [10.36.112.124])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8680C78822;
        Mon, 28 Sep 2020 20:11:36 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     stable@vger.kernel.org, Hagen Paul Pfeifer <hagen@jauu.net>,
        lkml <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Michael Petlan <mpetlan@redhat.com>
Subject: [PATCH] perf tools: Fix printable strings in python3 scripts
Date:   Mon, 28 Sep 2020 22:11:35 +0200
Message-Id: <20200928201135.3633850-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hagen reported broken strings in python3 tracepoint scripts:

  make PYTHON=python3
  ./perf record -e sched:sched_switch -a -- sleep 5
  ./perf script --gen-script py
  ./perf script -s ./perf-script.py

  [..]
  sched__sched_switch      7 563231.759525792        0 swapper   \
  prev_comm=bytearray(b'swapper/7\x00\x00\x00\x00\x00\x00\x00'), \
  prev_pid=0, prev_prio=120, prev_state=, next_comm=bytearray(b'mutex-thread-co\x00'),

The problem is in is_printable_array function that does not take
zero byte into account and claim such string as not printable,
so the code will create byte array instead of string.

Cc: stable@vger.kernel.org
Fixes: 249de6e07458 ("perf script python: Fix string vs byte array resolving")
Tested-by: Hagen Paul Pfeifer <hagen@jauu.net>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/print_binary.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/print_binary.c b/tools/perf/util/print_binary.c
index 599a1543871d..13fdc51c61d9 100644
--- a/tools/perf/util/print_binary.c
+++ b/tools/perf/util/print_binary.c
@@ -50,7 +50,7 @@ int is_printable_array(char *p, unsigned int len)
 
 	len--;
 
-	for (i = 0; i < len; i++) {
+	for (i = 0; i < len && p[i]; i++) {
 		if (!isprint(p[i]) && !isspace(p[i]))
 			return 0;
 	}
-- 
2.26.2

