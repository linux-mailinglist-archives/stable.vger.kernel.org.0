Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44A3D411D86
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348973AbhITRVI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:21:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:47440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348471AbhITRTY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:19:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9350961A52;
        Mon, 20 Sep 2021 17:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157205;
        bh=KA2P9HLThtfHkI7JeJ8fTjJdaRFBnGUqTzcKlLwUtNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hBxdqdSSAExeIxEGdoGW0ICDpXAul//M7BczA1oXB+0vzdujp0+X375ZbtrmOy7AT
         a+TsxK64mUYaCEY7QipTf/kuzYMxCuHwFLKFFAJO9lbk92jTaMT7rvOZnrKof4o9+N
         j7JOBW05ycX9aKilZd1Kh1slLR+UhwShmXxcv+EE=
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
Subject: [PATCH 4.14 100/217] blk-zoned: allow BLKREPORTZONE without CAP_SYS_ADMIN
Date:   Mon, 20 Sep 2021 18:42:01 +0200
Message-Id: <20210920163928.024579138@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163924.591371269@linuxfoundation.org>
References: <20210920163924.591371269@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

commit 4d643b66089591b4769bcdb6fd1bfeff2fe301b8 upstream.

A user space process should not need the CAP_SYS_ADMIN capability set
in order to perform a BLKREPORTZONE ioctl.

Getting the zone report is required in order to get the write pointer.
Neither read() nor write() requires CAP_SYS_ADMIN, so it is reasonable
that a user space process that can read/write from/to the device, also
can get the write pointer. (Since e.g. writes have to be at the write
pointer.)

Fixes: 3ed05a987e0f ("blk-zoned: implement ioctls")
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Aravind Ramesh <aravind.ramesh@wdc.com>
Reviewed-by: Adam Manzanares <a.manzanares@samsung.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: stable@vger.kernel.org # v4.10+
Link: https://lore.kernel.org/r/20210811110505.29649-3-Niklas.Cassel@wdc.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-zoned.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -277,9 +277,6 @@ int blkdev_report_zones_ioctl(struct blo
 	if (!blk_queue_is_zoned(q))
 		return -ENOTTY;
 
-	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
-
 	if (copy_from_user(&rep, argp, sizeof(struct blk_zone_report)))
 		return -EFAULT;
 


