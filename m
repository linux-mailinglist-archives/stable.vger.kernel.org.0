Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74B602E404A
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437925AbgL1OVc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:21:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:56518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502484AbgL1OVT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:21:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE33720791;
        Mon, 28 Dec 2020 14:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165263;
        bh=gB0sMBbjvHsllEBpp7DjNbg4rzoH6g7olzor5aVjVhM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PQpXbrL1cbG7K4mSPiS0Y1aQ1uLKePCCakXSvQZ736cZhI2UlwypT+3XYGfhkd4Xx
         5gjeZeFFKJMORgjBiC/sqCRhsBOvgzuQArkeWtcZi1K52z1EgXQxkxemO2XsCXwezw
         /cpSbeWWs0LBboKISXPE5efdou3S1i2Syo+wLhZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@cloud.ionos.com>,
        Md Haris Iqbal <haris.iqbal@cloud.ionos.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 470/717] block/rnbd-clt: Fix possible memleak
Date:   Mon, 28 Dec 2020 13:47:48 +0100
Message-Id: <20201228125043.489451327@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Wang <jinpu.wang@cloud.ionos.com>

[ Upstream commit 46067844efdb8275ade705923120fc5391543b53 ]

In error case, we do not free the memory for blk_symlink_name.

Do it by free the memory in error case, and set to NULL
afterwards.

Also fix the condition in rnbd_clt_remove_dev_symlink.

Fixes: 64e8a6ece1a5 ("block/rnbd-clt: Dynamically alloc buffer for pathname & blk_symlink_name")
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Reviewed-by: Md Haris Iqbal <haris.iqbal@cloud.ionos.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/rnbd/rnbd-clt-sysfs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/block/rnbd/rnbd-clt-sysfs.c b/drivers/block/rnbd/rnbd-clt-sysfs.c
index d854f057056bb..d9dd138ca9c64 100644
--- a/drivers/block/rnbd/rnbd-clt-sysfs.c
+++ b/drivers/block/rnbd/rnbd-clt-sysfs.c
@@ -433,7 +433,7 @@ void rnbd_clt_remove_dev_symlink(struct rnbd_clt_dev *dev)
 	 * i.e. rnbd_clt_unmap_dev_store() leading to a sysfs warning because
 	 * of sysfs link already was removed already.
 	 */
-	if (strlen(dev->blk_symlink_name) && try_module_get(THIS_MODULE)) {
+	if (dev->blk_symlink_name && try_module_get(THIS_MODULE)) {
 		sysfs_remove_link(rnbd_devs_kobj, dev->blk_symlink_name);
 		kfree(dev->blk_symlink_name);
 		module_put(THIS_MODULE);
@@ -516,7 +516,8 @@ static int rnbd_clt_add_dev_symlink(struct rnbd_clt_dev *dev)
 	return 0;
 
 out_err:
-	dev->blk_symlink_name[0] = '\0';
+	kfree(dev->blk_symlink_name);
+	dev->blk_symlink_name = NULL ;
 	return ret;
 }
 
-- 
2.27.0



