Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03750616BD
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727635AbfGGTiN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:38:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57648 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727617AbfGGTiM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:12 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz9-0006kK-DQ; Sun, 07 Jul 2019 20:38:07 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz6-0005di-SH; Sun, 07 Jul 2019 20:38:04 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Frederic Weisbecker" <fweisbec@gmail.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        "Mathias Krause" <minipli@googlemail.com>,
        "Michael Sartain" <mikesart@fastmail.com>,
        "Tony Jones" <tonyj@suse.de>,
        "Arnaldo Carvalho de Melo" <acme@redhat.com>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.890209196@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 092/129] tools lib traceevent: Fix buffer overflow in
 arg_eval
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
X-SA-Exim-Connect-IP: 94.197.121.43
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.70-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Jones <tonyj@suse.de>

commit 7c5b019e3a638a5a290b0ec020f6ca83d2ec2aaa upstream.

Fix buffer overflow observed when running perf test.

The overflow is when trying to evaluate "1ULL << (64 - 1)" which is
resulting in -9223372036854775808 which overflows the 20 character
buffer.

If is possible this bug has been reported before but I still don't see
any fix checked in:

See: https://www.spinics.net/lists/linux-perf-users/msg07714.html

Reported-by: Michael Sartain <mikesart@fastmail.com>
Reported-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: Tony Jones <tonyj@suse.de>
Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Fixes: f7d82350e597 ("tools/events: Add files to create libtraceevent.a")
Link: http://lkml.kernel.org/r/20190228015532.8941-1-tonyj@suse.de
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 tools/lib/traceevent/event-parse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -2283,7 +2283,7 @@ static int arg_num_eval(struct print_arg
 static char *arg_eval (struct print_arg *arg)
 {
 	long long val;
-	static char buf[20];
+	static char buf[24];
 
 	switch (arg->type) {
 	case PRINT_ATOM:

