Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69635462593
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234003AbhK2WlG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:41:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234324AbhK2WkJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:40:09 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B21C144FDB;
        Mon, 29 Nov 2021 10:33:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 72467CE139A;
        Mon, 29 Nov 2021 18:33:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 201AAC53FAD;
        Mon, 29 Nov 2021 18:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210818;
        bh=JyLokz3uTX1psmva6XXCGWuAqkaTiwTqi+lVRfFS/O8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gJH6Dqp3lvQ+RaRu5xTeIj3fjI+uN5Ulhni5Ym/2uIMzMmGRmU7zpN7NxJbBFPn+W
         bbTN5e39buP/mUWYjY5DyCsNuyAEnTl3xN7b0TSB32m4+sD6mEa+UGljI6a/EUpySS
         4ufUTnrVY96SdQXjjyLXv3h3ciCbxdSANgC8/WQQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Weichao Guo <guoweichao@oppo.com>,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 103/121] f2fs: set SBI_NEED_FSCK flag when inconsistent node block found
Date:   Mon, 29 Nov 2021 19:18:54 +0100
Message-Id: <20211129181715.126745724@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Weichao Guo <guoweichao@oppo.com>

[ Upstream commit 6663b138ded1a59e630c9e605e42aa7fde490cdc ]

Inconsistent node block will cause a file fail to open or read,
which could make the user process crashes or stucks. Let's mark
SBI_NEED_FSCK flag to trigger a fix at next fsck time. After
unlinking the corrupted file, the user process could regenerate
a new one and work correctly.

Signed-off-by: Weichao Guo <guoweichao@oppo.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/node.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 597a145c08ef5..7e625806bd4a2 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1389,6 +1389,7 @@ static struct page *__get_node_page(struct f2fs_sb_info *sbi, pgoff_t nid,
 			  nid, nid_of_node(page), ino_of_node(page),
 			  ofs_of_node(page), cpver_of_node(page),
 			  next_blkaddr_of_node(page));
+		set_sbi_flag(sbi, SBI_NEED_FSCK);
 		err = -EINVAL;
 out_err:
 		ClearPageUptodate(page);
-- 
2.33.0



