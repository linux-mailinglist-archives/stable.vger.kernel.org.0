Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA19110E6DA
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 09:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbfLBIWq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 03:22:46 -0500
Received: from mga01.intel.com ([192.55.52.88]:1451 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725977AbfLBIWq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Dec 2019 03:22:46 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Dec 2019 00:22:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,268,1571727600"; 
   d="scan'208";a="241851150"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.95])
  by fmsmga002.fm.intel.com with ESMTP; 02 Dec 2019 00:22:44 -0800
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     stable@vger.kernel.org
Subject: [PATCH] perf scripts python: exported-sql-viewer.py: Fix use of TRUE with SQLite
Date:   Mon,  2 Dec 2019 10:21:50 +0200
Message-Id: <20191202082150.22290-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.17.1
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit af833988c088d3fed3e7188e7c3dd9ca17178dc3 upstream

Prior to version 3.23 SQLite does not support TRUE or FALSE, so always
use 1 and 0 for SQLite.

Fixes: 26c11206f433 ("perf scripts python: exported-sql-viewer.py: Use new 'has_calls' column")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: stable@vger.kernel.org # v5.3+
Link: http://lore.kernel.org/lkml/20191113120206.26957-1-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
[Adrian: backported to v5.3, v5.4]
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/scripts/python/exported-sql-viewer.py | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/perf/scripts/python/exported-sql-viewer.py b/tools/perf/scripts/python/exported-sql-viewer.py
index 61b3911d91e6..4b28c9d08d5a 100755
--- a/tools/perf/scripts/python/exported-sql-viewer.py
+++ b/tools/perf/scripts/python/exported-sql-viewer.py
@@ -625,7 +625,7 @@ class CallGraphRootItem(CallGraphLevelItemBase):
 		self.query_done = True
 		if_has_calls = ""
 		if IsSelectable(glb.db, "comms", columns = "has_calls"):
-			if_has_calls = " WHERE has_calls = TRUE"
+			if_has_calls = " WHERE has_calls = " + glb.dbref.TRUE
 		query = QSqlQuery(glb.db)
 		QueryExec(query, "SELECT id, comm FROM comms" + if_has_calls)
 		while query.next():
@@ -905,7 +905,7 @@ class CallTreeRootItem(CallGraphLevelItemBase):
 		self.query_done = True
 		if_has_calls = ""
 		if IsSelectable(glb.db, "comms", columns = "has_calls"):
-			if_has_calls = " WHERE has_calls = TRUE"
+			if_has_calls = " WHERE has_calls = " + glb.dbref.TRUE
 		query = QSqlQuery(glb.db)
 		QueryExec(query, "SELECT id, comm FROM comms" + if_has_calls)
 		while query.next():
@@ -3509,6 +3509,12 @@ class DBRef():
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
2.17.1

