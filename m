Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 799ED53E5D3
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239773AbiFFOdU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 10:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239732AbiFFOdS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 10:33:18 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEEAA2BB23;
        Mon,  6 Jun 2022 07:33:16 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id d14so11126400wra.10;
        Mon, 06 Jun 2022 07:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4ADZbtAzVYEXGEOSgrcAKT0QzFIP7E8T2DQIIPmKyqo=;
        b=n91mLdVImBJysmLKm/dk0x82GvFIUs8jAIrBxtIpsme3svrhknEFt/CQX0vN7VNG0W
         n654VVxKLreeeJMabslKb/Oong6DQaEqSmo78rexJjwVDxMKKAXd6vVWzQfMHe5Vb5Uc
         ln8rbLe+7Nb4aZCKY78Gp2r+ll7oUMj6jP+KyjX8KL4I7lXbQnb3Zt8DxCDGLi1PfZjP
         bayefeFOPXxWraz3HXPAoKdhKfOrBKKRsmdD+l1o8P+TaLlaQ11d9ZYLjYVz7c23HzOW
         LSkKbY0VLXrpFYi+6eGCiWTzXCHSTEr2WJbPcaElJK2HZlNjNL5IflXh53cVuR6l8RzC
         n9OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4ADZbtAzVYEXGEOSgrcAKT0QzFIP7E8T2DQIIPmKyqo=;
        b=AxkrQp3CdSsIXFbyrtc2yk1UPcS1wK2gvA2Upb+OFESMHZE6DyyOahakMTOwGe4NA4
         a1YeCIos6oXj0K12ASI7+PgiegBXGF5wf5Nt/rfrVJExTQ5X0zdpadclLSctlNnrUig7
         1ZPdm1o7DO1lSLWqm6xbQA/bA95NWpFHEMD9CFcn5ahRwIUV/+PgNrl7CAGpMUQIxMm+
         XVK3sSNFMnNIv8m+t71zNyG8EzDdIQO2vyQaRU8g0A3b1il9xQxIy7LgiaJvndEc7QHJ
         ot9b+irxNTkqol/Lch5smtgcCH14IOdjfGyHTXzKWtMHsbDz9LidD/JIPhA4oDytgykM
         HvtQ==
X-Gm-Message-State: AOAM532uY1R55p3pX2noIl/rMWS1gx/i9ttXnp5bALnfsGM2Spkyv9aE
        6PM3P1/3TTP4g61Q+DBW9To=
X-Google-Smtp-Source: ABdhPJwxKROoHDO8Ew1abJrLoRdz5x87Zlc+FxcuDafnpdXSBzE/qqKnsVAz4ahyAv6DpKnkpLF4xw==
X-Received: by 2002:a5d:648a:0:b0:217:3552:eb2d with SMTP id o10-20020a5d648a000000b002173552eb2dmr9085512wri.78.1654525995382;
        Mon, 06 Jun 2022 07:33:15 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (bzq-166-168-31-246.red.bezeqint.net. [31.168.166.246])
        by smtp.gmail.com with ESMTPSA id h24-20020a05600c145800b0039c54bb28f2sm1622958wmi.36.2022.06.06.07.33.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 07:33:14 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 5.10 v2 8/8] xfs: assert in xfs_btree_del_cursor should take into account error
Date:   Mon,  6 Jun 2022 17:32:55 +0300
Message-Id: <20220606143255.685988-9-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220606143255.685988-1-amir73il@gmail.com>
References: <20220606143255.685988-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
---
 fs/xfs/libxfs/xfs_btree.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 9f9f9feccbcd..98c82f4935e1 100644
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
-- 
2.25.1

