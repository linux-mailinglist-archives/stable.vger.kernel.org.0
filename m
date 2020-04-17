Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30E641AD508
	for <lists+stable@lfdr.de>; Fri, 17 Apr 2020 06:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbgDQECF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Apr 2020 00:02:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:53998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725900AbgDQECE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Apr 2020 00:02:04 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7CE921D93;
        Fri, 17 Apr 2020 04:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587096123;
        bh=IDjNZorfcaxDPWV7IPT8G5mCfcCOgx2lHjIxDC5lRgk=;
        h=Date:From:To:Subject:From;
        b=K8/2TZFhggMqEUw83Mu41VNAYq+OXeTqMRoZ6HxlNh2/7U/vu/QXnpHEY7+IinJPg
         dNGfgU1XAtbh1w4BLNLdbl+dUE3ZllwwTXk5QBKY71BnhJej7wZplciyFBSo5KZ/tR
         IJXfEaurrCPjD/JOM/iM5jRdl3wXbWSpQy8h4egI=
Date:   Thu, 16 Apr 2020 21:02:02 -0700
From:   akpm@linux-foundation.org
To:     matthew.ruffell@canonical.com, mm-commits@vger.kernel.org,
        nhorman@tuxdriver.com, pabs3@bonedaddy.net, stable@vger.kernel.org,
        sudipm.mukherjee@gmail.com, viro@zeniv.linux.org.uk
Subject:  + coredump-fix-null-pointer-dereference-on-coredump.patch
 added to -mm tree
Message-ID: <20200417040202.O_VbU09Pt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: coredump: fix null pointer dereference on coredump
has been added to the -mm tree.  Its filename is
     coredump-fix-null-pointer-dereference-on-coredump.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/coredump-fix-null-pointer-dereference-on-coredump.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/coredump-fix-null-pointer-dereference-on-coredump.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: coredump: fix null pointer dereference on coredump

If the core_pattern is set to "|" and any process segfaults then we get
a null pointer derefernce while trying to coredump. The call stack shows:
[  108.212680] RIP: 0010:do_coredump+0x628/0x11c0

When the core_pattern has only "|" there is no use of trying the coredump
and we can check that while formating the corename and exit with an error.

After this change I get:
[   48.453756] format_corename failed
[   48.453758] Aborting core

Link: http://lkml.kernel.org/r/20200416194612.21418-1-sudipm.mukherjee@gmail.com
Fixes: 315c69261dd3 ("coredump: split pipe command whitespace before expanding template")
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Reported-by: Matthew Ruffell <matthew.ruffell@canonical.com>
Cc: Paul Wise <pabs3@bonedaddy.net>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coredump.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/coredump.c~coredump-fix-null-pointer-dereference-on-coredump
+++ a/fs/coredump.c
@@ -211,6 +211,8 @@ static int format_corename(struct core_n
 			return -ENOMEM;
 		(*argv)[(*argc)++] = 0;
 		++pat_ptr;
+		if (!(*pat_ptr))
+			return -ENOMEM;
 	}
 
 	/* Repeat as long as we have more pattern to process and more output
_

Patches currently in -mm which might be from sudipm.mukherjee@gmail.com are

coredump-fix-null-pointer-dereference-on-coredump.patch

