Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6164B2B657A
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730281AbgKQNWh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:22:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:55582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731017AbgKQNVo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:21:44 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF24F2463D;
        Tue, 17 Nov 2020 13:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619304;
        bh=TLVIvwsvMB97RHHE/Gx0HUixDjU2pJaETFWFpQ9yHdE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g0dYhNXZ8yyVnj+FOIbA4WhpjKWqWqj6AvtJsUREYXTBRi185taeOil0cOtmAw3Ht
         Ts3TKkFGQ8EkxynDMYU0TBPgCN/1c7Qjfmv0qMzGCL6fR0xy1W1a1ffwHgFSeX7di4
         nTRQqX1iUps/q0BF9c/y9rmE2uqoqvWgO/HlnGPc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Tapas Kundu <tkundu@vmware.com>
Subject: [PATCH 4.19 096/101] perf scripting python: Avoid declaring function pointers with a visibility attribute
Date:   Tue, 17 Nov 2020 14:06:03 +0100
Message-Id: <20201117122117.812072802@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122113.128215851@linuxfoundation.org>
References: <20201117122113.128215851@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/util/scripting-engines/trace-event-python.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -1493,7 +1493,6 @@ static void _free_command_line(wchar_t *
 static int python_start_script(const char *script, int argc, const char **argv)
 {
 	struct tables *tables = &tables_global;
-	PyMODINIT_FUNC (*initfunc)(void);
 #if PY_MAJOR_VERSION < 3
 	const char **command_line;
 #else
@@ -1508,20 +1507,18 @@ static int python_start_script(const cha
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


