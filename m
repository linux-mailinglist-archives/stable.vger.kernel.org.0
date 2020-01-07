Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B31E11332C9
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbgAGVNw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:13:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:35986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729890AbgAGVJ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:09:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B0162087F;
        Tue,  7 Jan 2020 21:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431395;
        bh=TH1ThpB6/nN9wvtvO/UM4yDorepWO1zLbfaBotEy2pk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SzgC+ChjRCTMugomC2U/MpXBgsQmXIYEVJ6/q0VamfLwyc9x+PTp11ZHAqZ4qSpe2
         nC1XSMsCs1GUGmToSr7/RnVDBH8DUy0fOHOUk9WahPDCkLSXMJJwAiu+MTp+5FyaxW
         V/iklLtXVN7Dfsdkqsf59xUpXRYvdlAfNvojKPHk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Prateek Sood <prsood@codeaurora.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.14 40/74] tracing: Fix lock inversion in trace_event_enable_tgid_record()
Date:   Tue,  7 Jan 2020 21:55:05 +0100
Message-Id: <20200107205209.114374966@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205135.369001641@linuxfoundation.org>
References: <20200107205135.369001641@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Prateek Sood <prsood@codeaurora.org>

commit 3a53acf1d9bea11b57c1f6205e3fe73f9d8a3688 upstream.

       Task T2                             Task T3
trace_options_core_write()            subsystem_open()

 mutex_lock(trace_types_lock)           mutex_lock(event_mutex)

 set_tracer_flag()

   trace_event_enable_tgid_record()       mutex_lock(trace_types_lock)

    mutex_lock(event_mutex)

This gives a circular dependency deadlock between trace_types_lock and
event_mutex. To fix this invert the usage of trace_types_lock and
event_mutex in trace_options_core_write(). This keeps the sequence of
lock usage consistent.

Link: http://lkml.kernel.org/r/0101016eef175e38-8ca71caf-a4eb-480d-a1e6-6f0bbc015495-000000@us-west-2.amazonses.com

Cc: stable@vger.kernel.org
Fixes: d914ba37d7145 ("tracing: Add support for recording tgid of tasks")
Signed-off-by: Prateek Sood <prsood@codeaurora.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace.c        |    8 ++++++++
 kernel/trace/trace_events.c |    8 ++++----
 2 files changed, 12 insertions(+), 4 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4368,6 +4368,10 @@ int trace_keep_overwrite(struct tracer *
 
 int set_tracer_flag(struct trace_array *tr, unsigned int mask, int enabled)
 {
+	if ((mask == TRACE_ITER_RECORD_TGID) ||
+	    (mask == TRACE_ITER_RECORD_CMD))
+		lockdep_assert_held(&event_mutex);
+
 	/* do nothing if flag is already set */
 	if (!!(tr->trace_flags & mask) == !!enabled)
 		return 0;
@@ -4433,6 +4437,7 @@ static int trace_set_options(struct trac
 		cmp += 2;
 	}
 
+	mutex_lock(&event_mutex);
 	mutex_lock(&trace_types_lock);
 
 	for (i = 0; trace_options[i]; i++) {
@@ -4447,6 +4452,7 @@ static int trace_set_options(struct trac
 		ret = set_tracer_option(tr, cmp, neg);
 
 	mutex_unlock(&trace_types_lock);
+	mutex_unlock(&event_mutex);
 
 	/*
 	 * If the first trailing whitespace is replaced with '\0' by strstrip,
@@ -7373,9 +7379,11 @@ trace_options_core_write(struct file *fi
 	if (val != 0 && val != 1)
 		return -EINVAL;
 
+	mutex_lock(&event_mutex);
 	mutex_lock(&trace_types_lock);
 	ret = set_tracer_flag(tr, 1 << index, val);
 	mutex_unlock(&trace_types_lock);
+	mutex_unlock(&event_mutex);
 
 	if (ret < 0)
 		return ret;
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -326,7 +326,8 @@ void trace_event_enable_cmd_record(bool
 	struct trace_event_file *file;
 	struct trace_array *tr;
 
-	mutex_lock(&event_mutex);
+	lockdep_assert_held(&event_mutex);
+
 	do_for_each_event_file(tr, file) {
 
 		if (!(file->flags & EVENT_FILE_FL_ENABLED))
@@ -340,7 +341,6 @@ void trace_event_enable_cmd_record(bool
 			clear_bit(EVENT_FILE_FL_RECORDED_CMD_BIT, &file->flags);
 		}
 	} while_for_each_event_file();
-	mutex_unlock(&event_mutex);
 }
 
 void trace_event_enable_tgid_record(bool enable)
@@ -348,7 +348,8 @@ void trace_event_enable_tgid_record(bool
 	struct trace_event_file *file;
 	struct trace_array *tr;
 
-	mutex_lock(&event_mutex);
+	lockdep_assert_held(&event_mutex);
+
 	do_for_each_event_file(tr, file) {
 		if (!(file->flags & EVENT_FILE_FL_ENABLED))
 			continue;
@@ -362,7 +363,6 @@ void trace_event_enable_tgid_record(bool
 				  &file->flags);
 		}
 	} while_for_each_event_file();
-	mutex_unlock(&event_mutex);
 }
 
 static int __ftrace_event_enable_disable(struct trace_event_file *file,


