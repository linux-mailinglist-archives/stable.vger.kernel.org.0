Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFD242B6180
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730422AbgKQNTf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:19:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:52568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730415AbgKQNTd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:19:33 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F05B1206D5;
        Tue, 17 Nov 2020 13:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619173;
        bh=1JM3XUMBgFSq2lQJHO/MI3V8t3AmxGTiwB7rTLk1RKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zmSwaz8+F2G17+NLaJNLJDefnDnjDzDrGgliw8LaIRaut84kIeOY+jh8rw1qtlbqK
         ohGkGFbfbxwJMtNsuhtTy9YjGCaxC4Tl36KQzQS6mpUVMiNiFUX3Upf5tnStLiBCwL
         99W0Wr93ds5sA5s3QJP7pKVnjfKrrL8vNQrgnvFk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 053/101] nbd: fix a block_device refcount leak in nbd_release
Date:   Tue, 17 Nov 2020 14:05:20 +0100
Message-Id: <20201117122115.680231335@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122113.128215851@linuxfoundation.org>
References: <20201117122113.128215851@linuxfoundation.org>
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
index 706115ecd9bee..517318bb350cf 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1448,6 +1448,7 @@ static void nbd_release(struct gendisk *disk, fmode_t mode)
 	if (test_bit(NBD_DISCONNECT_ON_CLOSE, &nbd->config->runtime_flags) &&
 			bdev->bd_openers == 0)
 		nbd_disconnect_and_put(nbd);
+	bdput(bdev);
 
 	nbd_config_put(nbd);
 	nbd_put(nbd);
-- 
2.27.0



