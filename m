Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A99EF26F1B6
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729232AbgIRCxP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:53:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:58500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727997AbgIRCHu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:07:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B2B2238E5;
        Fri, 18 Sep 2020 02:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394869;
        bh=4hFaOhYXhEZ2YUZK9br3DJlOh09O6SkwpCUDLEPAVF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PN/bnaKgm/ySCrwbRkWOW3VesIs8aajB5oghR8AW5rIo1dsx69C/bg3u8QihI2KbR
         LOmj0miWcS34JG60PyGSq6tRN1bWj7upIvzFGONjlXRYJfsU/nP3ArI5GWxDaAhHZA
         +AqjH/rytvLzulCOfhOLxXBuGElyBcEfDg1iQ0cI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Richter <tmricht@linux.ibm.com>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 321/330] perf tests: Fix test 68 zstd compression for s390
Date:   Thu, 17 Sep 2020 22:01:01 -0400
Message-Id: <20200918020110.2063155-321-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit 463538a383a27337cb83ae195e432a839a52d639 ]

Commit 5aa98879efe7 ("s390/cpum_sf: prohibit callchain data collection")
prohibits call graph sampling for hardware events on s390. The
information recorded is out of context and does not match.

On s390 this commit now breaks test case 68 Zstd perf.data
compression/decompression.

Therefore omit call graph sampling on s390 in this test.

Output before:
  [root@t35lp46 perf]# ./perf test -Fv 68
  68: Zstd perf.data compression/decompression              :
  --- start ---
  Collecting compressed record file:
  Error:
  cycles: PMU Hardware doesn't support sampling/overflow-interrupts.
                                Try 'perf stat'
  ---- end ----
  Zstd perf.data compression/decompression: FAILED!
  [root@t35lp46 perf]#

Output after:
[root@t35lp46 perf]# ./perf test -Fv 68
  68: Zstd perf.data compression/decompression              :
  --- start ---
  Collecting compressed record file:
  500+0 records in
  500+0 records out
  256000 bytes (256 kB, 250 KiB) copied, 0.00615638 s, 41.6 MB/s
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.004 MB /tmp/perf.data.X3M,
                        compressed (original 0.002 MB, ratio is 3.609) ]
  Checking compressed events stats:
  # compressed : Zstd, level = 1, ratio = 4
        COMPRESSED events:          1
  2ELIFREPh---- end ----
  Zstd perf.data compression/decompression: Ok
  [root@t35lp46 perf]#

Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Reviewed-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Link: http://lore.kernel.org/lkml/20200729135314.91281-1-tmricht@linux.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/record+zstd_comp_decomp.sh | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/tests/shell/record+zstd_comp_decomp.sh b/tools/perf/tests/shell/record+zstd_comp_decomp.sh
index 63a91ec473bb5..045723b3d9928 100755
--- a/tools/perf/tests/shell/record+zstd_comp_decomp.sh
+++ b/tools/perf/tests/shell/record+zstd_comp_decomp.sh
@@ -12,7 +12,8 @@ skip_if_no_z_record() {
 
 collect_z_record() {
 	echo "Collecting compressed record file:"
-	$perf_tool record -o $trace_file -g -z -F 5000 -- \
+	[[ "$(uname -m)" != s390x ]] && gflag='-g'
+	$perf_tool record -o $trace_file $gflag -z -F 5000 -- \
 		dd count=500 if=/dev/urandom of=/dev/null
 }
 
-- 
2.25.1

