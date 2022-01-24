Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F266C49A9B6
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243311AbiAYD12 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:27:28 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55618 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445472AbiAXVDj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:03:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B15CB80FA1;
        Mon, 24 Jan 2022 21:03:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8783C340E5;
        Mon, 24 Jan 2022 21:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058214;
        bh=e8+VAjX8qdBaRBg1pWk9PK9HVYFtA0VS7vIlBkabhfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KhfW+kHjdFpuF/zi0ADUttYl+LfXG6vr/FI3ojooYLL86Qo3NtSgaKfEUPZ92zkjv
         26MwtuHTEMoJ4c8oNye4kHLC19gfrJixXQrV1VhyxR+domTUsGmSIl6dR5blAf8evx
         WU02XTgimqK0wlHSYlptsp6Ti6TLIhim2/9yD9vM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0216/1039] null_blk: allow zero poll queues
Date:   Mon, 24 Jan 2022 19:33:25 +0100
Message-Id: <20220124184132.601140815@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 2bfdbe8b7ebd17b5331071071a910fbabc64b436 ]

There isn't any reason to not allow zero poll queues from user
viewpoint.

Also sometimes we need to compare io poll between poll mode and irq
mode, so not allowing poll queues is bad.

Fixes: 15dfc662ef31 ("null_blk: Fix handling of submit_queues and poll_queues attributes")
Cc: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20211203023935.3424042-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/null_blk/main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index 323af5c9c8026..fc1317060db54 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -340,9 +340,9 @@ static int nullb_update_nr_hw_queues(struct nullb_device *dev,
 		return 0;
 
 	/*
-	 * Make sure at least one queue exists for each of submit and poll.
+	 * Make sure at least one submit queue exists.
 	 */
-	if (!submit_queues || !poll_queues)
+	if (!submit_queues)
 		return -EINVAL;
 
 	/*
@@ -1918,8 +1918,6 @@ static int null_validate_conf(struct nullb_device *dev)
 
 	if (dev->poll_queues > g_poll_queues)
 		dev->poll_queues = g_poll_queues;
-	else if (dev->poll_queues == 0)
-		dev->poll_queues = 1;
 	dev->prev_poll_queues = dev->poll_queues;
 
 	dev->queue_mode = min_t(unsigned int, dev->queue_mode, NULL_Q_MQ);
-- 
2.34.1



