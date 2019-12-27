Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A614C12B924
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 19:03:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728611AbfL0SDS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 13:03:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:60430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728591AbfL0SDO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 13:03:14 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DDF621582;
        Fri, 27 Dec 2019 18:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577469793;
        bh=fEofdPQLdo3o+UTKlPauo6nULx3FWB7k5nBorR9fbVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S/8NOmmyFE0LN8CrMGzTSarzB1+h/4D4wKyZI7DfL/8zLdUW8Znkn20pvD9JZNyu2
         KVOWsACbwc89MJd9JYIW4bwtA5MeTQeGeyONKlNcPhWJJf9a/E6foRVl90EJrXNcTN
         Lf/a72+LNAt4mjhdoh43veu8Ngi4/8BadpfFdibI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 42/57] perf/x86/intel/bts: Fix the use of page_private()
Date:   Fri, 27 Dec 2019 13:02:07 -0500
Message-Id: <20191227180222.7076-42-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227180222.7076-1-sashal@kernel.org>
References: <20191227180222.7076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

[ Upstream commit ff61541cc6c1962957758ba433c574b76f588d23 ]

Commit

  8062382c8dbe2 ("perf/x86/intel/bts: Add BTS PMU driver")

brought in a warning with the BTS buffer initialization
that is easily tripped with (assuming KPTI is disabled):

instantly throwing:

> ------------[ cut here ]------------
> WARNING: CPU: 2 PID: 326 at arch/x86/events/intel/bts.c:86 bts_buffer_setup_aux+0x117/0x3d0
> Modules linked in:
> CPU: 2 PID: 326 Comm: perf Not tainted 5.4.0-rc8-00291-gceb9e77324fa #904
> RIP: 0010:bts_buffer_setup_aux+0x117/0x3d0
> Call Trace:
>  rb_alloc_aux+0x339/0x550
>  perf_mmap+0x607/0xc70
>  mmap_region+0x76b/0xbd0
...

It appears to assume (for lost raisins) that PagePrivate() is set,
while later it actually tests for PagePrivate() before using
page_private().

Make it consistent and always check PagePrivate() before using
page_private().

Fixes: 8062382c8dbe2 ("perf/x86/intel/bts: Add BTS PMU driver")
Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Link: https://lkml.kernel.org/r/20191205142853.28894-2-alexander.shishkin@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/bts.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/x86/events/intel/bts.c b/arch/x86/events/intel/bts.c
index 24ffa1e88cf9..4d3399405d06 100644
--- a/arch/x86/events/intel/bts.c
+++ b/arch/x86/events/intel/bts.c
@@ -71,9 +71,17 @@ struct bts_buffer {
 
 static struct pmu bts_pmu;
 
+static int buf_nr_pages(struct page *page)
+{
+	if (!PagePrivate(page))
+		return 1;
+
+	return 1 << page_private(page);
+}
+
 static size_t buf_size(struct page *page)
 {
-	return 1 << (PAGE_SHIFT + page_private(page));
+	return buf_nr_pages(page) * PAGE_SIZE;
 }
 
 static void *
@@ -89,9 +97,7 @@ bts_buffer_setup_aux(int cpu, void **pages, int nr_pages, bool overwrite)
 	/* count all the high order buffers */
 	for (pg = 0, nbuf = 0; pg < nr_pages;) {
 		page = virt_to_page(pages[pg]);
-		if (WARN_ON_ONCE(!PagePrivate(page) && nr_pages > 1))
-			return NULL;
-		pg += 1 << page_private(page);
+		pg += buf_nr_pages(page);
 		nbuf++;
 	}
 
@@ -115,7 +121,7 @@ bts_buffer_setup_aux(int cpu, void **pages, int nr_pages, bool overwrite)
 		unsigned int __nr_pages;
 
 		page = virt_to_page(pages[pg]);
-		__nr_pages = PagePrivate(page) ? 1 << page_private(page) : 1;
+		__nr_pages = buf_nr_pages(page);
 		buf->buf[nbuf].page = page;
 		buf->buf[nbuf].offset = offset;
 		buf->buf[nbuf].displacement = (pad ? BTS_RECORD_SIZE - pad : 0);
-- 
2.20.1

