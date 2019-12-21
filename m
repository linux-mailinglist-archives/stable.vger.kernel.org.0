Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7750128BA9
	for <lists+stable@lfdr.de>; Sat, 21 Dec 2019 22:11:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727492AbfLUVLk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Dec 2019 16:11:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:36860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727412AbfLUVLf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 21 Dec 2019 16:11:35 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC8272166E;
        Sat, 21 Dec 2019 21:11:34 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92.3)
        (envelope-from <rostedt@goodmis.org>)
        id 1iim29-000o3L-QZ; Sat, 21 Dec 2019 16:11:33 -0500
Message-Id: <20191221211133.694338753@goodmis.org>
User-Agent: quilt/0.65
Date:   Sat, 21 Dec 2019 16:11:11 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Tom Zanussi <tom.zanussi@linux.intel.com>,
        Sven Schnelle <svens@linux.ibm.com>
Subject: [for-linus][PATCH 5/5] tracing: Fix endianness bug in histogram trigger
References: <20191221211106.338673631@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Schnelle <svens@linux.ibm.com>

At least on PA-RISC and s390 synthetic histogram triggers are failing
selftests because trace_event_raw_event_synth() always writes a 64 bit
values, but the reader expects a field->size sized value. On little endian
machines this doesn't hurt, but on big endian this makes the reader always
read zero values.

Link: http://lore.kernel.org/linux-trace-devel/20191218074427.96184-4-svens@linux.ibm.com

Cc: stable@vger.kernel.org
Fixes: 4b147936fa509 ("tracing: Add support for 'synthetic' events")
Acked-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace_events_hist.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index f49d1a36d3ae..f62de5f43e79 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -911,7 +911,26 @@ static notrace void trace_event_raw_event_synth(void *__data,
 			strscpy(str_field, str_val, STR_VAR_LEN_MAX);
 			n_u64 += STR_VAR_LEN_MAX / sizeof(u64);
 		} else {
-			entry->fields[n_u64] = var_ref_vals[var_ref_idx + i];
+			struct synth_field *field = event->fields[i];
+			u64 val = var_ref_vals[var_ref_idx + i];
+
+			switch (field->size) {
+			case 1:
+				*(u8 *)&entry->fields[n_u64] = (u8)val;
+				break;
+
+			case 2:
+				*(u16 *)&entry->fields[n_u64] = (u16)val;
+				break;
+
+			case 4:
+				*(u32 *)&entry->fields[n_u64] = (u32)val;
+				break;
+
+			default:
+				entry->fields[n_u64] = val;
+				break;
+			}
 			n_u64++;
 		}
 	}
-- 
2.24.0


