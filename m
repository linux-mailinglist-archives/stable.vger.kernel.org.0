Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 057C338A409
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234649AbhETKAV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:00:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:59520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232754AbhETJ6G (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:58:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A342C6141D;
        Thu, 20 May 2021 09:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503498;
        bh=mn6rk5PFEi1IJN/e1MtilOrShk4Ts2LWoEIa5mbZdFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a/pIYXxX3ixRgbQCDeXw/Oyr9Zwnybf4OeB4CxL2aiNgkecSM4rLit05DEnGxuHvY
         Uu1jk6jvnzrSxPhvJIL1GnvqvnTZwlagJusLUNM4Z/I7rXTAKr1d7sqnMnCPIyRGaX
         JspX7R/3xeVKShrsU3YHQ5HsEevI2VDeQJXthvrI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 247/425] drivers/block/null_blk/main: Fix a double free in null_init.
Date:   Thu, 20 May 2021 11:20:16 +0200
Message-Id: <20210520092139.536803959@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
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
index 079ed33fd806..ba018f1da512 100644
--- a/drivers/block/null_blk_zoned.c
+++ b/drivers/block/null_blk_zoned.c
@@ -56,6 +56,7 @@ int null_zone_init(struct nullb_device *dev)
 void null_zone_exit(struct nullb_device *dev)
 {
 	kvfree(dev->zones);
+	dev->zones = NULL;
 }
 
 static void null_zone_fill_bio(struct nullb_device *dev, struct bio *bio,
-- 
2.30.2



