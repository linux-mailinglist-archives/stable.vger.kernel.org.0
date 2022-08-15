Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49AFF59476B
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232168AbiHOXRG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:17:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245760AbiHOXO1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:14:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC0267B780;
        Mon, 15 Aug 2022 13:01:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 43EB1612D1;
        Mon, 15 Aug 2022 20:01:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C75BC433D6;
        Mon, 15 Aug 2022 20:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593695;
        bh=JhNnQOE20HwpMMsPZPM6nzXHWRTIUJpndBIUOobfnog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BmU2Yz8W+Me6c2tZg5vGzW7bvNVaNm7AP6EFw+PpPjCfUjMnuf+bAAwibbA8TMP93
         +v3wmoRqq/weV/bxHE88m2Wab0Gy6uCdz4uNJqfzlBdfJOdsk50jwePwJgrCL+0eeI
         Un4PHoQiBgd3gvnUKpLZgJQ+Z7xL0lJII6DgL6k8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sungjong Seo <sj1557.seo@samsung.com>,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0954/1095] f2fs: allow compression for mmap files in compress_mode=user
Date:   Mon, 15 Aug 2022 20:05:53 +0200
Message-Id: <20220815180508.570829193@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Sungjong Seo <sj1557.seo@samsung.com>

[ Upstream commit 66d34fcbbe63ebd8584b792e0d741f6648100894 ]

Since commit e3c548323d32 ("f2fs: let's allow compression for mmap files"),
it has been allowed to compress mmap files. However, in compress_mode=user,
it is not allowed yet. To keep the same concept in both compress_modes,
f2fs_ioc_(de)compress_file() should also allow it.

Let's remove checking mmap files in f2fs_ioc_(de)compress_file() so that
the compression for mmap files is also allowed in compress_mode=user.

Signed-off-by: Sungjong Seo <sj1557.seo@samsung.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 863518695ea6..9a676ea080e4 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -3914,11 +3914,6 @@ static int f2fs_ioc_decompress_file(struct file *filp, unsigned long arg)
 		goto out;
 	}
 
-	if (f2fs_is_mmap_file(inode)) {
-		ret = -EBUSY;
-		goto out;
-	}
-
 	ret = filemap_write_and_wait_range(inode->i_mapping, 0, LLONG_MAX);
 	if (ret)
 		goto out;
@@ -3986,11 +3981,6 @@ static int f2fs_ioc_compress_file(struct file *filp, unsigned long arg)
 		goto out;
 	}
 
-	if (f2fs_is_mmap_file(inode)) {
-		ret = -EBUSY;
-		goto out;
-	}
-
 	ret = filemap_write_and_wait_range(inode->i_mapping, 0, LLONG_MAX);
 	if (ret)
 		goto out;
-- 
2.35.1



