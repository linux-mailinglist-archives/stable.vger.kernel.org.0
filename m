Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23901133239
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729368AbgAGVIX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:08:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:60574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729673AbgAGVIW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:08:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D5FE20880;
        Tue,  7 Jan 2020 21:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431301;
        bh=scddgpvllI85i/98LWMYBVIE/Q5evmoMzZcNLa0aPZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qmelnMm213luoFgx4fBPKu4uQTMsKhVR1HYeVha2pe+sD74mt8HULfm3OT3HOkhJo
         LECq9Bt9mteLRc8Pkj/FLFGzPsvb8pox3/DwUM/e4bKCt7oiuUJFPozp3yQttRb0N2
         gwNxkk+ccGYg5vIcDmfm3qS9oQh3opeB53dsQT6k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 115/115] perf/x86/intel/bts: Fix the use of page_private()
Date:   Tue,  7 Jan 2020 21:55:25 +0100
Message-Id: <20200107205311.271071706@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205240.283674026@linuxfoundation.org>
References: <20200107205240.283674026@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 7139f6bf27ad..510f9461407e 100644
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
@@ -91,9 +99,7 @@ bts_buffer_setup_aux(struct perf_event *event, void **pages,
 	/* count all the high order buffers */
 	for (pg = 0, nbuf = 0; pg < nr_pages;) {
 		page = virt_to_page(pages[pg]);
-		if (WARN_ON_ONCE(!PagePrivate(page) && nr_pages > 1))
-			return NULL;
-		pg += 1 << page_private(page);
+		pg += buf_nr_pages(page);
 		nbuf++;
 	}
 
@@ -117,7 +123,7 @@ bts_buffer_setup_aux(struct perf_event *event, void **pages,
 		unsigned int __nr_pages;
 
 		page = virt_to_page(pages[pg]);
-		__nr_pages = PagePrivate(page) ? 1 << page_private(page) : 1;
+		__nr_pages = buf_nr_pages(page);
 		buf->buf[nbuf].page = page;
 		buf->buf[nbuf].offset = offset;
 		buf->buf[nbuf].displacement = (pad ? BTS_RECORD_SIZE - pad : 0);
-- 
2.20.1



