Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1E0214E89D
	for <lists+stable@lfdr.de>; Fri, 31 Jan 2020 07:11:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728076AbgAaGLJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jan 2020 01:11:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:57924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbgAaGLI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 31 Jan 2020 01:11:08 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 098DD21734;
        Fri, 31 Jan 2020 06:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580451068;
        bh=vpsxjURaJ+1tZ+ToK+fDX7WaU2fULE0P/OkFaMA6/Nk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=x0XEz+KGL42PVjPAASfmn1uoCzF3aX+X0XwYw4621SX/LqZ/TzjEkNtzAEtgtZ6UR
         XW7OHC2/Se2VQEr1tsYSAP//p7G6rO0EDLlsjc26aqDNuFFDJeH8XLxphfVR0CG00s
         bijqsGHZrakyI0fXWqSLjhOU0/y0GOFjHq052gl0=
Date:   Thu, 30 Jan 2020 22:11:07 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, akpm@linux-foundation.org,
        dan.carpenter@oracle.com, hughd@google.com,
        lee.schermerhorn@hp.com, linux-mm@kvack.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 003/118] mm/mempolicy.c: fix out of bounds write
 in mpol_parse_str()
Message-ID: <20200131061107.US9oQYBpA%akpm@linux-foundation.org>
In-Reply-To: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
