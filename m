Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84D8137C54D
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234276AbhELPjV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:39:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:50220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234025AbhELPcB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:32:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06466611BF;
        Wed, 12 May 2021 15:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832598;
        bh=vFX9eZvi+lb0MeCVc1y8kW+YWK9lE5PF9Yxev8r9MK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J6JJkjQlKUdmDrm7I5EzL3aN3oe0rcKSB43sRr3i4jB0TNWYdwSzS3+M/uwEdPaLp
         EOkq/9S84ft7QUlJIhH2Sp+mYE6Ta97UbsjyRD896/PGZ1cOeeA9SJQQ5plB4a1GNo
         xqsu/HwptGHiJoSOZoWfKEV9LdfJJeEqvu44JCzM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 346/530] drivers/block/null_blk/main: Fix a double free in null_init.
Date:   Wed, 12 May 2021 16:47:36 +0200
Message-Id: <20210512144831.161671623@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lv Yunlong <lyl2019@mail.ustc.edu.cn>

[ Upstream commit 72ce11ddfa4e9e1879103581a60b7e34547eaa0a ]

In null_init, null_add_dev(dev) is called.
In null_add_dev, it calls null_free_zoned_dev(dev) to free dev->zones
via kvfree(dev->zones) in out_cleanup_zone branch and returns err.
Then null_init accept the err code and then calls null_free_dev(dev).

But in null_free_dev(dev), dev->zones is freed again by
null_free_zoned_dev().

My patch set dev->zones to NULL in null_free_zoned_dev() after
kvfree(dev->zones) is called, to avoid the double free.

Fixes: 2984c8684f962 ("nullb: factor disk parameters")
Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Link: https://lore.kernel.org/r/20210426143229.7374-1-lyl2019@mail.ustc.edu.cn
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/null_blk_zoned.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/null_blk_zoned.c b/drivers/block/null_blk_zoned.c
index 172f720b8d63..f5df82c26c16 100644
--- a/drivers/block/null_blk_zoned.c
+++ b/drivers/block/null_blk_zoned.c
@@ -149,6 +149,7 @@ void null_free_zoned_dev(struct nullb_device *dev)
 {
 	bitmap_free(dev->zone_locks);
 	kvfree(dev->zones);
+	dev->zones = NULL;
 }
 
 static inline void null_lock_zone(struct nullb_device *dev, unsigned int zno)
-- 
2.30.2



