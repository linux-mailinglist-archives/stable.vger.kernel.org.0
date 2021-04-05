Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF8C2353DF1
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237316AbhDEJDI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:03:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:45752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237564AbhDEJDE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:03:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C07276138A;
        Mon,  5 Apr 2021 09:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613379;
        bh=1sMLWdGui9IZoX410EUxWrk6ypUcQA0A1qfQRQlSckA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C/qC5cywaNY2XrFNbqG0BH4IAxyTgigRh4fg9iU+J427K8N9fr49MJYdbn8WahnQI
         XtV8BdUf2BmA5SJYntTaPtUK7+BGIlc6b/tkapxE1wG3O2ASQLmIr/hfoJXTne1277
         oLGgkhjff/9FudF9VYaeyV0KhUlBIII3lqIyyr04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhaolong Zhang <zhangzl2013@126.com>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 07/74] ext4: fix bh ref count on error paths
Date:   Mon,  5 Apr 2021 10:53:31 +0200
Message-Id: <20210405085024.958796787@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085024.703004126@linuxfoundation.org>
References: <20210405085024.703004126@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index efce97b938b7..1429d01d836b 100644
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



