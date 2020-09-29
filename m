Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13D1227C7EE
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731577AbgI2L5g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:57:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:40872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730304AbgI2Lm6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:42:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E3C42065C;
        Tue, 29 Sep 2020 11:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379777;
        bh=4hFaOhYXhEZ2YUZK9br3DJlOh09O6SkwpCUDLEPAVF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UKlcr5TBhxUxbwwJaVfxtqVqhtUayTW84mEwIGSP5cl9yBGoGnqz+AwoA5vBRKofL
         V07Xkwm1BGLGE7pn7ThB/XPTOcgi3SmduxvsFw4xSsf4ssuQIKpzxSOJlQI6Yhrx/i
         W8Q0bWVAO91shr61c8/kZmAlXBEoTtnN8KbXUdG4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Richter <tmricht@linux.ibm.com>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 312/388] perf tests: Fix test 68 zstd compression for s390
Date:   Tue, 29 Sep 2020 13:00:43 +0200
Message-Id: <20200929110025.574418883@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



