Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8814D21FB54
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730915AbgGNTAz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 15:00:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:59688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730891AbgGNTAk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 15:00:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4F6A22BED;
        Tue, 14 Jul 2020 19:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594753239;
        bh=E/O41ziLlGXad5UgL0xa+rM/Hmr3Fn4lysQaJWrleqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QuZMbmfEgaOKjIy65W2gNW9ay0IeJHiEbTs14eaUNmXGXoqoj1zkWWcl63KnVsJHt
         0U55NhDrwpNEkpjb563dX6X6wt3D0iq6ZI6zWtMwcsdMCOgT4Ukrpo720xK9TeqMIh
         myAwo7E7AfU/ps/RRjiKHi+8Nm2raLxQTRupWNuU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.7 164/166] perf scripts python: exported-sql-viewer.py: Fix zero id in call tree Find result
Date:   Tue, 14 Jul 2020 20:45:29 +0200
Message-Id: <20200714184123.678497479@linuxfoundation.org>
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

commit 031c8d5edb1ddeb6d398f7942ce2a01a1a51ada9 upstream.

Using ctrl-F ('Find') would not find 'unknown' because it matches id
zero.  Fix by excluding id zero from selection.

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

   Select: Reports -> Call Tree
   Press: Ctrl-F
   Enter: unknown
   Press: Enter

Before: displays 'unknown' not found
After: tree is expanded to line showing 'unknown'

Fixes: ae8b887c00d3f ("perf scripts python: exported-sql-viewer.py: Add call tree")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: stable@vger.kernel.org
Link: http://lore.kernel.org/lkml/20200629091955.17090-6-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/scripts/python/exported-sql-viewer.py |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/perf/scripts/python/exported-sql-viewer.py
+++ b/tools/perf/scripts/python/exported-sql-viewer.py
@@ -964,7 +964,8 @@ class CallTreeModel(CallGraphModelBase):
 						" FROM calls"
 						" INNER JOIN call_paths ON calls.call_path_id = call_paths.id"
 						" INNER JOIN symbols ON call_paths.symbol_id = symbols.id"
-						" WHERE symbols.name" + match +
+						" WHERE calls.id <> 0"
+						" AND symbols.name" + match +
 						" ORDER BY comm_id, thread_id, call_time, calls.id")
 
 	def FindPath(self, query):


