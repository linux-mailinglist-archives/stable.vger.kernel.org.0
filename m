Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9905F102312
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 12:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbfKSLdR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 06:33:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:46958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727584AbfKSLdR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 06:33:17 -0500
Received: from quaco.ghostprotocols.net (179.176.11.138.dynamic.adsl.gvt.net.br [179.176.11.138])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 988B42230D;
        Tue, 19 Nov 2019 11:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574163196;
        bh=sM6LjVoo1xfXZxPFYySwqIK3weoW/nciNqfJGG09xzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xujcKlkI5P4TtMuN/PDB04kJ+QYWIW9vKKRWXXG5A1Nyz1EiwI+aKN1CbRtzs8/Qf
         QcDRQPiC67dn36AOKSUHMpvhsqh6CSnwullf9ngDTeyXPDKITizrAdUiuAsF0un8M4
         55Z8WQy+XJrlcBzdKB9L1vZeOS7kwHcTVDXxnzX4=
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Clark Williams <williams@redhat.com>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>, stable@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/25] perf scripts python: exported-sql-viewer.py: Fix use of TRUE with SQLite
Date:   Tue, 19 Nov 2019 08:32:24 -0300
Message-Id: <20191119113245.19593-5-acme@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191119113245.19593-1-acme@kernel.org>
References: <20191119113245.19593-1-acme@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Prior to version 3.23 SQLite does not support TRUE or FALSE, so always
use 1 and 0 for SQLite.

Fixes: 26c11206f433 ("perf scripts python: exported-sql-viewer.py: Use new 'has_calls' column")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: stable@vger.kernel.org # v5.3+
Link: http://lore.kernel.org/lkml/20191113120206.26957-1-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/scripts/python/exported-sql-viewer.py | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/tools/perf/scripts/python/exported-sql-viewer.py b/tools/perf/scripts/python/exported-sql-viewer.py
index ebc6a2e5eae9..26d7be785288 100755
--- a/tools/perf/scripts/python/exported-sql-viewer.py
+++ b/tools/perf/scripts/python/exported-sql-viewer.py
@@ -637,7 +637,7 @@ class CallGraphRootItem(CallGraphLevelItemBase):
 		self.query_done = True
 		if_has_calls = ""
 		if IsSelectable(glb.db, "comms", columns = "has_calls"):
-			if_has_calls = " WHERE has_calls = TRUE"
+			if_has_calls = " WHERE has_calls = " + glb.dbref.TRUE
 		query = QSqlQuery(glb.db)
 		QueryExec(query, "SELECT id, comm FROM comms" + if_has_calls)
 		while query.next():
@@ -918,7 +918,7 @@ class CallTreeRootItem(CallGraphLevelItemBase):
 		self.query_done = True
 		if_has_calls = ""
 		if IsSelectable(glb.db, "comms", columns = "has_calls"):
-			if_has_calls = " WHERE has_calls = TRUE"
+			if_has_calls = " WHERE has_calls = " + glb.dbref.TRUE
 		query = QSqlQuery(glb.db)
 		QueryExec(query, "SELECT id, comm FROM comms" + if_has_calls)
 		while query.next():
@@ -1290,7 +1290,7 @@ class SwitchGraphData(GraphData):
 		QueryExec(query, "SELECT id, c_time"
 					" FROM comms"
 					" WHERE c_thread_id = " + str(thread_id) +
-					"   AND exec_flag = TRUE"
+					"   AND exec_flag = " + self.collection.glb.dbref.TRUE +
 					"   AND c_time >= " + str(start_time) +
 					"   AND c_time <= " + str(end_time) +
 					" ORDER BY c_time, id")
@@ -5016,6 +5016,12 @@ class DBRef():
 	def __init__(self, is_sqlite3, dbname):
 		self.is_sqlite3 = is_sqlite3
 		self.dbname = dbname
+		self.TRUE = "TRUE"
+		self.FALSE = "FALSE"
+		# SQLite prior to version 3.23 does not support TRUE and FALSE
+		if self.is_sqlite3:
+			self.TRUE = "1"
+			self.FALSE = "0"
 
 	def Open(self, connection_name):
 		dbname = self.dbname
-- 
2.21.0

