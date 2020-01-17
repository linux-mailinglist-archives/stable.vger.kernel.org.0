Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23C5B140234
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 04:06:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389217AbgAQDFp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 22:05:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:42808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388298AbgAQDFp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 22:05:45 -0500
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99A09206D7;
        Fri, 17 Jan 2020 03:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579230344;
        bh=YLHeXOAI167QYsQ85lU10nNKpLrqY7T51zHlepFSn7Q=;
        h=Date:From:To:Subject:From;
        b=yqlVpaX3pa2IpgMsq+scoUQ6AIBnDg5LQhYqJrbkc1nT9yjyiBURc0fw8kn7FJnwH
         EjYPNxvVLNkE50fsRuRGOA0SBdtQJ2203XZvW4vv3/M+LO54aejpNegruGaCCc9Czh
         fCSQACASU7qDyrj0+PDbhfEXBkSO+BRkcBvdoNRw=
Date:   Thu, 16 Jan 2020 19:05:44 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, stable@vger.kernel.org,
        mhocko@kernel.org, lee.schermerhorn@hp.com, hughd@google.com,
        aarcange@redhat.com, dan.carpenter@oracle.com
Subject:  +
 mm-mempolicyc-fix-out-of-bounds-write-in-mpol_parse_str.patch added to -mm
 tree
Message-ID: <20200117030544.atCbT%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/mempolicy.c: fix out of bounds write in mpol_parse_str()
has been added to the -mm tree.  Its filename is
     mm-mempolicyc-fix-out-of-bounds-write-in-mpol_parse_str.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicyc-fix-out-of-bounds-write-in-mpol_parse_str.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicyc-fix-out-of-bounds-write-in-mpol_parse_str.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: mm/mempolicy.c: fix out of bounds write in mpol_parse_str()

What we are trying to do is change the '=' character to a NUL terminator
and then at the end of the function we restore it back to an '='.  The
problem is there are two error paths where we jump to the end of the
function before we have replaced the '=' with NUL.  We end up putting the
'=' in the wrong place (possibly one element before the start of the
buffer).

Link: http://lkml.kernel.org/r/20200115055426.vdjwvry44nfug7yy@kili.mountain
Reported-by: syzbot+e64a13c5369a194d67df@syzkaller.appspotmail.com
Fixes: 095f1fc4ebf3 ("mempolicy: rework shmem mpol parsing and display")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Dmitry Vyukov <dvyukov@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicyc-fix-out-of-bounds-write-in-mpol_parse_str
+++ a/mm/mempolicy.c
@@ -2821,6 +2821,9 @@ int mpol_parse_str(char *str, struct mem
 	char *flags = strchr(str, '=');
 	int err = 1, mode;
 
+	if (flags)
+		*flags++ = '\0';	/* terminate mode string */
+
 	if (nodelist) {
 		/* NUL-terminate mode or flags string */
 		*nodelist++ = '\0';
@@ -2831,9 +2834,6 @@ int mpol_parse_str(char *str, struct mem
 	} else
 		nodes_clear(nodes);
 
-	if (flags)
-		*flags++ = '\0';	/* terminate mode string */
-
 	mode = match_string(policy_modes, MPOL_MAX, str);
 	if (mode < 0)
 		goto out;
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

mm-mempolicyc-fix-out-of-bounds-write-in-mpol_parse_str.patch
zswap-potential-null-dereference-on-error-in-init_zswap.patch

