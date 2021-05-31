Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7FD2395DBC
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbhEaNus (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:50:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:49502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232395AbhEaNrC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:47:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D5CE61607;
        Mon, 31 May 2021 13:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467827;
        bh=dixYiv4IqcDTYMXQxCyKzf3bhVXKR4o+mefvnnvINyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LnZQnBbqnDDRCCaC186wgRRztwK+xInlJdtcYL02ansfhYeeaHiXDDTk7q3VDU150
         lKcEqraJuF0lF9+MIlXHENLZBaWSmJby1EI8OGRRr5fPelnO8+uGctFM5mmZuoB+Jq
         SgCSF5WYixaxgBqQeAwaiXpFxroWKaujhU6Z5Low=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.10 016/252] perf scripts python: exported-sql-viewer.py: Fix Array TypeError
Date:   Mon, 31 May 2021 15:11:21 +0200
Message-Id: <20210531130658.528808458@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit fd931b2e234a7cc451a7bbb1965d6ce623189158 upstream.

The 'Array' class is present in more than one python standard library.
In some versions of Python 3, the following error occurs:

Traceback (most recent call last):
  File "tools/perf/scripts/python/exported-sql-viewer.py", line 4702, in <lambda>
    reports_menu.addAction(CreateAction(label, "Create a new window displaying branch events", lambda a=None,x=dbid: self.NewBranchView(x), self))
  File "tools/perf/scripts/python/exported-sql-viewer.py", line 4727, in NewBranchView
    BranchWindow(self.glb, event_id, ReportVars(), self)
  File "tools/perf/scripts/python/exported-sql-viewer.py", line 3208, in __init__
    self.model = LookupCreateModel(model_name, lambda: BranchModel(glb, event_id, report_vars.where_clause))
  File "tools/perf/scripts/python/exported-sql-viewer.py", line 343, in LookupCreateModel
    model = create_fn()
  File "tools/perf/scripts/python/exported-sql-viewer.py", line 3208, in <lambda>
    self.model = LookupCreateModel(model_name, lambda: BranchModel(glb, event_id, report_vars.where_clause))
  File "tools/perf/scripts/python/exported-sql-viewer.py", line 3124, in __init__
    self.fetcher = SQLFetcher(glb, sql, prep, self.AddSample)
  File "tools/perf/scripts/python/exported-sql-viewer.py", line 2658, in __init__
    self.buffer = Array(c_char, self.buffer_size, lock=False)
TypeError: abstract class

This apparently happens because Python can be inconsistent about which
class of the name 'Array' gets imported. Fix by importing explicitly by
name so that only the desired 'Array' gets imported.

Fixes: 8392b74b575c3 ("perf scripts python: exported-sql-viewer.py: Add ability to display all the database tables")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: stable@vger.kernel.org
Link: http://lore.kernel.org/lkml/20210521092053.25683-3-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/scripts/python/exported-sql-viewer.py |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/tools/perf/scripts/python/exported-sql-viewer.py
+++ b/tools/perf/scripts/python/exported-sql-viewer.py
@@ -125,8 +125,9 @@ if pyside_version_1:
 	from PySide.QtGui import *
 	from PySide.QtSql import *
 
-from decimal import *
-from ctypes import *
+from decimal import Decimal, ROUND_HALF_UP
+from ctypes import CDLL, Structure, create_string_buffer, addressof, sizeof, \
+		   c_void_p, c_bool, c_byte, c_char, c_int, c_uint, c_longlong, c_ulonglong
 from multiprocessing import Process, Array, Value, Event
 
 # xrange is range in Python3


