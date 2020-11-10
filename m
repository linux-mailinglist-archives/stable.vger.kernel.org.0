Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2B52ACF5A
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 07:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730050AbgKJGCk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 01:02:40 -0500
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:37509 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728085AbgKJGCj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Nov 2020 01:02:39 -0500
X-Greylist: delayed 900 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Nov 2020 01:02:39 EST
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Mon, 9 Nov 2020 21:47:35 -0800
Received: from localhost.localdomain (unknown [10.197.103.179])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id DEAF2207FC;
        Mon,  9 Nov 2020 21:47:37 -0800 (PST)
From:   Tapas Kundu <tkundu@vmware.com>
To:     <acme@redhat.com>
CC:     <stable@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <srivatsab@vmware.com>, <srivatsa@csail.mit.edu>,
        <anishs@vmware.com>, <vsirnapalli@vmware.com>, <akaher@vmware.com>,
        <tkundu@vmware.com>, <peterz@infradead.org>, <mingo@redhat.com>,
        <mark.rutland@arm.com>, <alexander.shishkin@linux.intel.com>,
        <jolsa@redhat.com>, <namhyung@kernel.org>,
        <linux-kernel@vger.kernel.org>, <adrian.hunter@intel.com>,
        <irogers@google.com>, Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH v5.9-v4.19] perf scripting python: Avoid declaring function pointers with a visibility attribute
Date:   Tue, 10 Nov 2020 11:16:12 +0530
Message-ID: <20201110054612.13170-1-tkundu@vmware.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-001.vmware.com: tkundu@vmware.com does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

commit d0e7b0c71fbb653de90a7163ef46912a96f0bdaf upstream.

To avoid this:

  util/scripting-engines/trace-event-python.c: In function 'python_start_script':
  util/scripting-engines/trace-event-python.c:1595:2: error: 'visibility' attribute ignored [-Werror=attributes]
   1595 |  PyMODINIT_FUNC (*initfunc)(void);
        |  ^~~~~~~~~~~~~~

That started breaking when building with PYTHON=python3 and these gcc
versions (I haven't checked with the clang ones, maybe it breaks there
as well):

  # export PERF_TARBALL=http://192.168.86.5/perf/perf-5.9.0.tar.xz
  # dm  fedora:33 fedora:rawhide
     1   107.80 fedora:33         : Ok   gcc (GCC) 10.2.1 20201005 (Red Hat 10.2.1-5), clang version 11.0.0 (Fedora 11.0.0-1.fc33)
     2    92.47 fedora:rawhide    : Ok   gcc (GCC) 10.2.1 20201016 (Red Hat 10.2.1-6), clang version 11.0.0 (Fedora 11.0.0-1.fc34)
  #

Avoid that by ditching that 'initfunc' function pointer with its:

    #define Py_EXPORTED_SYMBOL _attribute_ ((visibility ("default")))
    #define PyMODINIT_FUNC Py_EXPORTED_SYMBOL PyObject*

And just call PyImport_AppendInittab() at the end of the ifdef python3
block with the functions that were being attributed to that initfunc.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Tapas Kundu <tkundu@vmware.com>
---
 tools/perf/util/scripting-engines/trace-event-python.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 93c03b39c..3b02c3f1b 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -1587,7 +1587,6 @@ static void _free_command_line(wchar_t **command_line, int num)
 static int python_start_script(const char *script, int argc, const char **argv)
 {
 	struct tables *tables = &tables_global;
-	PyMODINIT_FUNC (*initfunc)(void);
 #if PY_MAJOR_VERSION < 3
 	const char **command_line;
 #else
@@ -1602,20 +1601,18 @@ static int python_start_script(const char *script, int argc, const char **argv)
 	FILE *fp;
 
 #if PY_MAJOR_VERSION < 3
-	initfunc = initperf_trace_context;
 	command_line = malloc((argc + 1) * sizeof(const char *));
 	command_line[0] = script;
 	for (i = 1; i < argc + 1; i++)
 		command_line[i] = argv[i - 1];
+	PyImport_AppendInittab(name, initperf_trace_context);
 #else
-	initfunc = PyInit_perf_trace_context;
 	command_line = malloc((argc + 1) * sizeof(wchar_t *));
 	command_line[0] = Py_DecodeLocale(script, NULL);
 	for (i = 1; i < argc + 1; i++)
 		command_line[i] = Py_DecodeLocale(argv[i - 1], NULL);
+	PyImport_AppendInittab(name, PyInit_perf_trace_context);
 #endif
-
-	PyImport_AppendInittab(name, initfunc);
 	Py_Initialize();
 
 #if PY_MAJOR_VERSION < 3
-- 
2.23.0

