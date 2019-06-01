Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BCE131DC8
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728304AbfFANZv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:25:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:56210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729552AbfFANZu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:25:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 146D82739B;
        Sat,  1 Jun 2019 13:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395549;
        bh=FJIoqZ3bUBzyDyOiVEgVb95bb2oFjRDbg5iidlYew6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XMahaD9f404fTDalv3bnEzgEAZvn4Wy5f70bNJB30R/iR33AMhFypSbh6dZEvhpEn
         bzljlsW1Y9TAU8r3gn7MpP+ijRr7d7ftbsaFntfOK2sWp0NZ3G8Kc7/QLXx2bAoRkW
         hkuQPf6uKeuIW7hO1zV8ls7620wC2T4N55b0f6ls=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Elazar Leibovich <elazar@lightbitslabs.com>,
        Orit Wasserman <orit.was@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 25/74] tracing: Fix partial reading of trace event's id file
Date:   Sat,  1 Jun 2019 09:24:12 -0400
Message-Id: <20190601132501.27021-25-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601132501.27021-1-sashal@kernel.org>
References: <20190601132501.27021-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Elazar Leibovich <elazar@lightbitslabs.com>

[ Upstream commit cbe08bcbbe787315c425dde284dcb715cfbf3f39 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 9549ed120556e..af969f753e5e9 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1310,9 +1310,6 @@ event_id_read(struct file *filp, char __user *ubuf, size_t cnt, loff_t *ppos)
 	char buf[32];
 	int len;
 
-	if (*ppos)
-		return 0;
-
 	if (unlikely(!id))
 		return -ENODEV;
 
-- 
2.20.1

