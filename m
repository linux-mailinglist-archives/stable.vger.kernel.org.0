Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB5D214300B
	for <lists+stable@lfdr.de>; Mon, 20 Jan 2020 17:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgATQgo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jan 2020 11:36:44 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37931 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729073AbgATQgo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jan 2020 11:36:44 -0500
Received: by mail-wm1-f66.google.com with SMTP id u2so238880wmc.3
        for <stable@vger.kernel.org>; Mon, 20 Jan 2020 08:36:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ALyiENCeDuKpEATpQ1h8kabgaW8aSQkr3Q+Uga+z3qo=;
        b=fQAjUbwG/NJ9IpKC7iPF9FtqCaWW3aDhrXxPMOXfoK/iVBvgQ0H8z0FVaipFLAeVhM
         D3NzrKgWqQSaiWXsGuXP4RQdpMsG3kv0J8lv0BJvgeSrL+2FAUgXTQaKAG1d3QxYFmCY
         rXUJ+GNMPaeMkm59Bztuc0lpyyLQhn0f9iHJVEhyLeguW7FuNBm+yEEBblxzoDDuBVtN
         a3IJtaCSSI+ptQa2vGDqJlQQSFerI0Z4aOmJ5N/9NqM/Tup6Kv3yWQceP0hu3kXx9fc/
         zcarmG6YwaFpuJ+fzbQf7Ocf1EI/ecWaW4aMd/E2/oBhVZkLhF3FonGMXhCMFVY97uPG
         iDpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ALyiENCeDuKpEATpQ1h8kabgaW8aSQkr3Q+Uga+z3qo=;
        b=Gwt+Pa9ccrjsRTX6DJKQgSJxEjAyswli8tfhobr2nq5Yu7oUodGT+8fZm81lqqhRT/
         LGrgD2ifE643qJE86g/nKbIw1a0I3dc2VAjGxxeHuBu3J9INIOJsUUfo3RMQ2gS2z5nm
         RgwLSflv52z7FD5xXfbVYaCisBbVJd7Bp81GExu/WXQkg7WmY2BSuyvZVEytEERbc+Oz
         ofsC2c5x6NYJPh+ZpV0xWHPbKLSUf+YNcudGj+pmOPf7wph8LsLKVV8MPdx60B5gMZsT
         siFelfTu16QbTOQZLjpgG2EeoPe8XZZ6mGIwqQDJbTg0f5HTMgzz89HhN/BbKeLJyMq4
         nkJQ==
X-Gm-Message-State: APjAAAV/asAk7WjOQs2QlAE0FbYIgtbGo9WOsonBfTjOW1yAvMzhbFQy
        cUoRBlXK0+dGdJQpFHaKDz++Nxs5r26C
X-Google-Smtp-Source: APXvYqzEvrdX/Hxd5Rq8phJxuRR6PXyExt54UX8lGrTBXfMn2GTGCsPON347HusQYomvmosMI8OSyg==
X-Received: by 2002:a1c:6755:: with SMTP id b82mr206896wmc.126.1579538202623;
        Mon, 20 Jan 2020 08:36:42 -0800 (PST)
Received: from ninjahub.org ([91.235.65.22])
        by smtp.googlemail.com with ESMTPSA id x7sm47089018wrq.41.2020.01.20.08.36.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 08:36:42 -0800 (PST)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     jbi.octave@gmail.com
Cc:     Kaitao Cheng <pilgrimtao@gmail.com>, stable@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6/7] kernel/trace: Fix do not unregister tracepoints when register sched_migrate_task fail
Date:   Mon, 20 Jan 2020 16:36:21 +0000
Message-Id: <20200120163622.8603-6-jbi.octave@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200120163622.8603-1-jbi.octave@gmail.com>
References: <20200120163622.8603-1-jbi.octave@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kaitao Cheng <pilgrimtao@gmail.com>

In the function, if register_trace_sched_migrate_task() returns error,
sched_switch/sched_wakeup_new/sched_wakeup won't unregister. That is
why fail_deprobe_sched_switch was added.

Link: http://lkml.kernel.org/r/20191231133530.2794-1-pilgrimtao@gmail.com

Cc: stable@vger.kernel.org
Fixes: 478142c39c8c2 ("tracing: do not grab lock in wakeup latency function tracing")
Signed-off-by: Kaitao Cheng <pilgrimtao@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace_sched_wakeup.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 5e43b9664eca..617e297f46dc 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -630,7 +630,7 @@ static void start_wakeup_tracer(struct trace_array *tr)
 	if (ret) {
 		pr_info("wakeup trace: Couldn't activate tracepoint"
 			" probe to kernel_sched_migrate_task\n");
-		return;
+		goto fail_deprobe_sched_switch;
 	}
 
 	wakeup_reset(tr);
@@ -648,6 +648,8 @@ static void start_wakeup_tracer(struct trace_array *tr)
 		printk(KERN_ERR "failed to start wakeup tracer\n");
 
 	return;
+fail_deprobe_sched_switch:
+	unregister_trace_sched_switch(probe_wakeup_sched_switch, NULL);
 fail_deprobe_wake_new:
 	unregister_trace_sched_wakeup_new(probe_wakeup, NULL);
 fail_deprobe:
-- 
2.24.1

