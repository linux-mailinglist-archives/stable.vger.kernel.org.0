Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9887069148
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 16:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389250AbfGOO1x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:27:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:37570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731849AbfGOO1w (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:27:52 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1615E21537;
        Mon, 15 Jul 2019 14:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563200870;
        bh=MRuoeZo2dWpHz8nyaOXwZYILKFW//UU99AgewcmcHME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=giIKWChJpEWbRLgyIwdq4XAdESfwdtbXp1ecQQCHYVRe/HKrSPyfSXr7AK3eDt245
         557wD8s36MdBanAc61xOAvDFC2cj5ToJUqNRBI64/k7NYwxQ6Np+hb9TXRa7rqqO1U
         GiZ+sR1tO1S7tmlU3DpNK9wApKOZ4c/YpxkXifyc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Seeteena Thoufeek <s1seetee@linux.vnet.ibm.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Hendrik Brueckner <brueckner@linux.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Michael Petlan <mpetlan@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sandipan Das <sandipan@linux.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 150/158] perf tests: Fix record+probe_libc_inet_pton.sh for powerpc64
Date:   Mon, 15 Jul 2019 10:18:01 -0400
Message-Id: <20190715141809.8445-150-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715141809.8445-1-sashal@kernel.org>
References: <20190715141809.8445-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Seeteena Thoufeek <s1seetee@linux.vnet.ibm.com>

[ Upstream commit bff5a556c149804de29347a88a884d25e4e4e3a2 ]

'probe libc's inet_pton & backtrace it with ping' testcase sometimes
fails on powerpc because distro ping binary does not have symbol
information and thus it prints "[unknown]" function name in the
backtrace.

Accept "[unknown]" as valid function name for powerpc as well.

 # perf test -v "probe libc's inet_pton & backtrace it with ping"

Before:

  59: probe libc's inet_pton & backtrace it with ping       :
  --- start ---
  test child forked, pid 79695
  ping 79718 [077] 96483.787025: probe_libc:inet_pton: (7fff83a754c8)
  7fff83a754c8 __GI___inet_pton+0x8 (/usr/lib64/power9/libc-2.28.so)
  7fff83a2b7a0 gaih_inet.constprop.7+0x1020
  (/usr/lib64/power9/libc-2.28.so)
  7fff83a2c170 getaddrinfo+0x160 (/usr/lib64/power9/libc-2.28.so)
  1171830f4 [unknown] (/usr/bin/ping)
  FAIL: expected backtrace entry
  ".*\+0x[[:xdigit:]]+[[:space:]]\(.*/bin/ping.*\)$"
  got "1171830f4 [unknown] (/usr/bin/ping)"
  test child finished with -1
  ---- end ----
  probe libc's inet_pton & backtrace it with ping: FAILED!

After:

  59: probe libc's inet_pton & backtrace it with ping       :
  --- start ---
  test child forked, pid 79085
  ping 79108 [045] 96400.214177: probe_libc:inet_pton: (7fffbb9654c8)
  7fffbb9654c8 __GI___inet_pton+0x8 (/usr/lib64/power9/libc-2.28.so)
  7fffbb91b7a0 gaih_inet.constprop.7+0x1020
  (/usr/lib64/power9/libc-2.28.so)
  7fffbb91c170 getaddrinfo+0x160 (/usr/lib64/power9/libc-2.28.so)
  132e830f4 [unknown] (/usr/bin/ping)
  test child finished with 0
  ---- end ----
  probe libc's inet_pton & backtrace it with ping: Ok

Signed-off-by: Seeteena Thoufeek <s1seetee@linux.vnet.ibm.com>
Reviewed-by: Kim Phillips <kim.phillips@amd.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Hendrik Brueckner <brueckner@linux.ibm.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Michael Petlan <mpetlan@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sandipan Das <sandipan@linux.ibm.com>
Fixes: 1632936480a5 ("perf tests: Fix record+probe_libc_inet_pton.sh without ping's debuginfo")
Link: http://lkml.kernel.org/r/1561630614-3216-1-git-send-email-s1seetee@linux.vnet.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/record+probe_libc_inet_pton.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/tests/shell/record+probe_libc_inet_pton.sh b/tools/perf/tests/shell/record+probe_libc_inet_pton.sh
index cab7b0aea6ea..f5837f28f3af 100755
--- a/tools/perf/tests/shell/record+probe_libc_inet_pton.sh
+++ b/tools/perf/tests/shell/record+probe_libc_inet_pton.sh
@@ -43,7 +43,7 @@ trace_libc_inet_pton_backtrace() {
 		eventattr='max-stack=4'
 		echo "gaih_inet.*\+0x[[:xdigit:]]+[[:space:]]\($libc\)$" >> $expected
 		echo "getaddrinfo\+0x[[:xdigit:]]+[[:space:]]\($libc\)$" >> $expected
-		echo ".*\+0x[[:xdigit:]]+[[:space:]]\(.*/bin/ping.*\)$" >> $expected
+		echo ".*(\+0x[[:xdigit:]]+|\[unknown\])[[:space:]]\(.*/bin/ping.*\)$" >> $expected
 		;;
 	*)
 		eventattr='max-stack=3'
-- 
2.20.1

