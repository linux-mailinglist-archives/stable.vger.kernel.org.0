Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50B5463E03F
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbiK3SzE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:55:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231582AbiK3SzC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:55:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C4D93A55
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:55:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5724461D4F
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:55:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B33AC433D6;
        Wed, 30 Nov 2022 18:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834500;
        bh=YV/g4gHeGL9nPftnW7aDWYSFRYJ/FYEbVp5rDMcHxy4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zbge9bP+TDWfKP84NDmmTrmOf4EuD312BFyVerMWD/vT5ydnpA/dIBrxpqKl53XyP
         Kc00y7RKg17K1EFMyWc8SOKDU8a0CYO6QzsMdr6fUmBy0qP7acrG3Wgwn00yysby2h
         UIT8315LV8xiaBpOc4huOm4w1/paEJ85Y/eJLokE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Keith Busch <kbusch@kernel.org>,
        Mike Snitzer <snitzer@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 259/289] dm-log-writes: set dma_alignment limit in io_hints
Date:   Wed, 30 Nov 2022 19:24:04 +0100
Message-Id: <20221130180549.974631689@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



