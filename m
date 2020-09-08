Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5867261ED0
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732143AbgIHTzv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:55:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:58864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730577AbgIHPgu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 11:36:50 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2995F22582;
        Tue,  8 Sep 2020 15:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579315;
        bh=ht+MpGssPKdJ6E3rsvdmycBCNz+RMWwRINpMqFlTCqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K+xBNi2Q+LKxAfSmMOo0Ia0Y0dez09p4Iu6JGdOKj8tT0hMqK9tcb9HlJpThbIuni
         /UuU2l+wqzHJpuag+o0t1g3hNphmPom1ydp2YVI07Of1qBZh63S7KEMhRZT+I5YkDI
         BLXPRs5z51bfp9sXcRX0cCh7hytrqgj24yNPAL1Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hou Pu <houpu@bytedance.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 027/186] nbd: restore default timeout when setting it to zero
Date:   Tue,  8 Sep 2020 17:22:49 +0200
Message-Id: <20200908152242.972650373@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hou Pu <houpu@bytedance.com>

[ Upstream commit acb19e17c5134dd78668c429ecba5b481f038e6a ]

If we configured io timeout of nbd0 to 100s. Later after we
finished using it, we configured nbd0 again and set the io
timeout to 0. We expect it would timeout after 30 seconds
and keep retry. But in fact we could not change the timeout
when we set it to 0. the timeout is still the original 100s.

So change the timeout to default 30s when we set it to zero.
It also behaves same as commit 2da22da57348 ("nbd: fix zero
cmd timeout handling v2").

It becomes more important if we were reconfigure a nbd device
and the io timeout it set to zero. Because it could take 30s
to detect the new socket and thus io could be completed more
quickly compared to 100s.

Signed-off-by: Hou Pu <houpu@bytedance.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/nbd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index ce7e9f223b20b..bc9dc1f847e19 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1360,6 +1360,8 @@ static void nbd_set_cmd_timeout(struct nbd_device *nbd, u64 timeout)
 	nbd->tag_set.timeout = timeout * HZ;
 	if (timeout)
 		blk_queue_rq_timeout(nbd->disk->queue, timeout * HZ);
+	else
+		blk_queue_rq_timeout(nbd->disk->queue, 30 * HZ);
 }
 
 /* Must be called with config_lock held */
-- 
2.25.1



