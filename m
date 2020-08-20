Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14DD824B263
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbgHTJ3L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:29:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:36868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727068AbgHTJ22 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:28:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECE8D22CA1;
        Thu, 20 Aug 2020 09:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597915700;
        bh=5AckTXm0iPCXnCFpyigvpzwr1s+pozYsuJuIRPH0wgk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PzFp4m0VnHt2eJmb35obIL5K44CKIvE02P9hun4OoOQVvv8wwmyX+M7+4ALRM/dmw
         o1HUHqi7QwCQbbkPGFIf+E/n8BKghTnxySjj+F75BVVFnHtVcX1/FCQTFZ/qqkje4g
         1CHvq94kdCA9p0GZSx/SNaTDFJ6Ailp5Ukb+dHFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 5.8 105/232] perf intel-pt: Fix duplicate branch after CBR
Date:   Thu, 20 Aug 2020 11:19:16 +0200
Message-Id: <20200820091617.908535739@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit a58a057ce65b52125dd355b7d8b0d540ea267a5f upstream.

CBR events can result in a duplicate branch event, because the state
type defaults to a branch. Fix by clearing the state type.

Example: trace 'sleep' and hope for a frequency change

 Before:

   $ perf record -e intel_pt//u sleep 0.1
   [ perf record: Woken up 1 times to write data ]
   [ perf record: Captured and wrote 0.034 MB perf.data ]
   $ perf script --itrace=bpe > before.txt

 After:

   $ perf script --itrace=bpe > after.txt
   $ diff -u before.txt after.txt
#  --- before.txt  2020-07-07 14:42:18.191508098 +0300
#  +++ after.txt   2020-07-07 14:42:36.587891753 +0300
   @@ -29673,7 +29673,6 @@
               sleep 93431 [007] 15411.619905:          1  branches:u:                 0 [unknown] ([unknown]) =>     7f0818abb2e0 clock_nanosleep@@GLIBC_2.17+0x0 (/usr/lib/x86_64-linux-gnu/libc-2.31.so)
               sleep 93431 [007] 15411.619905:          1  branches:u:      7f0818abb30c clock_nanosleep@@GLIBC_2.17+0x2c (/usr/lib/x86_64-linux-gnu/libc-2.31.so) =>                0 [unknown] ([unknown])
               sleep 93431 [007] 15411.720069:         cbr:  cbr: 15 freq: 1507 MHz ( 56%)         7f0818abb30c clock_nanosleep@@GLIBC_2.17+0x2c (/usr/lib/x86_64-linux-gnu/libc-2.31.so)
   -           sleep 93431 [007] 15411.720069:          1  branches:u:      7f0818abb30c clock_nanosleep@@GLIBC_2.17+0x2c (/usr/lib/x86_64-linux-gnu/libc-2.31.so) =>                0 [unknown] ([unknown])
               sleep 93431 [007] 15411.720076:          1  branches:u:                 0 [unknown] ([unknown]) =>     7f0818abb30e clock_nanosleep@@GLIBC_2.17+0x2e (/usr/lib/x86_64-linux-gnu/libc-2.31.so)
               sleep 93431 [007] 15411.720077:          1  branches:u:      7f0818abb323 clock_nanosleep@@GLIBC_2.17+0x43 (/usr/lib/x86_64-linux-gnu/libc-2.31.so) =>     7f0818ac0eb7 __nanosleep+0x17 (/usr/lib/x86_64-linux-gnu/libc-2.31.so)
               sleep 93431 [007] 15411.720077:          1  branches:u:      7f0818ac0ebf __nanosleep+0x1f (/usr/lib/x86_64-linux-gnu/libc-2.31.so) =>     55cb7e4c2827 rpl_nanosleep+0x97 (/usr/bin/sleep)

Fixes: 91de8684f1cff ("perf intel-pt: Cater for CBR change in PSB+")
Fixes: abe5a1d3e4bee ("perf intel-pt: Decoder to output CBR changes immediately")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: stable@vger.kernel.org
Link: http://lore.kernel.org/lkml/20200710151104.15137-3-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/util/intel-pt-decoder/intel-pt-decoder.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
@@ -1977,8 +1977,10 @@ next:
 			 * possibility of another CBR change that gets caught up
 			 * in the PSB+.
 			 */
-			if (decoder->cbr != decoder->cbr_seen)
+			if (decoder->cbr != decoder->cbr_seen) {
+				decoder->state.type = 0;
 				return 0;
+			}
 			break;
 
 		case INTEL_PT_PIP:
@@ -2019,8 +2021,10 @@ next:
 
 		case INTEL_PT_CBR:
 			intel_pt_calc_cbr(decoder);
-			if (decoder->cbr != decoder->cbr_seen)
+			if (decoder->cbr != decoder->cbr_seen) {
+				decoder->state.type = 0;
 				return 0;
+			}
 			break;
 
 		case INTEL_PT_MODE_EXEC:


