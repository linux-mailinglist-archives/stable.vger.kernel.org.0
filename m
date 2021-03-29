Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA2A34C9F8
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234026AbhC2Iee (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:34:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:52660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234654AbhC2IdY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:33:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F2DF619CB;
        Mon, 29 Mar 2021 08:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006767;
        bh=vK3bL2CcSFq5WbG8CncNPHnxHxR2Mf+H4mNZPynxhXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FF31VOuj8+oxBDHxD2DuRkNVjQDgWYzyXmE36Kilkvz7fUqz4yCBaNQ5GKbargZWa
         KXxj266u4dcYLmwzrh3zs4KvrBg6OPMyvmgR+E7P1rqrqsXB9f1xEPjBBtvS9TqZw8
         LxLdP0y82OJ0V0tgt7a6OaY5ovCGVT0rGZRI5ATQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 042/254] block: Fix REQ_OP_ZONE_RESET_ALL handling
Date:   Mon, 29 Mar 2021 09:55:58 +0200
Message-Id: <20210329075634.531956917@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index df0ecf6790d3..fc925f73d694 100644
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



