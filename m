Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF81C916E
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 21:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729398AbfJBTIW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 15:08:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36126 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729385AbfJBTIW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Oct 2019 15:08:22 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyu-000368-RX; Wed, 02 Oct 2019 20:08:12 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyq-0003fy-10; Wed, 02 Oct 2019 20:08:08 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        mpe@ellerman.id.au, "Ravi Bangoria" <ravi.bangoria@linux.ibm.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Arnaldo Carvalho de Melo" <acme@redhat.com>,
        "Ingo Molnar" <mingo@kernel.org>, linuxppc-dev@lists.ozlabs.org,
        "Stephane Eranian" <eranian@google.com>, maddy@linux.vnet.ibm.com,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Alexander Shishkin" <alexander.shishkin@linux.intel.com>,
        "Vince Weaver" <vincent.weaver@maine.edu>, acme@kernel.org,
        "Jiri Olsa" <jolsa@redhat.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>
Date:   Wed, 02 Oct 2019 20:06:51 +0100
Message-ID: <lsq.1570043211.910896713@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 76/87] perf/ioctl: Add check for the sample_period value
In-Reply-To: <lsq.1570043210.379046399@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.75-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ravi Bangoria <ravi.bangoria@linux.ibm.com>

commit 913a90bc5a3a06b1f04c337320e9aeee2328dd77 upstream.

perf_event_open() limits the sample_period to 63 bits. See:

  0819b2e30ccb ("perf: Limit perf_event_attr::sample_period to 63 bits")

Make ioctl() consistent with it.

Also on PowerPC, negative sample_period could cause a recursive
PMIs leading to a hang (reported when running perf-fuzzer).

Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Cc: acme@kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: maddy@linux.vnet.ibm.com
Cc: mpe@ellerman.id.au
Fixes: 0819b2e30ccb ("perf: Limit perf_event_attr::sample_period to 63 bits")
Link: https://lkml.kernel.org/r/20190604042953.914-1-ravi.bangoria@linux.ibm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/events/core.c | 3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3823,6 +3823,9 @@ static int perf_event_period(struct perf
 	if (perf_event_check_period(event, value))
 		return -EINVAL;
 
+	if (!event->attr.freq && (value & (1ULL << 63)))
+		return -EINVAL;
+
 	task = ctx->task;
 	pe.value = value;
 

