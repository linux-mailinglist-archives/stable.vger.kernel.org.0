Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37B08129BEC
	for <lists+stable@lfdr.de>; Tue, 24 Dec 2019 01:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbfLXACH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Dec 2019 19:02:07 -0500
Received: from mo-csw1515.securemx.jp ([210.130.202.154]:60316 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726833AbfLXACG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Dec 2019 19:02:06 -0500
Received: by mo-csw.securemx.jp (mx-mo-csw1515) id xBO024bQ003102; Tue, 24 Dec 2019 09:02:05 +0900
X-Iguazu-Qid: 34ts1P8d963rX1mGu7
X-Iguazu-QSIG: v=2; s=0; t=1577145724; q=34ts1P8d963rX1mGu7; m=HWLF8q+PUDy1RmiSppMdnCeLjyinDBO9RVnSYvvasVs=
Received: from imx2.toshiba.co.jp (imx2.toshiba.co.jp [106.186.93.51])
        by relay.securemx.jp (mx-mr1512) id xBO02497010321;
        Tue, 24 Dec 2019 09:02:04 +0900
Received: from enc01.localdomain ([106.186.93.100])
        by imx2.toshiba.co.jp  with ESMTP id xBO0244S026824
        for <stable@vger.kernel.org>; Tue, 24 Dec 2019 09:02:04 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
        by enc01.localdomain  with ESMTP id xBO0243G009396
        for <stable@vger.kernel.org>; Tue, 24 Dec 2019 09:02:04 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Subject: [PATCH for 4.9, 4.14, 4.19] perf strbuf: Remove redundant va_end() in strbuf_addv()
Date:   Tue, 24 Dec 2019 09:02:03 +0900
X-TSB-HOP: ON
Message-Id: <20191224000203.14122-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mattias Jacobsson <2pi@mok.nu>

commit 099be748865eece21362aee416c350c0b1ae34df upstream.

Each call to va_copy() should have one, and only one, corresponding call
to va_end(). In strbuf_addv() some code paths result in va_end() getting
called multiple times. Remove the superfluous va_end().

Signed-off-by: Mattias Jacobsson <2pi@mok.nu>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sanskriti Sharma <sansharm@redhat.com>
Link: http://lkml.kernel.org/r/20181229141750.16945-1-2pi@mok.nu
Fixes: ce49d8436cff ("perf strbuf: Match va_{add,copy} with va_end")
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 tools/perf/util/strbuf.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/perf/util/strbuf.c b/tools/perf/util/strbuf.c
index 9005fbe0780e..23092fd6451d 100644
--- a/tools/perf/util/strbuf.c
+++ b/tools/perf/util/strbuf.c
@@ -109,7 +109,6 @@ static int strbuf_addv(struct strbuf *sb, const char *fmt, va_list ap)
 			return ret;
 		}
 		len = vsnprintf(sb->buf + sb->len, sb->alloc - sb->len, fmt, ap_saved);
-		va_end(ap_saved);
 		if (len > strbuf_avail(sb)) {
 			pr_debug("this should not happen, your vsnprintf is broken");
 			va_end(ap_saved);
-- 
2.23.0

