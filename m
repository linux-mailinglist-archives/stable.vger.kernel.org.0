Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7566840DEEA
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240269AbhIPQFN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:05:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:44334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240502AbhIPQFM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:05:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D2BE60232;
        Thu, 16 Sep 2021 16:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808231;
        bh=vIi+KtSITgBFVphFihL+2DklvZnOUJyzR4klBHNI5h8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YCHAmlryj8bY0sFh/OQ41JaZkPrlwiSsgTZo3Hf7AWya5frudjtWZCKtE3MDj2dLZ
         XiaIPKxNa8u/aK4JDalxW72vgkclGXGlVuCkUa3thtAm8EnZr9fNgKzNvrXxdrvjqC
         D5tTlTgRLP8NHyvSGXhUOhVHS65cQN13nyBggn0o=
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
Subject: [PATCH 5.10 010/306] blk-zoned: allow BLKREPORTZONE without CAP_SYS_ADMIN
Date:   Thu, 16 Sep 2021 17:55:55 +0200
Message-Id: <20210916155754.270690596@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
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
@@ -296,9 +296,6 @@ int blkdev_report_zones_ioctl(struct blo
 	if (!blk_queue_is_zoned(q))
 		return -ENOTTY;
 
-	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
-
 	if (copy_from_user(&rep, argp, sizeof(struct blk_zone_report)))
 		return -EFAULT;
 


