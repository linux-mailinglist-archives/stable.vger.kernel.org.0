Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE1613FDB8B
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245486AbhIAMmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:42:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:42974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344923AbhIAMkN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:40:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4BBB4610FF;
        Wed,  1 Sep 2021 12:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499774;
        bh=RWFEaJQM9JI22pQcDB9RJYhNt9np77mFEJLr/m/K6YA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zUMFfUksPWiawVqQPWHWaFMNOApzU0D2UDt8Ymk0pqgpqqQA7IlrAG7nhQvD+TAsZ
         Y+ix4TccKQpx94dYBo5SEwUvA4Kz72uEFUsP+STngCMz1PQ3ezy9FBX6oJWLk6cR+Y
         p8GbHMjppEZbQQ988zM7ANDPRUPOcr+sh948K8p8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Riccardo Mancini <rickyman7@gmail.com>,
        Ian Rogers <irogers@google.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH 5.10 080/103] perf env: Fix memory leak of bpf_prog_info_linear member
Date:   Wed,  1 Sep 2021 14:28:30 +0200
Message-Id: <20210901122303.242360974@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
References: <20210901122300.503008474@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Riccardo Mancini <rickyman7@gmail.com>

commit 67069a1f0fe5f9eeca86d954fff2087f5542a008 upstream.

ASan reported a memory leak caused by info_linear not being deallocated.

The info_linear was allocated during in perf_event__synthesize_one_bpf_prog().

This patch adds the corresponding free() when bpf_prog_info_node
is freed in perf_env__purge_bpf().

  $ sudo ./perf record -- sleep 5
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.025 MB perf.data (8 samples) ]

  =================================================================
  ==297735==ERROR: LeakSanitizer: detected memory leaks

  Direct leak of 7688 byte(s) in 19 object(s) allocated from:
      #0 0x4f420f in malloc (/home/user/linux/tools/perf/perf+0x4f420f)
      #1 0xc06a74 in bpf_program__get_prog_info_linear /home/user/linux/tools/lib/bpf/libbpf.c:11113:16
      #2 0xb426fe in perf_event__synthesize_one_bpf_prog /home/user/linux/tools/perf/util/bpf-event.c:191:16
      #3 0xb42008 in perf_event__synthesize_bpf_events /home/user/linux/tools/perf/util/bpf-event.c:410:9
      #4 0x594596 in record__synthesize /home/user/linux/tools/perf/builtin-record.c:1490:8
      #5 0x58c9ac in __cmd_record /home/user/linux/tools/perf/builtin-record.c:1798:8
      #6 0x58990b in cmd_record /home/user/linux/tools/perf/builtin-record.c:2901:8
      #7 0x7b2a20 in run_builtin /home/user/linux/tools/perf/perf.c:313:11
      #8 0x7b12ff in handle_internal_command /home/user/linux/tools/perf/perf.c:365:8
      #9 0x7b2583 in run_argv /home/user/linux/tools/perf/perf.c:409:2
      #10 0x7b0d79 in main /home/user/linux/tools/perf/perf.c:539:3
      #11 0x7fa357ef6b74 in __libc_start_main /usr/src/debug/glibc-2.33-8.fc34.x86_64/csu/../csu/libc-start.c:332:16

Signed-off-by: Riccardo Mancini <rickyman7@gmail.com>
Acked-by: Ian Rogers <irogers@google.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Link: http://lore.kernel.org/lkml/20210602224024.300485-1-rickyman7@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Hanjun Guo <guohanjun@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/env.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/perf/util/env.c
+++ b/tools/perf/util/env.c
@@ -142,6 +142,7 @@ static void perf_env__purge_bpf(struct p
 		node = rb_entry(next, struct bpf_prog_info_node, rb_node);
 		next = rb_next(&node->rb_node);
 		rb_erase(&node->rb_node, root);
+		free(node->info_linear);
 		free(node);
 	}
 


