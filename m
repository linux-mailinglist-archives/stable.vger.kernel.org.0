Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93DCC2E640D
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391964AbgL1Pqu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:46:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:45124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404470AbgL1NoY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:44:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2199D208B3;
        Mon, 28 Dec 2020 13:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163023;
        bh=1UMIi5cA6bV/1FYQ8Z0Hc6qGD11glO1XaIT1zqVgcLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tJnSbYn4fQ76+lY2PEjpn96m8xCOv3syedR6sDJk07f7sBMnnvjCApbs5NfNoURge
         LwCkB3flhuMK+f6JdmEWDttSde8wBk0E0cZ5wE4avM8Dv0mT8/U2KFrQ408YZMNLrK
         LY2khq6/72iKIuc32pLsIayi8bs0bqZye1Q876qc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 102/453] f2fs: call f2fs_get_meta_page_retry for nat page
Date:   Mon, 28 Dec 2020 13:45:38 +0100
Message-Id: <20201228124942.126906185@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit 3acc4522d89e0a326db69e9d0afaad8cf763a54c ]

When running fault injection test, if we don't stop checkpoint, some stale
NAT entries were flushed which breaks consistency.

Fixes: 86f33603f8c5 ("f2fs: handle errors of f2fs_get_meta_page_nofail")
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/node.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 2a4a382f28fed..3ac2a4b32375d 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -109,7 +109,7 @@ static void clear_node_page_dirty(struct page *page)
 
 static struct page *get_current_nat_page(struct f2fs_sb_info *sbi, nid_t nid)
 {
-	return f2fs_get_meta_page(sbi, current_nat_addr(sbi, nid));
+	return f2fs_get_meta_page_retry(sbi, current_nat_addr(sbi, nid));
 }
 
 static struct page *get_next_nat_page(struct f2fs_sb_info *sbi, nid_t nid)
-- 
2.27.0



