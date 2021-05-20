Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B151638A994
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239749AbhETLEB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:04:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:57140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238974AbhETLB5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:01:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BCAC61D0D;
        Thu, 20 May 2021 10:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505031;
        bh=XYQPbT2/nh1qXOxzHrB7JbpxI31hnd3KzjabaIYCqAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hndYyoTixxh7qIKZtxRgGgbMjyJzl9gEtfI20xR3sQHGhy+CJPC0bTzWqEo27wiI/
         aspZg4k9jKoqm5YOZnxg+9NJaQ6XEPSTLqV0wpZ+IND+psTJClJQEIavdJpS5mEByO
         hbJuhVDJDSat7FN5zGLk1/rP/3ejo22piH62KL8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 192/240] f2fs: fix a redundant call to f2fs_balance_fs if an error occurs
Date:   Thu, 20 May 2021 11:23:04 +0200
Message-Id: <20210520092115.115609478@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 28e18ee636ba28532dbe425540af06245a0bbecb ]

The  uninitialized variable dn.node_changed does not get set when a
call to f2fs_get_node_page fails.  This uninitialized value gets used
in the call to f2fs_balance_fs() that may or not may not balances
dirty node and dentry pages depending on the uninitialized state of
the variable. Fix this by only calling f2fs_balance_fs if err is
not set.

Thanks to Jaegeuk Kim for suggesting an appropriate fix.

Addresses-Coverity: ("Uninitialized scalar variable")
Fixes: 2a3407607028 ("f2fs: call f2fs_balance_fs only when node was changed")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/inline.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index 482888ee8942..481fae63f163 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -196,7 +196,8 @@ out:
 
 	f2fs_put_page(page, 1);
 
-	f2fs_balance_fs(sbi, dn.node_changed);
+	if (!err)
+		f2fs_balance_fs(sbi, dn.node_changed);
 
 	return err;
 }
-- 
2.30.2



