Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CBD433E392
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 01:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbhCQA5H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:57:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:33544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230425AbhCQA41 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:56:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCA0D64F97;
        Wed, 17 Mar 2021 00:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942586;
        bh=EHVD1Bszn93nsf/vciw4KnHQG2gd8dz9190jW55PaE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BmDUXbQ/bCuWoBWxlUq4pHWCdJ969sObmhyK2MGJI1Be9O68rRMCg8YwPGF32m3Db
         J405Igj0oDoOcsF/1DMsQPHc2s3/HRvdIBkqcqwFOseTn+fDzxBJvT4HrLp21TXaeG
         iPbGefjIBmFbGU/HbN/xjJ04bmBMjlWv56XinuNUmRYmLjFTBl8zQiaraE96iZffyJ
         9FOOOhoqNOww76PTKK3Lt8axlZTy2AZue0/5gpRjkYFYUHRa6qkwxYrvDYopywfzT9
         1AvvYTRUW3pACgUc0Lv5iqHya+7W3YiIu3hknXjpPMmjVJ1GczEv/Qr+qxK+jsUxBK
         D55Bs0I90H5DQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Damien Le Moal <damien.lemoal@wdc.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 42/61] block: Fix REQ_OP_ZONE_RESET_ALL handling
Date:   Tue, 16 Mar 2021 20:55:16 -0400
Message-Id: <20210317005536.724046-42-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005536.724046-1-sashal@kernel.org>
References: <20210317005536.724046-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@wdc.com>

[ Upstream commit faa44c69daf9ccbd5b8a1aee13e0e0d037c0be17 ]

Similarly to a single zone reset operation (REQ_OP_ZONE_RESET), execute
REQ_OP_ZONE_RESET_ALL operations with REQ_SYNC set.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-zoned.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 7a68b6e4300c..f1683f10b020 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -240,7 +240,7 @@ int blkdev_zone_mgmt(struct block_device *bdev, enum req_opf op,
 		 */
 		if (op == REQ_OP_ZONE_RESET &&
 		    blkdev_allow_reset_all_zones(bdev, sector, nr_sectors)) {
-			bio->bi_opf = REQ_OP_ZONE_RESET_ALL;
+			bio->bi_opf = REQ_OP_ZONE_RESET_ALL | REQ_SYNC;
 			break;
 		}
 
-- 
2.30.1

