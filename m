Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EFC0EEEA3
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:16:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388412AbfKDWE0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:04:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:35118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388315AbfKDWE0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:04:26 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C8AD222C1;
        Mon,  4 Nov 2019 22:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905065;
        bh=+UnMfg+m4swdchYKP2ODwEcQQQuDupu3pI/pxiofxoo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CuvLcdLiGCP+JFFQ7FKVGFuvEG8Yz0YOD8vVhu2oZOHiKZIw+TMr5eS7b2ASw4TZd
         +v6Pz6IeSuIqeKLtpOlUWJQS68GUsvXC3HD0A8CCZFyXfonarPdnh5/034cwZI88/F
         RpO5+5WZ/Ys60ZhIXG9X/EWRzpdzsxRakYlUdpro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Will Deacon <will@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 5.3 017/163] perf annotate: Fix arch specific ->init() failure errors
Date:   Mon,  4 Nov 2019 22:43:27 +0100
Message-Id: <20191104212141.665821076@linuxfoundation.org>
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 42d7a9107d83223a5fcecc6732d626a6c074cbc2 ]

They are called from symbol__annotate() and to propagate errors that can
help understand the problem make them return what
symbol__strerror_disassemble() known, i.e. errno codes and other
annotation specific errors in a special, out of errnos, range.

Reported-by: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
Cc: Will Deacon <will@kernel.org>
Link: https://lkml.kernel.org/n/tip-pqx7srcv7tixgid251aeboj6@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/arch/arm/annotate/instructions.c   | 4 ++--
 tools/perf/arch/arm64/annotate/instructions.c | 4 ++--
 tools/perf/arch/s390/annotate/instructions.c  | 6 ++++--
 tools/perf/arch/x86/annotate/instructions.c   | 6 ++++--
 tools/perf/util/annotate.c                    | 6 ++++++
 tools/perf/util/annotate.h                    | 2 ++
 6 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/tools/perf/arch/arm/annotate/instructions.c b/tools/perf/arch/arm/annotate/instructions.c
index c7d1a69b894fe..19ac54758c713 100644
--- a/tools/perf/arch/arm/annotate/instructions.c
+++ b/tools/perf/arch/arm/annotate/instructions.c
@@ -36,7 +36,7 @@ static int arm__annotate_init(struct arch *arch, char *cpuid __maybe_unused)
 
 	arm = zalloc(sizeof(*arm));
 	if (!arm)
-		return -1;
+		return ENOMEM;
 
 #define ARM_CONDS "(cc|cs|eq|ge|gt|hi|le|ls|lt|mi|ne|pl|vc|vs)"
 	err = regcomp(&arm->call_insn, "^blx?" ARM_CONDS "?$", REG_EXTENDED);
@@ -58,5 +58,5 @@ out_free_call:
 	regfree(&arm->call_insn);
 out_free_arm:
 	free(arm);
-	return -1;
+	return SYMBOL_ANNOTATE_ERRNO__ARCH_INIT_REGEXP;
 }
diff --git a/tools/perf/arch/arm64/annotate/instructions.c b/tools/perf/arch/arm64/annotate/instructions.c
index 8f70a1b282dfb..223e2f161f414 100644
--- a/tools/perf/arch/arm64/annotate/instructions.c
+++ b/tools/perf/arch/arm64/annotate/instructions.c
@@ -94,7 +94,7 @@ static int arm64__annotate_init(struct arch *arch, char *cpuid __maybe_unused)
 
 	arm = zalloc(sizeof(*arm));
 	if (!arm)
-		return -1;
+		return ENOMEM;
 
 	/* bl, blr */
 	err = regcomp(&arm->call_insn, "^blr?$", REG_EXTENDED);
@@ -117,5 +117,5 @@ out_free_call:
 	regfree(&arm->call_insn);
 out_free_arm:
 	free(arm);
-	return -1;
+	return SYMBOL_ANNOTATE_ERRNO__ARCH_INIT_REGEXP;
 }
diff --git a/tools/perf/arch/s390/annotate/instructions.c b/tools/perf/arch/s390/annotate/instructions.c
index 89bb8f2c54cee..a50e70baf9183 100644
--- a/tools/perf/arch/s390/annotate/instructions.c
+++ b/tools/perf/arch/s390/annotate/instructions.c
@@ -164,8 +164,10 @@ static int s390__annotate_init(struct arch *arch, char *cpuid __maybe_unused)
 	if (!arch->initialized) {
 		arch->initialized = true;
 		arch->associate_instruction_ops = s390__associate_ins_ops;
-		if (cpuid)
-			err = s390__cpuid_parse(arch, cpuid);
+		if (cpuid) {
+			if (s390__cpuid_parse(arch, cpuid))
+				err = SYMBOL_ANNOTATE_ERRNO__ARCH_INIT_CPUID_PARSING;
+		}
 	}
 
 	return err;
diff --git a/tools/perf/arch/x86/annotate/instructions.c b/tools/perf/arch/x86/annotate/instructions.c
index 44f5aba78210e..7eb5621c021d8 100644
--- a/tools/perf/arch/x86/annotate/instructions.c
+++ b/tools/perf/arch/x86/annotate/instructions.c
@@ -196,8 +196,10 @@ static int x86__annotate_init(struct arch *arch, char *cpuid)
 	if (arch->initialized)
 		return 0;
 
-	if (cpuid)
-		err = x86__cpuid_parse(arch, cpuid);
+	if (cpuid) {
+		if (x86__cpuid_parse(arch, cpuid))
+			err = SYMBOL_ANNOTATE_ERRNO__ARCH_INIT_CPUID_PARSING;
+	}
 
 	arch->initialized = true;
 	return err;
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index ca8b517e38fa8..b475449f955ef 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -1625,6 +1625,12 @@ int symbol__strerror_disassemble(struct symbol *sym __maybe_unused, struct map *
 	case SYMBOL_ANNOTATE_ERRNO__NO_LIBOPCODES_FOR_BPF:
 		scnprintf(buf, buflen, "Please link with binutils's libopcode to enable BPF annotation");
 		break;
+	case SYMBOL_ANNOTATE_ERRNO__ARCH_INIT_REGEXP:
+		scnprintf(buf, buflen, "Problems with arch specific instruction name regular expressions.");
+		break;
+	case SYMBOL_ANNOTATE_ERRNO__ARCH_INIT_CPUID_PARSING:
+		scnprintf(buf, buflen, "Problems while parsing the CPUID in the arch specific initialization.");
+		break;
 	default:
 		scnprintf(buf, buflen, "Internal error: Invalid %d error code\n", errnum);
 		break;
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index 5bc0cf655d377..a1191995fe77e 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -370,6 +370,8 @@ enum symbol_disassemble_errno {
 
 	SYMBOL_ANNOTATE_ERRNO__NO_VMLINUX	= __SYMBOL_ANNOTATE_ERRNO__START,
 	SYMBOL_ANNOTATE_ERRNO__NO_LIBOPCODES_FOR_BPF,
+	SYMBOL_ANNOTATE_ERRNO__ARCH_INIT_CPUID_PARSING,
+	SYMBOL_ANNOTATE_ERRNO__ARCH_INIT_REGEXP,
 
 	__SYMBOL_ANNOTATE_ERRNO__END,
 };
-- 
2.20.1



