Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4A2223716
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 15:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388081AbfETMVB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:21:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:34526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388077AbfETMVB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:21:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06D8F20656;
        Mon, 20 May 2019 12:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558354860;
        bh=aoak7GZr+DL/b67tuvNtNkms+8SOBqbrBSp9kWjJFA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R1QCSEAEp+7MdSTBQDEOfgQE5FepZCISt1ydWul8vIPnvy4lAu06ookzuCBJgLjao
         1HXkdkpzicqUMsoFdXHX86U01W4jR7C9T6zm3OLuelPKj/8XAgP7pHsVWQCwYtRmiv
         YGGdiBmtwzoIAWE88eggv5Vy8OUKWjKYEioZu2kU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "zhangyi (F)" <yi.zhang@huawei.com>,
        Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>
Subject: [PATCH 4.14 63/63] ext4: fix compile error when using BUFFER_TRACE
Date:   Mon, 20 May 2019 14:14:42 +0200
Message-Id: <20190520115237.837048692@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115231.137981521@linuxfoundation.org>
References: <20190520115231.137981521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhangyi (F) <yi.zhang@huawei.com>

commit ddccb6dbe780d68133191477571cb7c69e17bb8c upstream.

Fix compile error below when using BUFFER_TRACE.

fs/ext4/inode.c: In function ‘ext4_expand_extra_isize’:
fs/ext4/inode.c:5979:19: error: request for member ‘bh’ in something not a structure or union
  BUFFER_TRACE(iloc.bh, "get_write_access");

Fixes: c03b45b853f58 ("ext4, project: expand inode extra size if possible")
Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5818,7 +5818,7 @@ int ext4_expand_extra_isize(struct inode
 
 	ext4_write_lock_xattr(inode, &no_expand);
 
-	BUFFER_TRACE(iloc.bh, "get_write_access");
+	BUFFER_TRACE(iloc->bh, "get_write_access");
 	error = ext4_journal_get_write_access(handle, iloc->bh);
 	if (error) {
 		brelse(iloc->bh);


