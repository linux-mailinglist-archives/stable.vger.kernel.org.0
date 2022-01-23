Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7698C496E89
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 01:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235198AbiAWANA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jan 2022 19:13:00 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36544 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235193AbiAWAMP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jan 2022 19:12:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 542E260F9F;
        Sun, 23 Jan 2022 00:12:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE1C1C340E2;
        Sun, 23 Jan 2022 00:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642896734;
        bh=fZypQpgkRfInoHjS2iRjdcBucBEwTWKnEXuwoq78lFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p32UkSUEoYFwR5iF6/gwU2slKJ0zQv9fLe1ZfuzH89ek4VJcFo0Kllt0P+d1JKaGT
         UtVaRcN4dBpAvM76+fgPfPLQ3C0se342z0JFhJL4x4TsCXdn7hvxX5iH33Vy34rqMq
         bTM7UwN6bcZDhi4pvfCmM9OhDHh1HE95ctlfiN8A12rXDRogIcCPxsyYuipRyGAQYW
         lDAAxgGkHRpXN2ybN4RrHTTIRPVD9L3YeVUJeGel7ETgkGdV3eyj6Tq+sjBBfdRuE9
         Q59VYzO/anXrssC7JN39B5U/2pY69W7H2PhbbXKjCxzSNZA1q6TCUus/M/Jug4ji5p
         0Rz5ZfYCguikw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        syzbot+ac94ae5f68b84197f41c@syzkaller.appspotmail.com,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 19/19] block: Fix wrong offset in bio_truncate()
Date:   Sat, 22 Jan 2022 19:11:12 -0500
Message-Id: <20220123001113.2460140-19-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220123001113.2460140-1-sashal@kernel.org>
References: <20220123001113.2460140-1-sashal@kernel.org>
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
index 15ab0d6d1c06e..99cad261ec531 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -569,7 +569,8 @@ static void bio_truncate(struct bio *bio, unsigned new_size)
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

