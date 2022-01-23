Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36CCC496F2B
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 01:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235577AbiAWAQ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jan 2022 19:16:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231836AbiAWAPi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jan 2022 19:15:38 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B40EC061768;
        Sat, 22 Jan 2022 16:13:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F0ECECE0AD1;
        Sun, 23 Jan 2022 00:13:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90FD7C004E1;
        Sun, 23 Jan 2022 00:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642896831;
        bh=izXuRLTqqf53tu6dekzU+DqbvdILLQrv0sYd8FrFK8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XoEEIsCEaSl854DrQLPfdYTinF5Qxo1n5AzmB2Z8alEmuygXb6PgwcSHknADe1wif
         vJsBJ5tf2dCH+t4PbjU52p+dIxj/9WxjkQaOk3wsIBV/Rol6Yxyz8MKnW8sHVXWfcK
         d9uefpz1LqCh9GH5JsmbpwI1pHs0YCaGaUB4s9IQHmDNASAGUSAhB0A6qRmnedGGd4
         fr79SC+cmBz5DaZDz8/kuK8mAnTFtTmANKuOqnfwxpTjoDC1ovyVgoQmCTsLELxYNc
         MiKqxj2XoXgBFpTJ4flj0ibAtQqY8EOrGAi+AQZzM8GdYl+2Vg4WYycRpqMQN1fbiO
         TmBtHh5G57JWQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        syzbot+ac94ae5f68b84197f41c@syzkaller.appspotmail.com,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 8/8] block: Fix wrong offset in bio_truncate()
Date:   Sat, 22 Jan 2022 19:13:23 -0500
Message-Id: <20220123001323.2460719-8-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220123001323.2460719-1-sashal@kernel.org>
References: <20220123001323.2460719-1-sashal@kernel.org>
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
index cb38d6f3acceb..1c52d0196e15c 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -569,7 +569,8 @@ void bio_truncate(struct bio *bio, unsigned new_size)
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

