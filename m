Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3040D411FB0
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353155AbhITRn7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:43:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:48732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352753AbhITRlk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:41:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9141761B4F;
        Mon, 20 Sep 2021 17:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157718;
        bh=jgTnWG7ziQ4HdX8OUDfsP/d5R/A9x0yiHuW/ALPsHu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QEWAQB9QEZ8UIGT0XREozaVsaSyPz9ae3YjsrvOA46IHyRH+gz9ZOBcLFfl7kq/c/
         Y3jnFsNbZpHVIEwom7k+rCtWYKyC9Iin+a6jYdU4pqU/LkdKO4Z0NXlFFCcO+3pDFk
         7Q5WyjFt6oOtRz6X7MO7fB3Clck+ZhgGt7XhSuLg=
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
Subject: [PATCH 4.19 120/293] blk-zoned: allow zone management send operations without CAP_SYS_ADMIN
Date:   Mon, 20 Sep 2021 18:41:22 +0200
Message-Id: <20210920163937.365135673@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
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
@@ -380,9 +380,6 @@ int blkdev_reset_zones_ioctl(struct bloc
 	if (!blk_queue_is_zoned(q))
 		return -ENOTTY;
 
-	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
-
 	if (!(mode & FMODE_WRITE))
 		return -EBADF;
 


