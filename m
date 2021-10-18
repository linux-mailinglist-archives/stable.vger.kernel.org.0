Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF54B431E2C
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234102AbhJRN6z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:58:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:59334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232330AbhJRN42 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:56:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96A26613A6;
        Mon, 18 Oct 2021 13:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564433;
        bh=Pk0vjCTxsyUVkxJShviw2ozJNFJ2klvJbRjQupwHRNE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iWPPhFe/6lNsui2cVEagC6x9PGZ/tRlehwh6bC/eZUIkx+gOOOdaZai5gb8qmFPNB
         SKkPoMC60qQ2WWL6k+o5tO7IGDqFgjj05q3s/uut6pccIKLOBkHetn+HTQfw7NPVrY
         H9fQtVVn+YqhYrGA4OLklpjnkcqFe+6bmxwQdTKY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        Jackie Liu <liuyun01@kylinos.cn>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH 5.14 087/151] tracing: Fix missing osnoise tracer on max_latency
Date:   Mon, 18 Oct 2021 15:24:26 +0200
Message-Id: <20211018132343.517300612@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jackie Liu <liuyun01@kylinos.cn>

commit 424b650f35c77defbb3cbd6e5221d3697af42250 upstream.

The compiler warns when the data are actually unused:

  kernel/trace/trace.c:1712:13: error: ‘trace_create_maxlat_file’ defined but not used [-Werror=unused-function]
   1712 | static void trace_create_maxlat_file(struct trace_array *tr,
        |             ^~~~~~~~~~~~~~~~~~~~~~~~

[Why]
CONFIG_HWLAT_TRACER=n, CONFIG_TRACER_MAX_TRACE=n, CONFIG_OSNOISE_TRACER=y
gcc report warns.

[How]
Now trace_create_maxlat_file will only take effect when
CONFIG_HWLAT_TRACER=y or CONFIG_TRACER_MAX_TRACE=y. In fact, after
adding osnoise trace, it also needs to take effect.

Link: https://lore.kernel.org/all/c1d9e328-ad7c-920b-6c24-9e1598a6421c@infradead.org/
Link: https://lkml.kernel.org/r/20210922025122.3268022-1-liu.yun@linux.dev

Fixes: bce29ac9ce0b ("trace: Add osnoise tracer")
Cc: Daniel Bristot de Oliveira <bristot@redhat.com>
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Reviewed-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org> # build-tested
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1744,16 +1744,15 @@ void latency_fsnotify(struct trace_array
 	irq_work_queue(&tr->fsnotify_irqwork);
 }
 
-/*
- * (defined(CONFIG_TRACER_MAX_TRACE) || defined(CONFIG_HWLAT_TRACER)) && \
- *  defined(CONFIG_FSNOTIFY)
- */
-#else
+#elif defined(CONFIG_TRACER_MAX_TRACE) || defined(CONFIG_HWLAT_TRACER)	\
+	|| defined(CONFIG_OSNOISE_TRACER)
 
 #define trace_create_maxlat_file(tr, d_tracer)				\
 	trace_create_file("tracing_max_latency", 0644, d_tracer,	\
 			  &tr->max_latency, &tracing_max_lat_fops)
 
+#else
+#define trace_create_maxlat_file(tr, d_tracer)	 do { } while (0)
 #endif
 
 #ifdef CONFIG_TRACER_MAX_TRACE
@@ -9457,9 +9456,7 @@ init_tracer_tracefs(struct trace_array *
 
 	create_trace_options_dir(tr);
 
-#if defined(CONFIG_TRACER_MAX_TRACE) || defined(CONFIG_HWLAT_TRACER)
 	trace_create_maxlat_file(tr, d_tracer);
-#endif
 
 	if (ftrace_create_function_files(tr, d_tracer))
 		MEM_FAIL(1, "Could not allocate function filter files");


