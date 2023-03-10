Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5D7C6B419F
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbjCJNzJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:55:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231307AbjCJNzE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:55:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F0810F44C
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:54:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0D12B822B5
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:54:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C0DCC433EF;
        Fri, 10 Mar 2023 13:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456493;
        bh=B068v76bWBhtRZQcOi6a7akpFDt1GrmjkN6k/69KC4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QnrYsMYBAMXsRrSnUSxjJYNWcSVt0skfA38tjdU55gcO67DglSaxp8t0BJ9zgwY5Z
         zaN6jsybLYEAfyAJEOUg8tyDini5msBOSfsejB0EJ7ZWa2TyP0ZvhFHYHn74hfc60r
         flSUrc42znt2Pom1WkXOh8Ka3K1ZOI8piRJV0ExU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yangtao Li <frank.li@vivo.com>,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 022/211] f2fs: allow set compression option of files without blocks
Date:   Fri, 10 Mar 2023 14:36:42 +0100
Message-Id: <20230310133719.404960241@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yangtao Li <frank.li@vivo.com>

[ Upstream commit e6261beb0c629403dc58997294dd521bd23664af ]

Files created by truncate have a size but no blocks, so
they can be allowed to set compression option.

Fixes: e1e8debec656 ("f2fs: add F2FS_IOC_SET_COMPRESS_OPTION ioctl")
Signed-off-by: Yangtao Li <frank.li@vivo.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 2498e5c70fd83..78e6015ce3a6f 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -3945,7 +3945,7 @@ static int f2fs_ioc_set_compress_option(struct file *filp, unsigned long arg)
 		goto out;
 	}
 
-	if (inode->i_size != 0) {
+	if (F2FS_HAS_BLOCKS(inode)) {
 		ret = -EFBIG;
 		goto out;
 	}
-- 
2.39.2



