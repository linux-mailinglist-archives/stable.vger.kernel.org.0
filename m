Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B55BA2EB04
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727571AbfE3DJ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:09:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:44064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727548AbfE3DJ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:09:27 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00B9C24476;
        Thu, 30 May 2019 03:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185766;
        bh=1E2yZP9wUD7Z28oDdb97GAXSKy+cvmrKQ+1fc9bEQUk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XvytrlwVRJnDft2qX+E8ryFO0F3mePoUaCixzYI3BdE4/1EJGwgOKj8ws+Q5fIB17
         gLfVV6pBa06+5Dvv9ciKQfwsMMZBi/KtLiSSDcFPLCKs+dY151Ag4CEDgac52wGY0/
         k3XC8/xOIpGI9MmiMSd0zWrv8XRiX2iucu/D4OcE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Zanussi <tom.zanussi@linux.intel.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.1 013/405] tracing: Add a check_val() check before updating cond_snapshot() track_val
Date:   Wed, 29 May 2019 20:00:11 -0700
Message-Id: <20190530030541.131126634@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Zanussi <tom.zanussi@linux.intel.com>

commit 9b2ca371b1505a547217b244f903ad3fb86fa5b4 upstream.

Without this check a snapshot is taken whenever a bucket's max is hit,
rather than only when the global max is hit, as it should be.

Before:

  In this example, we do a first run of the workload (cyclictest),
  examine the output, note the max ('triggering value') (347), then do
  a second run and note the max again.

  In this case, the max in the second run (39) is below the max in the
  first run, but since we haven't cleared the histogram, the first max
  is still in the histogram and is higher than any other max, so it
  should still be the max for the snapshot.  It isn't however - the
  value should still be 347 after the second run.

  # echo 'hist:keys=pid:ts0=common_timestamp.usecs if comm=="cyclictest"' >> /sys/kernel/debug/tracing/events/sched/sched_waking/trigger
  # echo 'hist:keys=next_pid:wakeup_lat=common_timestamp.usecs-$ts0:onmax($wakeup_lat).save(next_prio,next_comm,prev_pid,prev_prio,prev_comm):onmax($wakeup_lat).snapshot() if next_comm=="cyclictest"' >> /sys/kernel/debug/tracing/events/sched/sched_switch/trigger

  # cyclictest -p 80 -n -s -t 2 -D 2

  # cat /sys/kernel/debug/tracing/events/sched/sched_switch/hist

  { next_pid:       2143 } hitcount:        199
    max:         44  next_prio:        120  next_comm: cyclictest
    prev_pid:          0  prev_prio:        120  prev_comm: swapper/4

  { next_pid:       2145 } hitcount:       1325
    max:         38  next_prio:         19  next_comm: cyclictest
    prev_pid:          0  prev_prio:        120  prev_comm: swapper/2

  { next_pid:       2144 } hitcount:       1982
    max:        347  next_prio:         19  next_comm: cyclictest
    prev_pid:          0  prev_prio:        120  prev_comm: swapper/6

  Snapshot taken (see tracing/snapshot).  Details:
      triggering value { onmax($wakeup_lat) }:        347
      triggered by event with key: { next_pid:       2144 }

  # cyclictest -p 80 -n -s -t 2 -D 2

  # cat /sys/kernel/debug/tracing/events/sched/sched_switch/hist

  { next_pid:       2143 } hitcount:        199
    max:         44  next_prio:        120  next_comm: cyclictest
    prev_pid:          0  prev_prio:        120  prev_comm: swapper/4

  { next_pid:       2148 } hitcount:        199
    max:         16  next_prio:        120  next_comm: cyclictest
    prev_pid:          0  prev_prio:        120  prev_comm: swapper/1

  { next_pid:       2145 } hitcount:       1325
    max:         38  next_prio:         19  next_comm: cyclictest
    prev_pid:          0  prev_prio:        120  prev_comm: swapper/2

  { next_pid:       2150 } hitcount:       1326
    max:         39  next_prio:         19  next_comm: cyclictest
    prev_pid:          0  prev_prio:        120  prev_comm: swapper/4

  { next_pid:       2144 } hitcount:       1982
    max:        347  next_prio:         19  next_comm: cyclictest
    prev_pid:          0  prev_prio:        120  prev_comm: swapper/6

  { next_pid:       2149 } hitcount:       1983
    max:        130  next_prio:         19  next_comm: cyclictest
    prev_pid:          0  prev_prio:        120  prev_comm: swapper/0

  Snapshot taken (see tracing/snapshot).  Details:
    triggering value { onmax($wakeup_lat) }:    39
    triggered by event with key: { next_pid:       2150 }

