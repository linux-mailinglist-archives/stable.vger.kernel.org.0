Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E13AD21FB4E
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731120AbgGNTAi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 15:00:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:59632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731368AbgGNTAh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 15:00:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59D2F22B39;
        Tue, 14 Jul 2020 19:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594753236;
        bh=2bpNbQc+/BYSMVjotI6QoVA2+KgvsROwJ+YNunxzev0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PHuSHDSBMSQLf6/G4/O4eLQxoPHesvKHhufbkXUvdmCCK3fhA6q8twNY6WSuqH2t0
         /QXGA/oxwTj4GR2/4aJIu9au7KFXEZU3sewnfyoqKPIIc7McJ/fMz3gb327SfI+Eyz
         cnTnRhAvU9g5if7xjHEBV5diBwxAQM4NNYRb8q6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.7 163/166] perf scripts python: exported-sql-viewer.py: Fix zero id in call graph Find result
Date:   Tue, 14 Jul 2020 20:45:28 +0200
Message-Id: <20200714184123.628728228@linuxfoundation.org>
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

commit 7ff520b0a71dd2db695b52ad117d81b7eaf6ff9d upstream.

Using ctrl-F ('Find') would not find 'unknown' because it matches id zero.
Fix by excluding id zero from selection.

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

  Select: Reports -> Context-Sensitive Call Graph
  Press: Ctrl-F
  Enter: unknown
  Press: Enter

Before: gets stuck
After: tree is expanded to line showing 'unknown'

Fixes: 254c0d820b86d ("perf scripts python: exported-sql-viewer.py: Factor out CallGraphModelBase")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: stable@vger.kernel.org
Link: http://lore.kernel.org/lkml/20200629091955.17090-5-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/scripts/python/exported-sql-viewer.py |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/perf/scripts/python/exported-sql-viewer.py
+++ b/tools/perf/scripts/python/exported-sql-viewer.py
@@ -768,7 +768,8 @@ class CallGraphModel(CallGraphModelBase)
 						" FROM calls"
 						" INNER JOIN call_paths ON calls.call_path_id = call_paths.id"
 						" INNER JOIN symbols ON call_paths.symbol_id = symbols.id"
-						" WHERE symbols.name" + match +
+						" WHERE calls.id <> 0"
+						" AND symbols.name" + match +
 						" GROUP BY comm_id, thread_id, call_path_id"
 						" ORDER BY comm_id, thread_id, call_path_id")
 


