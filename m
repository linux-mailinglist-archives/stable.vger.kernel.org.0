Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6DDF3FB580
	for <lists+stable@lfdr.de>; Mon, 30 Aug 2021 14:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236829AbhH3MEp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 08:04:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:48524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236797AbhH3MBP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Aug 2021 08:01:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BAB66117A;
        Mon, 30 Aug 2021 12:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630324817;
        bh=Xul5IBRdGFdvKaXnW2vbVJHMh8bEFMV50GdRfD1BXfY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=atkf8cq9fUsd+q2ejhWNNTnDC0tinwtRVXAag6x1Dt4PO1JfdxRqwMBXBx7pPjpZe
         XXqLmAQxPJgGnmFZ8RpOJwely7fxpYFtJePrdOb5Mkk2Isj/XqWbZtcUUiedULGkSi
         8iePcvSLjkoyBiaPuDDutd34RFpBWCCrXfd4uQDM3axdiiCJ6WiQDvPf5aWegoZAdO
         oNBbkdJtuRFpOa0uO3/oicB9ZRQeBG8derUYh2DBUng0lJGW+lBVZz4b9Z23G8HBQ+
         ZEAnp+97V20rlU7SWOG8O7dPiSw+8R127/mB8hjXdjXTqcUSdsSir4Xc7p79clvND4
         TRuktm/WKfLvQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 11/11] cryptoloop: add a deprecation warning
Date:   Mon, 30 Aug 2021 08:00:02 -0400
Message-Id: <20210830120002.1017700-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210830120002.1017700-1-sashal@kernel.org>
References: <20210830120002.1017700-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 222013f9ac30b9cec44301daa8dbd0aae38abffb ]

Support for cryptoloop has been officially marked broken and deprecated
in favor of dm-crypt (which supports the same broken algorithms if
needed) in Linux 2.6.4 (released in March 2004), and support for it has
been entirely removed from losetup in util-linux 2.23 (released in April
2013).  Add a warning and a deprecation schedule.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20210827163250.255325-1-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/Kconfig      | 4 ++--
 drivers/block/cryptoloop.c | 2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index f40ebe9f5047..f2548049aa0e 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -230,7 +230,7 @@ config BLK_DEV_LOOP_MIN_COUNT
 	  dynamically allocated with the /dev/loop-control interface.
 
 config BLK_DEV_CRYPTOLOOP
-	tristate "Cryptoloop Support"
+	tristate "Cryptoloop Support (DEPRECATED)"
 	select CRYPTO
 	select CRYPTO_CBC
 	depends on BLK_DEV_LOOP
@@ -242,7 +242,7 @@ config BLK_DEV_CRYPTOLOOP
 	  WARNING: This device is not safe for journaled file systems like
 	  ext3 or Reiserfs. Please use the Device Mapper crypto module
 	  instead, which can be configured to be on-disk compatible with the
-	  cryptoloop device.
+	  cryptoloop device.  cryptoloop support will be removed in Linux 5.16.
 
 source "drivers/block/drbd/Kconfig"
 
diff --git a/drivers/block/cryptoloop.c b/drivers/block/cryptoloop.c
index 3cabc335ae74..f0a91faa43a8 100644
--- a/drivers/block/cryptoloop.c
+++ b/drivers/block/cryptoloop.c
@@ -189,6 +189,8 @@ init_cryptoloop(void)
 
 	if (rc)
 		printk(KERN_ERR "cryptoloop: loop_register_transfer failed\n");
+	else
+		pr_warn("the cryptoloop driver has been deprecated and will be removed in in Linux 5.16\n");
 	return rc;
 }
 
-- 
2.30.2

