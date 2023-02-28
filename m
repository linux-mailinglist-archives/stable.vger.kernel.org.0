Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 466906A5057
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 02:01:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbjB1BA7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 20:00:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbjB1BA6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 20:00:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E9922943F;
        Mon, 27 Feb 2023 17:00:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE9DF60F05;
        Tue, 28 Feb 2023 01:00:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52960C4339C;
        Tue, 28 Feb 2023 01:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677546054;
        bh=hk6Isp83fVhMZHhaEpepdIuZyFnv0MOxbnz2+DM1gCg=;
        h=Date:To:From:Subject:From;
        b=b0W0JzGoDRtmVrAmHzBy6WXoTxHzjWKu3RYp0BP6cSS2W2Au4Q63jB58YdQqR1OC6
         RCemlaj9IHDwBlnzz0kT9nETlGiqCpJ+84Cslf/wG0m77KosSS5PQa+kCW50MyMd/6
         zq5QnDYbJjn84LHegnt18OFz30bXc8ldtjrB7FGs=
Date:   Mon, 27 Feb 2023 17:00:53 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        piaojun@huawei.com, mark@fasheh.com, junxiao.bi@oracle.com,
        joseph.qi@linux.alibaba.com, jlbec@evilplan.org,
        heming.zhao@suse.com, ghe@suse.com, gechangwei@live.cn,
        ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] ocfs2-fix-defrag-path-triggering-jbd2-assert.patch removed from -mm tree
Message-Id: <20230228010054.52960C4339C@smtp.kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: ocfs2: fix defrag path triggering jbd2 ASSERT
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-defrag-path-triggering-jbd2-assert.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Heming Zhao via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Subject: ocfs2: fix defrag path triggering jbd2 ASSERT
Date: Fri, 17 Feb 2023 08:37:17 +0800

code path:

ocfs2_ioctl_move_extents
 ocfs2_move_extents
  ocfs2_defrag_extent
   __ocfs2_move_extent
    + ocfs2_journal_access_di
    + ocfs2_split_extent  //sub-paths call jbd2_journal_restart
    + ocfs2_journal_dirty //crash by jbs2 ASSERT

crash stacks:

PID: 11297  TASK: ffff974a676dcd00  CPU: 67  COMMAND: "defragfs.ocfs2"
 #0 [ffffb25d8dad3900] machine_kexec at ffffffff8386fe01
 #1 [ffffb25d8dad3958] __crash_kexec at ffffffff8395959d
 #2 [ffffb25d8dad3a20] crash_kexec at ffffffff8395a45d
 #3 [ffffb25d8dad3a38] oops_end at ffffffff83836d3f
 #4 [ffffb25d8dad3a58] do_trap at ffffffff83833205
 #5 [ffffb25d8dad3aa0] do_invalid_op at ffffffff83833aa6
 #6 [ffffb25d8dad3ac0] invalid_op at ffffffff84200d18
    [exception RIP: jbd2_journal_dirty_metadata+0x2ba]
    RIP: ffffffffc09ca54a  RSP: ffffb25d8dad3b70  RFLAGS: 00010207
    RAX: 0000000000000000  RBX: ffff9706eedc5248  RCX: 0000000000000000
    RDX: 0000000000000001  RSI: ffff97337029ea28  RDI: ffff9706eedc5250
    RBP: ffff9703c3520200   R8: 000000000f46b0b2   R9: 0000000000000000
    R10: 0000000000000001  R11: 00000001000000fe  R12: ffff97337029ea28
    R13: 0000000000000000  R14: ffff9703de59bf60  R15: ffff9706eedc5250
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 #7 [ffffb25d8dad3ba8] ocfs2_journal_dirty at ffffffffc137fb95 [ocfs2]
 #8 [ffffb25d8dad3be8] __ocfs2_move_extent at ffffffffc139a950 [ocfs2]
 #9 [ffffb25d8dad3c80] ocfs2_defrag_extent at ffffffffc139b2d2 [ocfs2]

Analysis

This bug has the same root cause of 'commit 7f27ec978b0e ("ocfs2: call
ocfs2_journal_access_di() before ocfs2_journal_dirty() in
ocfs2_write_end_nolock()")'.  For this bug, jbd2_journal_restart() is
called by ocfs2_split_extent() during defragmenting.

How to fix

For ocfs2_split_extent() can handle journal operations totally by itself. 
Caller doesn't need to call journal access/dirty pair, and caller only
needs to call journal start/stop pair.  The fix method is to remove
journal access/dirty from __ocfs2_move_extent().

The discussion for this patch:
https://oss.oracle.com/pipermail/ocfs2-devel/2023-February/000647.html

Link: https://lkml.kernel.org/r/20230217003717.32469-1-heming.zhao@suse.com
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


--- a/fs/ocfs2/move_extents.c~ocfs2-fix-defrag-path-triggering-jbd2-assert
+++ a/fs/ocfs2/move_extents.c
@@ -105,14 +105,6 @@ static int __ocfs2_move_extent(handle_t
 	 */
 	replace_rec.e_flags = ext_flags & ~OCFS2_EXT_REFCOUNTED;
 
-	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode),
-				      context->et.et_root_bh,
-				      OCFS2_JOURNAL_ACCESS_WRITE);
-	if (ret) {
-		mlog_errno(ret);
-		goto out;
-	}
-
 	ret = ocfs2_split_extent(handle, &context->et, path, index,
 				 &replace_rec, context->meta_ac,
 				 &context->dealloc);
@@ -121,8 +113,6 @@ static int __ocfs2_move_extent(handle_t
 		goto out;
 	}
 
-	ocfs2_journal_dirty(handle, context->et.et_root_bh);
-
 	context->new_phys_cpos = new_p_cpos;
 
 	/*
_

Patches currently in -mm which might be from ocfs2-devel@oss.oracle.com are


