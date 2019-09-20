Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7740BB924F
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391082AbfITObX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:31:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36776 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388361AbfITOZO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:25:14 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqP-000512-UW; Fri, 20 Sep 2019 15:25:10 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqF-0007vA-OL; Fri, 20 Sep 2019 15:24:59 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Oleg Nesterov" <oleg@redhat.com>,
        "Orit Wasserman" <orit.was@gmail.com>,
        "Elazar Leibovich" <elazar@lightbitslabs.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        "Ingo Molnar" <mingo@redhat.com>
Date:   Fri, 20 Sep 2019 15:23:35 +0100
Message-ID: <lsq.1568989415.223863765@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 082/132] tracing: Fix partial reading of trace
 event's id file
In-Reply-To: <lsq.1568989414.954567518@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.74-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Elazar Leibovich <elazar@lightbitslabs.com>

commit cbe08bcbbe787315c425dde284dcb715cfbf3f39 upstream.

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
Fixes: 23725aeeab10b ("ftrace: provide an id file for each event")
Signed-off-by: Elazar Leibovich <elazar@lightbitslabs.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/trace/trace_events.c | 3 ---
 1 file changed, 3 deletions(-)

--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1007,9 +1007,6 @@ event_id_read(struct file *filp, char __
 	char buf[32];
 	int len;
 
-	if (*ppos)
-		return 0;
-
 	if (unlikely(!id))
 		return -ENODEV;
 

