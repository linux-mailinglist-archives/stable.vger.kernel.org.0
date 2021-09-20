Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0990D411CC6
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345870AbhITRNI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:13:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:33902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343489AbhITRLH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:11:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44C83613A3;
        Mon, 20 Sep 2021 16:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157015;
        bh=t9tEat3ZVKAChYi9xcQ3UhIPOgPUidcS1OFDZJhmYrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f8br9jw3hSpmfKsFMdNKBW13d7s5NeSlQErUvTfMqYVLhALCzjYYgSqB1y6Ho7msw
         XJlxbmXOlQbD6yW3sZv+tun7m0Fud2cmB/MqtpBHKWeG3+DIX12hhhgoFV4qTRAD5e
         okRfrSJ9JqOprpGt/aOamCOSy4O5Lif3DkeIJ/zM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 4.14 015/217] f2fs: fix potential overflow
Date:   Mon, 20 Sep 2021 18:40:36 +0200
Message-Id: <20210920163925.129646852@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163924.591371269@linuxfoundation.org>
References: <20210920163924.591371269@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

commit a9af3fdcc4258af406879eca63d82e9d6baa892e upstream.

In build_sit_entries(), if valid_blocks in SIT block is smaller than
valid_blocks in journal, for below calculation:

sbi->discard_blks += old_valid_blocks - se->valid_blocks;

There will be two times potential overflow:
- old_valid_blocks - se->valid_blocks will overflow, and be a very
large number.
- sbi->discard_blks += result will overflow again, comes out a correct
result accidently.

Anyway, it should be fixed.

Fixes: d600af236da5 ("f2fs: avoid unneeded loop in build_sit_entries")
Fixes: 1f43e2ad7bff ("f2fs: introduce CP_TRIMMED_FLAG to avoid unneeded discard")
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/segment.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -3337,14 +3337,17 @@ static int build_sit_entries(struct f2fs
 			} else {
 				memcpy(se->discard_map, se->cur_valid_map,
 							SIT_VBLOCK_MAP_SIZE);
-				sbi->discard_blks += old_valid_blocks -
-							se->valid_blocks;
+				sbi->discard_blks += old_valid_blocks;
+				sbi->discard_blks -= se->valid_blocks;
 			}
 		}
 
-		if (sbi->segs_per_sec > 1)
+		if (sbi->segs_per_sec > 1) {
 			get_sec_entry(sbi, start)->valid_blocks +=
-				se->valid_blocks - old_valid_blocks;
+							se->valid_blocks;
+			get_sec_entry(sbi, start)->valid_blocks -=
+							old_valid_blocks;
+		}
 	}
 	up_read(&curseg->journal_rwsem);
 