After:

  In this example, we do a first run of the workload (cyclictest),
  examine the output, note the max ('triggering value') (375), then do
  a second run and note the max again.

  In this case, the max in the second run is still 375, the highest in
  any bucket, as it should be.

  # cyclictest -p 80 -n -s -t 2 -D 2

  # cat /sys/kernel/debug/tracing/events/sched/sched_switch/hist

  { next_pid:       2072 } hitcount:        200
    max:         28  next_prio:        120  next_comm: cyclictest
    prev_pid:          0  prev_prio:        120  prev_comm: swapper/5

  { next_pid:       2074 } hitcount:       1323
    max:        375  next_prio:         19  next_comm: cyclictest
    prev_pid:          0  prev_prio:        120  prev_comm: swapper/2

  { next_pid:       2073 } hitcount:       1980
    max:        153  next_prio:         19  next_comm: cyclictest
    prev_pid:          0  prev_prio:        120  prev_comm: swapper/6

  Snapshot taken (see tracing/snapshot).  Details:
    triggering value { onmax($wakeup_lat) }:        375
    triggered by event with key: { next_pid:       2074 }

  # cyclictest -p 80 -n -s -t 2 -D 2

  # cat /sys/kernel/debug/tracing/events/sched/sched_switch/hist

  { next_pid:       2101 } hitcount:        199
    max:         49  next_prio:        120  next_comm: cyclictest
    prev_pid:          0  prev_prio:        120  prev_comm: swapper/6

  { next_pid:       2072 } hitcount:        200
    max:         28  next_prio:        120  next_comm: cyclictest
    prev_pid:          0  prev_prio:        120  prev_comm: swapper/5

  { next_pid:       2074 } hitcount:       1323
    max:        375  next_prio:         19  next_comm: cyclictest
    prev_pid:          0  prev_prio:        120  prev_comm: swapper/2

  { next_pid:       2103 } hitcount:       1325
    max:         74  next_prio:         19  next_comm: cyclictest
    prev_pid:          0  prev_prio:        120  prev_comm: swapper/4

  { next_pid:       2073 } hitcount:       1980
    max:        153  next_prio:         19  next_comm: cyclictest
    prev_pid:          0  prev_prio:        120  prev_comm: swapper/6

  { next_pid:       2102 } hitcount:       1981
    max:         84  next_prio:         19  next_comm: cyclictest
    prev_pid:         12  prev_prio:        120  prev_comm: kworker/0:1

  Snapshot taken (see tracing/snapshot).  Details:
    triggering value { onmax($wakeup_lat) }:        375
    triggered by event with key: { next_pid:       2074 }

Link: http://lkml.kernel.org/r/95958351329f129c07504b4d1769c47a97b70d65.1555597045.git.tom.zanussi@linux.intel.com

Cc: stable@vger.kernel.org
Fixes: a3785b7eca8fd ("tracing: Add hist trigger snapshot() action")
Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace_events_hist.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -3543,14 +3543,20 @@ static bool cond_snapshot_update(struct
 	struct track_data *track_data = tr->cond_snapshot->cond_data;
 	struct hist_elt_data *elt_data, *track_elt_data;
 	struct snapshot_context *context = cond_data;
+	struct action_data *action;
 	u64 track_val;
 
 	if (!track_data)
 		return false;
 
+	action = track_data->action_data;
+
 	track_val = get_track_val(track_data->hist_data, context->elt,
 				  track_data->action_data);
 
+	if (!action->track_data.check_val(track_data->track_val, track_val))
+		return false;
+
 	track_data->track_val = track_val;
 	memcpy(track_data->key, context->key, track_data->key_len);
 


