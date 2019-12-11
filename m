Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1365211B7EA
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730597AbfLKPLZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:11:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:59970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729797AbfLKPLZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:11:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 483F522B48;
        Wed, 11 Dec 2019 15:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077084;
        bh=iCe981dpQcbeniIuJo78yCB5icEWgktPbevCe92sIE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0EazbO5qBnKV5m1s07bSuR3gyCqzGFekAg3kJQ+dqt3Q4YP5SQqtiVbq9BTSs2oNm
         NxC2nRqL+Egt3K1RwNPw7M3GfpJlzEojFi3EuqIf55U9dPfsG4+QFPXJgsrhqRRrEe
         +Gt4ejIRNoCN83j3lLpcywY/6wWmUgpHDzyi1NBE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.3 003/105] perf scripts python: exported-sql-viewer.py: Fix use of TRUE with SQLite
Date:   Wed, 11 Dec 2019 16:04:52 +0100
Message-Id: <20191211150222.212877093@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.153659747@linuxfoundation.org>
References: <20191211150221.153659747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit af833988c088d3fed3e7188e7c3dd9ca17178dc3 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/scripts/python/exported-sql-viewer.py |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/tools/perf/scripts/python/exported-sql-viewer.py
+++ b/tools/perf/scripts/python/exported-sql-viewer.py
@@ -625,7 +625,7 @@ class CallGraphRootItem(CallGraphLevelIt
 		self.query_done = True
 		if_has_calls = ""
 		if IsSelectable(glb.db, "comms", columns = "has_calls"):
-			if_has_calls = " WHERE has_calls = TRUE"
+			if_has_calls = " WHERE has_calls = " + glb.dbref.TRUE
 		query = QSqlQuery(glb.db)
 		QueryExec(query, "SELECT id, comm FROM comms" + if_has_calls)
 		while query.next():
@@ -905,7 +905,7 @@ class CallTreeRootItem(CallGraphLevelIte
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


