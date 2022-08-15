Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B27B593AB7
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345138AbiHOTsl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:48:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345560AbiHOTrH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:47:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C4CA70E64;
        Mon, 15 Aug 2022 11:49:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0117B810A1;
        Mon, 15 Aug 2022 18:49:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAE89C433C1;
        Mon, 15 Aug 2022 18:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589368;
        bh=MXWx+3HasW0tR213YqIc6ahlgS/NMcSpnkiVtVTpnvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fumdkHlqrimhcrllJ4qus25NVcbJTFzSlDo4qL1hzzxktwPIWq0caoMSdE0tg+3zo
         Lvn5FMwCC0kAu24SwJIcdjh+Bwb0FGzBf/0HDA/suea60P2fCmtHscJTLeYMJon0eP
         vD0fCvty0fD4cLyLjOsXHIZmQg9VrT+U3CwmK8k4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Junbeom Yeom <junbeom.yeom@samsung.com>,
        Sungjong Seo <sj1557.seo@samsung.com>,
        Youngjin Gil <youngjin.gil@samsung.com>,
        Jaewook Kim <jw5454.kim@samsung.com>,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 665/779] f2fs: do not allow to decompress files have FI_COMPRESS_RELEASED
Date:   Mon, 15 Aug 2022 20:05:09 +0200
Message-Id: <20220815180405.775800553@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jaewook Kim <jw5454.kim@samsung.com>

[ Upstream commit 90be48bd9d29ece3965e5e8b21499b6db166e57b ]

If a file has FI_COMPRESS_RELEASED, all writes for it should not be
allowed. However, as of now, in case of compress_mode=user, writes
triggered by IOCTLs like F2FS_IOC_DE/COMPRESS_FILE are allowed unexpectly,
which could crash that file.
To fix it, let's do not allow F2FS_IOC_DE/COMPRESS_IOCTL if a file already
has FI_COMPRESS_RELEASED flag.

This is the reproduction process:
1.  $ touch ./file
2.  $ chattr +c ./file
3.  $ dd if=/dev/random of=./file bs=4096 count=30 conv=notrunc
4.  $ dd if=/dev/zero of=./file bs=4096 count=34 seek=30 conv=notrunc
5.  $ sync
6.  $ do_compress ./file      ; call F2FS_IOC_COMPRESS_FILE
7.  $ get_compr_blocks ./file ; call F2FS_IOC_GET_COMPRESS_BLOCKS
8.  $ release ./file          ; call F2FS_IOC_RELEASE_COMPRESS_BLOCKS
9.  $ do_compress ./file      ; call F2FS_IOC_COMPRESS_FILE again
10. $ get_compr_blocks ./file ; call F2FS_IOC_GET_COMPRESS_BLOCKS again

This reproduction process is tested in 128kb cluster size.
You can find compr_blocks has a negative value.

Fixes: 5fdb322ff2c2b ("f2fs: add F2FS_IOC_DECOMPRESS_FILE and F2FS_IOC_COMPRESS_FILE")

Signed-off-by: Junbeom Yeom <junbeom.yeom@samsung.com>
Signed-off-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Youngjin Gil <youngjin.gil@samsung.com>
Signed-off-by: Jaewook Kim <jw5454.kim@samsung.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 0669464a942a..758048a885d2 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -4011,6 +4011,11 @@ static int f2fs_ioc_decompress_file(struct file *filp, unsigned long arg)
 		goto out;
 	}
 
+	if (is_inode_flag_set(inode, FI_COMPRESS_RELEASED)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	ret = filemap_write_and_wait_range(inode->i_mapping, 0, LLONG_MAX);
 	if (ret)
 		goto out;
@@ -4078,6 +4083,11 @@ static int f2fs_ioc_compress_file(struct file *filp, unsigned long arg)
 		goto out;
 	}
 
+	if (is_inode_flag_set(inode, FI_COMPRESS_RELEASED)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	ret = filemap_write_and_wait_range(inode->i_mapping, 0, LLONG_MAX);
 	if (ret)
 		goto out;
-- 
2.35.1



