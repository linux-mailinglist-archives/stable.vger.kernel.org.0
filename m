Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE423836E7
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244679AbhEQPhT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:37:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:40232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343680AbhEQPel (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:34:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 297D861CDC;
        Mon, 17 May 2021 14:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262365;
        bh=DyR27eA7BveT8S5A53uC42YSqXL53DAj2gw+VDf+7jA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ifhNpG0BHqUhmjQDEWozavaDvIayiSq4WbxY9m4+sp3ns+CPC33izKFrC1zrmsPYI
         j5PwgIB6d04nxG7UDAvCWHZsblNN2dTNYfBGixnoCauDT4TdDm4m0X8HGBi4BreQZN
         44QxVkh9yMdthj2iMVmYqMVh5E+iwLDcKtRjBV7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Xiubo Li <xiubli@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 139/289] ceph: fix inode leak on getattr error in __fh_to_dentry
Date:   Mon, 17 May 2021 16:01:04 +0200
Message-Id: <20210517140309.833964655@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 1775c7ddacfcea29051c67409087578f8f4d751b ]

Fixes: 878dabb64117 ("ceph: don't return -ESTALE if there's still an open file")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/export.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/export.c b/fs/ceph/export.c
index e088843a7734..baa6368bece5 100644
--- a/fs/ceph/export.c
+++ b/fs/ceph/export.c
@@ -178,8 +178,10 @@ static struct dentry *__fh_to_dentry(struct super_block *sb, u64 ino)
 		return ERR_CAST(inode);
 	/* We need LINK caps to reliably check i_nlink */
 	err = ceph_do_getattr(inode, CEPH_CAP_LINK_SHARED, false);
-	if (err)
+	if (err) {
+		iput(inode);
 		return ERR_PTR(err);
+	}
 	/* -ESTALE if inode as been unlinked and no file is open */
 	if ((inode->i_nlink == 0) && (atomic_read(&inode->i_count) == 1)) {
 		iput(inode);
-- 
2.30.2



