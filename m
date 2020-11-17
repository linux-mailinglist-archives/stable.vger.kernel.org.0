Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95BEE2B645F
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732481AbgKQNqz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:46:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:48422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732947AbgKQNhX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:37:23 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70A5F20870;
        Tue, 17 Nov 2020 13:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620243;
        bh=eioIBJxLKiEpJRcB3ViW2s8x0ek8thK0oEexwvMsF8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f5NKfF2l9k+JbvJSaD0/YB7gcohuAqBN2eu1IK5WeyMq7UsKCrFlungUbtMgVF2bI
         qEZefMY63nKhRKaI8vQqTBYlRlGeatPxPmjMy9HpoqAZw+Rf6Vs3JWFHxvRHYsojY9
         HHT+r696FizQs0ad1vvqTDxkrlRVeByBEtWbUUhw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 152/255] nbd: fix a block_device refcount leak in nbd_release
Date:   Tue, 17 Nov 2020 14:04:52 +0100
Message-Id: <20201117122146.365344112@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
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
index d76fca629c143..36c46fe078556 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1517,6 +1517,7 @@ static void nbd_release(struct gendisk *disk, fmode_t mode)
 	if (test_bit(NBD_RT_DISCONNECT_ON_CLOSE, &nbd->config->runtime_flags) &&
 			bdev->bd_openers == 0)
 		nbd_disconnect_and_put(nbd);
+	bdput(bdev);
 
 	nbd_config_put(nbd);
 	nbd_put(nbd);
-- 
2.27.0



