Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D943DD4E1
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbfJRW2I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:28:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:35338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727166AbfJRWDs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:03:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC8A92245B;
        Fri, 18 Oct 2019 22:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436228;
        bh=oVOeKJXMi/4L8ddaH2Ou/ffyVHk8XoU2AZ/+BO6rhXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ntNBgQ7s17z+RwNXsR5aCKyHliZBcQXFI0qM6EnxRI+DBjW+UkdcptCCU5UfSOc63
         S+OWDjRGn8uR8T9tR5xs6zj8e1BaGetNlQwr+uqXpp/YOXruRf9jlJm76Cge5XPG6A
         +ReSiuuMI9dZNIUjIeyH9aEJp606oPAOSYsBQAmg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnaldo Carvalho de Melo <acme@redhat.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 14/89] perf annotate: Don't return -1 for error when doing BPF disassembly
Date:   Fri, 18 Oct 2019 18:02:09 -0400
Message-Id: <20191018220324.8165-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220324.8165-1-sashal@kernel.org>
References: <20191018220324.8165-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 11aad897f6d1a28eae3b7e5b293647c522d65819 ]

Return errno when open_memstream() fails and add two new speciall error
codes for when an invalid, non BPF file or one without BTF is passed to
symbol__disassemble_bpf(), so that its callers can rely on
symbol__strerror_disassemble() to convert that to a human readable error
message that can help figure out what is wrong, with hints even.

Cc: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc: Song Liu <songliubraving@fb.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
Cc: Will Deacon <will@kernel.org>
Link: https://lkml.kernel.org/n/tip-usevw9r2gcipfcrbpaueurw0@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/annotate.c | 19 +++++++++++++++----
 tools/perf/util/annotate.h |  2 ++
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index ab7851ec0ce53..fb8756026a805 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -1631,6 +1631,13 @@ int symbol__strerror_disassemble(struct symbol *sym __maybe_unused, struct map *
 	case SYMBOL_ANNOTATE_ERRNO__ARCH_INIT_CPUID_PARSING:
 		scnprintf(buf, buflen, "Problems while parsing the CPUID in the arch specific initialization.");
 		break;
+	case SYMBOL_ANNOTATE_ERRNO__BPF_INVALID_FILE:
+		scnprintf(buf, buflen, "Invalid BPF file: %s.", dso->long_name);
+		break;
+	case SYMBOL_ANNOTATE_ERRNO__BPF_MISSING_BTF:
+		scnprintf(buf, buflen, "The %s BPF file has no BTF section, compile with -g or use pahole -J.",
+			  dso->long_name);
+		break;
 	default:
 		scnprintf(buf, buflen, "Internal error: Invalid %d error code\n", errnum);
 		break;
@@ -1713,13 +1720,13 @@ static int symbol__disassemble_bpf(struct symbol *sym,
 	char tpath[PATH_MAX];
 	size_t buf_size;
 	int nr_skip = 0;
-	int ret = -1;
 	char *buf;
 	bfd *bfdf;
+	int ret;
 	FILE *s;
 
 	if (dso->binary_type != DSO_BINARY_TYPE__BPF_PROG_INFO)
-		return -1;
+		return SYMBOL_ANNOTATE_ERRNO__BPF_INVALID_FILE;
 
 	pr_debug("%s: handling sym %s addr %" PRIx64 " len %" PRIx64 "\n", __func__,
 		  sym->name, sym->start, sym->end - sym->start);
@@ -1732,8 +1739,10 @@ static int symbol__disassemble_bpf(struct symbol *sym,
 	assert(bfd_check_format(bfdf, bfd_object));
 
 	s = open_memstream(&buf, &buf_size);
-	if (!s)
+	if (!s) {
+		ret = errno;
 		goto out;
+	}
 	init_disassemble_info(&info, s,
 			      (fprintf_ftype) fprintf);
 
@@ -1742,8 +1751,10 @@ static int symbol__disassemble_bpf(struct symbol *sym,
 
 	info_node = perf_env__find_bpf_prog_info(dso->bpf_prog.env,
 						 dso->bpf_prog.id);
-	if (!info_node)
+	if (!info_node) {
+		return SYMBOL_ANNOTATE_ERRNO__BPF_MISSING_BTF;
 		goto out;
+	}
 	info_linear = info_node->info_linear;
 	sub_id = dso->bpf_prog.sub_id;
 
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index a1191995fe77e..2004e2cf0211b 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -372,6 +372,8 @@ enum symbol_disassemble_errno {
 	SYMBOL_ANNOTATE_ERRNO__NO_LIBOPCODES_FOR_BPF,
 	SYMBOL_ANNOTATE_ERRNO__ARCH_INIT_CPUID_PARSING,
 	SYMBOL_ANNOTATE_ERRNO__ARCH_INIT_REGEXP,
+	SYMBOL_ANNOTATE_ERRNO__BPF_INVALID_FILE,
+	SYMBOL_ANNOTATE_ERRNO__BPF_MISSING_BTF,
 
 	__SYMBOL_ANNOTATE_ERRNO__END,
 };
-- 
2.20.1

