Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 427BD111C38
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:41:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbfLCWlq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:41:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:56334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728256AbfLCWlp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:41:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A399820684;
        Tue,  3 Dec 2019 22:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412904;
        bh=CXGuL/+Zj1tzPKy5oPWPoR1umpi1OerSw3+E7vfGeT4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S8qLN0CdFAjezNEMhbPyjJKuuwtRrU3YDcKIVdAfylHjWv9Y97GDpVo/u26hwS3Nx
         AWNiMhZ/RuOZFoD36DVhG+8eXswJFVvmQVScsOPWW1uQWSaBf2Aj+uOEkQQPrLrcrv
         Jhgge71N3a579UEKhEbGUo065iXpQ3dKL1N3g5L8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        linux-trace-devel@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 061/135] perf scripting engines: Iterate on tep event arrays directly
Date:   Tue,  3 Dec 2019 23:35:01 +0100
Message-Id: <20191203213022.529997869@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

[ Upstream commit 443b0636ea7386d01dc460b4a4264e125f710b53 ]

Instead of calling a useless (and broken) helper function to get the
next event of a tep event array, just get the array directly and iterate
over it.

Note, the broken part was from trace_find_next_event() which after this
will no longer be used, and can be removed.

Committer notes:

This fixes a segfault when generating python scripts from perf.data
files with multiple tracepoint events, i.e. the following use case is
fixed by this patch:

  # perf record -e sched:* sleep 1
  [ perf record: Woken up 31 times to write data ]
  [ perf record: Captured and wrote 0.031 MB perf.data (9 samples) ]
  # perf script -g python
  Segmentation fault (core dumped)
  #

Reported-by: Daniel Bristot de Oliveira <bristot@redhat.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: linux-trace-devel@vger.kernel.org
Link: http://lkml.kernel.org/r/20191017153733.630cd5eb@gandalf.local.home
Link: http://lore.kernel.org/lkml/20191017210636.061448713@goodmis.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/scripting-engines/trace-event-perl.c   | 8 ++++++--
 tools/perf/util/scripting-engines/trace-event-python.c | 9 +++++++--
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index 61aa7f3df915b..6a0dcaee3f3ee 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -539,10 +539,11 @@ static int perl_stop_script(void)
 
 static int perl_generate_script(struct tep_handle *pevent, const char *outfile)
 {
+	int i, not_first, count, nr_events;
+	struct tep_event **all_events;
 	struct tep_event *event = NULL;
 	struct tep_format_field *f;
 	char fname[PATH_MAX];
-	int not_first, count;
 	FILE *ofp;
 
 	sprintf(fname, "%s.pl", outfile);
@@ -603,8 +604,11 @@ sub print_backtrace\n\
 }\n\n\
 ");
 
+	nr_events = tep_get_events_count(pevent);
+	all_events = tep_list_events(pevent, TEP_EVENT_SORT_ID);
 
-	while ((event = trace_find_next_event(pevent, event))) {
+	for (i = 0; all_events && i < nr_events; i++) {
+		event = all_events[i];
 		fprintf(ofp, "sub %s::%s\n{\n", event->system, event->name);
 		fprintf(ofp, "\tmy (");
 
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 25dc1d765553b..df5ebb6af9fc8 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -1687,10 +1687,11 @@ static int python_stop_script(void)
 
 static int python_generate_script(struct tep_handle *pevent, const char *outfile)
 {
+	int i, not_first, count, nr_events;
+	struct tep_event **all_events;
 	struct tep_event *event = NULL;
 	struct tep_format_field *f;
 	char fname[PATH_MAX];
-	int not_first, count;
 	FILE *ofp;
 
 	sprintf(fname, "%s.py", outfile);
@@ -1735,7 +1736,11 @@ static int python_generate_script(struct tep_handle *pevent, const char *outfile
 	fprintf(ofp, "def trace_end():\n");
 	fprintf(ofp, "\tprint(\"in trace_end\")\n\n");
 
-	while ((event = trace_find_next_event(pevent, event))) {
+	nr_events = tep_get_events_count(pevent);
+	all_events = tep_list_events(pevent, TEP_EVENT_SORT_ID);
+
+	for (i = 0; all_events && i < nr_events; i++) {
+		event = all_events[i];
 		fprintf(ofp, "def %s__%s(", event->system, event->name);
 		fprintf(ofp, "event_name, ");
 		fprintf(ofp, "context, ");
-- 
2.20.1



