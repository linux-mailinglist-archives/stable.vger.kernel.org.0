Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 201E4328FE3
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242634AbhCAT6y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:58:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:57704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242332AbhCATs1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:48:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F051E6525D;
        Mon,  1 Mar 2021 17:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619716;
        bh=7huvN+C20SkmZILgftz3wqApWdpSaE+GDlgsLyMY1P8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c4j37if5YfXiap1N1b8rz4GyL+CJ4SCFG7PjnuSsbtk9m8j+GE6+hSMMROPHkgo6u
         QlaEtTO9tAnCx1pVJEFrRB35OKKReR93Y6C7dtvzYiUGOWSubTvfuGtFXDic55IGSq
         TmY3XomQgUcpe24h18HKnMm4ogivJD/UOKqDrGeg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huang Jianan <huangjianan@oppo.com>,
        Chao Yu <yuchao0@huawei.com>, Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH 5.10 525/663] erofs: initialized fields can only be observed after bit is set
Date:   Mon,  1 Mar 2021 17:12:53 +0100
Message-Id: <20210301161207.817582272@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gao Xiang <hsiangkao@redhat.com>

commit ce063129181312f8781a047a50be439c5859747b upstream.

Currently, although set_bit() & test_bit() pairs are used as a fast-
path for initialized configurations. However, these atomic ops are
actually relaxed forms. Instead, load-acquire & store-release form is
needed to make sure uninitialized fields won't be observed in advance
here (yet no such corresponding bitops so use full barriers instead.)

Link: https://lore.kernel.org/r/20210209130618.15838-1-hsiangkao@aol.com
Fixes: 62dc45979f3f ("staging: erofs: fix race of initializing xattrs of a inode at the same time")
Fixes: 152a333a5895 ("staging: erofs: add compacted compression indexes support")
Cc: <stable@vger.kernel.org> # 5.3+
Reported-by: Huang Jianan <huangjianan@oppo.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/erofs/xattr.c |   10 +++++++++-
 fs/erofs/zmap.c  |   10 +++++++++-
 2 files changed, 18 insertions(+), 2 deletions(-)

--- a/fs/erofs/xattr.c
+++ b/fs/erofs/xattr.c
@@ -48,8 +48,14 @@ static int init_inode_xattrs(struct inod
 	int ret = 0;
 
 	/* the most case is that xattrs of this inode are initialized. */
-	if (test_bit(EROFS_I_EA_INITED_BIT, &vi->flags))
+	if (test_bit(EROFS_I_EA_INITED_BIT, &vi->flags)) {
+		/*
+		 * paired with smp_mb() at the end of the function to ensure
+		 * fields will only be observed after the bit is set.
+		 */
+		smp_mb();
 		return 0;
+	}
 
 	if (wait_on_bit_lock(&vi->flags, EROFS_I_BL_XATTR_BIT, TASK_KILLABLE))
 		return -ERESTARTSYS;
@@ -137,6 +143,8 @@ static int init_inode_xattrs(struct inod
 	}
 	xattr_iter_end(&it, atomic_map);
 
+	/* paired with smp_mb() at the beginning of the function. */
+	smp_mb();
 	set_bit(EROFS_I_EA_INITED_BIT, &vi->flags);
 
 out_unlock:
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -36,8 +36,14 @@ static int z_erofs_fill_inode_lazy(struc
 	void *kaddr;
 	struct z_erofs_map_header *h;
 
-	if (test_bit(EROFS_I_Z_INITED_BIT, &vi->flags))
+	if (test_bit(EROFS_I_Z_INITED_BIT, &vi->flags)) {
+		/*
+		 * paired with smp_mb() at the end of the function to ensure
+		 * fields will only be observed after the bit is set.
+		 */
+		smp_mb();
 		return 0;
+	}
 
 	if (wait_on_bit_lock(&vi->flags, EROFS_I_BL_Z_BIT, TASK_KILLABLE))
 		return -ERESTARTSYS;
@@ -83,6 +89,8 @@ static int z_erofs_fill_inode_lazy(struc
 
 	vi->z_physical_clusterbits[1] = vi->z_logical_clusterbits +
 					((h->h_clusterbits >> 5) & 7);
+	/* paired with smp_mb() at the beginning of the function */
+	smp_mb();
 	set_bit(EROFS_I_Z_INITED_BIT, &vi->flags);
 unmap_done:
 	kunmap_atomic(kaddr);


