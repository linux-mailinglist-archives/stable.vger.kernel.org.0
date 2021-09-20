Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98D7C4120FE
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356708AbhITSBG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:01:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:57188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356263AbhITR7F (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:59:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7BFE1619E9;
        Mon, 20 Sep 2021 17:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158125;
        bh=GtS+MMkWgp999l+GrKKbBpEiBmli5o+aicXaKShSfpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sB9j0+OFWbkj+FkjaPefoLUU86eyK0SQ5kSzTl8ps/P3Hb3dlAEMd7SXbYlZCyrxR
         hDwonVt5B/gjGCjInQ1VVLlDrdZQ1loifXwdyrGUpzEai0sIwXs2Px+m3oM1nNg3wx
         AzycfVirfctCSGCfg7yt4k3seetrh1qmYenbSSzg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Aravind Ramesh <aravind.ramesh@wdc.com>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.4 004/260] blk-zoned: allow zone management send operations without CAP_SYS_ADMIN
Date:   Mon, 20 Sep 2021 18:40:22 +0200
Message-Id: <20210920163931.278620855@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

commit ead3b768bb51259e3a5f2287ff5fc9041eb6f450 upstream.

Zone management send operations (BLKRESETZONE, BLKOPENZONE, BLKCLOSEZONE
and BLKFINISHZONE) should be allowed under the same permissions as write().
(write() does not require CAP_SYS_ADMIN).

Additionally, other ioctls like BLKSECDISCARD and BLKZEROOUT only check if
the fd was successfully opened with FMODE_WRITE.
(They do not require CAP_SYS_ADMIN).

Currently, zone management send operations require both CAP_SYS_ADMIN
and that the fd was successfully opened with FMODE_WRITE.

Remove the CAP_SYS_ADMIN requirement, so that zone management send
operations match the access control requirement of write(), BLKSECDISCARD
and BLKZEROOUT.

Fixes: 3ed05a987e0f ("blk-zoned: implement ioctls")
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Aravind Ramesh <aravind.ramesh@wdc.com>
Reviewed-by: Adam Manzanares <a.manzanares@samsung.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: stable@vger.kernel.org # v4.10+
Link: https://lore.kernel.org/r/20210811110505.29649-2-Niklas.Cassel@wdc.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-zoned.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -374,9 +374,6 @@ int blkdev_reset_zones_ioctl(struct bloc
 	if (!blk_queue_is_zoned(q))
 		return -ENOTTY;
 
-	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
-
 	if (!(mode & FMODE_WRITE))
 		return -EBADF;
 


