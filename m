Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9974FCAC3C
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732900AbfJCQHM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:07:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:54880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732896AbfJCQHL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:07:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B9A3215EA;
        Thu,  3 Oct 2019 16:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118831;
        bh=mHXwAPPYFfViVZ1f2smTpzXkHdCN1X+YpOEyrOCoclY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e9+oHrm6+MCXbVMlrmJ4XQG4rkon6JDyOAVSz09g88ItGqabxW9m0WCLcgrd4wG4i
         xHWLQpXwRHpsl1EASYU6LFbrolgfhV3MUw6PeOtDrhKHJKHxpqX6PP0alwgaLOdRgU
         EmHU++Wg3i9YiAe1C6EhkrHEfjNWKtk+OgT0x57E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 025/185] Revert "f2fs: avoid out-of-range memory access"
Date:   Thu,  3 Oct 2019 17:51:43 +0200
Message-Id: <20191003154443.366504907@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154437.541662648@linuxfoundation.org>
References: <20191003154437.541662648@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit a37d0862d17411edb67677a580a6f505ec2225f6 ]

As Pavel Machek reported:

"We normally use -EUCLEAN to signal filesystem corruption. Plus, it is
good idea to report it to the syslog and mark filesystem as "needing
fsck" if filesystem can do that."

Still we need improve the original patch with:
- use unlikely keyword
- add message print
- return EUCLEAN

However, after rethink this patch, I don't think we should add such
condition check here as below reasons:
- We have already checked the field in f2fs_sanity_check_ckpt(),
- If there is fs corrupt or security vulnerability, there is nothing
to guarantee the field is integrated after the check, unless we do
the check before each of its use, however no filesystem does that.
- We only have similar check for bitmap, which was added due to there
is bitmap corruption happened on f2fs' runtime in product.
- There are so many key fields in SB/CP/NAT did have such check
after f2fs_sanity_check_{sb,cp,..}.

So I propose to revert this unneeded check.

This reverts commit 56f3ce675103e3fb9e631cfb4131fc768bc23e9a.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 18d51c36a5e32..70bd15cadb44e 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -2612,11 +2612,6 @@ static int read_compacted_summaries(struct f2fs_sb_info *sbi)
 		seg_i = CURSEG_I(sbi, i);
 		segno = le32_to_cpu(ckpt->cur_data_segno[i]);
 		blk_off = le16_to_cpu(ckpt->cur_data_blkoff[i]);
-		if (blk_off > ENTRIES_IN_SUM) {
-			f2fs_bug_on(sbi, 1);
-			f2fs_put_page(page, 1);
-			return -EFAULT;
-		}
 		seg_i->next_segno = segno;
 		reset_curseg(sbi, i, 0);
 		seg_i->alloc_type = ckpt->alloc_type[i];
-- 
2.20.1



