Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA95749AA05
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1323975AbiAYDaE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:30:04 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49694 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S3415666AbiAYBu5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 20:50:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38B976091F;
        Tue, 25 Jan 2022 01:50:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EF74C340E4;
        Tue, 25 Jan 2022 01:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643075456;
        bh=cYRC1nhlXVznSM1StHYWfr9h5NXZqhF5DjHD121++WY=;
        h=Date:From:To:Subject:From;
        b=fKkr1wPq9lIbmNJ8vA0Z4J6tvCM7UFgb+z43aZ29HshSzt/F43M08OyaEaMYupCby
         rQYMOU6X2UflqlJOcSY99nv/ANduG6LdfPX73lP89MKGe6z7/DGSdoJ1ukq1gk3T/E
         W+Xr9uPq/7/BmhvGeiVabqXRYUG95iPskstNCRHc=
Date:   Mon, 24 Jan 2022 17:50:55 -0800
From:   akpm@linux-foundation.org
To:     adilger.kernel@dilger.ca, gautham.ananthakrishna@oracle.com,
        gechangwei@live.cn, ghe@suse.com, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com,
        mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com,
        saeed.mirzamohammadi@oracle.com, stable@vger.kernel.org,
        tytso@mit.edu
Subject:  + jbd2-export-jbd2_journal__journal_head.patch added to
 -mm tree
Message-ID: <20220125015055.rxmzD6EYV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: jbd2: export jbd2_journal_[grab|put]_journal_head
has been added to the -mm tree.  Its filename is
     jbd2-export-jbd2_journal__journal_head.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/jbd2-export-jbd2_journal__journal_head.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/jbd2-export-jbd2_journal__journal_head.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: jbd2: export jbd2_journal_[grab|put]_journal_head

Patch series "ocfs2: fix a deadlock case".

This fixes a deadlock case in ocfs2.  We firstly export jbd2 symbols
jbd2_journal_[grab|put]_journal_head as preparation and later use them in
ocfs2 insread of jbd_[lock|unlock]_bh_journal_head to fix the deadlock.


This patch (of 2):

This exports symbols jbd2_journal_[grab|put]_journal_head, which will be
used outside modules, e.g. ocfs2.

Link: https://lkml.kernel.org/r/20220121071205.100648-2-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Gautham Ananthakrishna <gautham.ananthakrishna@oracle.com>
Cc: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd2/journal.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/jbd2/journal.c~jbd2-export-jbd2_journal__journal_head
+++ a/fs/jbd2/journal.c
@@ -2972,6 +2972,7 @@ struct journal_head *jbd2_journal_grab_j
 	jbd_unlock_bh_journal_head(bh);
 	return jh;
 }
+EXPORT_SYMBOL(jbd2_journal_grab_journal_head);
 
 static void __journal_remove_journal_head(struct buffer_head *bh)
 {
@@ -3024,6 +3025,7 @@ void jbd2_journal_put_journal_head(struc
 		jbd_unlock_bh_journal_head(bh);
 	}
 }
+EXPORT_SYMBOL(jbd2_journal_put_journal_head);
 
 /*
  * Initialize jbd inode head
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are

jbd2-export-jbd2_journal__journal_head.patch
ocfs2-fix-a-deadlock-when-commit-trans.patch

