Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBEB9348EF2
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:26:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbhCYLZb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:25:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:33568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229716AbhCYLZH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 07:25:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5242D61A17;
        Thu, 25 Mar 2021 11:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671507;
        bh=iBd8lv3XWAnh+G1+FV3Mpd4a8xPiapG6OA7D9kyr+IA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FOErQptZBOsUM2m7MKg3+bBpOGehvKQMn6+K92tCwrmj+iSyBcWTBE1q2WMNV5pCM
         xwzU3QZR4v3eK6EpnmT8Q4oEaHt1Udqse0a7yGRjLlrn9MQn0joSCLWSJ4ReCMTMCE
         u70pqtPqAggzBnzeh1F/mVv+ZG9D2E7hLPGkfvVdb8bPkFFlE1pNHp39jD0WT4objH
         GhCDCMAAQN+L6WQ+bWYyqkjtSlbh7BNu4IyHxY1988UcCOAq8nK8FE/WfSXxq2hvVK
         HqL4t5gjF3XXh9bBGzgmp0hnwz0Q3V3BF90wAHBIY0UKfl5DvUxDDcBVpJhLwtoq6k
         zYOSb7u5MwiNg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhaolong Zhang <zhangzl2013@126.com>,
        Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 05/44] ext4: fix bh ref count on error paths
Date:   Thu, 25 Mar 2021 07:24:20 -0400
Message-Id: <20210325112459.1926846-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112459.1926846-1-sashal@kernel.org>
References: <20210325112459.1926846-1-sashal@kernel.org>
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
index c173c8405856..ffbd459e2b37 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1937,13 +1937,13 @@ static int __ext4_journalled_writepage(struct page *page,
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

