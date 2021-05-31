Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD24395FD8
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232449AbhEaOQn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:16:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:40830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232901AbhEaOMl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:12:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03C386198C;
        Mon, 31 May 2021 13:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468505;
        bh=b0Q5+kE6Pc40tmlcoKT6wXVJsrD0ncmvgMdZFD/y0pg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XFYDBcFOc2gjIN43FT/+DmCw7085TYI3Mfb1kLl3Mb1eDSMVOuq5JAG1jM+JMw/wS
         Jxz5EXZ4F5+78OTkGxxnfSbtQlEyJ+EDhWPrRj/SkgnzxQFY1LLcPxtqTgpsh1dNjV
         UkUnRzEh4452aEaYcsHtCWqKFf2mZJZHqTe0ODU8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.4 007/177] perf intel-pt: Fix sample instruction bytes
Date:   Mon, 31 May 2021 15:12:44 +0200
Message-Id: <20210531130648.155173343@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit c954eb72b31a9dc56c99b450253ec5b121add320 upstream.

The decoder reports the current instruction if it was decoded. In some
cases the current instruction is not decoded, in which case the instruction
bytes length must be set to zero. Ensure that is always done.

Note perf script can anyway get the instruction bytes for any samples where
they are not present.

Also note, that there is a redundant "ptq->insn_len = 0" statement which is
not removed until a subsequent patch in order to make this patch apply
cleanly to stable branches.

Example:

A machne that supports TSX is required. It will have flag "rtm". Kernel
parameter tsx=on may be required.

 # for w in `cat /proc/cpuinfo | grep -m1 flags `;do echo $w | grep rtm ; done
 rtm

Test program:

 #include <stdio.h>
 #include <immintrin.h>

 int main()
 {
        int x = 0;

        if (_xbegin() == _XBEGIN_STARTED) {
                x = 1;
                _xabort(1);
        } else {
                printf("x = %d\n", x);
        }
        return 0;
 }

Compile with -mrtm i.e.

 gcc -Wall -Wextra -mrtm xabort.c -o xabort

Record:

 perf record -e intel_pt/cyc/u --filter 'filter main @ ./xabort' ./xabort

Before:

 # perf script --itrace=xe -F+flags,+insn,-period --xed --ns
          xabort  1478 [007] 92161.431348581:   transactions:   x                              400b81 main+0x14 (/root/xabort)          mov $0xffffffff, %eax
          xabort  1478 [007] 92161.431348624:   transactions:   tx abrt                        400b93 main+0x26 (/root/xabort)          mov $0xffffffff, %eax

After:

 # perf script --itrace=xe -F+flags,+insn,-period --xed --ns
          xabort  1478 [007] 92161.431348581:   transactions:   x                              400b81 main+0x14 (/root/xabort)          xbegin 0x6
          xabort  1478 [007] 92161.431348624:   transactions:   tx abrt                        400b93 main+0x26 (/root/xabort)          xabort $0x1

Fixes: faaa87680b25d ("perf intel-pt/bts: Report instruction bytes and length in sample")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: stable@vger.kernel.org
Link: http://lore.kernel.org/lkml/20210519074515.9262-3-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/intel-pt.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/tools/perf/util/intel-pt.c
+++ b/tools/perf/util/intel-pt.c
@@ -602,8 +602,10 @@ static int intel_pt_walk_next_insn(struc
 
 			*ip += intel_pt_insn->length;
 
-			if (to_ip && *ip == to_ip)
+			if (to_ip && *ip == to_ip) {
+				intel_pt_insn->length = 0;
 				goto out_no_cache;
+			}
 
 			if (*ip >= al.map->end)
 				break;
@@ -991,6 +993,7 @@ static void intel_pt_set_pid_tid_cpu(str
 
 static void intel_pt_sample_flags(struct intel_pt_queue *ptq)
 {
+	ptq->insn_len = 0;
 	if (ptq->state->flags & INTEL_PT_ABORT_TX) {
 		ptq->flags = PERF_IP_FLAG_BRANCH | PERF_IP_FLAG_TX_ABORT;
 	} else if (ptq->state->flags & INTEL_PT_ASYNC) {


