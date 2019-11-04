Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89381EED60
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389901AbfKDWGC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:06:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:37662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388887AbfKDWGB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:06:01 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 750432190F;
        Mon,  4 Nov 2019 22:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905161;
        bh=ZZLlPeXBR+EVEvw0FmNfaS2VKB63dks1AB/dmDQjob4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ss3kOJ/hNphNygQwxgFGL6vVlhUw+0xgmd/TdHESim840liKFzSY6A+9Oopxksw+W
         N7ehAqq8WzWulWxdTJUNEDwn/nF8Jb2yUSMmUeUhCwWJQ9cTWOvKKRDcdWSP4UxM0W
         QhfWIBB//DpgPdzJ2xoW/Iw7qTGnfaYvXpRrtUkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 011/163] perf script brstackinsn: Fix recovery from LBR/binary mismatch
Date:   Mon,  4 Nov 2019 22:43:21 +0100
Message-Id: <20191104212141.304255192@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

[ Upstream commit e98df280bc2a499fd41d7f9e2d6733884de69902 ]

When the LBR data and the instructions in a binary do not match the loop
printing instructions could get confused and print a long stream of
bogus <bad> instructions.

The problem was that if the instruction decoder cannot decode an
instruction it ilen wasn't initialized, so the loop going through the
basic block would continue with the previous value.

Harden the code to avoid such problems:

- Make sure ilen is always freshly initialized and is 0 for bad
  instructions.

- Do not overrun the code buffer while printing instructions

- Print a warning message if the final jump is not on an instruction
  boundary.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Link: http://lore.kernel.org/lkml/20190927233546.11533-1-andi@firstfloor.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-script.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 0140ddb8dd0bd..c14a1cdad80c0 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -1054,7 +1054,7 @@ static int perf_sample__fprintf_brstackinsn(struct perf_sample *sample,
 			continue;
 
 		insn = 0;
-		for (off = 0;; off += ilen) {
+		for (off = 0; off < (unsigned)len; off += ilen) {
 			uint64_t ip = start + off;
 
 			printed += ip__fprintf_sym(ip, thread, x.cpumode, x.cpu, &lastsym, attr, fp);
@@ -1065,6 +1065,7 @@ static int perf_sample__fprintf_brstackinsn(struct perf_sample *sample,
 					printed += print_srccode(thread, x.cpumode, ip);
 				break;
 			} else {
+				ilen = 0;
 				printed += fprintf(fp, "\t%016" PRIx64 "\t%s\n", ip,
 						   dump_insn(&x, ip, buffer + off, len - off, &ilen));
 				if (ilen == 0)
@@ -1074,6 +1075,8 @@ static int perf_sample__fprintf_brstackinsn(struct perf_sample *sample,
 				insn++;
 			}
 		}
+		if (off != (unsigned)len)
+			printed += fprintf(fp, "\tmismatch of LBR data and executable\n");
 	}
 
 	/*
@@ -1114,6 +1117,7 @@ static int perf_sample__fprintf_brstackinsn(struct perf_sample *sample,
 		goto out;
 	}
 	for (off = 0; off <= end - start; off += ilen) {
+		ilen = 0;
 		printed += fprintf(fp, "\t%016" PRIx64 "\t%s\n", start + off,
 				   dump_insn(&x, start + off, buffer + off, len - off, &ilen));
 		if (ilen == 0)
-- 
2.20.1



