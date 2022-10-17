Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACF5660053B
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 04:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbiJQC3i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 22:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbiJQC3g (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 22:29:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 782AEB84F;
        Sun, 16 Oct 2022 19:29:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B666B80E4B;
        Mon, 17 Oct 2022 02:29:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDB60C433D7;
        Mon, 17 Oct 2022 02:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665973771;
        bh=EcRoEsGOGyiX0I1YJb7hdpGUEomdSIXsX2KFN2pd9EQ=;
        h=Date:To:From:Subject:From;
        b=pdN7Qu3HW1ANYewfA3H3BHNIye5QTnIxRNtCTbG2Tvg5oEOj5UOb0sRIkDVpYgClV
         uyzhF7WBgHU9BiX5ERHfX9MsJAkTqVINvytrySnJH3VkAKFT6lR0HYD5Ak6KCik8J5
         PJKQ2e1TPyaaLgPiXHuRcV7zHt8t2KsywCvpgyf0=
Date:   Sun, 16 Oct 2022 19:29:31 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        piaojun@huawei.com, mark@fasheh.com, junxiao.bi@oracle.com,
        jlbec@evilplan.org, jiangqi903@gmail.com, ghe@suse.com,
        gechangwei@live.cn, wangyan122@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] ocfs2-fix-ocfs2-corrupt-when-iputting-an-inode.patch removed from -mm tree
Message-Id: <20221017022931.BDB60C433D7@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: ocfs2: fix ocfs2 corrupt when iputting an inode
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-ocfs2-corrupt-when-iputting-an-inode.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Wangyan <wangyan122@huawei.com>
Subject: ocfs2: fix ocfs2 corrupt when iputting an inode

In this condition, it will cause an bug on error.
ocfs2_mkdir()
  ->ocfs2_mknod()
    ->ocfs2_mknod_locked()
      ->__ocfs2_mknod_locked()
        //Assume inode->i_generation is genN.
        ->inode->i_generation = osb->s_next_generation++;
        // The inode lockres has been initialized.
        ->ocfs2_populate_inode()
        ->ocfs2_create_new_inode_locks()
            ->An error happened, returned value is non-zero
      // free the start_bit x in bg_blkno
      ->ocfs2_free_suballoc_bits()
    ->...  /* Another process execute mkdir success in this place,
              and it occupied the start_bit x in bg_blkno
              which has been freed before. Its inode->i_generation
              is genN + 1 */
    ->iput(inode)
      ->evict()
        ->ocfs2_evict_inode()
          ->ocfs2_delete_inode()
            ->ocfs2_inode_lock()
              ->ocfs2_inode_lock_update()
                /* Bug on here, genN != genN + 1 */
                ->mlog_bug_on_msg(inode->i_generation !=
                  le32_to_cpu(fe->i_generation))

So, we need not to reclaim the inode when the inode->ip_inode_lockres
has been initialized. It will be freed in iput().

Link: http://lkml.kernel.org/r/ef080ca3-5d74-e276-17a1-d9e7c7e662c9@huawei.com
Fixes: b1529a41f777 ("ocfs2: should reclaim the inode if '__ocfs2_mknod_locked' returns an error")
Signed-off-by: Yan Wang <wangyan122@huawei.com>
Reviewed-by: Jun Piao <piaojun@huawei.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/namei.c~ocfs2-fix-ocfs2-corrupt-when-iputting-an-inode
+++ a/fs/ocfs2/namei.c
@@ -641,7 +641,8 @@ static int ocfs2_mknod_locked(struct ocf
 	status = __ocfs2_mknod_locked(dir, inode, dev, new_fe_bh,
 				    parent_fe_bh, handle, inode_ac,
 				    fe_blkno, suballoc_loc, suballoc_bit);
-	if (status < 0) {
+	if (status < 0 && !(OCFS2_I(inode)->ip_inode_lockres.l_flags &
+				OCFS2_LOCK_INITIALIZED)) {
 		u64 bg_blkno = ocfs2_which_suballoc_group(fe_blkno, suballoc_bit);
 		int tmp = ocfs2_free_suballoc_bits(handle, inode_ac->ac_inode,
 				inode_ac->ac_bh, suballoc_bit, bg_blkno, 1);
_

Patches currently in -mm which might be from wangyan122@huawei.com are


