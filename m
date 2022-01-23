Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7D0496EDC
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 01:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235880AbiAWAOx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jan 2022 19:14:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235421AbiAWANu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jan 2022 19:13:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25F0EC0613EF;
        Sat, 22 Jan 2022 16:12:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8D8B60DCB;
        Sun, 23 Jan 2022 00:12:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51545C36AE3;
        Sun, 23 Jan 2022 00:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642896777;
        bh=VmLhdCS4KUMyAmSPEGWU9WdfoMa100y8oyPOd1Cd6vE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mHEdqksGgcMg3po5kgb+cXppN83fZSpfYU6WEJSfE8myAkCIZ7BP+luJtiX2hXMP4
         GeCqZzVux3BYCpyK9j02FMOc7WJbfAxqZWuPQAHOe9oygEhb/TbEDNvjqC4nfg6Y1W
         8SAMdyQraQpV765lxu4EAv+mT5Ij6ZUIkbssZjCdqWtxGbWTZABdGlrZAG8eepv3pc
         bgvgcFk/53ZbaKwHdOS204/nz2+WTL8lmjRRE59J7RR1OPsGq+KxxnZ4bjj2pleqZp
         u6/Mu/anpkTQFhWbPX3IfbMH5ujDMFmAHLpmD8XPCvjgKmlB0M/VSO5pzIgQ29nnSg
         K5WzaN2s+Sn4g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        syzbot+ac94ae5f68b84197f41c@syzkaller.appspotmail.com,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 16/16] block: Fix wrong offset in bio_truncate()
Date:   Sat, 22 Jan 2022 19:12:15 -0500
Message-Id: <20220123001216.2460383-16-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220123001216.2460383-1-sashal@kernel.org>
References: <20220123001216.2460383-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

[ Upstream commit 3ee859e384d453d6ac68bfd5971f630d9fa46ad3 ]

bio_truncate() clears the buffer outside of last block of bdev, however
current bio_truncate() is using the wrong offset of page. So it can
return the uninitialized data.

This happened when both of truncated/corrupted FS and userspace (via
bdev) are trying to read the last of bdev.

Reported-by: syzbot+ac94ae5f68b84197f41c@syzkaller.appspotmail.com
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/875yqt1c9g.fsf@mail.parknet.co.jp
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/bio.c b/block/bio.c
index a6fb6a0b42955..25f1ed261100b 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -567,7 +567,8 @@ void bio_truncate(struct bio *bio, unsigned new_size)
 				offset = new_size - done;
 			else
 				offset = 0;
-			zero_user(bv.bv_page, offset, bv.bv_len - offset);
+			zero_user(bv.bv_page, bv.bv_offset + offset,
+				  bv.bv_len - offset);
 			truncated = true;
 		}
 		done += bv.bv_len;
-- 
2.34.1

