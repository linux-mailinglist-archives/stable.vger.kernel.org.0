Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF35348FB9
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbhCYL3q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:29:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231455AbhCYL1V (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 07:27:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD19461A4B;
        Thu, 25 Mar 2021 11:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671614;
        bh=dBfXH6G7zEwfGP/mD7NQGLedJ9F3QDCuhNlQncp/NQ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kzomNv+hwZpkiUF6K/CnwNtp5TVOrIn9J9eNm8fXTaNoVBzPTXxQZgRTzEKyCBTOX
         t5uDXje6AJ/6aZatX9ekATtz3fufjTElfQXc7dQPaTPQhwtmc8QT/lFyYVAhl1uz/4
         aHX7YUgYe4/kivbQY1kZa13NMWGMjt1nVDPeh9MULCldJWsqj59RkjTenavg1dYroJ
         RlcK5j+o7v7fYtR6DyiFNa2bppi1P/aNFJo7wd5PGrcgOOkZ3ygRXPTnprySwNlzZE
         zw2L0m4VOnklGDZ2FJc/5jnNELObu152d1m3Gx1o3jOmm5jpJYLiW6OteM2ELpn/Av
         0zlD47VX1EFrA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhaolong Zhang <zhangzl2013@126.com>,
        Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 02/24] ext4: fix bh ref count on error paths
Date:   Thu, 25 Mar 2021 07:26:28 -0400
Message-Id: <20210325112651.1927828-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112651.1927828-1-sashal@kernel.org>
References: <20210325112651.1927828-1-sashal@kernel.org>
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
index 539d95bd364d..7e3eef597655 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2076,13 +2076,13 @@ static int __ext4_journalled_writepage(struct page *page,
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

