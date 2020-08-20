Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B86B224B684
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731326AbgHTKgw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:36:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:41266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731179AbgHTKSl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:18:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67DC82075E;
        Thu, 20 Aug 2020 10:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918716;
        bh=C2e74BvxcPUgeYI2NSIS75gacK4akmEZa73yXqLdLok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YR4i3r/il3tyR1jkJCKKBmyBQ2/vwjANtfS/P+1ALc2I98qIcI03xPmREBRXeA5cN
         DhkUZGniKmn7iiQmv26ciTgLt2jhvuECw2BneRkKApCuTpS3Rfd7T+Nb+gT+L9VefC
         GCcr96MeKlJnA7NKjM+RIJh4TF30ec81RkReZX5o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gong Chen <gongchen4@huawei.com>,
        Sheng Yong <shengyong1@huawei.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 011/149] f2fs: check if file namelen exceeds max value
Date:   Thu, 20 Aug 2020 11:21:28 +0200
Message-Id: <20200820092126.244160395@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820092125.688850368@linuxfoundation.org>
References: <20200820092125.688850368@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sheng Yong <shengyong1@huawei.com>

[ Upstream commit 720db068634c91553a8e1d9a0fcd8c7050e06d2b ]

Dentry bitmap is not enough to detect incorrect dentries. So this patch
also checks the namelen value of a dentry.

Signed-off-by: Gong Chen <gongchen4@huawei.com>
Signed-off-by: Sheng Yong <shengyong1@huawei.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/dir.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 5411d6667781f..e2ff0eb16f89c 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -807,7 +807,8 @@ bool f2fs_fill_dentries(struct dir_context *ctx, struct f2fs_dentry_ptr *d,
 
 		/* check memory boundary before moving forward */
 		bit_pos += GET_DENTRY_SLOTS(le16_to_cpu(de->name_len));
-		if (unlikely(bit_pos > d->max)) {
+		if (unlikely(bit_pos > d->max ||
+				le16_to_cpu(de->name_len) > F2FS_NAME_LEN)) {
 			f2fs_msg(F2FS_I_SB(d->inode)->sb, KERN_WARNING,
 				"%s: corrupted namelen=%d, run fsck to fix.",
 				__func__, le16_to_cpu(de->name_len));
-- 
2.25.1



