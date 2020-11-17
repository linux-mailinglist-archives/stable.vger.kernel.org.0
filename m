Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8546D2B650A
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731256AbgKQN2e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:28:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:34290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731504AbgKQN0o (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:26:44 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2EC3206D5;
        Tue, 17 Nov 2020 13:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619604;
        bh=1QT9HRE/DdywlrkuAxGHltvhDA0FbHg4eUI177LYd1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C+1rdvH0JiTNxgwanKDfdIGzNmO7UfrBjO9r9ORH7NJaa2X2hS1Ky1IKYOuInQ4Xo
         N+GcI5E43F7W15W7BfDqijWoGrItTj+z1VCJKiok8grkURMPL/GJgaXsEKThG3+YkA
         IgflYZ2O50F1k09yLIRZ3idf1gxGDKI79p3/X7/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 094/151] nbd: fix a block_device refcount leak in nbd_release
Date:   Tue, 17 Nov 2020 14:05:24 +0100
Message-Id: <20201117122125.980260339@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 2bd645b2d3f0bacadaa6037f067538e1cd4e42ef ]

bdget_disk needs to be paired with bdput to not leak a reference
on the block device inode.

Fixes: 08ba91ee6e2c ("nbd: Add the nbd NBD_DISCONNECT_ON_CLOSE config flag.")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/nbd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 62a873718b5bb..a3037fe54c3ab 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1503,6 +1503,7 @@ static void nbd_release(struct gendisk *disk, fmode_t mode)
 	if (test_bit(NBD_RT_DISCONNECT_ON_CLOSE, &nbd->config->runtime_flags) &&
 			bdev->bd_openers == 0)
 		nbd_disconnect_and_put(nbd);
+	bdput(bdev);
 
 	nbd_config_put(nbd);
 	nbd_put(nbd);
-- 
2.27.0



