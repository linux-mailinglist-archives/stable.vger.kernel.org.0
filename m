Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B51E395C54
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232308AbhEaNbX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:31:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:33262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232467AbhEaN3W (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:29:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98FF96141E;
        Mon, 31 May 2021 13:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467356;
        bh=ONFhqZotYwOTGryO8adXe6Fe90MUm7ufkRVFMThU7qs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hh3DUQO4w8ZU9SnyEDoU7OkgmPsrmgkHzDkmc4np+eCV2oP4BPPsrV41IxDbYQMFZ
         5ULeUJlBZmJkxOmB9U2+EQCDgCJdL+Wb6BPorh/TxzVB9726RVLWl3+2DooFCHGvvG
         pPAD++B7RikTpvbnTJdcm8HNGf8g0vrWIw2F6Isw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4.19 008/116] perf intel-pt: Fix transaction abort handling
Date:   Mon, 31 May 2021 15:13:04 +0200
Message-Id: <20210531130640.430978660@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130640.131924542@linuxfoundation.org>
References: <20210531130640.131924542@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit cb7987837c31b217b28089bbc78922d5c9187869 upstream.

When adding support for power events, some handling of FUP packets was
unified. That resulted in breaking reporting of TSX aborts, by not
considering the associated TIP packet. Fix that.

Example:

A machine that supports TSX is required. It will have flag "rtm". Kernel
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

 # perf script --itrace=be -F+flags,+addr,-period,-event --ns
          xabort  1478 [007] 92161.431348552:   tr strt                             0 [unknown] ([unknown]) =>           400b6d main+0x0 (/root/xabort)
          xabort  1478 [007] 92161.431348624:   jmp                            400b96 main+0x29 (/root/xabort) =>           400bae main+0x41 (/root/xabort)
          xabort  1478 [007] 92161.431348624:   return                         400bb4 main+0x47 (/root/xabort) =>           400b87 main+0x1a (/root/xabort)
          xabort  1478 [007] 92161.431348637:   jcc                            400b8a main+0x1d (/root/xabort) =>           400b98 main+0x2b (/root/xabort)
          xabort  1478 [007] 92161.431348644:   tr end  call                   400ba9 main+0x3c (/root/xabort) =>           40f690 printf+0x0 (/root/xabort)
          xabort  1478 [007] 92161.431360859:   tr strt                             0 [unknown] ([unknown]) =>           400bae main+0x41 (/root/xabort)
          xabort  1478 [007] 92161.431360882:   tr end  return                 400bb4 main+0x47 (/root/xabort) =>           401139 __libc_start_main+0x309 (/root/xabort)

After:

 # perf script --itrace=be -F+flags,+addr,-period,-event --ns
          xabort  1478 [007] 92161.431348552:   tr strt                             0 [unknown] ([unknown]) =>           400b6d main+0x0 (/root/xabort)
          xabort  1478 [007] 92161.431348624:   tx abrt                        400b93 main+0x26 (/root/xabort) =>           400b87 main+0x1a (/root/xabort)
          xabort  1478 [007] 92161.431348637:   jcc                            400b8a main+0x1d (/root/xabort) =>           400b98 main+0x2b (/root/xabort)
          xabort  1478 [007] 92161.431348644:   tr end  call                   400ba9 main+0x3c (/root/xabort) =>           40f690 printf+0x0 (/root/xabort)
          xabort  1478 [007] 92161.431360859:   tr strt                             0 [unknown] ([unknown]) =>           400bae main+0x41 (/root/xabort)
          xabort  1478 [007] 92161.431360882:   tr end  return                 400bb4 main+0x47 (/root/xabort) =>           401139 __libc_start_main+0x309 (/root/xabort)

Fixes: a472e65fc490a ("perf intel-pt: Add decoder support for ptwrite and power event packets")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: stable@vger.kernel.org
Link: http://lore.kernel.org/lkml/20210519074515.9262-2-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/intel-pt-decoder/intel-pt-decoder.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
@@ -1063,6 +1063,8 @@ static bool intel_pt_fup_event(struct in
 		decoder->set_fup_tx_flags = false;
 		decoder->tx_flags = decoder->fup_tx_flags;
 		decoder->state.type = INTEL_PT_TRANSACTION;
+		if (decoder->fup_tx_flags & INTEL_PT_ABORT_TX)
+			decoder->state.type |= INTEL_PT_BRANCH;
 		decoder->state.from_ip = decoder->ip;
 		decoder->state.to_ip = 0;
 		decoder->state.flags = decoder->fup_tx_flags;
@@ -1129,8 +1131,10 @@ static int intel_pt_walk_fup(struct inte
 			return 0;
 		if (err == -EAGAIN ||
 		    intel_pt_fup_with_nlip(decoder, &intel_pt_insn, ip, err)) {
+			bool no_tip = decoder->pkt_state != INTEL_PT_STATE_FUP;
+
 			decoder->pkt_state = INTEL_PT_STATE_IN_SYNC;
-			if (intel_pt_fup_event(decoder))
+			if (intel_pt_fup_event(decoder) && no_tip)
 				return 0;
 			return -EAGAIN;
 		}


