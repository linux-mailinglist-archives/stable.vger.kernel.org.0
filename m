Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE6156DCFC
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388956AbfGSEMq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:12:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:48244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388933AbfGSEMo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:12:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA94F218E0;
        Fri, 19 Jul 2019 04:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509563;
        bh=4oix9x7A/tqf3jdGjWpv3BVILSw+e5mGGDNcbkJd5vQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a7NZJncvgUQ4enC81DZJy7mVsYCnFkt25Zcu4yZJZVECWKBXFijiie/UtKm+VU+0M
         xUnFJxIoL2XlZsRVWl1N3vWD6JKPWfd+4y/S/IuBBJ+328hgmxq6oj6i2a0eDtfkTK
         XLQmoN4gfkNiH5B9mB/qEIf4UESibKUdCgYqLbn0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ocean Chen <oceanchen@google.com>, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.14 49/60] f2fs: avoid out-of-range memory access
Date:   Fri, 19 Jul 2019 00:10:58 -0400
Message-Id: <20190719041109.18262-49-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719041109.18262-1-sashal@kernel.org>
References: <20190719041109.18262-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ocean Chen <oceanchen@google.com>

[ Upstream commit 56f3ce675103e3fb9e631cfb4131fc768bc23e9a ]

blkoff_off might over 512 due to fs corrupt or security
vulnerability. That should be checked before being using.

Use ENTRIES_IN_SUM to protect invalid value in cur_data_blkoff.

Signed-off-by: Ocean Chen <oceanchen@google.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 70bd15cadb44..18d51c36a5e3 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -2612,6 +2612,11 @@ static int read_compacted_summaries(struct f2fs_sb_info *sbi)
 		seg_i = CURSEG_I(sbi, i);
 		segno = le32_to_cpu(ckpt->cur_data_segno[i]);
 		blk_off = le16_to_cpu(ckpt->cur_data_blkoff[i]);
+		if (blk_off > ENTRIES_IN_SUM) {
+			f2fs_bug_on(sbi, 1);
+			f2fs_put_page(page, 1);
+			return -EFAULT;
+		}
 		seg_i->next_segno = segno;
 		reset_curseg(sbi, i, 0);
 		seg_i->alloc_type = ckpt->alloc_type[i];
-- 
2.20.1

