Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 795E944069
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390235AbfFMQGM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:06:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:34794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731326AbfFMIqL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:46:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1080E2147A;
        Thu, 13 Jun 2019 08:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415570;
        bh=VqdjPSckO1hZLBcHpwUjJ+GpAzDhy/Hn8MOS1h8wunw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g+IWrxz0HcePBddm5K7CyIqAd8kTTJgiFLqD5i4JrQxc4BfxTPjWaGu/bepgBREjN
         5q06VRqGSYECy/w2w5nRfBk2AWIF8VKMGriymwxGoIj/IaWsahGKPwwwdHudlnwedY
         z/9wGt4hWDvwqvMvLwgsC8EPeheIvkfQWnY4vtus=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 049/155] f2fs: fix to use inline space only if inline_xattr is enable
Date:   Thu, 13 Jun 2019 10:32:41 +0200
Message-Id: <20190613075655.870518200@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 622927f3b8809206f6da54a6a7ed4df1a7770fce ]

With below mkfs and mount option:

MKFS_OPTIONS  -- -O extra_attr -O project_quota -O inode_checksum -O flexible_inline_xattr -O inode_crtime -f
MOUNT_OPTIONS -- -o noinline_xattr

We may miss xattr data with below testcase:
- mkdir dir
- setfattr -n "user.name" -v 0 dir
- for ((i = 0; i < 190; i++)) do touch dir/$i; done
- umount
- mount
- getfattr -n "user.name" dir

user.name: No such attribute

The root cause is that we persist xattr data into reserved inline xattr
space, even if inline_xattr is not enable in inline directory inode, after
inline dentry conversion, reserved space no longer exists, so that xattr
data missed.

Let's use inline xattr space only if inline_xattr flag is set on inode
to fix this iusse.

Fixes: 6afc662e68b5 ("f2fs: support flexible inline xattr size")
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/f2fs.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 74f06f12110f..10240fbdd396 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -2579,7 +2579,9 @@ static inline void *inline_xattr_addr(struct inode *inode, struct page *page)
 
 static inline int inline_xattr_size(struct inode *inode)
 {
-	return get_inline_xattr_addrs(inode) * sizeof(__le32);
+	if (f2fs_has_inline_xattr(inode))
+		return get_inline_xattr_addrs(inode) * sizeof(__le32);
+	return 0;
 }
 
 static inline int f2fs_has_inline_data(struct inode *inode)
-- 
2.20.1



