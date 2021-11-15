Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F00BD45126E
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346621AbhKOTfv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:35:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:44632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244790AbhKOTRc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:17:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0005160EFE;
        Mon, 15 Nov 2021 18:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000631;
        bh=a+2VaIAUuFNi6Rt63CHFe68YFV8drM28h/4vPQdTEKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kk+CjVgmmbgbtIGN/kLPb3i6+24/SXkFE4sfXrm1UZZoqaNSLOeKyui8CmPbo8+z1
         /oyEA+ay5EJRwsGENC5act9IjvD92X37/EawvB7J7bYA70kGgWfsxAE6Gj9jwYrpw0
         Krbbb1KsPleIZlRL5DsjGt7FcA0ODRFeOcvrHuJM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 732/849] block/ataflop: use the blk_cleanup_disk() helper
Date:   Mon, 15 Nov 2021 18:03:35 +0100
Message-Id: <20211115165445.011536138@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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
index 4947e41f89b7d..1a908455ff96f 100644
--- a/drivers/block/ataflop.c
+++ b/drivers/block/ataflop.c
@@ -2097,8 +2097,7 @@ static int __init atari_floppy_init (void)
 
 err:
 	while (--i >= 0) {
-		blk_cleanup_queue(unit[i].disk[0]->queue);
-		put_disk(unit[i].disk[0]);
+		blk_cleanup_disk(unit[i].disk[0]);
 		blk_mq_free_tag_set(&unit[i].tag_set);
 	}
 
@@ -2156,8 +2155,7 @@ static void __exit atari_floppy_exit(void)
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



