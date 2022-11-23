Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E896E635E7B
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 13:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237559AbiKWMtC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 07:49:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237626AbiKWMrf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 07:47:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB89A74CD9;
        Wed, 23 Nov 2022 04:43:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8700661CAC;
        Wed, 23 Nov 2022 12:43:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21D0EC433C1;
        Wed, 23 Nov 2022 12:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207407;
        bh=sk00pbKNrgS0I3XKE8gzui0QuOBd7ZDNpkzyJGozIC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XWvt4CfaTGZjxrq4SvYjLk+IVnBoAYJo3jHwhbtxyLyHXV2LVZHUXNpd43+1UNNCt
         64FkxBQHL6RoQiP+5pZxfqu2A+TS92keaCQwYQFUBbkRXXnGF1KdKKzUAOcPDkM2X3
         Ht0qoMTOtWfhA1c79PFKinf59OBPP6xEwxyz3IdqxrYouL/tAM6KwAsLHEnu/dVa2E
         yo1295HeEp9uLfC4NDPOPRB9xOBaJGFrmh1Nxig8PwvLAZNbEFx51sU4eaLxnLPgLM
         ydAuRcz8S2TNz8+PjHJ8NfoEymrPdWU2c+8h6KN9NqBCpeD/4m+EDBmiWlaTmxaMSd
         RXqetti5pjL/g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Keith Busch <kbusch@kernel.org>, Mike Snitzer <snitzer@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        agk@redhat.com, dm-devel@redhat.com
Subject: [PATCH AUTOSEL 5.15 25/31] dm-log-writes: set dma_alignment limit in io_hints
Date:   Wed, 23 Nov 2022 07:42:26 -0500
Message-Id: <20221123124234.265396-25-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221123124234.265396-1-sashal@kernel.org>
References: <20221123124234.265396-1-sashal@kernel.org>
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
index d93a4db23512..4f8f73b89512 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -901,6 +901,7 @@ static void log_writes_io_hints(struct dm_target *ti, struct queue_limits *limit
 	limits->logical_block_size = bdev_logical_block_size(lc->dev->bdev);
 	limits->physical_block_size = bdev_physical_block_size(lc->dev->bdev);
 	limits->io_min = limits->physical_block_size;
+	limits->dma_alignment = limits->logical_block_size - 1;
 }
 
 #if IS_ENABLED(CONFIG_DAX_DRIVER)
-- 
2.35.1

