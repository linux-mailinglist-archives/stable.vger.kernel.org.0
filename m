Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14A252E7977
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 14:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727985AbgL3NJs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 08:09:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:53862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727311AbgL3NFE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Dec 2020 08:05:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7909022273;
        Wed, 30 Dec 2020 13:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609333449;
        bh=EQuTxe93qH+mzxHMm8+bihGMmglHMW2tWqNnbAsi4U4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kpMAo5eRvjJO02LJNfj+6vZ+9SbF9YQjPL6FMG1al1WZMB+MngHgwCpkLbLsHQE6Q
         l3M5ojOG3IMDGcnjB4k/EQaGAxW5Fu8ZNvav5jss+9BdTqS9aGeXj54QkDovVOGLvq
         Udlbs0AnDicUjzQRzKkppCu6qIdHchWSloChz+djHorwVWrfTQ0SRiFwVc09nX4/lm
         rvDvKgT18Ue9RPya63GEHxNv5j9DxVF+Gaolmcx5speMa++8Er0VYM3ywZ6FwGjPV2
         st89jVPc3Vyw6M83zHY7zs0o9SRhk14V2pzpgt4xR09PcfdxzGeCB2XnW0R5c1diEe
         ApoCqvu0BqyTw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rustam Kovhaev <rkovhaev@gmail.com>,
        syzbot+83b6f7cf9922cae5c4d7@syzkaller.appspotmail.com,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>,
        reiserfs-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 08/17] reiserfs: add check for an invalid ih_entry_count
Date:   Wed, 30 Dec 2020 08:03:48 -0500
Message-Id: <20201230130357.3637261-8-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201230130357.3637261-1-sashal@kernel.org>
References: <20201230130357.3637261-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rustam Kovhaev <rkovhaev@gmail.com>

[ Upstream commit d24396c5290ba8ab04ba505176874c4e04a2d53c ]

when directory item has an invalid value set for ih_entry_count it might
trigger use-after-free or out-of-bounds read in bin_search_in_dir_item()

ih_entry_count * IH_SIZE for directory item should not be larger than
ih_item_len

Link: https://lore.kernel.org/r/20201101140958.3650143-1-rkovhaev@gmail.com
Reported-and-tested-by: syzbot+83b6f7cf9922cae5c4d7@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=83b6f7cf9922cae5c4d7
Signed-off-by: Rustam Kovhaev <rkovhaev@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/reiserfs/stree.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/reiserfs/stree.c b/fs/reiserfs/stree.c
index bb4973aefbb18..9e64e23014e8e 100644
--- a/fs/reiserfs/stree.c
+++ b/fs/reiserfs/stree.c
@@ -454,6 +454,12 @@ static int is_leaf(char *buf, int blocksize, struct buffer_head *bh)
 					 "(second one): %h", ih);
 			return 0;
 		}
+		if (is_direntry_le_ih(ih) && (ih_item_len(ih) < (ih_entry_count(ih) * IH_SIZE))) {
+			reiserfs_warning(NULL, "reiserfs-5093",
+					 "item entry count seems wrong %h",
+					 ih);
+			return 0;
+		}
 		prev_location = ih_location(ih);
 	}
 
-- 
2.27.0

