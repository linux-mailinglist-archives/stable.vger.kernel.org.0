Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4AB4F4344
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 23:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349309AbiDEMWA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:22:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356703AbiDEKYt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:24:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 980E9BF502;
        Tue,  5 Apr 2022 03:08:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3160AB81C8B;
        Tue,  5 Apr 2022 10:08:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79387C385A6;
        Tue,  5 Apr 2022 10:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153329;
        bh=2G8/AqG0+BbaHGBuCW1Wgi9beZzm2Mxp5cB/nqaBBfY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1VOVI7ild3F6wRDaJmSopmKa4448/hYMG8TWNY5ch3FfiubAFTa0lLoZSqh6ebF9O
         iTBcs4K0/82hk8/PL23D++v7IlJ0ZTv40TVqK+yXJAFtNJk61XiQh8ySygHajWaMoH
         XL3mlSbm4z+/DLjwHkS32YqLN1PCVg6Kefg4cqCQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Fengnan Chang <changfengnan@vivo.com>,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 184/599] f2fs: fix compressed file start atomic write may cause data corruption
Date:   Tue,  5 Apr 2022 09:27:58 +0200
Message-Id: <20220405070304.316914552@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fengnan Chang <changfengnan@vivo.com>

[ Upstream commit 9b56adcf525522e9ffa52471260298d91fc1d395 ]

When compressed file has blocks, f2fs_ioc_start_atomic_write will succeed,
but compressed flag will be remained in inode. If write partial compreseed
cluster and commit atomic write will cause data corruption.

This is the reproduction process:
Step 1:
create a compressed file ,write 64K data , call fsync(), then the blocks
are write as compressed cluster.
Step2:
iotcl(F2FS_IOC_START_ATOMIC_WRITE)  --- this should be fail, but not.
write page 0 and page 3.
iotcl(F2FS_IOC_COMMIT_ATOMIC_WRITE)  -- page 0 and 3 write as normal file,
Step3:
drop cache.
read page 0-4   -- Since page 0 has a valid block address, read as
non-compressed cluster, page 1 and 2 will be filled with compressed data
or zero.

The root cause is, after commit 7eab7a696827 ("f2fs: compress: remove
unneeded read when rewrite whole cluster"), in step 2, f2fs_write_begin()
only set target page dirty, and in f2fs_commit_inmem_pages(), we will write
partial raw pages into compressed cluster, result in corrupting compressed
cluster layout.

Fixes: 4c8ff7095bef ("f2fs: support data compression")
Fixes: 7eab7a696827 ("f2fs: compress: remove unneeded read when rewrite whole cluster")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Fengnan Chang <changfengnan@vivo.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 2 +-
 fs/f2fs/file.c | 5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 04e980c58319..b2016fd3a7ca 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -3461,7 +3461,7 @@ static int f2fs_write_begin(struct file *file, struct address_space *mapping,
 
 		*fsdata = NULL;
 
-		if (len == PAGE_SIZE)
+		if (len == PAGE_SIZE && !(f2fs_is_atomic_file(inode)))
 			goto repeat;
 
 		ret = f2fs_prepare_compress_overwrite(inode, pagep,
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 1fbaab1f7aba..792f9059d897 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2035,7 +2035,10 @@ static int f2fs_ioc_start_atomic_write(struct file *filp)
 
 	inode_lock(inode);
 
-	f2fs_disable_compressed_file(inode);
+	if (!f2fs_disable_compressed_file(inode)) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	if (f2fs_is_atomic_file(inode)) {
 		if (is_inode_flag_set(inode, FI_ATOMIC_REVOKE_REQUEST))
-- 
2.34.1



