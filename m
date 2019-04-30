Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5399F79A
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 14:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730397AbfD3Lpd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:45:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:57826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730412AbfD3Lpc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:45:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83CAA21670;
        Tue, 30 Apr 2019 11:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624732;
        bh=SAKPEEYub/KbxrzvuSF0mqml4c6b15bwxKqcb4l6Wxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jxDq+mM1RYTkgYwIW01XjW0axfTksbam+liS9d/eaOXBPKUGrvUg6OVqPbFj/4vdh
         wOzOpnqFP94C3+LvG9Spi/IItnxDKgfycqoqwkBkiuA0ITHYQ7er40zWea8ozCnJyq
         +z5QDhWwAfby/nkrQivCjdh7fnPQ/TFuX/d8LriE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongli Zhang <dongli.zhang@oracle.com>,
        Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 016/100] loop: do not print warn message if partition scan is successful
Date:   Tue, 30 Apr 2019 13:37:45 +0200
Message-Id: <20190430113609.361897912@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113608.616903219@linuxfoundation.org>
References: <20190430113608.616903219@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 40853d6fc619a6fd3d3177c3973a2eac9b598a80 ]

Do not print warn message when the partition scan returns 0.

Fixes: d57f3374ba48 ("loop: Move special partition reread handling in loop_clr_fd()")
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/loop.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index a63da9e07341..f1e63eb7cbca 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1112,8 +1112,9 @@ out_unlock:
 			err = __blkdev_reread_part(bdev);
 		else
 			err = blkdev_reread_part(bdev);
-		pr_warn("%s: partition scan of loop%d failed (rc=%d)\n",
-			__func__, lo_number, err);
+		if (err)
+			pr_warn("%s: partition scan of loop%d failed (rc=%d)\n",
+				__func__, lo_number, err);
 		/* Device is gone, no point in returning error */
 		err = 0;
 	}
-- 
2.19.1



