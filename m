Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21607450E95
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:14:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237845AbhKOSQl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:16:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:50078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240638AbhKOSLd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:11:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC9BF633C1;
        Mon, 15 Nov 2021 17:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998446;
        bh=3KtkX4JAl/kdbTm3RAf6AbO9QtZkvVrg2VGbFj2toAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TiYEefq+0lADO4CXxmeFybcWUNcfr3uagu3f2t5l0M65pFtDpln9DX4b/5cbyjmyD
         01RKj7/UFCbU8k8RnaoWgM6vDWDa1O4B+seU1giUTQhDco9zHrJfn/5M3AmMTK/Er7
         zpcbWOu+Ug3ogA+ocxXygCzeGDeyhfkVGSA3QPCA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 513/575] block/ataflop: use the blk_cleanup_disk() helper
Date:   Mon, 15 Nov 2021 18:03:58 +0100
Message-Id: <20211115165401.423670097@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luis Chamberlain <mcgrof@kernel.org>

[ Upstream commit 44a469b6acae6ad05c4acca8429467d1d50a8b8d ]

Use the helper to replace two lines with one.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Link: https://lore.kernel.org/r/20210927220302.1073499-12-mcgrof@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ataflop.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/block/ataflop.c b/drivers/block/ataflop.c
index 94b76c254db9b..359417a016e43 100644
--- a/drivers/block/ataflop.c
+++ b/drivers/block/ataflop.c
@@ -2102,8 +2102,7 @@ static int __init atari_floppy_init (void)
 
 err:
 	while (--i >= 0) {
-		blk_cleanup_queue(unit[i].disk[0]->queue);
-		put_disk(unit[i].disk[0]);
+		blk_cleanup_disk(unit[i].disk[0]);
 		blk_mq_free_tag_set(&unit[i].tag_set);
 	}
 
@@ -2161,8 +2160,7 @@ static void __exit atari_floppy_exit(void)
 			if (!unit[i].disk[type])
 				continue;
 			del_gendisk(unit[i].disk[type]);
-			blk_cleanup_queue(unit[i].disk[type]->queue);
-			put_disk(unit[i].disk[type]);
+			blk_cleanup_disk(unit[i].disk[type]);
 		}
 		blk_mq_free_tag_set(&unit[i].tag_set);
 	}
-- 
2.33.0



