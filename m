Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1363396107
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233113AbhEaOfR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:35:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:32786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233944AbhEaOdI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:33:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45C4061C39;
        Mon, 31 May 2021 13:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468992;
        bh=MdXx8nvefx0CsVv8KljOMYZO5YFzTnvk+ckz98B0Rd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uJYonJheKUryZoEQP+ybEBiQjTvQiwdmxMHraL4RjOrZuExBr2PtGEW+hnt7S4C0/
         X3rhqPpcV1AmRz3mpTORQeHeL5jIgBWtlD+m9mZRZugaDHYAV3A0ZXk2ZuiZxUx5i1
         51dF1MdCRFyXi0dPbhdz0xZZGTSsy1dKJnyKOCZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.12 029/296] perf scripts python: exported-sql-viewer.py: Fix warning display
Date:   Mon, 31 May 2021 15:11:24 +0200
Message-Id: <20210531130704.773620786@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit f56299a9c998e0bfbd4ab07cafe9eb8444512448 upstream.

Deprecation warnings are useful only for the developer, not an end user.
Display warnings only when requested using the python -W option. This
stops the display of warnings like:

 tools/perf/scripts/python/exported-sql-viewer.py:5102: DeprecationWarning:
         an integer is required (got type PySide2.QtCore.Qt.AlignmentFlag).
         Implicit conversion to integers using __int__ is deprecated, and
         may be removed in a future version of Python.
    err = app.exec_()

Since the warning can be fixed only in PySide2, we must wait for it to
be finally fixed there.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: stable@vger.kernel.org      # v5.3+
Link: http://lore.kernel.org/lkml/20210521092053.25683-4-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/scripts/python/exported-sql-viewer.py |    5 +++++
 1 file changed, 5 insertions(+)

--- a/tools/perf/scripts/python/exported-sql-viewer.py
+++ b/tools/perf/scripts/python/exported-sql-viewer.py
@@ -91,6 +91,11 @@
 from __future__ import print_function
 
 import sys
+# Only change warnings if the python -W option was not used
+if not sys.warnoptions:
+	import warnings
+	# PySide2 causes deprecation warnings, ignore them.
+	warnings.filterwarnings("ignore", category=DeprecationWarning)
 import argparse
 import weakref
 import threading


