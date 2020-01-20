Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A485143008
	for <lists+stable@lfdr.de>; Mon, 20 Jan 2020 17:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729121AbgATQgn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jan 2020 11:36:43 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54794 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729073AbgATQgm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jan 2020 11:36:42 -0500
Received: by mail-wm1-f68.google.com with SMTP id b19so212299wmj.4
        for <stable@vger.kernel.org>; Mon, 20 Jan 2020 08:36:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=my3klEdMv2aXl47gDfCMre1jIwXbyGvgJglyXOvxDvo=;
        b=ptMjcISULgCPNftGjxd+Y+qnIh7ZlYKa9X/KNGrAx46pIiZDTahrK62V3Eu2fsca66
         61sd2aODUGLQrV8f/eap8xrUlJP/B8GfNfiQE6VhVe8H42uITQ9B0L9t8CsRd48l3XJ5
         UhuHeXK2H4HomE3ckAJBjvj7jeTiht6KEvPXmx/Vy37vkHLyMc8e2b/SNwnYlUj+BXj3
         xD8GN066/9fC7x2YpLvWgbuQNQY1+xzcAQu77b08a/T2c0lZcPQvCrgYUJwfBi3WSOlj
         6UoiWl+Ry/aVcl1zziQkIPAkfsg033Yj7XI+5cDmoTCO0VrR7V7/9Vo3r65xFN/x+qGA
         9/bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=my3klEdMv2aXl47gDfCMre1jIwXbyGvgJglyXOvxDvo=;
        b=ks//9VqHX4TQNNW/M6rWH9XP672610fCiVqLq+Qr53kOlCXjfiHE2jyCgwfCMQrRPN
         s3VtF7qm8/XTPSI2wBpyuO6CEgbu3U9GRWYUX/rtlBdpMSh3DT4vgKQSJXLsdt+jGsD5
         Kk6e7KRE8AM6b6Xa74Oiv7kBRmp6BXUyySnGqLmMs4Ft8HoVdSdqrcp9D48YoAuKk4Mv
         DRj4hnXCQg3nyleGFd28jVLvZwfkBdLtWZAOoG3nwJK5sYKG+cYUthy6/8g2vu8tVE9h
         h0RqQMDLmrE5OrjUCbvlvxsp2dfPvYxCLd7emmOKrEsyy/0H5Nyqc43P1r68RevvWZW2
         433g==
X-Gm-Message-State: APjAAAXeLDnU7RZJ2ylu1ZUjk2vtqsxdCDGYZlsrLUudl4jXr3MO0i4W
        tbz6HAmEKb8AF7PdrPxztR+oivDQsQ==
X-Google-Smtp-Source: APXvYqwoLM+da5XTG5xwcz216k8hd+a6Cc9iGoOt4iLYUDOsRkUEzN9TF30EzBz5S9HZBhtyVqmGcw==
X-Received: by 2002:a7b:c386:: with SMTP id s6mr174680wmj.105.1579538200748;
        Mon, 20 Jan 2020 08:36:40 -0800 (PST)
Received: from ninjahub.org ([91.235.65.22])
        by smtp.googlemail.com with ESMTPSA id x7sm47089018wrq.41.2020.01.20.08.36.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 08:36:40 -0800 (PST)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     jbi.octave@gmail.com
Cc:     Wen Yang <wenyang@linux.alibaba.com>, stable@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 4/7] ftrace: Avoid potential division by zero in function profiler
Date:   Mon, 20 Jan 2020 16:36:19 +0000
Message-Id: <20200120163622.8603-4-jbi.octave@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200120163622.8603-1-jbi.octave@gmail.com>
References: <20200120163622.8603-1-jbi.octave@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Yang <wenyang@linux.alibaba.com>

The ftrace_profile->counter is unsigned long and
do_div truncates it to 32 bits, which means it can test
non-zero and be truncated to zero for division.
Fix this issue by using div64_ul() instead.

Link: http://lkml.kernel.org/r/20200103030248.14516-1-wenyang@linux.alibaba.com

Cc: stable@vger.kernel.org
Fixes: e330b3bcd8319 ("tracing: Show sample std dev in function profiling")
Fixes: 34886c8bc590f ("tracing: add average time in function to function profiler")
Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index ac99a3500076..9bf1f2cd515e 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -526,8 +526,7 @@ static int function_stat_show(struct seq_file *m, void *v)
 	}
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
-	avg = rec->time;
-	do_div(avg, rec->counter);
+	avg = div64_ul(rec->time, rec->counter);
 	if (tracing_thresh && (avg < tracing_thresh))
 		goto out;
 #endif
@@ -553,7 +552,8 @@ static int function_stat_show(struct seq_file *m, void *v)
 		 * Divide only 1000 for ns^2 -> us^2 conversion.
 		 * trace_print_graph_duration will divide 1000 again.
 		 */
-		do_div(stddev, rec->counter * (rec->counter - 1) * 1000);
+		stddev = div64_ul(stddev,
+				  rec->counter * (rec->counter - 1) * 1000);
 	}
 
 	trace_seq_init(&s);
-- 
2.24.1

