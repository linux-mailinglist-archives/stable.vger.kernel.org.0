Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 141CD2BA84D
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 12:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728360AbgKTLGQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 06:06:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:53976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728348AbgKTLGL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 06:06:11 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 011D5206E3;
        Fri, 20 Nov 2020 11:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605870370;
        bh=6WPY7IXik1n0TmpUGXGANP023j170ZaxUYNVhqmACzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0rqzymRQtqmVoyby4aQ5Ojo/Ufg9/Jyet0UiQquN4xrETeUKU/Y+nuS/bBphpl+4K
         /FErEFwSTeeF/WoYgFVxh6ghFKykhORvs3WxCgFde4K0m/nZYZugp5ouXkkOviFpua
         4KyouYq1gZIPCtvoDF+wGZwO3n0WeDLCU3q3q5Ic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Leo Yan <leo.yan@linaro.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Suzuki Poulouse <suzuki.poulose@arm.com>,
        Tor Jeremiassen <tor@ti.com>,
        linux-arm-kernel@lists.infradead.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Salvatore Bonaccorso <carnil@debian.org>
Subject: [PATCH 4.19 08/14] Revert "perf cs-etm: Move definition of traceid_list global variable from header file"
Date:   Fri, 20 Nov 2020 12:03:29 +0100
Message-Id: <20201120104540.213608508@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120104539.806156260@linuxfoundation.org>
References: <20201120104539.806156260@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Salvatore Bonaccorso <carnil@debian.org>

This reverts commit 168200b6d6ea0cb5765943ec5da5b8149701f36a upstream.
(but only from 4.19.y)

The original commit introduces a build failure as seen on Debian buster
when compiled with gcc (Debian 8.3.0-6) 8.3.0:

  $ LC_ALL=C.UTF-8 ARCH=x86 make perf
  [...]
  Warning: Kernel ABI header at 'tools/include/uapi/linux/bpf.h' differs from latest version at 'include/uapi/linux/bpf.h'
    CC       util/cs-etm-decoder/cs-etm-decoder.o
    CC       util/intel-pt.o
  util/cs-etm-decoder/cs-etm-decoder.c: In function 'cs_etm_decoder__buffer_packet':
  util/cs-etm-decoder/cs-etm-decoder.c:287:24: error: 'traceid_list' undeclared (first use in this function); did you mean 'trace_event'?
    inode = intlist__find(traceid_list, trace_chan_id);
                          ^~~~~~~~~~~~
                          trace_event
  util/cs-etm-decoder/cs-etm-decoder.c:287:24: note: each undeclared identifier is reported only once for each function it appears in
  make[6]: *** [/build/linux-stable/tools/build/Makefile.build:97: util/cs-etm-decoder/cs-etm-decoder.o] Error 1
  make[5]: *** [/build/linux-stable/tools/build/Makefile.build:139: cs-etm-decoder] Error 2
  make[5]: *** Waiting for unfinished jobs....
  make[4]: *** [/build/linux-stable/tools/build/Makefile.build:139: util] Error 2
  make[3]: *** [Makefile.perf:633: libperf-in.o] Error 2
  make[2]: *** [Makefile.perf:206: sub-make] Error 2
  make[1]: *** [Makefile:70: all] Error 2
  make: *** [Makefile:77: perf] Error 2

Link: https://lore.kernel.org/stable/20201114083501.GA468764@eldamar.lan/
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suzuki Poulouse <suzuki.poulose@arm.com>
Cc: Tor Jeremiassen <tor@ti.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <stable@vger.kernel.org> # 4.19.y
Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/cs-etm.c |    3 ---
 tools/perf/util/cs-etm.h |    3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/tools/perf/util/cs-etm.c
+++ b/tools/perf/util/cs-etm.c
@@ -87,9 +87,6 @@ struct cs_etm_queue {
 	struct cs_etm_packet *packet;
 };
 
-/* RB tree for quick conversion between traceID and metadata pointers */
-static struct intlist *traceid_list;
-
 static int cs_etm__update_queues(struct cs_etm_auxtrace *etm);
 static int cs_etm__process_timeless_queues(struct cs_etm_auxtrace *etm,
 					   pid_t tid, u64 time_);
--- a/tools/perf/util/cs-etm.h
+++ b/tools/perf/util/cs-etm.h
@@ -53,6 +53,9 @@ enum {
 	CS_ETMV4_PRIV_MAX,
 };
 
+/* RB tree for quick conversion between traceID and CPUs */
+struct intlist *traceid_list;
+
 #define KiB(x) ((x) * 1024)
 #define MiB(x) ((x) * 1024 * 1024)
 


