Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD64D34C7F5
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232905AbhC2IS4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:18:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:34208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231769AbhC2ISK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:18:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC5D861613;
        Mon, 29 Mar 2021 08:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005886;
        bh=XifRrMrxCJg43rByW+sMjpAN3EOVGEybq7XVqXaYOW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1RYYYXf45AK7QpmY/o6rs8mGaA/aBZc7G83cnnNP14LQiex4fTXtEL+qN6kYgV0g1
         ELeh8Wf16/etBbiosv87ypE/9d8fDumVKFfL6neuWBi5gqsMobxH3MOu3CasmYBscz
         5e9topCt4OJawnroUwXY7cu4JtWolq2BOYDpPJug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 041/221] block: Fix REQ_OP_ZONE_RESET_ALL handling
Date:   Mon, 29 Mar 2021 09:56:12 +0200
Message-Id: <20210329075630.554463458@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
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
index 4676c6f00489..ab7d7ebcf6dd 100644
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



