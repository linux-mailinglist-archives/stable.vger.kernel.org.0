Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 831C127C53B
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729051AbgI2LdO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:33:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:45276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729278AbgI2Lbh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:31:37 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE01E23B19;
        Tue, 29 Sep 2020 11:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378712;
        bh=1b4JsZ4VH04Yz7PW3Dfj7RJdRXwpxJuAyxmg9mrOlys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kP5NPOrcmtWHt4aCW00qMbAC0K9f5yUV8Apo3cH4hznzwieEB4Rk9fAvyyUpebvOf
         yA9uxh4hAtakKWf1IjynvljXNmNFUWoBvCQXzOBkd3Fe/h+yap3GMyWWPN3DlcV5YM
         sy/aN2WsBBrrny64bpxwP3vgls0vZ87QrDrk11Kc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Richter <tmricht@linux.ibm.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 082/245] perf test: Fix test trace+probe_vfs_getname.sh on s390
Date:   Tue, 29 Sep 2020 12:58:53 +0200
Message-Id: <20200929105950.984356570@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit 2bbc83537614517730e9f2811195004b712de207 ]

This test places a kprobe to function getname_flags() in the kernel
which has the following prototype:

  struct filename *getname_flags(const char __user *filename, int flags, int *empty)

The 'filename' argument points to a filename located in user space memory.

Looking at commit 88903c464321c ("tracing/probe: Add ustring type for
user-space string") the kprobe should indicate that user space memory is
accessed.

Output before:

   [root@m35lp76 perf]# ./perf test 66 67
   66: Use vfs_getname probe to get syscall args filenames   : FAILED!
   67: Check open filename arg using perf trace + vfs_getname: FAILED!
   [root@m35lp76 perf]#

Output after:

   [root@m35lp76 perf]# ./perf test 66 67
   66: Use vfs_getname probe to get syscall args filenames   : Ok
   67: Check open filename arg using perf trace + vfs_getname: Ok
   [root@m35lp76 perf]#

Comments from Masami Hiramatsu:

This bug doesn't happen on x86 or other archs on which user address
space and kernel address space is the same. On some arches (ppc64 in
this case?) user address space is partially or completely the same as
kernel address space.

(Yes, they switch the world when running into the kernel) In this case,
we need to use different data access functions for each space.

That is why I introduced the "ustring" type for kprobe events.

As far as I can see, Thomas's patch is sane. Thomas, could you show us
your result on your test environment?

Comments from Thomas Richter:

Test results for s/390 included above.

Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Sumanth Korikkar <sumanthk@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Link: http://lore.kernel.org/lkml/20200217102111.61137-1-tmricht@linux.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/lib/probe_vfs_getname.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/tests/shell/lib/probe_vfs_getname.sh b/tools/perf/tests/shell/lib/probe_vfs_getname.sh
index 7cb99b433888b..c2cc42daf9242 100644
--- a/tools/perf/tests/shell/lib/probe_vfs_getname.sh
+++ b/tools/perf/tests/shell/lib/probe_vfs_getname.sh
@@ -14,7 +14,7 @@ add_probe_vfs_getname() {
 	if [ $had_vfs_getname -eq 1 ] ; then
 		line=$(perf probe -L getname_flags 2>&1 | egrep 'result.*=.*filename;' | sed -r 's/[[:space:]]+([[:digit:]]+)[[:space:]]+result->uptr.*/\1/')
 		perf probe -q       "vfs_getname=getname_flags:${line} pathname=result->name:string" || \
-		perf probe $verbose "vfs_getname=getname_flags:${line} pathname=filename:string"
+		perf probe $verbose "vfs_getname=getname_flags:${line} pathname=filename:ustring"
 	fi
 }
 
-- 
2.25.1



