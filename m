Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 809B120167A
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389656AbgFSQbY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:31:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:47158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389644AbgFSOw5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:52:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4308D21852;
        Fri, 19 Jun 2020 14:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578376;
        bh=VWd75qwe8Tw9/e6o2TotNGK1ySb4QoeLd+Hl9mcG2XU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ttUXntdEou9tAShuWaVZBILzqfJV2gg0clGASBFtx0jTrJmeCoXEv5mwsooOgA+lI
         3cDXblgnKnahLLpStyAQS6NnWv9KUxcjxYhr1U3RYhjWNakq0xpwjJf8Z8kPKZ3/Yo
         XBRg36+fJquToiGJ63kIPiLjeO5YnXwoMlubAJK4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 4.14 188/190] perf probe: Do not show the skipped events
Date:   Fri, 19 Jun 2020 16:33:53 +0200
Message-Id: <20200619141643.253762879@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141633.446429600@linuxfoundation.org>
References: <20200619141633.446429600@linuxfoundation.org>
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
@@ -377,6 +377,9 @@ static int perf_add_probe_events(struct
 
 		for (k = 0; k < pev->ntevs; k++) {
 			struct probe_trace_event *tev = &pev->tevs[k];
+			/* Skipped events have no event name */
+			if (!tev->event)
+				continue;
 
 			/* We use tev's name for showing new events */
 			show_perf_probe_event(tev->group, tev->event, pev,


