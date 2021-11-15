Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5BE1450E1C
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240605AbhKOSKz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:10:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:46106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240009AbhKOSF3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:05:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D96236337B;
        Mon, 15 Nov 2021 17:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998097;
        bh=MwbZVDPdGRfxkLUSKP+bP0+bZv0GRE6qJPEW+sMlwHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Va2eTlTGljkYE0kOCc8DVA3+SX1zMA/npJq80IPzsl7j5VVnRbQqvYNL8S2EOC4/L
         9Pca7YGYSc011Ub9baJ3cUyrvi0TaDrDrHA9MbhMXSH29oSbQWEXwT/xUbtbQsw41S
         yZmA6352u1gCEH6yd/3RfeLOiKTVAmBTcaxoI/vA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 359/575] ataflop: potential out of bounds in do_format()
Date:   Mon, 15 Nov 2021 18:01:24 +0100
Message-Id: <20211115165356.225040124@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 1ffec389a6431782a8a28805830b6fae9bf00af1 ]

The function uses "type" as an array index:

	q = unit[drive].disk[type]->queue;

Unfortunately the bounds check on "type" isn't done until later in the
function.  Fix this by moving the bounds check to the start.

Fixes: bf9c0538e485 ("ataflop: use a separate gendisk for each media format")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ataflop.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/block/ataflop.c b/drivers/block/ataflop.c
index e6264db11e415..0a86f9d3a3798 100644
--- a/drivers/block/ataflop.c
+++ b/drivers/block/ataflop.c
@@ -726,8 +726,12 @@ static int do_format(int drive, int type, struct atari_format_descr *desc)
 	unsigned long	flags;
 	int ret;
 
-	if (type)
+	if (type) {
 		type--;
+		if (type >= NUM_DISK_MINORS ||
+		    minor2disktype[type].drive_types > DriveType)
+			return -EINVAL;
+	}
 
 	q = unit[drive].disk[type]->queue;
 	blk_mq_freeze_queue(q);
@@ -739,11 +743,6 @@ static int do_format(int drive, int type, struct atari_format_descr *desc)
 	local_irq_restore(flags);
 
 	if (type) {
-		if (type >= NUM_DISK_MINORS ||
-		    minor2disktype[type].drive_types > DriveType) {
-			ret = -EINVAL;
-			goto out;
-		}
 		type = minor2disktype[type].index;
 		UDT = &atari_disk_type[type];
 	}
-- 
2.33.0



