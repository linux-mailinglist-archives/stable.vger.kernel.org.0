Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B16777FACC
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 15:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393675AbfHBNWA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 09:22:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:60556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393666AbfHBNV7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 09:21:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81373217D4;
        Fri,  2 Aug 2019 13:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564752119;
        bh=UDciwU+C4yH+IQMZq0y8cHobVlyc+1OycBfUZehk1Eo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jBTQ/pn3mUL6wuQRM760PXc2kLKfQopsKe6wB08DtXArcAFhXbmZA+XxIBlY1+PjV
         d2IdBRIQfnTv31/QHZ7fKXxdnf+KXf0954OF5mCsdpdzT+wucr6WH3l2ir2hvloShE
         dKexp0gNeMbjPK88rJMY5RpZruU28+BjHxg2OqZA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andi Kleen <ak@linux.intel.com>,
        Denis Bakhvalov <denis.bakhvalov@intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 52/76] perf script: Fix off by one in brstackinsn IPC computation
Date:   Fri,  2 Aug 2019 09:19:26 -0400
Message-Id: <20190802131951.11600-52-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190802131951.11600-1-sashal@kernel.org>
References: <20190802131951.11600-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

[ Upstream commit dde4e732a5b02fa5599c2c0e6c48a0c11789afc4 ]

When we hit the end of a program block, need to count the last
instruction too for the IPC computation. This caused large errors for
small blocks.

  % perf script -b ls / > /dev/null

Before:

  % perf script -F +brstackinsn --xed
  ...
        00007f94c9ac70d8                        jz 0x7f94c9ac70e3                       # PRED 3 cycles [36] 4.33 IPC
        00007f94c9ac70e3                        testb  $0x20, 0x31d(%rbx)
        00007f94c9ac70ea                        jnz 0x7f94c9ac70b0
        00007f94c9ac70ec                        testb  $0x8, 0x205ad(%rip)
        00007f94c9ac70f3                        jz 0x7f94c9ac6ff0               # PRED 1 cycles [37] 3.00 IPC

After:

  % perf script -F +brstackinsn --xed
  ...
        00007f94c9ac70d8                        jz 0x7f94c9ac70e3                       # PRED 3 cycles [15] 4.67 IPC
        00007f94c9ac70e3                        testb  $0x20, 0x31d(%rbx)
        00007f94c9ac70ea                        jnz 0x7f94c9ac70b0
        00007f94c9ac70ec                        testb  $0x8, 0x205ad(%rip)
        00007f94c9ac70f3                        jz 0x7f94c9ac6ff0               # PRED 1 cycles [16] 4.00 IPC

Suggested-by: Denis Bakhvalov <denis.bakhvalov@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Link: http://lkml.kernel.org/r/20190711181922.18765-2-andi@firstfloor.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-script.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index d089eb706d188..4380474c8c35a 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -1057,7 +1057,7 @@ static int perf_sample__fprintf_brstackinsn(struct perf_sample *sample,
 
 			printed += ip__fprintf_sym(ip, thread, x.cpumode, x.cpu, &lastsym, attr, fp);
 			if (ip == end) {
-				printed += ip__fprintf_jump(ip, &br->entries[i], &x, buffer + off, len - off, insn, fp,
+				printed += ip__fprintf_jump(ip, &br->entries[i], &x, buffer + off, len - off, ++insn, fp,
 							    &total_cycles);
 				if (PRINT_FIELD(SRCCODE))
 					printed += print_srccode(thread, x.cpumode, ip);
-- 
2.20.1

