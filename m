Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60BFE4173A9
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344771AbhIXM7X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:59:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:51474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344305AbhIXM5Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:57:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B52D6139D;
        Fri, 24 Sep 2021 12:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487917;
        bh=MPC7zKHtC4smyWWMsDXtutR3S7IBf+X97TiGKjurXxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ap3mqHxrs1/hpfOLFhfCXfhhjk6L41awLUpGMDCl+A5CPkw2qcE8Nas8oUHDQ/aLY
         sDoOjYrCQVMrPD6U1VX3lp+6i2b2s5VOxAr4343nxUHioSDHSX7XWI/UPPZHjvkIch
         KQUzqoMtHmpVXkY0FK4Dx1ARKKG/zanM47uE1Rz4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Remi Bernon <rbernon@codeweavers.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Nicholas Fraser <nfraser@codeweavers.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.14 012/100] perf symbol: Look for ImageBase in PE file to compute .text offset
Date:   Fri, 24 Sep 2021 14:43:21 +0200
Message-Id: <20210924124341.862153366@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Remi Bernon <rbernon@codeweavers.com>

commit d2930ede5218be28413a00130a6895d14393c325 upstream.

Instead of using the file offset in the debug file.

This fixes a regression from 00a3423492bc90be ("perf symbols: Make
dso__load_bfd_symbols() load PE files from debug cache only"), causing
incorrect symbol resolution when debug file have been stripped from
non-debug sections (in which case its .text section is empty and doesn't
have any file position).

The debug files could also be created with a different file alignment,
and have different file positions from the mmap-ed binary, or have the
section reordered.

This instead looks for the file image base, using the corresponding bfd
*ABS* symbols. As PE symbols only have 4 bytes, it also needs to keep
.text section vma high bits.

Signed-off-by: Remi Bernon <rbernon@codeweavers.com>
Fixes: 00a3423492bc90be ("perf symbols: Make dso__load_bfd_symbols() load PE files from debug cache only")
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Nicholas Fraser <nfraser@codeweavers.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/20210909192637.4139125-1-rbernon@codeweavers.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/symbol.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1581,10 +1581,6 @@ int dso__load_bfd_symbols(struct dso *ds
 	if (bfd_get_flavour(abfd) == bfd_target_elf_flavour)
 		goto out_close;
 
-	section = bfd_get_section_by_name(abfd, ".text");
-	if (section)
-		dso->text_offset = section->vma - section->filepos;
-
 	symbols_size = bfd_get_symtab_upper_bound(abfd);
 	if (symbols_size == 0) {
 		bfd_close(abfd);
@@ -1602,6 +1598,22 @@ int dso__load_bfd_symbols(struct dso *ds
 	if (symbols_count < 0)
 		goto out_free;
 
+	section = bfd_get_section_by_name(abfd, ".text");
+	if (section) {
+		for (i = 0; i < symbols_count; ++i) {
+			if (!strcmp(bfd_asymbol_name(symbols[i]), "__ImageBase") ||
+			    !strcmp(bfd_asymbol_name(symbols[i]), "__image_base__"))
+				break;
+		}
+		if (i < symbols_count) {
+			/* PE symbols can only have 4 bytes, so use .text high bits */
+			dso->text_offset = section->vma - (u32)section->vma;
+			dso->text_offset += (u32)bfd_asymbol_value(symbols[i]);
+		} else {
+			dso->text_offset = section->vma - section->filepos;
+		}
+	}
+
 	qsort(symbols, symbols_count, sizeof(asymbol *), bfd_symbols__cmpvalue);
 
 #ifdef bfd_get_section


