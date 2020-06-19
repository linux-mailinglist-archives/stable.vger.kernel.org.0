Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8BFA200F32
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404063AbgFSPQa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:16:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:47046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404078AbgFSPQ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:16:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10AC72080C;
        Fri, 19 Jun 2020 15:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579788;
        bh=MqiTUwiN2/J/Fok+hBOgitTkj1dSroJsDa+XbOOl9Sk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1ty4Eexs48iPROyrtN/7/KytkHxye2JMq33SRC4AqMt9KosV/D1lxhPnlPq60A0o4
         2phxkOel/Yaumd91iBq3pwvpzueiEP07P34Miaazq9cE+8lduWWRG0h9vUAhpt65Te
         e5l5Qy/F9U4R+V1SuUat48zR5SVah/k5ilI1eOZk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 5.4 259/261] perf probe: Check address correctness by map instead of _etext
Date:   Fri, 19 Jun 2020 16:34:30 +0200
Message-Id: <20200619141702.289786110@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

commit 2ae5d0d7d8868df7c05c2013c0b9cddd4d40610e upstream.

Since commit 03db8b583d1c ("perf tools: Fix
maps__find_symbol_by_name()") introduced map address range check in
maps__find_symbol_by_name(), we can not get "_etext" from kernel map
because _etext is placed on the edge of the kernel .text section (=
kernel map in perf.)

To fix this issue, this checks the address correctness by map address
range information (map->start and map->end) instead of using _etext
address.

This can cause an error if the target inlined function is embedded in
both __init function and normal function.

For exaample, request_resource() is a normal function but also embedded
in __init reserve_setup(). In this case, the probe point in
reserve_setup() must be skipped.

However, without this fix, it failes to setup all probe points:

  # ./perf probe -v request_resource
  probe-definition(0): request_resource
  symbol:request_resource file:(null) line:0 offset:0 return:0 lazy:(null)
  0 arguments
  Looking at the vmlinux_path (8 entries long)
  Using /usr/lib/debug/lib/modules/5.5.17-200.fc31.x86_64/vmlinux for symbols
  Open Debuginfo file: /usr/lib/debug/lib/modules/5.5.17-200.fc31.x86_64/vmlinux
  Try to find probe point from debuginfo.
  Matched function: request_resource [15e29ad]
  found inline addr: 0xffffffff82fbf892
  Probe point found: reserve_setup+204
  found inline addr: 0xffffffff810e9790
  Probe point found: request_resource+0
  Found 2 probe_trace_events.
  Opening /sys/kernel/debug/tracing//kprobe_events write=1
  Opening /sys/kernel/debug/tracing//README write=0
  Writing event: p:probe/request_resource _text+33290386
  Failed to write event: Invalid argument
    Error: Failed to add events. Reason: Invalid argument (Code: -22)
  #

With this fix,

  # ./perf probe request_resource
  reserve_setup is out of .text, skip it.
  Added new events:
    (null):(null)        (on request_resource)
    probe:request_resource (on request_resource)

  You can now use it in all perf tools, such as:

  	perf record -e probe:request_resource -aR sleep 1

  #

Fixes: 03db8b583d1c ("perf tools: Fix maps__find_symbol_by_name()")
Reported-by: Arnaldo Carvalho de Melo <acme@kernel.org>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: stable@vger.kernel.org
Link: http://lore.kernel.org/lkml/158763967332.30755.4922496724365529088.stgit@devnote2
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/util/probe-event.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -236,21 +236,22 @@ static void clear_probe_trace_events(str
 static bool kprobe_blacklist__listed(unsigned long address);
 static bool kprobe_warn_out_range(const char *symbol, unsigned long address)
 {
-	u64 etext_addr = 0;
-	int ret;
+	struct map *map;
+	bool ret = false;
 
-	/* Get the address of _etext for checking non-probable text symbol */
-	ret = kernel_get_symbol_address_by_name("_etext", &etext_addr,
-						false, false);
-
-	if (ret == 0 && etext_addr < address)
-		pr_warning("%s is out of .text, skip it.\n", symbol);
-	else if (kprobe_blacklist__listed(address))
+	map = kernel_get_module_map(NULL);
+	if (map) {
+		ret = address <= map->start || map->end < address;
+		if (ret)
+			pr_warning("%s is out of .text, skip it.\n", symbol);
+		map__put(map);
+	}
+	if (!ret && kprobe_blacklist__listed(address)) {
 		pr_warning("%s is blacklisted function, skip it.\n", symbol);
-	else
-		return false;
+		ret = true;
+	}
 
-	return true;
+	return ret;
 }
 
 /*


