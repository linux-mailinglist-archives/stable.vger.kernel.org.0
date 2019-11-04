Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B514CEEF54
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:21:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388363AbfKDWUe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:20:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:56648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388155AbfKDV71 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:59:27 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92FE920650;
        Mon,  4 Nov 2019 21:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904767;
        bh=VxPe53bJmI0+m8+ilMm7PTOAeAZoj1mvrbS4fD+q3hc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uFfIyn3NkH/rQGrzmhxX+pB1hGAPrXXCmZhjhTvZY3lM41yYfW7iW712i7kOlmAPW
         BTTPeTA6AeJVqv/pzzkqea2kRmnTjfj+4I/w68ijcgbziV01+mP8jwBrV3A53IpywQ
         hMT+v4TsQFnob2rUZyQMwj6tQ8nfDqvZ1jfBvvzg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 063/149] perf script brstackinsn: Fix recovery from LBR/binary mismatch
Date:   Mon,  4 Nov 2019 22:44:16 +0100
Message-Id: <20191104212141.179859359@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
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
index 53c11fc0855ee..d20f851796c52 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -1021,7 +1021,7 @@ static int perf_sample__fprintf_brstackinsn(struct perf_sample *sample,
 			continue;
 
 		insn = 0;
-		for (off = 0;; off += ilen) {
+		for (off = 0; off < (unsigned)len; off += ilen) {
 			uint64_t ip = start + off;
 
 			printed += ip__fprintf_sym(ip, thread, x.cpumode, x.cpu, &lastsym, attr, fp);
@@ -1029,6 +1029,7 @@ static int perf_sample__fprintf_brstackinsn(struct perf_sample *sample,
 				printed += ip__fprintf_jump(ip, &br->entries[i], &x, buffer + off, len - off, insn, fp);
 				break;
 			} else {
+				ilen = 0;
 				printed += fprintf(fp, "\t%016" PRIx64 "\t%s\n", ip,
 						   dump_insn(&x, ip, buffer + off, len - off, &ilen));
 				if (ilen == 0)
@@ -1036,6 +1037,8 @@ static int perf_sample__fprintf_brstackinsn(struct perf_sample *sample,
 				insn++;
 			}
 		}
+		if (off != (unsigned)len)
+			printed += fprintf(fp, "\tmismatch of LBR data and executable\n");
 	}
 
 	/*
@@ -1066,6 +1069,7 @@ static int perf_sample__fprintf_brstackinsn(struct perf_sample *sample,
 		goto out;
 	}
 	for (off = 0; off <= end - start; off += ilen) {
+		ilen = 0;
 		printed += fprintf(fp, "\t%016" PRIx64 "\t%s\n", start + off,
 				   dump_insn(&x, start + off, buffer + off, len - off, &ilen));
 		if (ilen == 0)
-- 
2.20.1



