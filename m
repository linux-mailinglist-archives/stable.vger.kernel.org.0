Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E98D51216CB
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730668AbfLPSKu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:10:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:54276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730665AbfLPSKu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:10:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7460E207FF;
        Mon, 16 Dec 2019 18:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519849;
        bh=+mUDm720vOil5NekTWtSXYLAFxEU5F0beangRkvpLQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t8cDNcxUVYU/NU+2dM5lLxuLsefCOmyQZOSIq2zwjcZynrpQmJUBEne60KQVKK6Mk
         Ftg+vg8bUTVT7zGF9JR43+fyyNSTZr0hum3q5QQtc4BLkLfvtVhkpO78hujYeDweyA
         Y1RzlwJ34Q/aZNgEJ7NrjzWR9iu6LY/JOBuhitwA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Gao Xiang <gaoxiang25@huawei.com>
Subject: [PATCH 5.3 094/180] erofs: zero out when listxattr is called with no xattr
Date:   Mon, 16 Dec 2019 18:48:54 +0100
Message-Id: <20191216174835.001737408@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174806.018988360@linuxfoundation.org>
References: <20191216174806.018988360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gao Xiang <gaoxiang25@huawei.com>

commit 926d1650176448d7684b991fbe1a5b1a8289e97c upstream.

As David reported [1], ENODATA returns when attempting
to modify files by using EROFS as an overlayfs lower layer.

The root cause is that listxattr could return unexpected
-ENODATA by mistake for inodes without xattr. That breaks
listxattr return value convention and it can cause copy
up failure when used with overlayfs.

Resolve by zeroing out if no xattr is found for listxattr.

[1] https://lore.kernel.org/r/CAEvUa7nxnby+rxK-KRMA46=exeOMApkDMAV08AjMkkPnTPV4CQ@mail.gmail.com
Link: https://lore.kernel.org/r/20191201084040.29275-1-hsiangkao@aol.com
Fixes: cadf1ccf1b00 ("staging: erofs: add error handling for xattr submodule")
Cc: <stable@vger.kernel.org> # 4.19+
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/erofs/xattr.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/staging/erofs/xattr.c
+++ b/drivers/staging/erofs/xattr.c
@@ -649,6 +649,8 @@ ssize_t erofs_listxattr(struct dentry *d
 	struct listxattr_iter it;
 
 	ret = init_inode_xattrs(d_inode(dentry));
+	if (ret == -ENOATTR)
+		return 0;
 	if (ret)
 		return ret;
 


