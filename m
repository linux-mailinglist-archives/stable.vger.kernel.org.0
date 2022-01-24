Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1D264999E5
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:47:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1456310AbiAXVif (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:38:35 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34330 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447449AbiAXVKr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:10:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 75E2C6146E;
        Mon, 24 Jan 2022 21:10:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5274DC340E5;
        Mon, 24 Jan 2022 21:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058645;
        bh=QfXVEBS5CJYobEpr5tZk3+nLG5aBcq5DD0u6HnQqvQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oxdwS3dDVPPin4pc9AgCZYH9e/5dbk/Co3qyw6hhuCr4MKf4TdSQhJEk3PHwvKeNi
         y5jB48n7meRhdPeOgswcbd0RizUJxjv7W5fQ/pcypZskSCWQjfZzDoNCAqKeWFJXdL
         EZbql0VzYYp6nf/N80mIUAIZ8/cs8do1iBonEfbY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0356/1039] block: null_blk: only set set->nr_maps as 3 if active poll_queues is > 0
Date:   Mon, 24 Jan 2022 19:35:45 +0100
Message-Id: <20220124184137.245958548@linuxfoundation.org>
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

[ Upstream commit 19768f80cf23834e65482f1667ff54192d469fee ]

It isn't correct to set set->nr_maps as 3 if g_poll_queues is > 0 since
we can change it via configfs for null_blk device created there, so only
set it as 3 if active poll_queues is > 0.

Fixes divide zero exception reported by Shinichiro.

Fixes: 2bfdbe8b7ebd ("null_blk: allow zero poll queues")
Reported-by: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Link: https://lore.kernel.org/r/20211224010831.1521805-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/null_blk/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index fc1317060db54..e23aac1a83f73 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -1891,7 +1891,7 @@ static int null_init_tag_set(struct nullb *nullb, struct blk_mq_tag_set *set)
 	if (g_shared_tag_bitmap)
 		set->flags |= BLK_MQ_F_TAG_HCTX_SHARED;
 	set->driver_data = nullb;
-	if (g_poll_queues)
+	if (poll_queues)
 		set->nr_maps = 3;
 	else
 		set->nr_maps = 1;
-- 
2.34.1



