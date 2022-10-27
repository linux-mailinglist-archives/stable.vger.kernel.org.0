Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF1960FE6E
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236927AbiJ0RFO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236929AbiJ0RFM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:05:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8B717B1F6
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:05:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 75867623D8
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:05:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60369C433D6;
        Thu, 27 Oct 2022 17:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890303;
        bh=r+KS8rqtmSjB5OajPQGy7sYcPK6l46rCGGmiNG3tgRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JskOx9BoXqXMcXgBaSG02tK1PDDj7uQcQRR4npEOVXbPCAEV4O+o8XfuDfS/rJQCi
         emN+1f+dxZQyLpDyL77mf+NJ8UZX0aviT3fmYRX0KJKykpy7uwKD8OLD3vcnTpGri9
         Dtl6nfoGzcmDPlDcXoQ+QOCJ1Gxh1GRO5RzZxVFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Joseph Qi <joseph.qi@linux.alibaba.com>,
        Yan Wang <wangyan122@huawei.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        Changwei Ge <gechangwei@live.cn>, Gang He <ghe@suse.com>,
        Jun Piao <piaojun@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 02/79] ocfs2: fix BUG when iput after ocfs2_mknod fails
Date:   Thu, 27 Oct 2022 18:55:12 +0200
Message-Id: <20221027165054.372565541@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.270676357@linuxfoundation.org>
References: <20221027165054.270676357@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joseph Qi <joseph.qi@linux.alibaba.com>

commit 759a7c6126eef5635506453e9b9d55a6a3ac2084 upstream.

Commit b1529a41f777 "ocfs2: should reclaim the inode if
'__ocfs2_mknod_locked' returns an error" tried to reclaim the claimed
inode if __ocfs2_mknod_locked() fails later.  But this introduce a race,
the freed bit may be reused immediately by another thread, which will
update dinode, e.g.  i_generation.  Then iput this inode will lead to BUG:
inode->i_generation != le32_to_cpu(fe->i_generation)

We could make this inode as bad, but we did want to do operations like
wipe in some cases.  Since the claimed inode bit can only affect that an
dinode is missing and will return back after fsck, it seems not a big
problem.  So just leave it as is by revert the reclaim logic.

Link: https://lkml.kernel.org/r/20221017130227.234480-1-joseph.qi@linux.alibaba.com
Fixes: b1529a41f777 ("ocfs2: should reclaim the inode if '__ocfs2_mknod_locked' returns an error")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reported-by: Yan Wang <wangyan122@huawei.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/namei.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -636,18 +636,9 @@ static int ocfs2_mknod_locked(struct ocf
 		return status;
 	}
 
-	status = __ocfs2_mknod_locked(dir, inode, dev, new_fe_bh,
+	return __ocfs2_mknod_locked(dir, inode, dev, new_fe_bh,
 				    parent_fe_bh, handle, inode_ac,
 				    fe_blkno, suballoc_loc, suballoc_bit);
-	if (status < 0) {
-		u64 bg_blkno = ocfs2_which_suballoc_group(fe_blkno, suballoc_bit);
-		int tmp = ocfs2_free_suballoc_bits(handle, inode_ac->ac_inode,
-				inode_ac->ac_bh, suballoc_bit, bg_blkno, 1);
-		if (tmp)
-			mlog_errno(tmp);
-	}
-
-	return status;
 }
 
 static int ocfs2_mkdir(struct inode *dir,


