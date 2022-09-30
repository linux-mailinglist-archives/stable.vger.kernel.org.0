Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC35E5F1657
	for <lists+stable@lfdr.de>; Sat,  1 Oct 2022 00:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbiI3Wxs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Sep 2022 18:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbiI3Wxr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Sep 2022 18:53:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F29A41A4083;
        Fri, 30 Sep 2022 15:53:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E5D3B82A74;
        Fri, 30 Sep 2022 22:53:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37F41C433D6;
        Fri, 30 Sep 2022 22:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664578424;
        bh=9EXgBqrR50Mngy3h5BZ5N6yyftKrfXoBYvd3zN2XaC8=;
        h=From:To:Cc:Subject:Date:From;
        b=oiAvvtZoqckXC0j50I1AAJK9Sj52GZMnBzweqAFlDMwx8zRtiZI1ZM8biXckHsCAc
         usYt8weLCpsJDAQ4sYRARnXCJZ2XdOia7MNwYc58+/0hRxTjg7AJY/pvXLRSqKsvoJ
         zqARasueqVLVv+ez0nM3Q4pykRMLRKvePKM3sYhN6lLome/3AGsZWCdT/2SXcZL2Vp
         8rvAKms+uXOpDJxGWu0yJfZbnXm+WjcucQuHUu/I511qM7R2zOHb88Dzp5kNgHEyYL
         JWYGuZt9i9foVEsMyFfygCzhPWKP4QcIa4qpV4V7RBB28XL7rgaIMzNp6RHzIhLG27
         k6ZUodc95znlQ==
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, stable@vger.kernel.org,
        Eunhee Rho <eunhee83.rho@samsung.com>
Subject: [PATCH] f2fs: allow direct read for zoned device
Date:   Fri, 30 Sep 2022 15:53:42 -0700
Message-Id: <20220930225342.1057276-1-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts dbf8e63f48af ("f2fs: remove device type check for direct IO"),
and apply the below first version, since it contributed out-of-order DIO writes.

For zoned devices, f2fs forbids direct IO and forces buffered IO
to serialize write IOs. However, the constraint does not apply to
read IOs.

Cc: stable@vger.kernel.org
Fixes: dbf8e63f48af ("f2fs: remove device type check for direct IO")
Signed-off-by: Eunhee Rho <eunhee83.rho@samsung.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/f2fs.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 2ed00111a399..a0b2c8626a75 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -4535,7 +4535,12 @@ static inline bool f2fs_force_buffered_io(struct inode *inode,
 	/* disallow direct IO if any of devices has unaligned blksize */
 	if (f2fs_is_multi_device(sbi) && !sbi->aligned_blksize)
 		return true;
-
+	/*
+	 * for blkzoned device, fallback direct IO to buffered IO, so
+	 * all IOs can be serialized by log-structured write.
+	 */
+	if (f2fs_sb_has_blkzoned(sbi) && (rw == WRITE))
+		return true;
 	if (f2fs_lfs_mode(sbi) && (rw == WRITE)) {
 		if (block_unaligned_IO(inode, iocb, iter))
 			return true;
-- 
2.38.0.rc1.362.ged0d419d3c-goog

