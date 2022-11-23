Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3096635EA9
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 13:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235735AbiKWM5x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 07:57:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238200AbiKWMzb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 07:55:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8ADC903A6;
        Wed, 23 Nov 2022 04:45:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53E1CB81F38;
        Wed, 23 Nov 2022 12:45:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 481CFC4347C;
        Wed, 23 Nov 2022 12:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207536;
        bh=bQMeOUAG60aBNGTKJyGoRaSKtjrdr8ioTcXYGwASjwA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VNgWWolLaoCs3R2LE6jE+MUx7DmXey3JMW1wB8IkSz15wZ+2m2Dn1ARYpHfudr3W7
         HPPkyt76ZyG+zuggKtddG7znPH913lugnCWefKM2ZuGh19ppkVq4KdKqMMo6fulYJq
         VIAr6mhhJ/8ZHL+ij6JGdHJjPjkthcnj5yrqeeTtK4t79KIXWZkhqonsTnYB41Na+o
         gG+X4hBouHVSpJNLZs5Ynu0ea/LPU4cakoASkUQY74Tq2mszWZs+ivgc/V7Uv8Ka8q
         wcFECOnU+fT6xKcX7IGbLmX38sUh+0xo2is2XXrznGUWr8t0AVld4YV3BFU2Of0rYe
         Y7sXSEFJHGioA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Keith Busch <kbusch@kernel.org>, Mike Snitzer <snitzer@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        agk@redhat.com, dm-devel@redhat.com
Subject: [PATCH AUTOSEL 4.14 09/10] dm-log-writes: set dma_alignment limit in io_hints
Date:   Wed, 23 Nov 2022 07:45:17 -0500
Message-Id: <20221123124520.266643-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221123124520.266643-1-sashal@kernel.org>
References: <20221123124520.266643-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 50a893359cd2643ee1afc96eedc9e7084cab49fa ]

This device mapper needs bio vectors to be sized and memory aligned to
the logical block size. Set the minimum required queue limit
accordingly.

Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Mike Snitzer <snitzer@kernel.org>
Link: https://lore.kernel.org/r/20221110184501.2451620-6-kbusch@meta.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-log-writes.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index dafedbc28bcc..386148560734 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -809,6 +809,7 @@ static void log_writes_io_hints(struct dm_target *ti, struct queue_limits *limit
 	limits->logical_block_size = bdev_logical_block_size(lc->dev->bdev);
 	limits->physical_block_size = bdev_physical_block_size(lc->dev->bdev);
 	limits->io_min = limits->physical_block_size;
+	limits->dma_alignment = limits->logical_block_size - 1;
 }
 
 static struct target_type log_writes_target = {
-- 
2.35.1

