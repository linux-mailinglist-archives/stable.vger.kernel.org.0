Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B04C383340
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241800AbhEQO4f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:56:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:48472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241921AbhEQOyQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:54:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8629261992;
        Mon, 17 May 2021 14:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261472;
        bh=UQybdjdzss65f7/YPov0bFeM1dGimb8qAfWrK+W3mJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vSJHOgL7bFNmeoDZ7dPlpFes0f8GMx0461b0QZQF0lZmmGyTa09R70j4ceYopsVI/
         QTgoA9AHbhOMV+9OToAl0WQN6LCZuu7ZnbKWLe56K1mn9c9+jZM+xcDy0/54C2Fo2+
         BFMdr4NoXyErnr/ZMUnooYNUlQoQk7Jbx8Axo9w0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 117/329] f2fs: fix a redundant call to f2fs_balance_fs if an error occurs
Date:   Mon, 17 May 2021 16:00:28 +0200
Message-Id: <20210517140306.059847690@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
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
index 993caefcd2bb..92652ca7a7c8 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -219,7 +219,8 @@ out:
 
 	f2fs_put_page(page, 1);
 
-	f2fs_balance_fs(sbi, dn.node_changed);
+	if (!err)
+		f2fs_balance_fs(sbi, dn.node_changed);
 
 	return err;
 }
-- 
2.30.2



