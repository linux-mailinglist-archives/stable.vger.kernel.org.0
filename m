Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52A89411EF2
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351931AbhITRgJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:36:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:35794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351521AbhITReS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:34:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68F6761373;
        Mon, 20 Sep 2021 17:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157541;
        bh=FwzfyyuZ6VLcfr1F4gDZkIzt9er8qc+k9jKBDlAJIYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XK0FwZiIZzWCUlj/pAsa0dpOkubBHU2J04+9MAM2tzeWK6WEDDABXoc1OwLZ9YwGg
         v9GVlx3bQFmzfofPDV+mWOFi4KkiKFSdqLTA7m7bpR3UnFdVTvT/3t6eqgTH5JvTs7
         fZ7t5tdOsFwc3P/Jui1rLRJ9mIwp/88vJi3YXn10=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 009/293] cryptoloop: add a deprecation warning
Date:   Mon, 20 Sep 2021 18:39:31 +0200
Message-Id: <20210920163933.575922347@linuxfoundation.org>
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
index e101f286ac35..60662771bd46 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -242,7 +242,7 @@ config BLK_DEV_LOOP_MIN_COUNT
 	  dynamically allocated with the /dev/loop-control interface.
 
 config BLK_DEV_CRYPTOLOOP
-	tristate "Cryptoloop Support"
+	tristate "Cryptoloop Support (DEPRECATED)"
 	select CRYPTO
 	select CRYPTO_CBC
 	depends on BLK_DEV_LOOP
@@ -254,7 +254,7 @@ config BLK_DEV_CRYPTOLOOP
 	  WARNING: This device is not safe for journaled file systems like
 	  ext3 or Reiserfs. Please use the Device Mapper crypto module
 	  instead, which can be configured to be on-disk compatible with the
-	  cryptoloop device.
+	  cryptoloop device.  cryptoloop support will be removed in Linux 5.16.
 
 source "drivers/block/drbd/Kconfig"
 
diff --git a/drivers/block/cryptoloop.c b/drivers/block/cryptoloop.c
index 7033a4beda66..1b84105dfe62 100644
--- a/drivers/block/cryptoloop.c
+++ b/drivers/block/cryptoloop.c
@@ -201,6 +201,8 @@ init_cryptoloop(void)
 
 	if (rc)
 		printk(KERN_ERR "cryptoloop: loop_register_transfer failed\n");
+	else
+		pr_warn("the cryptoloop driver has been deprecated and will be removed in in Linux 5.16\n");
 	return rc;
 }
 
-- 
2.30.2



