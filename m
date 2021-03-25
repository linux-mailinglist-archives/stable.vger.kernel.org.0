Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD5DD34902F
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbhCYLdF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:33:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:35468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230232AbhCYLau (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 07:30:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9D8C61A34;
        Thu, 25 Mar 2021 11:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671673;
        bh=Z1NQWWPiBe7V44sHym2mkS/Erd8sBxgqu+5voTV/SXk=;
        h=From:To:Cc:Subject:Date:From;
        b=CLSnMkmxXJPhrpgBeFnw7mV1itYkdz2wBNLoJEfx+6uHox0NdhP+N7ls1HsAI5/jk
         SUW5gv1RlbzW53IHK/qZjetCLLThsDq4xws1Cy6DgWRr/TGDO+oJS1fWdCFuzRamkq
         +nGzS950hAOwfZ/ew35zXr/ggc7K73lP5A5LIHpTpxHW7nhwropC1ojzBrwXdYjNr+
         WEL25xRT28lyhGfJSxAU2EQLovl1Yr1owmdF+828Htw/zX15Md4WOB9SNWcbcs+c74
         jGyPnLbb5yIGMjP/ozeeBFhGnxUm++1vI/73HaFq+09QgoDHSuh1AnqfoDAYljG49n
         Ny+UQSBujw79Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhaolong Zhang <zhangzl2013@126.com>,
        Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 01/16] ext4: fix bh ref count on error paths
Date:   Thu, 25 Mar 2021 07:27:36 -0400
Message-Id: <20210325112751.1928421-1-sashal@kernel.org>
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
index eb635eab304e..435a62d65e27 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2072,13 +2072,13 @@ static int __ext4_journalled_writepage(struct page *page,
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

