Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBB88344431
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 14:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbhCVM7C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:59:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:47786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232421AbhCVMyz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:54:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01DF5619A4;
        Mon, 22 Mar 2021 12:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616417284;
        bh=AIEqNF8jdUfsBYHH4OZq6TpfslM/sTMG34G5Gyz9jGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RoOdY9MQvSArVnb6WWIjpcaWPCZnsYWYrNr55cBRe6KRRKlOiypLzQQ9U6ikb2BX0
         C74gAEJZUCkCB9OEZjctrubJ+Wg+BUroXmbrDUrYIYG1ZiUQVlFCeAntKRddp0q1uq
         aKCAU6Y7w6TtKMnfiQPrw4yp3PGx1VCE+EIyXGpc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Changbin Du <changbin.du@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.14 14/43] perf: Make perf able to build with latest libbfd
Date:   Mon, 22 Mar 2021 13:28:55 +0100
Message-Id: <20210322121920.507343398@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121920.053255560@linuxfoundation.org>
References: <20210322121920.053255560@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/srcline.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/tools/perf/util/srcline.c
+++ b/tools/perf/util/srcline.c
@@ -139,16 +139,30 @@ static void find_address_in_section(bfd
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


