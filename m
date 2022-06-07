Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54E4B5407F5
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348719AbiFGRxR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349659AbiFGRv0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:51:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EB5013C08E;
        Tue,  7 Jun 2022 10:38:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2311AB80B66;
        Tue,  7 Jun 2022 17:38:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8811EC385A5;
        Tue,  7 Jun 2022 17:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623488;
        bh=hDCiPEacoCm4kd0iu071/ZJvY3zZhf4KDgFQjIIqAsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=td4OQds9+6+pz6g0lVhnCY3xBMtIlUafSxb78bnKVzhLmA17fv/8OLFOZytO95fHc
         Ar7ZIX/PR2Tkfk3Bd4mn15JJ0jyFnLtgjeeJjZ1jR1d9/v+qkUXjJXJzqUUJoP7oQP
         JcTNG2bhU5yG8GBZSCzfD/d+78cMxqW1CYQv4p/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>,
        Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5.10 437/452] xfs: assert in xfs_btree_del_cursor should take into account error
Date:   Tue,  7 Jun 2022 19:04:54 +0200
Message-Id: <20220607164921.582897883@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

commit 56486f307100e8fc66efa2ebd8a71941fa10bf6f upstream.

xfs/538 on a 1kB block filesystem failed with this assert:

XFS: Assertion failed: cur->bc_btnum != XFS_BTNUM_BMAP || cur->bc_ino.allocated == 0 || xfs_is_shutdown(cur->bc_mp), file: fs/xfs/libxfs/xfs_btree.c, line: 448

The problem was that an allocation failed unexpectedly in
xfs_bmbt_alloc_block() after roughly 150,000 minlen allocation error
injections, resulting in an EFSCORRUPTED error being returned to
xfs_bmapi_write(). The error occurred on extent-to-btree format
conversion allocating the new root block:

 RIP: 0010:xfs_bmbt_alloc_block+0x177/0x210
 Call Trace:
  <TASK>
  xfs_btree_new_iroot+0xdf/0x520
  xfs_btree_make_block_unfull+0x10d/0x1c0
  xfs_btree_insrec+0x364/0x790
  xfs_btree_insert+0xaa/0x210
  xfs_bmap_add_extent_hole_real+0x1fe/0x9a0
  xfs_bmapi_allocate+0x34c/0x420
  xfs_bmapi_write+0x53c/0x9c0
  xfs_alloc_file_space+0xee/0x320
  xfs_file_fallocate+0x36b/0x450
  vfs_fallocate+0x148/0x340
  __x64_sys_fallocate+0x3c/0x70
  do_syscall_64+0x35/0x80
  entry_SYSCALL_64_after_hwframe+0x44/0xa

Why the allocation failed at this point is unknown, but is likely
that we ran the transaction out of reserved space and filesystem out
of space with bmbt blocks because of all the minlen allocations
being done causing worst case fragmentation of a large allocation.

Regardless of the cause, we've then called xfs_bmapi_finish() which
calls xfs_btree_del_cursor(cur, error) to tear down the cursor.

So we have a failed operation, error != 0, cur->bc_ino.allocated > 0
and the filesystem is still up. The assert fails to take into
account that allocation can fail with an error and the transaction
teardown will shut the filesystem down if necessary. i.e. the
assert needs to check "|| error != 0" as well, because at this point
shutdown is pending because the current transaction is dirty....

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_btree.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -372,8 +372,14 @@ xfs_btree_del_cursor(
 			break;
 	}
 
+	/*
+	 * If we are doing a BMBT update, the number of unaccounted blocks
+	 * allocated during this cursor life time should be zero. If it's not
+	 * zero, then we should be shut down or on our way to shutdown due to
+	 * cancelling a dirty transaction on error.
+	 */
 	ASSERT(cur->bc_btnum != XFS_BTNUM_BMAP || cur->bc_ino.allocated == 0 ||
-	       XFS_FORCED_SHUTDOWN(cur->bc_mp));
+	       XFS_FORCED_SHUTDOWN(cur->bc_mp) || error != 0);
 	if (unlikely(cur->bc_flags & XFS_BTREE_STAGING))
 		kmem_free(cur->bc_ops);
 	kmem_cache_free(xfs_btree_cur_zone, cur);


