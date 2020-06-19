Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22CC320129F
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404110AbgFSPx7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:53:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:53398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392943AbgFSPWD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:22:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA55920B80;
        Fri, 19 Jun 2020 15:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580122;
        bh=SWWGoQsVVAyjX/AN81bixPfF8lDzZ/UMYuq0YgzmvUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QAPQ0senfd3k1MlMvgoUxFJJIit0iDF7vZHmexCYQDPzMyfA1FI0pguWzftEyVav9
         wMlA+YU01cgAhSHcXmT1fio3FD2qWz3lP2xpgCjE3zfIP+l13FTBG88hc0nprN6Eio
         RUTPc5KD/clqMdTM2I0CAA5gKFF011MNvN/CHjFE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 113/376] bcache: remove a duplicate ->make_request_fn assignment
Date:   Fri, 19 Jun 2020 16:30:31 +0200
Message-Id: <20200619141715.697548215@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit a91b2014fc31dc6eaa02ca33aa3b4d1b6e4a0207 ]

The make_request_fn pointer should only be assigned by blk_alloc_queue.
Fix a left over manual initialization.

Fixes: ff27668ce809 ("bcache: pass the make_request methods to blk_queue_make_request")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/request.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 71a90fbec314..77d1a2697517 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -1372,7 +1372,6 @@ void bch_flash_dev_request_init(struct bcache_device *d)
 {
 	struct gendisk *g = d->disk;
 
-	g->queue->make_request_fn		= flash_dev_make_request;
 	g->queue->backing_dev_info->congested_fn = flash_dev_congested;
 	d->cache_miss				= flash_dev_cache_miss;
 	d->ioctl				= flash_dev_ioctl;
-- 
2.25.1



