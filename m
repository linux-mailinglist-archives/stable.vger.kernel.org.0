Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24C4821FB43
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731361AbgGNTAU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 15:00:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:59218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730398AbgGNTAU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 15:00:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF3D4221ED;
        Tue, 14 Jul 2020 19:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594753219;
        bh=xock2xhvXW8AIVet0UfzmThCMeZmRI18CnIIzW3WzgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZM7N1P8eZNHgvfCx71i0Pox1bIL7CKxU54rgwisj306DLwO+NNNRRCpXK3AzZH+za
         QVIIYOavPTIg4wMSKAmKN8MckkvHvd2uyaaTakc4YNn505ZGpbjxTtpuc1UxpAnKQv
         sKnCgA1UDNef3lcNpKVRuDMoTcUfncVC2XUIoRbs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.7 166/166] perf scripts python: exported-sql-viewer.py: Fix time chart call tree
Date:   Tue, 14 Jul 2020 20:45:31 +0200
Message-Id: <20200714184123.778557023@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit f18d5cf86cdb58eb50cafb5a5e20943ec7a61b1f upstream.

Using Python version 3.8.2 and PySide2 version 5.14.0, time chart call tree
would not expand the tree to the result. Fix by using setExpanded().

Example:

  $ perf record -e intel_pt//u uname
  Linux
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.034 MB perf.data ]
  $ perf script --itrace=bep -s ~/libexec/perf-core/scripts/python/export-to-sqlite.py perf.data.db branches calls
  2020-06-26 15:32:14.928997 Creating database ...
  2020-06-26 15:32:14.933971 Writing records...
  2020-06-26 15:32:15.535251 Adding indexes
  2020-06-26 15:32:15.542993 Dropping unused tables
  2020-06-26 15:32:15.549716 Done
  $ python3 ~/libexec/perf-core/scripts/python/exported-sql-viewer.py perf.data.db

  Select: Charts -> Time chart by CPU
  Move mouse over middle of chart
  Right-click and select Show Call Tree

Before: displays Call Tree but not expanded to selected time
After: displays Call Tree expanded to selected time

Fixes: e69d5df75d74d ("perf scripts python: exported-sql-viewer.py: Add ability for Call tree to open at a specified task and time")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: stable@vger.kernel.org
Link: http://lore.kernel.org/lkml/20200629091955.17090-7-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/scripts/python/exported-sql-viewer.py |    4 ++++
 1 file changed, 4 insertions(+)

--- a/tools/perf/scripts/python/exported-sql-viewer.py
+++ b/tools/perf/scripts/python/exported-sql-viewer.py
@@ -1130,6 +1130,7 @@ class CallTreeWindow(TreeWindowBase):
 				child = self.model.index(row, 0, parent)
 				if child.internalPointer().dbid == dbid:
 					found = True
+					self.view.setExpanded(parent, True)
 					self.view.setCurrentIndex(child)
 					parent = child
 					break
@@ -1142,6 +1143,7 @@ class CallTreeWindow(TreeWindowBase):
 				return
 			last_child = None
 			for row in xrange(n):
+				self.view.setExpanded(parent, True)
 				child = self.model.index(row, 0, parent)
 				child_call_time = child.internalPointer().call_time
 				if child_call_time < time:
@@ -1154,9 +1156,11 @@ class CallTreeWindow(TreeWindowBase):
 			if not last_child:
 				if not found:
 					child = self.model.index(0, 0, parent)
+					self.view.setExpanded(parent, True)
 					self.view.setCurrentIndex(child)
 				return
 			found = True
+			self.view.setExpanded(parent, True)
 			self.view.setCurrentIndex(last_child)
 			parent = last_child
 


