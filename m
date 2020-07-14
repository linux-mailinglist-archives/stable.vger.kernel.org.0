Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9570D21FB58
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731095AbgGNTAU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 15:00:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:59130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730432AbgGNTAR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 15:00:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18B2C222B9;
        Tue, 14 Jul 2020 19:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594753216;
        bh=sw0ALnkgVPkZIbmwtCxhXYy2uvT5QOHsQSK5xEnka0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yj7KQvs29UOCvR8sNRccNsIZhLuBZj6epqWcAkC9kb7GmNzjch++rYdLc5V0YaBLY
         IuGaeYdtGkWZ6hxbB0Fvp/4LuZEbznarcezn/UL7gxNirE/XYvqmXS5Crx3phnyd3a
         a826Bf4ok+YP3RElzyTEIhiu0Aj0QqFzmjrwg5DQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.7 165/166] perf scripts python: exported-sql-viewer.py: Fix unexpanded Find result
Date:   Tue, 14 Jul 2020 20:45:30 +0200
Message-Id: <20200714184123.727630133@linuxfoundation.org>
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

commit 3a3cf7c570a486b07d9a6e68a77548aea6a8421f upstream.

Using Python version 3.8.2 and PySide2 version 5.14.0, ctrl-F ('Find')
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

  Select: Reports -> Context-Sensitive Call Graph    or     Reports -> Call Tree
  Press: Ctrl-F
  Enter: main
  Press: Enter

Before: line showing 'main' does not display

After: tree is expanded to line showing 'main'

Fixes: ebd70c7dc2f5f ("perf scripts python: exported-sql-viewer.py: Add ability to find symbols in the call-graph")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: stable@vger.kernel.org
Link: http://lore.kernel.org/lkml/20200629091955.17090-4-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/scripts/python/exported-sql-viewer.py |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/perf/scripts/python/exported-sql-viewer.py
+++ b/tools/perf/scripts/python/exported-sql-viewer.py
@@ -1052,6 +1052,7 @@ class TreeWindowBase(QMdiSubWindow):
 				child = self.model.index(row, 0, parent)
 				if child.internalPointer().dbid == dbid:
 					found = True
+					self.view.setExpanded(parent, True)
 					self.view.setCurrentIndex(child)
 					parent = child
 					break


