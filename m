Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC69B349061
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbhCYLeg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:34:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:42140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232026AbhCYLch (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 07:32:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D64961A32;
        Thu, 25 Mar 2021 11:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671696;
        bh=P0r+3uN5GBDqBg+P3fl9fPh59W8VXQ7KuvSjr4zbcfo=;
        h=From:To:Cc:Subject:Date:From;
        b=aHLeVhNL5aEMwfhGuINCC2CwlYJziW+KobywhP6efI0CWbdF9Vrsp9rgxQYWY1dc8
         l4jnnowZEzlcrU4utbgZ+ehkiXqoQbh1m/stdvRtxkYGsOWerD5MGjvaq6N+FrqtnV
         NtliQ59WyNHDmWEq39v7+PPW6ytS9CvjumC7sPeu+UeBoZeO5wYsqE6KmxSdH5N1ZT
         43mgJCl/vILdnEh0OHwhPUwKp87V6g6LioBcO6dbuBF4yZMqXPTXq+eBoukA4F7Oh8
         kN92ZzfXwdJlTMa4NP50VQrYxU6hPL79UNXM+Fc7+7lmrrN8pgjafXDlRiQcX6sDee
         P1OQfAYhKHBTA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhaolong Zhang <zhangzl2013@126.com>,
        Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 01/13] ext4: fix bh ref count on error paths
Date:   Thu, 25 Mar 2021 07:28:01 -0400
Message-Id: <20210325112814.1928637-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhaolong Zhang <zhangzl2013@126.com>

[ Upstream commit c915fb80eaa6194fa9bd0a4487705cd5b0dda2f1 ]

__ext4_journalled_writepage should drop bhs' ref count on error paths

Signed-off-by: Zhaolong Zhang <zhangzl2013@126.com>
Link: https://lore.kernel.org/r/1614678151-70481-1-git-send-email-zhangzl2013@126.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index ccce89de6d7e..7e41f7ccbfb5 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1979,13 +1979,13 @@ static int __ext4_journalled_writepage(struct page *page,
 	if (!ret)
 		ret = err;
 
-	if (!ext4_has_inline_data(inode))
-		ext4_walk_page_buffers(NULL, page_bufs, 0, len,
-				       NULL, bput_one);
 	ext4_set_inode_state(inode, EXT4_STATE_JDATA);
 out:
 	unlock_page(page);
 out_no_pagelock:
+	if (!inline_data && page_bufs)
+		ext4_walk_page_buffers(NULL, page_bufs, 0, len,
+				       NULL, bput_one);
 	brelse(inode_bh);
 	return ret;
 }
-- 
2.30.1

