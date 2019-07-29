Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95E5679883
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388454AbfG2Thc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:37:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:52302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388714AbfG2Tha (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:37:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 086212171F;
        Mon, 29 Jul 2019 19:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429049;
        bh=4P2i2gaZ1antH6yCHEkpjWcNYzqo3v1guLr01cMlNC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jT2VXhtSh20kLuh45jJCN8PRyM+8D1C/EB1URDGL4ETtdKLcASg0mhp11o1reFJWD
         h+584Ksu5cj9JDwUznNx8Kt11pSdNOLxBuYXayxs9na7z73jXiapzzJbpf+AEvg9Iu
         bUTkZh/aSEXhhLhaQYC1pCtP/qQDjYLOy1esMjvE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ocean Chen <oceanchen@google.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 266/293] f2fs: avoid out-of-range memory access
Date:   Mon, 29 Jul 2019 21:22:37 +0200
Message-Id: <20190729190844.753195129@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



