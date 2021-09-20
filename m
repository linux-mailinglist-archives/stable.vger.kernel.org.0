Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F352411B77
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239422AbhITQ6z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:58:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:45174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343683AbhITQ4n (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:56:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 689CB61350;
        Mon, 20 Sep 2021 16:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156686;
        bh=7DcOuY0O7gWl9b7yzExv33fKZSCdPDnTi+RIBRHA8Og=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p6Q7pkUMCuxlMjAucbAHQP4F7w9mpuAUgOsBkSr3pLs0x6hnEMozRCc2MqFLaKH8g
         wPQPgeVAIXF74piIE9HUoM7tzZUHY1zAEaXAJQmRzjbIXvuhRF4082mbfo8iUKDcG1
         0/XVuytp39uC9dTBVoRAgbTHZAu/2Sx0u877zroA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 007/175] cryptoloop: add a deprecation warning
Date:   Mon, 20 Sep 2021 18:40:56 +0200
Message-Id: <20210920163918.308651739@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163918.068823680@linuxfoundation.org>
References: <20210920163918.068823680@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 894102fd5a06..b701c79f07e5 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -257,7 +257,7 @@ config BLK_DEV_LOOP_MIN_COUNT
 	  dynamically allocated with the /dev/loop-control interface.
 
 config BLK_DEV_CRYPTOLOOP
-	tristate "Cryptoloop Support"
+	tristate "Cryptoloop Support (DEPRECATED)"
 	select CRYPTO
 	select CRYPTO_CBC
 	depends on BLK_DEV_LOOP
@@ -269,7 +269,7 @@ config BLK_DEV_CRYPTOLOOP
 	  WARNING: This device is not safe for journaled file systems like
 	  ext3 or Reiserfs. Please use the Device Mapper crypto module
 	  instead, which can be configured to be on-disk compatible with the
-	  cryptoloop device.
+	  cryptoloop device.  cryptoloop support will be removed in Linux 5.16.
 
 source "drivers/block/drbd/Kconfig"
 
diff --git a/drivers/block/cryptoloop.c b/drivers/block/cryptoloop.c
index 3d31761c0ed0..adbfd3e2a60f 100644
--- a/drivers/block/cryptoloop.c
+++ b/drivers/block/cryptoloop.c
@@ -203,6 +203,8 @@ init_cryptoloop(void)
 
 	if (rc)
 		printk(KERN_ERR "cryptoloop: loop_register_transfer failed\n");
+	else
+		pr_warn("the cryptoloop driver has been deprecated and will be removed in in Linux 5.16\n");
 	return rc;
 }
 
-- 
2.30.2



