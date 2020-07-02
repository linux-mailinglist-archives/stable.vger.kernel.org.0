Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF059212390
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 14:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728976AbgGBMmO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jul 2020 08:42:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:48144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728893AbgGBMmN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jul 2020 08:42:13 -0400
Received: from localhost.localdomain (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4BE320885;
        Thu,  2 Jul 2020 12:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593693733;
        bh=oEPMOrl5gOT0FsyHfygw3so6SkLEhFqkRhcwfdwKeS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T8budiXrfE64fmTlkd0n1pK72DE25MhbTVhU8IcjuF0MeEsdjAQMs+Vx0Omn8bRI/
         mdc5O19wizGihmQF4mj+TmF1O56jMRdT+wqmTFBdateoqtVU5uP/NKhb5dA/3BnpP7
         HKNeNw/ib/FbQukguUV/yUCeLxYHhjgWB+yIUEjY=
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     stable@vger.kernel.org
Cc:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Changbin Du <changbin.du@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        mhiramat@kernel.org
Subject: [PATCH for 4.4.y 4/5] perf: Make perf able to build with latest libbfd
Date:   Thu,  2 Jul 2020 21:42:09 +0900
Message-Id: <159369372956.82195.13259704917220595682.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <159369369207.82195.5763005209795799082.stgit@devnote2>
References: <159369369207.82195.5763005209795799082.stgit@devnote2>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Changbin Du <changbin.du@gmail.com>

commit 0ada120c883d4f1f6aafd01cf0fbb10d8bbba015 upstream.

libbfd has changed the bfd_section_* macros to inline functions
bfd_section_<field> since 2019-09-18. See below two commits:
  o http://www.sourceware.org/ml/gdb-cvs/2019-09/msg00064.html
  o https://www.sourceware.org/ml/gdb-cvs/2019-09/msg00072.html

This fix make perf able to build with both old and new libbfd.

Signed-off-by: Changbin Du <changbin.du@gmail.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/20200128152938.31413-1-changbin.du@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/srcline.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/srcline.c b/tools/perf/util/srcline.c
index b4db3f48e3b0..2853d4728ab9 100644
--- a/tools/perf/util/srcline.c
+++ b/tools/perf/util/srcline.c
@@ -86,16 +86,30 @@ static void find_address_in_section(bfd *abfd, asection *section, void *data)
 	bfd_vma pc, vma;
 	bfd_size_type size;
 	struct a2l_data *a2l = data;
+	flagword flags;
 
 	if (a2l->found)
 		return;
 
-	if ((bfd_get_section_flags(abfd, section) & SEC_ALLOC) == 0)
+#ifdef bfd_get_section_flags
+	flags = bfd_get_section_flags(abfd, section);
+#else
+	flags = bfd_section_flags(section);
+#endif
+	if ((flags & SEC_ALLOC) == 0)
 		return;
 
 	pc = a2l->addr;
+#ifdef bfd_get_section_vma
 	vma = bfd_get_section_vma(abfd, section);
+#else
+	vma = bfd_section_vma(section);
+#endif
+#ifdef bfd_get_section_size
 	size = bfd_get_section_size(section);
+#else
+	size = bfd_section_size(section);
+#endif
 
 	if (pc < vma || pc >= vma + size)
 		return;

