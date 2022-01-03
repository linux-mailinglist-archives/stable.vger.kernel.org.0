Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 596CD483357
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235066AbiACOgL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:36:11 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38476 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235457AbiACOei (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:34:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19498B80EF8;
        Mon,  3 Jan 2022 14:34:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F693C36AEB;
        Mon,  3 Jan 2022 14:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220474;
        bh=PaXPqYaoFMI9T5OndNXPaAuB+lhRL8XpIlIY1ORlOrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cE+cBCPezB6zaN0x9mwIRyNeh/6tKzEo8AjxFU7dgeE9GcwjCHXky3P7UdNor0/hz
         /iN2I/+kaiTgOJxAhkXQfnRta8xQ51ta7zLDthLAlPywg8buJWXAwPMH7hGCSzJyOO
         UAtrRa2qAYMN96OLeeFCRh+Wb1HxEqIIIk+BH5rY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Riccardo Mancini <rickyman7@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.15 73/73] perf scripts python: intel-pt-events.py: Fix printing of switch events
Date:   Mon,  3 Jan 2022 15:24:34 +0100
Message-Id: <20220103142059.296906296@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142056.911344037@linuxfoundation.org>
References: <20220103142056.911344037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit 0f80bfbf4919e32f52fe1312c3900ff4fbb7eeb9 upstream.

The intel-pt-events.py script displays only the last of consecutive switch
statements but that may not be the last switch event for the CPU. Fix by
keeping a dictionary of last context switch keyed by CPU, and make it
possible to see all switch events by adding option --all-switch-events.

Fixes: a92bf335fd82eeee ("perf scripts python: intel-pt-events.py: Add branches to script")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Riccardo Mancini <rickyman7@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20211215080636.149562-4-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/scripts/python/intel-pt-events.py |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

--- a/tools/perf/scripts/python/intel-pt-events.py
+++ b/tools/perf/scripts/python/intel-pt-events.py
@@ -32,8 +32,7 @@ try:
 except:
 	broken_pipe_exception = IOError
 
-glb_switch_str		= None
-glb_switch_printed	= True
+glb_switch_str		= {}
 glb_insn		= False
 glb_disassembler	= None
 glb_src			= False
@@ -70,6 +69,7 @@ def trace_begin():
 	ap = argparse.ArgumentParser(usage = "", add_help = False)
 	ap.add_argument("--insn-trace", action='store_true')
 	ap.add_argument("--src-trace", action='store_true')
+	ap.add_argument("--all-switch-events", action='store_true')
 	global glb_args
 	global glb_insn
 	global glb_src
@@ -256,10 +256,6 @@ def print_srccode(comm, param_dict, samp
 	print(start_str, src_str)
 
 def do_process_event(param_dict):
-	global glb_switch_printed
-	if not glb_switch_printed:
-		print(glb_switch_str)
-		glb_switch_printed = True
 	event_attr = param_dict["attr"]
 	sample	   = param_dict["sample"]
 	raw_buf	   = param_dict["raw_buf"]
@@ -274,6 +270,11 @@ def do_process_event(param_dict):
 	dso    = get_optional(param_dict, "dso")
 	symbol = get_optional(param_dict, "symbol")
 
+	cpu = sample["cpu"]
+	if cpu in glb_switch_str:
+		print(glb_switch_str[cpu])
+		del glb_switch_str[cpu]
+
 	if name[0:12] == "instructions":
 		if glb_src:
 			print_srccode(comm, param_dict, sample, symbol, dso, True)
@@ -336,8 +337,6 @@ def auxtrace_error(typ, code, cpu, pid,
 		sys.exit(1)
 
 def context_switch(ts, cpu, pid, tid, np_pid, np_tid, machine_pid, out, out_preempt, *x):
-	global glb_switch_printed
-	global glb_switch_str
 	if out:
 		out_str = "Switch out "
 	else:
@@ -350,6 +349,10 @@ def context_switch(ts, cpu, pid, tid, np
 		machine_str = ""
 	else:
 		machine_str = "machine PID %d" % machine_pid
-	glb_switch_str = "%16s %5d/%-5d [%03u] %9u.%09u %5d/%-5d %s %s" % \
+	switch_str = "%16s %5d/%-5d [%03u] %9u.%09u %5d/%-5d %s %s" % \
 		(out_str, pid, tid, cpu, ts / 1000000000, ts %1000000000, np_pid, np_tid, machine_str, preempt_str)
-	glb_switch_printed = False
+	if glb_args.all_switch_events:
+		print(switch_str);
+	else:
+		global glb_switch_str
+		glb_switch_str[cpu] = switch_str


