Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3B80328BA3
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240244AbhCASiU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:38:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:43176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235375AbhCAS3I (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:29:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 719386535B;
        Mon,  1 Mar 2021 17:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620752;
        bh=EnBmsuJYKSpZiuhUD6hO6qDSM8ZcOC22+RqBoIHyr/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yz6RS4ONceO/Agy3vzq+c/n0NuNsqCCV6ud2uKc01RSHBWHs3iHPrYdVgWsrccKVR
         Me6xKGgNYM6gcWvRy5iGUea0APKIcwbArIADPR6/4RkFmp6XdHSuiNg/A89oOAgBZ/
         euhp4ImCrbFh8gczXsT2i3Vo/e5WG/ECLCPQ3WtQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daeho Jeong <daehojeong@google.com>,
        Colin Ian King <colin.king@canonical.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 236/775] f2fs: fix null page reference in redirty_blocks
Date:   Mon,  1 Mar 2021 17:06:44 +0100
Message-Id: <20210301161213.291220418@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daeho Jeong <daehojeong@google.com>

[ Upstream commit df0736d70c4fa6ed711ba103b61880fe72bb4777 ]

By Colin's static analysis, we found out there is a null page reference
under low memory situation in redirty_blocks. I've made the page finding
loop stop immediately and return an error not to cause further memory
pressure when we run into a failure to find a page under low memory
condition.

Signed-off-by: Daeho Jeong <daehojeong@google.com>
Reported-by: Colin Ian King <colin.king@canonical.com>
Fixes: 5fdb322ff2c2 ("f2fs: add F2FS_IOC_DECOMPRESS_FILE and F2FS_IOC_COMPRESS_FILE")
Reviewed-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index f585545277d77..cd62b0d3369ab 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -4043,8 +4043,10 @@ static int redirty_blocks(struct inode *inode, pgoff_t page_idx, int len)
 
 	for (i = 0; i < page_len; i++, redirty_idx++) {
 		page = find_lock_page(mapping, redirty_idx);
-		if (!page)
-			ret = -ENOENT;
+		if (!page) {
+			ret = -ENOMEM;
+			break;
+		}
 		set_page_dirty(page);
 		f2fs_put_page(page, 1);
 		f2fs_put_page(page, 0);
-- 
2.27.0



