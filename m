Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB6C66A119A
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 22:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbjBWVGf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 16:06:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjBWVGc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 16:06:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC7614208;
        Thu, 23 Feb 2023 13:06:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0EACBB81B2E;
        Thu, 23 Feb 2023 21:06:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9768C433D2;
        Thu, 23 Feb 2023 21:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677186388;
        bh=46eNsRC3mfD38LEk7IkS4/LHgA+yCMd0QH7FJUCXC8k=;
        h=Date:To:From:Subject:From;
        b=Vt/3mbg3MrhV7h4DJuCz/b9e/pmMUfrfaqXFmWfedDvNGBqE57UQfdr7vZKy/WT1m
         4fCcosRhbkFB0uvc1J4t4i8a9IDF/GAuQc0PAUZRQ6Th2Nq2FgnfLcGP+3Mt9KLNhJ
         FyVTfh3R/N5QEsd1Cqnp2l6jafrKqP5BeFp7itf0=
Date:   Thu, 23 Feb 2023 13:06:28 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        piaojun@huawei.com, mark@fasheh.com, junxiao.bi@oracle.com,
        joseph.qi@linux.alibaba.com, jlbec@evilplan.org,
        heming.zhao@suse.com, ghe@suse.com, gechangwei@live.cn,
        ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-non-auto-defrag-path-not-working-issue.patch added to mm-hotfixes-unstable branch
Message-Id: <20230223210628.B9768C433D2@smtp.kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: ocfs2: fix non-auto defrag path not working issue
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     ocfs2-fix-non-auto-defrag-path-not-working-issue.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-non-auto-defrag-path-not-working-issue.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Subject: ocfs2: fix non-auto defrag path not working issue
Date: Mon, 20 Feb 2023 13:05:26 +0800

This fixes three issues on move extents ioctl without auto defrag:

a) In ocfs2_find_victim_alloc_group(), we have to convert bits to block
   first in case of global bitmap.

b) In ocfs2_probe_alloc_group(), when finding enough bits in block
   group bitmap, we have to back off move_len to start pos as well,
   otherwise it may corrupt filesystem.

c) In ocfs2_ioctl_move_extents(), set me_threshold both for non-auto
   and auto defrag paths.  Otherwise it will set move_max_hop to 0 and
   finally cause unexpectedly ENOSPC error.

Currently there are no tools triggering the above issues since
defragfs.ocfs2 enables auto defrag by default.  Tested with manually
changing defragfs.ocfs2 to run non auto defrag path.

Link: https://lkml.kernel.org/r/20230220050526.22020-1-heming.zhao@suse.com
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/move_extents.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

--- a/fs/ocfs2/move_extents.c~ocfs2-fix-non-auto-defrag-path-not-working-issue
+++ a/fs/ocfs2/move_extents.c
@@ -434,7 +434,7 @@ static int ocfs2_find_victim_alloc_group
 			bg = (struct ocfs2_group_desc *)gd_bh->b_data;
 
 			if (vict_blkno < (le64_to_cpu(bg->bg_blkno) +
-						le16_to_cpu(bg->bg_bits))) {
+						(le16_to_cpu(bg->bg_bits) << bits_per_unit))) {
 
 				*ret_bh = gd_bh;
 				*vict_bit = (vict_blkno - blkno) >>
@@ -549,6 +549,7 @@ static void ocfs2_probe_alloc_group(stru
 			last_free_bits++;
 
 		if (last_free_bits == move_len) {
+			i -= move_len;
 			*goal_bit = i;
 			*phys_cpos = base_cpos + i;
 			break;
@@ -1020,18 +1021,19 @@ int ocfs2_ioctl_move_extents(struct file
 
 	context->range = &range;
 
+	/*
+	 * ok, the default theshold for the defragmentation
+	 * is 1M, since our maximum clustersize was 1M also.
+	 * any thought?
+	 */
+	if (!range.me_threshold)
+		range.me_threshold = 1024 * 1024;
+
+	if (range.me_threshold > i_size_read(inode))
+		range.me_threshold = i_size_read(inode);
+
 	if (range.me_flags & OCFS2_MOVE_EXT_FL_AUTO_DEFRAG) {
 		context->auto_defrag = 1;
-		/*
-		 * ok, the default theshold for the defragmentation
-		 * is 1M, since our maximum clustersize was 1M also.
-		 * any thought?
-		 */
-		if (!range.me_threshold)
-			range.me_threshold = 1024 * 1024;
-
-		if (range.me_threshold > i_size_read(inode))
-			range.me_threshold = i_size_read(inode);
 
 		if (range.me_flags & OCFS2_MOVE_EXT_FL_PART_DEFRAG)
 			context->partial = 1;
_

Patches currently in -mm which might be from ocfs2-devel@oss.oracle.com are

ocfs2-fix-defrag-path-triggering-jbd2-assert.patch
ocfs2-fix-non-auto-defrag-path-not-working-issue.patch

