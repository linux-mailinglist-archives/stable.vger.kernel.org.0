Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF61F3C4A7B
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239139AbhGLGwe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:52:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:48258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239132AbhGLGta (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:49:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 852536100B;
        Mon, 12 Jul 2021 06:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072383;
        bh=8xr/XvRzypM7CcCr10HDc64nHFPH+fOD2OKn86YUXo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uL93HZHBmspSidi4914gVwo0RbWNnIGEfpxl6lGECd5Co69K7aZ/DKQ+pwj4E50kj
         xIN2e2MGOstQx+C1qolfnNV3e4VGPubRxVuqOynDvSaEcjx2wlwwl8RKbxK3JQPVaO
         D7MqYGMcqrWruMnG/rH2v7nmOBDty1aQfrYSu1Qw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 472/593] perf scripting python: Fix tuple_set_u64()
Date:   Mon, 12 Jul 2021 08:10:32 +0200
Message-Id: <20210712060941.972343380@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit d04c1ff0b3ddd5c0fbbe640996c8eaad279ed1c5 ]

tuple_set_u64() produces a signed value instead of an unsigned value.
That works for database export but not other cases. Rename to
tuple_set_d64() for database export and fix tuple_set_u64().

Fixes: df919b400ad3f ("perf scripting python: Extend interface to export data in a database-friendly way")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Link: https://lore.kernel.org/r/20210525095112.1399-2-adrian.hunter@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../scripting-engines/trace-event-python.c    | 146 ++++++++++--------
 1 file changed, 81 insertions(+), 65 deletions(-)

diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index c83c2c6564e0..23dc5014e711 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -934,7 +934,7 @@ static PyObject *tuple_new(unsigned int sz)
 	return t;
 }
 
-static int tuple_set_u64(PyObject *t, unsigned int pos, u64 val)
+static int tuple_set_s64(PyObject *t, unsigned int pos, s64 val)
 {
 #if BITS_PER_LONG == 64
 	return PyTuple_SetItem(t, pos, _PyLong_FromLong(val));
@@ -944,6 +944,22 @@ static int tuple_set_u64(PyObject *t, unsigned int pos, u64 val)
 #endif
 }
 
