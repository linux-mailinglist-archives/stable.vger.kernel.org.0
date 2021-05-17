Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD194383596
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241935AbhEQPXS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:23:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:55934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243878AbhEQPSj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:18:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 501EB61C6D;
        Mon, 17 May 2021 14:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262015;
        bh=lRHZAkPNnB3u0zdGDlu72WVES0PxqvkLZbc7RzB4zDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qsjHIHEy0IF2JwVbqD0BH7l3JfWYtR18WqFj+E4e/ZyF7GxWDCmQHNpBdbtliilkf
         nujSPQDoNmkf86yj6je+gMkIRBBNPIj4Z72U7FEu3ExGCfB2DKdPNogH6wRJaKpgFn
         hcG3+7AeAqnmqDGmsjGo94ZPc15BaxlvJBuy8Ews=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 099/289] f2fs: fix a redundant call to f2fs_balance_fs if an error occurs
Date:   Mon, 17 May 2021 16:00:24 +0200
Message-Id: <20210517140308.523384837@linuxfoundation.org>
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
index b9e37f0b3e09..1d7dafdaffe3 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -218,7 +218,8 @@ out:
 
 	f2fs_put_page(page, 1);
 
-	f2fs_balance_fs(sbi, dn.node_changed);
+	if (!err)
+		f2fs_balance_fs(sbi, dn.node_changed);
 
 	return err;
 }
-- 
2.30.2



