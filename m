Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DEFE496F19
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 01:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231995AbiAWAQX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jan 2022 19:16:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235649AbiAWAOe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jan 2022 19:14:34 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0FEAC0617BF;
        Sat, 22 Jan 2022 16:13:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B750ACE0025;
        Sun, 23 Jan 2022 00:13:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E59C340E2;
        Sun, 23 Jan 2022 00:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642896803;
        bh=sRFbfziYn/GXziu1+HwHd/arn8ZkRrexYZMBH0GRhpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dCVHQs8Ve+cSPdqfTU9rACArpCOC1lwB9DSj/HHEtO7TYr89fYsuRquUq9Hr7tEmN
         DV5VLXim2cMnLUjr7RD7oYSrXFeSZHdbX27eNefB85TIOK1vtL3li+xOXhNlY1bqUs
         sf/uU8oBsoFN4NJpICQSgBWhugtAXLxRU0HmV5BcNt1LGKorylbmkXhn00t+YKmPqg
         JIsFkgIJ/KiSvW8eonC+xS48AgYeOhfkm5rvtYhmsLsxp3T5ykuHuhBV0k5Zuh/C9f
         i4XViBx64v3nByTsQyEtgqFFH2d1EURp0gFS19tSMpOc17Mg8Js4gPhus6nA2ekPXo
         X/WBCJJ2vjdcg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        syzbot+ac94ae5f68b84197f41c@syzkaller.appspotmail.com,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 9/9] block: Fix wrong offset in bio_truncate()
Date:   Sat, 22 Jan 2022 19:12:58 -0500
Message-Id: <20220123001258.2460594-9-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220123001258.2460594-1-sashal@kernel.org>
References: <20220123001258.2460594-1-sashal@kernel.org>
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
index 0703a208ca248..f8d26ce7b61b0 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -575,7 +575,8 @@ void bio_truncate(struct bio *bio, unsigned new_size)
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

