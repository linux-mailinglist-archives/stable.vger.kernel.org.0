Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6144575F5
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 18:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235158AbhKSRnV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 12:43:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:46564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232120AbhKSRnP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 12:43:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 958FF61A8A;
        Fri, 19 Nov 2021 17:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637343613;
        bh=hxWzZkEIe8x6oY4WovY4nINMmDxqVVv+ejl8OgkMoe8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wa8zWl8BOw/KJ9cdau63++nEUUYhZRBwDAwJE1LSqQgsQvHGJ4Pmas1zrxO6TJSyL
         OnypIrN/CjI12FUvhgD86+psu6c85BbGJZ6Kzqq4XSQJ7e8/LJzxtXwn9wC3RNxM1z
         fiqeF2E357Y3Qn3bFsRoKwhL8/RRJ5TG9Wls5ECw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        Jens Axboe <axboe@kernel.dk>,
        Tadeusz Struk <tadeusz.struk@linaro.org>
Subject: [PATCH 5.15 13/20] loop: Use blk_validate_block_size() to validate block size
Date:   Fri, 19 Nov 2021 18:39:31 +0100
Message-Id: <20211119171445.089760603@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211119171444.640508836@linuxfoundation.org>
References: <20211119171444.640508836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xie Yongji <xieyongji@bytedance.com>

commit af3c570fb0df422b4906ebd11c1bf363d89961d5 upstream.

Remove loop_validate_block_size() and use the block layer helper
to validate block size.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Link: https://lore.kernel.org/r/20211026144015.188-4-xieyongji@bytedance.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Cc: Tadeusz Struk <tadeusz.struk@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/loop.c |   17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -273,19 +273,6 @@ static void __loop_update_dio(struct loo
 }
 
 /**
- * loop_validate_block_size() - validates the passed in block size
- * @bsize: size to validate
- */
-static int
-loop_validate_block_size(unsigned short bsize)
-{
-	if (bsize < 512 || bsize > PAGE_SIZE || !is_power_of_2(bsize))
-		return -EINVAL;
-
-	return 0;
-}
-
-/**
  * loop_set_size() - sets device size and notifies userspace
  * @lo: struct loop_device to set the size for
  * @size: new size of the loop device
@@ -1236,7 +1223,7 @@ static int loop_configure(struct loop_de
 	}
 
 	if (config->block_size) {
-		error = loop_validate_block_size(config->block_size);
+		error = blk_validate_block_size(config->block_size);
 		if (error)
 			goto out_unlock;
 	}
@@ -1759,7 +1746,7 @@ static int loop_set_block_size(struct lo
 	if (lo->lo_state != Lo_bound)
 		return -ENXIO;
 
-	err = loop_validate_block_size(arg);
+	err = blk_validate_block_size(arg);
 	if (err)
 		return err;
 


