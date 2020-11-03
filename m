Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89C3F2A57BF
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730667AbgKCVpb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:45:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:50230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732182AbgKCUwz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:52:55 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A203A2053B;
        Tue,  3 Nov 2020 20:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436775;
        bh=RAJY/o5wLsTD7a8m2ah2SQ32/iyA/FEWJLhEtrirAw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ndh8Tm4cDj6mgGzcKGAfxKQddumQxXQGcb0wPRxmsUQ4Prkg3OF+8Ybn/4TFx91XB
         D2gvRikRajjVDQVGXqRcuzCaImmUrjhcXgyNMeB1VBoodjanq8qY4iec7MWiASA58O
         FBQE+0IbuNqxXy5c61pZjuSGd5vocrOacpwe2G/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Quanyang Wang <quanyang.wang@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.9 390/391] time/sched_clock: Mark sched_clock_read_begin/retry() as notrace
Date:   Tue,  3 Nov 2020 21:37:21 +0100
Message-Id: <20201103203413.480694586@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quanyang Wang <quanyang.wang@windriver.com>

commit 4cd2bb12981165f865d2b8ed92b446b52310ef74 upstream.

Since sched_clock_read_begin() and sched_clock_read_retry() are called
by notrace function sched_clock(), they shouldn't be traceable either,
or else ftrace_graph_caller will run into a dead loop on the path
as below (arm for instance):

  ftrace_graph_caller()
    prepare_ftrace_return()
      function_graph_enter()
        ftrace_push_return_trace()
          trace_clock_local()
            sched_clock()
              sched_clock_read_begin/retry()

Fixes: 1b86abc1c645 ("sched_clock: Expose struct clock_read_data")
Signed-off-by: Quanyang Wang <quanyang.wang@windriver.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200929082027.16787-1-quanyang.wang@windriver.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/time/sched_clock.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/time/sched_clock.c
+++ b/kernel/time/sched_clock.c
@@ -68,13 +68,13 @@ static inline u64 notrace cyc_to_ns(u64
 	return (cyc * mult) >> shift;
 }
 
-struct clock_read_data *sched_clock_read_begin(unsigned int *seq)
+notrace struct clock_read_data *sched_clock_read_begin(unsigned int *seq)
 {
 	*seq = raw_read_seqcount_latch(&cd.seq);
 	return cd.read_data + (*seq & 1);
 }
 
-int sched_clock_read_retry(unsigned int seq)
+notrace int sched_clock_read_retry(unsigned int seq)
 {
 	return read_seqcount_retry(&cd.seq, seq);
 }