+/*
+ * Databases support only signed 64-bit numbers, so even though we are
+ * exporting a u64, it must be as s64.
+ */
+#define tuple_set_d64 tuple_set_s64
+
+static int tuple_set_u64(PyObject *t, unsigned int pos, u64 val)
+{
+#if BITS_PER_LONG == 64
+	return PyTuple_SetItem(t, pos, PyLong_FromUnsignedLong(val));
+#endif
+#if BITS_PER_LONG == 32
+	return PyTuple_SetItem(t, pos, PyLong_FromUnsignedLongLong(val));
+#endif
+}
+
 static int tuple_set_s32(PyObject *t, unsigned int pos, s32 val)
 {
 	return PyTuple_SetItem(t, pos, _PyLong_FromLong(val));
@@ -967,7 +983,7 @@ static int python_export_evsel(struct db_export *dbe, struct evsel *evsel)
 
 	t = tuple_new(2);
 
-	tuple_set_u64(t, 0, evsel->db_id);
+	tuple_set_d64(t, 0, evsel->db_id);
 	tuple_set_string(t, 1, evsel__name(evsel));
 
 	call_object(tables->evsel_handler, t, "evsel_table");
@@ -985,7 +1001,7 @@ static int python_export_machine(struct db_export *dbe,
 
 	t = tuple_new(3);
 
-	tuple_set_u64(t, 0, machine->db_id);
+	tuple_set_d64(t, 0, machine->db_id);
 	tuple_set_s32(t, 1, machine->pid);
 	tuple_set_string(t, 2, machine->root_dir ? machine->root_dir : "");
 
@@ -1004,9 +1020,9 @@ static int python_export_thread(struct db_export *dbe, struct thread *thread,
 
 	t = tuple_new(5);
 
-	tuple_set_u64(t, 0, thread->db_id);
-	tuple_set_u64(t, 1, machine->db_id);
-	tuple_set_u64(t, 2, main_thread_db_id);
+	tuple_set_d64(t, 0, thread->db_id);
+	tuple_set_d64(t, 1, machine->db_id);
+	tuple_set_d64(t, 2, main_thread_db_id);
 	tuple_set_s32(t, 3, thread->pid_);
 	tuple_set_s32(t, 4, thread->tid);
 
@@ -1025,10 +1041,10 @@ static int python_export_comm(struct db_export *dbe, struct comm *comm,
 
 	t = tuple_new(5);
 
-	tuple_set_u64(t, 0, comm->db_id);
+	tuple_set_d64(t, 0, comm->db_id);
 	tuple_set_string(t, 1, comm__str(comm));
-	tuple_set_u64(t, 2, thread->db_id);
-	tuple_set_u64(t, 3, comm->start);
+	tuple_set_d64(t, 2, thread->db_id);
+	tuple_set_d64(t, 3, comm->start);
 	tuple_set_s32(t, 4, comm->exec);
 
 	call_object(tables->comm_handler, t, "comm_table");
@@ -1046,9 +1062,9 @@ static int python_export_comm_thread(struct db_export *dbe, u64 db_id,
 
 	t = tuple_new(3);
 
-	tuple_set_u64(t, 0, db_id);
-	tuple_set_u64(t, 1, comm->db_id);
-	tuple_set_u64(t, 2, thread->db_id);
+	tuple_set_d64(t, 0, db_id);
+	tuple_set_d64(t, 1, comm->db_id);
+	tuple_set_d64(t, 2, thread->db_id);
 
 	call_object(tables->comm_thread_handler, t, "comm_thread_table");
 
@@ -1068,8 +1084,8 @@ static int python_export_dso(struct db_export *dbe, struct dso *dso,
 
 	t = tuple_new(5);
 
-	tuple_set_u64(t, 0, dso->db_id);
-	tuple_set_u64(t, 1, machine->db_id);
+	tuple_set_d64(t, 0, dso->db_id);
+	tuple_set_d64(t, 1, machine->db_id);
 	tuple_set_string(t, 2, dso->short_name);
 	tuple_set_string(t, 3, dso->long_name);
 	tuple_set_string(t, 4, sbuild_id);
@@ -1090,10 +1106,10 @@ static int python_export_symbol(struct db_export *dbe, struct symbol *sym,
 
 	t = tuple_new(6);
 
-	tuple_set_u64(t, 0, *sym_db_id);
-	tuple_set_u64(t, 1, dso->db_id);
-	tuple_set_u64(t, 2, sym->start);
-	tuple_set_u64(t, 3, sym->end);
+	tuple_set_d64(t, 0, *sym_db_id);
+	tuple_set_d64(t, 1, dso->db_id);
+	tuple_set_d64(t, 2, sym->start);
+	tuple_set_d64(t, 3, sym->end);
 	tuple_set_s32(t, 4, sym->binding);
 	tuple_set_string(t, 5, sym->name);
 
@@ -1130,30 +1146,30 @@ static void python_export_sample_table(struct db_export *dbe,
 
 	t = tuple_new(24);
 
-	tuple_set_u64(t, 0, es->db_id);
-	tuple_set_u64(t, 1, es->evsel->db_id);
-	tuple_set_u64(t, 2, es->al->maps->machine->db_id);
-	tuple_set_u64(t, 3, es->al->thread->db_id);
-	tuple_set_u64(t, 4, es->comm_db_id);
-	tuple_set_u64(t, 5, es->dso_db_id);
-	tuple_set_u64(t, 6, es->sym_db_id);
-	tuple_set_u64(t, 7, es->offset);
-	tuple_set_u64(t, 8, es->sample->ip);
-	tuple_set_u64(t, 9, es->sample->time);
+	tuple_set_d64(t, 0, es->db_id);
+	tuple_set_d64(t, 1, es->evsel->db_id);
+	tuple_set_d64(t, 2, es->al->maps->machine->db_id);
+	tuple_set_d64(t, 3, es->al->thread->db_id);
+	tuple_set_d64(t, 4, es->comm_db_id);
+	tuple_set_d64(t, 5, es->dso_db_id);
+	tuple_set_d64(t, 6, es->sym_db_id);
+	tuple_set_d64(t, 7, es->offset);
+	tuple_set_d64(t, 8, es->sample->ip);
+	tuple_set_d64(t, 9, es->sample->time);
 	tuple_set_s32(t, 10, es->sample->cpu);
-	tuple_set_u64(t, 11, es->addr_dso_db_id);
-	tuple_set_u64(t, 12, es->addr_sym_db_id);
-	tuple_set_u64(t, 13, es->addr_offset);
-	tuple_set_u64(t, 14, es->sample->addr);
-	tuple_set_u64(t, 15, es->sample->period);
-	tuple_set_u64(t, 16, es->sample->weight);
-	tuple_set_u64(t, 17, es->sample->transaction);
-	tuple_set_u64(t, 18, es->sample->data_src);
+	tuple_set_d64(t, 11, es->addr_dso_db_id);
+	tuple_set_d64(t, 12, es->addr_sym_db_id);
+	tuple_set_d64(t, 13, es->addr_offset);
+	tuple_set_d64(t, 14, es->sample->addr);
+	tuple_set_d64(t, 15, es->sample->period);
+	tuple_set_d64(t, 16, es->sample->weight);
+	tuple_set_d64(t, 17, es->sample->transaction);
+	tuple_set_d64(t, 18, es->sample->data_src);
 	tuple_set_s32(t, 19, es->sample->flags & PERF_BRANCH_MASK);
 	tuple_set_s32(t, 20, !!(es->sample->flags & PERF_IP_FLAG_IN_TX));
-	tuple_set_u64(t, 21, es->call_path_id);
-	tuple_set_u64(t, 22, es->sample->insn_cnt);
-	tuple_set_u64(t, 23, es->sample->cyc_cnt);
+	tuple_set_d64(t, 21, es->call_path_id);
+	tuple_set_d64(t, 22, es->sample->insn_cnt);
+	tuple_set_d64(t, 23, es->sample->cyc_cnt);
 
 	call_object(tables->sample_handler, t, "sample_table");
 
@@ -1167,8 +1183,8 @@ static void python_export_synth(struct db_export *dbe, struct export_sample *es)
 
 	t = tuple_new(3);
 
-	tuple_set_u64(t, 0, es->db_id);
-	tuple_set_u64(t, 1, es->evsel->core.attr.config);
+	tuple_set_d64(t, 0, es->db_id);
+	tuple_set_d64(t, 1, es->evsel->core.attr.config);
 	tuple_set_bytes(t, 2, es->sample->raw_data, es->sample->raw_size);
 
 	call_object(tables->synth_handler, t, "synth_data");
@@ -1200,10 +1216,10 @@ static int python_export_call_path(struct db_export *dbe, struct call_path *cp)
 
 	t = tuple_new(4);
 
-	tuple_set_u64(t, 0, cp->db_id);
-	tuple_set_u64(t, 1, parent_db_id);
-	tuple_set_u64(t, 2, sym_db_id);
-	tuple_set_u64(t, 3, cp->ip);
+	tuple_set_d64(t, 0, cp->db_id);
+	tuple_set_d64(t, 1, parent_db_id);
+	tuple_set_d64(t, 2, sym_db_id);
+	tuple_set_d64(t, 3, cp->ip);
 
 	call_object(tables->call_path_handler, t, "call_path_table");
 
@@ -1221,20 +1237,20 @@ static int python_export_call_return(struct db_export *dbe,
 
 	t = tuple_new(14);
 
-	tuple_set_u64(t, 0, cr->db_id);
-	tuple_set_u64(t, 1, cr->thread->db_id);
-	tuple_set_u64(t, 2, comm_db_id);
-	tuple_set_u64(t, 3, cr->cp->db_id);
-	tuple_set_u64(t, 4, cr->call_time);
-	tuple_set_u64(t, 5, cr->return_time);
-	tuple_set_u64(t, 6, cr->branch_count);
-	tuple_set_u64(t, 7, cr->call_ref);
-	tuple_set_u64(t, 8, cr->return_ref);
-	tuple_set_u64(t, 9, cr->cp->parent->db_id);
+	tuple_set_d64(t, 0, cr->db_id);
+	tuple_set_d64(t, 1, cr->thread->db_id);
+	tuple_set_d64(t, 2, comm_db_id);
+	tuple_set_d64(t, 3, cr->cp->db_id);
+	tuple_set_d64(t, 4, cr->call_time);
+	tuple_set_d64(t, 5, cr->return_time);
+	tuple_set_d64(t, 6, cr->branch_count);
+	tuple_set_d64(t, 7, cr->call_ref);
+	tuple_set_d64(t, 8, cr->return_ref);
+	tuple_set_d64(t, 9, cr->cp->parent->db_id);
 	tuple_set_s32(t, 10, cr->flags);
-	tuple_set_u64(t, 11, cr->parent_db_id);
-	tuple_set_u64(t, 12, cr->insn_count);
-	tuple_set_u64(t, 13, cr->cyc_count);
+	tuple_set_d64(t, 11, cr->parent_db_id);
+	tuple_set_d64(t, 12, cr->insn_count);
+	tuple_set_d64(t, 13, cr->cyc_count);
 
 	call_object(tables->call_return_handler, t, "call_return_table");
 
@@ -1254,14 +1270,14 @@ static int python_export_context_switch(struct db_export *dbe, u64 db_id,
 
 	t = tuple_new(9);
 
-	tuple_set_u64(t, 0, db_id);
-	tuple_set_u64(t, 1, machine->db_id);
-	tuple_set_u64(t, 2, sample->time);
+	tuple_set_d64(t, 0, db_id);
+	tuple_set_d64(t, 1, machine->db_id);
+	tuple_set_d64(t, 2, sample->time);
 	tuple_set_s32(t, 3, sample->cpu);
-	tuple_set_u64(t, 4, th_out_id);
-	tuple_set_u64(t, 5, comm_out_id);
-	tuple_set_u64(t, 6, th_in_id);
-	tuple_set_u64(t, 7, comm_in_id);
+	tuple_set_d64(t, 4, th_out_id);
+	tuple_set_d64(t, 5, comm_out_id);
+	tuple_set_d64(t, 6, th_in_id);
+	tuple_set_d64(t, 7, comm_in_id);
 	tuple_set_s32(t, 8, flags);
 
 	call_object(tables->context_switch_handler, t, "context_switch");
-- 
2.30.2



