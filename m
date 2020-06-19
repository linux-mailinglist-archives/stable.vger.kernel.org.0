Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5609F2010B3
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393920AbgFSPcq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:32:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:36700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393916AbgFSPcm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:32:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EEFE2193E;
        Fri, 19 Jun 2020 15:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580761;
        bh=nhzK09wCodJFeA1IUmPaRWZcWfbdGnkU6PB+LiOMDRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0KvPGwafmX6x2uMYHl/RwtRWt2u1NRGgpx7kwYK5r54Ut2NhHpNNHVE6wzo0J/Lu7
         QLY5Y1luV+iqVJy6SOICQipM8prGZcNFaUeIzWZ2oONT4jbax1dAsdm/VLj693wmdv
         FTFQIdpGpQsLSiCfUnRZQxSyracYiAtIW/PYW3Qc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 5.7 372/376] perf probe: Do not show the skipped events
Date:   Fri, 19 Jun 2020 16:34:50 +0200
Message-Id: <20200619141727.901485074@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

commit f41ebe9defacddeae96a872a33f0f22ced0bfcef upstream.

When a probe point is expanded to several places (like inlined) and if
some of them are skipped because of blacklisted or __init function,
those trace_events has no event name. It must be skipped while showing
results.

Without this fix, you can see "(null):(null)" on the list,

  # ./perf probe request_resource
  reserve_setup is out of .text, skip it.
  Added new events:
    (null):(null)        (on request_resource)
    probe:request_resource (on request_resource)

  You can now use it in all perf tools, such as:

  	perf record -e probe:request_resource -aR sleep 1

  #

With this fix, it is ignored:

  # ./perf probe request_resource
  reserve_setup is out of .text, skip it.
  Added new events:
    probe:request_resource (on request_resource)

  You can now use it in all perf tools, such as:

  	perf record -e probe:request_resource -aR sleep 1

  #

Fixes: 5a51fcd1f30c ("perf probe: Skip kernel symbols which is out of .text")
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: stable@vger.kernel.org
Link: http://lore.kernel.org/lkml/158763968263.30755.12800484151476026340.stgit@devnote2
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/builtin-probe.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -364,6 +364,9 @@ static int perf_add_probe_events(struct
 
 		for (k = 0; k < pev->ntevs; k++) {
 			struct probe_trace_event *tev = &pev->tevs[k];
+			/* Skipped events have no event name */
+			if (!tev->event)
+				continue;
 
 			/* We use tev's name for showing new events */
 			show_perf_probe_event(tev->group, tev->event, pev,


