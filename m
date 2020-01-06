Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB1E131A43
	for <lists+stable@lfdr.de>; Mon,  6 Jan 2020 22:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbgAFVUA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jan 2020 16:20:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:56362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726967AbgAFVUA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Jan 2020 16:20:00 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DF2D24676;
        Mon,  6 Jan 2020 21:19:59 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92.3)
        (envelope-from <rostedt@goodmis.org>)
        id 1ioZn4-000MWy-HX; Mon, 06 Jan 2020 16:19:58 -0500
Message-Id: <20200106211958.412341162@goodmis.org>
User-Agent: quilt/0.65
Date:   Mon, 06 Jan 2020 16:19:06 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        David Sterba <dsterba@suse.com>,
        Ingo Molnar <mingo@redhat.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Antonio Borneo <antonio.borneo@st.com>, stable@vger.kernel.org,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>
Subject: [for-linus][PATCH 5/7] tracing: Change offset type to s32 in preempt/irq tracepoints
References: <20200106211901.293910946@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Joel Fernandes (Google)" <joel@joelfernandes.org>

Discussion in the below link reported that symbols in modules can appear
to be before _stext on ARM architecture, causing wrapping with the
offsets of this tracepoint. Change the offset type to s32 to fix this.

Link: http://lore.kernel.org/r/20191127154428.191095-1-antonio.borneo@st.com
Link: http://lkml.kernel.org/r/20200102194625.226436-1-joel@joelfernandes.org

Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Antonio Borneo <antonio.borneo@st.com>
Cc: stable@vger.kernel.org
Fixes: d59158162e032 ("tracing: Add support for preempt and irq enable/disable events")
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/trace/events/preemptirq.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/preemptirq.h b/include/trace/events/preemptirq.h
index 95fba0471e5b..3f249e150c0c 100644
--- a/include/trace/events/preemptirq.h
+++ b/include/trace/events/preemptirq.h
@@ -18,13 +18,13 @@ DECLARE_EVENT_CLASS(preemptirq_template,
 	TP_ARGS(ip, parent_ip),
 
 	TP_STRUCT__entry(
-		__field(u32, caller_offs)
-		__field(u32, parent_offs)
+		__field(s32, caller_offs)
+		__field(s32, parent_offs)
 	),
 
 	TP_fast_assign(
-		__entry->caller_offs = (u32)(ip - (unsigned long)_stext);
-		__entry->parent_offs = (u32)(parent_ip - (unsigned long)_stext);
+		__entry->caller_offs = (s32)(ip - (unsigned long)_stext);
+		__entry->parent_offs = (s32)(parent_ip - (unsigned long)_stext);
 	),
 
 	TP_printk("caller=%pS parent=%pS",
-- 
2.24.0


