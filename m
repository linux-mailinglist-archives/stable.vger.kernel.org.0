Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49AE6D5714
	for <lists+stable@lfdr.de>; Sun, 13 Oct 2019 19:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726264AbfJMRoe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Oct 2019 13:44:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:36820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728689AbfJMRoV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 13 Oct 2019 13:44:21 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA3182084D;
        Sun, 13 Oct 2019 17:44:20 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92.2)
        (envelope-from <rostedt@goodmis.org>)
        id 1iJhul-00024k-RY; Sun, 13 Oct 2019 13:44:19 -0400
Message-Id: <20191013174419.738889779@goodmis.org>
User-Agent: quilt/0.65
Date:   Sun, 13 Oct 2019 13:43:52 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org,
        "Srivatsa S. Bhat (VMware)" <srivatsa@csail.mit.edu>
Subject: [for-linus][PATCH 10/11] tracing/hwlat: Dont ignore outer-loop duration when calculating
 max_latency
References: <20191013174342.381019558@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Srivatsa S. Bhat (VMware)" <srivatsa@csail.mit.edu>

max_latency is intended to record the maximum ever observed hardware
latency, which may occur in either part of the loop (inner/outer). So
we need to also consider the outer-loop sample when updating
max_latency.

Link: http://lkml.kernel.org/r/157073345463.17189.18124025522664682811.stgit@srivatsa-ubuntu

Fixes: e7c15cd8a113 ("tracing: Added hardware latency tracer")
Cc: stable@vger.kernel.org
Signed-off-by: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace_hwlat.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/trace/trace_hwlat.c b/kernel/trace/trace_hwlat.c
index a0251a78807d..862f4b0139fc 100644
--- a/kernel/trace/trace_hwlat.c
+++ b/kernel/trace/trace_hwlat.c
@@ -256,6 +256,8 @@ static int get_sample(void)
 		/* Keep a running maximum ever recorded hardware latency */
 		if (sample > tr->max_latency)
 			tr->max_latency = sample;
+		if (outer_sample > tr->max_latency)
+			tr->max_latency = outer_sample;
 	}
 
 out:
-- 
2.23.0


