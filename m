Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CEA928B925
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389075AbgJLN5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:57:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:43860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731478AbgJLNk6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:40:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C02322265;
        Mon, 12 Oct 2020 13:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510056;
        bh=0MFjUIJWDitqfpda3yDHJMDncKBqjrD8Llc6FXQLceE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xs1q/RZ2UA72f1dBCB1yzyvWSIRdoqCIaj9El4uNxJQLlbKYwQbsQ53+uwBEWd+t3
         5+o8GCCM4cFV+rO7/uoBga3OIwkd9p7X5Xxj+oX8Cr9ehlPOTjz1xlbsBVlkLGsEAo
         aEFdN9wTJfLP7/VfaYZCZ3sFDtanj1dqJtyriZtg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tommi Rantala <tommi.t.rantala@nokia.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Mamatha Inamdar <mamatha4@linux.vnet.ibm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Subject: [PATCH 5.4 22/85] perf test session topology: Fix data path
Date:   Mon, 12 Oct 2020 15:26:45 +0200
Message-Id: <20201012132633.918610335@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132632.846779148@linuxfoundation.org>
References: <20201012132632.846779148@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tommi Rantala <tommi.t.rantala@nokia.com>

commit dbd660e6b2884b864d2642d930a163d3bcebe4be upstream.

Commit 2d4f27999b88 ("perf data: Add global path holder") missed path
conversion in tests/topology.c, causing the "Session topology" testcase
to "hang" (waits forever for input from stdin) when doing "ssh $VM perf
test".

Can be reproduced by running "cat | perf test topo", and crashed by
replacing cat with true:

  $ true | perf test -v topo
  40: Session topology                                      :
  --- start ---
  test child forked, pid 3638
  templ file: /tmp/perf-test-QPvAch
  incompatible file format
  incompatible file format (rerun with -v to learn more)
  free(): invalid pointer
  test child interrupted
  ---- end ----
  Session topology: FAILED!

Committer testing:

Reproduced the above result before the patch and after it is back
working:

  # true | perf test -v topo
  41: Session topology                                      :
  --- start ---
  test child forked, pid 19374
  templ file: /tmp/perf-test-YOTEQg
  CPU 0, core 0, socket 0
  CPU 1, core 1, socket 0
  CPU 2, core 2, socket 0
  CPU 3, core 3, socket 0
  CPU 4, core 0, socket 0
  CPU 5, core 1, socket 0
  CPU 6, core 2, socket 0
  CPU 7, core 3, socket 0
  test child finished with 0
  ---- end ----
  Session topology: Ok
  #

Fixes: 2d4f27999b88 ("perf data: Add global path holder")
Signed-off-by: Tommi Rantala <tommi.t.rantala@nokia.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Mamatha Inamdar <mamatha4@linux.vnet.ibm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Link: http://lore.kernel.org/lkml/20200423115341.562782-1-tommi.t.rantala@nokia.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/tests/topology.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/tools/perf/tests/topology.c
+++ b/tools/perf/tests/topology.c
@@ -33,10 +33,8 @@ static int session_write_header(char *pa
 {
 	struct perf_session *session;
 	struct perf_data data = {
-		.file      = {
-			.path = path,
-		},
-		.mode      = PERF_DATA_MODE_WRITE,
+		.path = path,
+		.mode = PERF_DATA_MODE_WRITE,
 	};
 
 	session = perf_session__new(&data, false, NULL);
@@ -63,10 +61,8 @@ static int check_cpu_topology(char *path
 {
 	struct perf_session *session;
 	struct perf_data data = {
-		.file      = {
-			.path = path,
-		},
-		.mode      = PERF_DATA_MODE_READ,
+		.path = path,
+		.mode = PERF_DATA_MODE_READ,
 	};
 	int i;
 


