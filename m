Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12CCF33E41B
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 02:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231844AbhCQA6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:58:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:36026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231428AbhCQA5s (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:57:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16D6965001;
        Wed, 17 Mar 2021 00:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942661;
        bh=56uNLpGhow18UAxJYzyNBOTBjBLlIqWJDSkel4S87w4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NIrBvD3cvzPmx3LMXQYTARDM5YmAw5+1RiMg+RLhqlLkZi8CW+++3rNGZtmvFR0js
         YaayNFF3UQZ1gjvQiPk8216JLldk6RPrVYcXJ51Flb39cR4koHxAr57bcIOLLEdV1T
         gjlYo9czE3JaFODg31DYDaLo2BsxcYgTHrPE3p+CCjbIxmVX0TUs2oa8IMVZ1+EsTY
         q76iLXHVRwQjXM6qsmDSkNch2V51iyEfIEIRlaL9JqCFFhh/YPmjWTdhEnuomvberA
         v9E3kWZahWNmaav7pROYybpkgRa9wP51i5I7iowyloPGKbgcscGWaZ+SrJIfLlEdiB
         bDGx+KPwfgFDg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Damien Le Moal <damien.lemoal@wdc.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 39/54] block: Fix REQ_OP_ZONE_RESET_ALL handling
Date:   Tue, 16 Mar 2021 20:56:38 -0400
Message-Id: <20210317005654.724862-39-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005654.724862-1-sashal@kernel.org>
References: <20210317005654.724862-1-sashal@kernel.org>
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
index 6817a673e5ce..f81eac647feb 100644
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

