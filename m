Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6696180F8
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 22:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728965AbfEHUZF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 May 2019 16:25:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:35160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728837AbfEHUYz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 May 2019 16:24:55 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84B962173B;
        Wed,  8 May 2019 20:24:54 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92)
        (envelope-from <rostedt@goodmis.org>)
        id 1hOT7V-0007ji-Ku; Wed, 08 May 2019 16:24:53 -0400
Message-Id: <20190508202453.536550511@goodmis.org>
User-Agent: quilt/0.65
Date:   Wed, 08 May 2019 16:24:38 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Orit Wasserman <orit.was@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, stable@vger.kernel.org,
        Elazar Leibovich <elazar@lightbitslabs.com>
Subject: [for-next][PATCH 11/13] tracing: Fix partial reading of trace events id file
References: <20190508202427.252736423@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Elazar Leibovich <elazar@lightbitslabs.com>

When reading only part of the id file, the ppos isn't tracked correctly.
This is taken care by simple_read_from_buffer.

Reading a single byte, and then the next byte would result EOF.

While this seems like not a big deal, this breaks abstractions that
reads information from files unbuffered. See for example
https://github.com/golang/go/issues/29399

This code was mentioned as problematic in
commit cd458ba9d5a5
("tracing: Do not (ab)use trace_seq in event_id_read()")

An example C code that show this bug is:

  #include <stdio.h>
  #include <stdint.h>

  #include <sys/types.h>
  #include <sys/stat.h>
  #include <fcntl.h>
  #include <unistd.h>

  int main(int argc, char **argv) {
    if (argc < 2)
      return 1;
    int fd = open(argv[1], O_RDONLY);
    char c;
    read(fd, &c, 1);
    printf("First  %c\n", c);
    read(fd, &c, 1);
    printf("Second %c\n", c);
  }

Then run with, e.g.

  sudo ./a.out /sys/kernel/debug/tracing/events/tcp/tcp_set_state/id

You'll notice you're getting the first character twice, instead of the
first two characters in the id file.

Link: http://lkml.kernel.org/r/20181231115837.4932-1-elazar@lightbitslabs.com

Cc: Orit Wasserman <orit.was@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 23725aeeab10b ("ftrace: provide an id file for each event")
Signed-off-by: Elazar Leibovich <elazar@lightbitslabs.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 81c038ed6cee..0ce3db67f556 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1319,9 +1319,6 @@ event_id_read(struct file *filp, char __user *ubuf, size_t cnt, loff_t *ppos)
 	char buf[32];
 	int len;
 
-	if (*ppos)
-		return 0;
-
 	if (unlikely(!id))
 		return -ENODEV;
 
-- 
2.20.1


