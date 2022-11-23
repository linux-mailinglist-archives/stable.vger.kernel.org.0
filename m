Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0D1635DB5
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 13:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237814AbiKWMpu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 07:45:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237732AbiKWMov (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 07:44:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B58FD6EB70;
        Wed, 23 Nov 2022 04:42:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5FB61B81F31;
        Wed, 23 Nov 2022 12:42:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EBABC43470;
        Wed, 23 Nov 2022 12:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207343;
        bh=YV/g4gHeGL9nPftnW7aDWYSFRYJ/FYEbVp5rDMcHxy4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sB6FRS9oldjTem5B7DsOyl4XfQPaxREjSxQ8wMvX3a70Pqxmd0Pzd4CmBxVD0VM6P
         CwZNcYnpKK4pXRuZATxPqB/EmZefFQh1/Gh9hSbaWF6zrBGKrPNmn/vfYP75OrVtWk
         50Ukqvlvvr6cElqsEzQ33NddnWVtLyWOGeHjBQmJpJ2L775c+U6nEGkwZvJYlv4er9
         ae36hqW4fvHIKLKPnQRh7RmlRTABHUloRznaPS7P5Jl9//6wMC02dCfNglyTTJNBQc
         t7QQ9jCkHeVkI8rP18es9tNmXqAmS+0eS0hUYAqnbWtGv0swECI1Ghw70zr7I8x197
         x0k5Fv9D4PKAA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Keith Busch <kbusch@kernel.org>, Mike Snitzer <snitzer@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        agk@redhat.com, dm-devel@redhat.com
Subject: [PATCH AUTOSEL 6.0 38/44] dm-log-writes: set dma_alignment limit in io_hints
Date:   Wed, 23 Nov 2022 07:40:47 -0500
Message-Id: <20221123124057.264822-38-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221123124057.264822-1-sashal@kernel.org>
References: <20221123124057.264822-1-sashal@kernel.org>
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
index 20fd688f72e7..178e13a5b059 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -875,6 +875,7 @@ static void log_writes_io_hints(struct dm_target *ti, struct queue_limits *limit
 	limits->logical_block_size = bdev_logical_block_size(lc->dev->bdev);
 	limits->physical_block_size = bdev_physical_block_size(lc->dev->bdev);
 	limits->io_min = limits->physical_block_size;
+	limits->dma_alignment = limits->logical_block_size - 1;
 }
 
 #if IS_ENABLED(CONFIG_FS_DAX)
-- 
2.35.1

