Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15337635E5B
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 13:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238531AbiKWMzW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 07:55:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238728AbiKWMxX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 07:53:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A4A8F3E7;
        Wed, 23 Nov 2022 04:45:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B513B81F40;
        Wed, 23 Nov 2022 12:45:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38E06C433D6;
        Wed, 23 Nov 2022 12:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207514;
        bh=feiwACPMzYxX4kKwKpUNBdGjFoF/KXZpD2lFf6Cv168=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QJ42pshF9+6VUzkVxcNXEadydTfFmGPXuQ1gheuz5CG5cZM1xddgEDyXPEW1VTJ9u
         lCu9aa88R4QA3zErHgHR4/9jykpUIMhW1e69FDAcav87li1+a6PQJ3zXLPFM9StyaA
         KC7Ig1viE29nVfm/Noou1AJ6BWCM07eynYQv82tdoTSxF9oJ4Lu1hPf/zw6uoaK2Ui
         Eiqnjg/oxoEQfVBY26x/oAdA0T64OpbXXY5qw6WRwz9RWtNaxCRLMLg6XRLQnaNgJY
         oNi38vrP+LXPrKtxmS9lyxCr11iPHqGz+uxFY0P0UobwjS7ynAP0jiFK0g+b/h48yS
         VwtiS+bX9TsMg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Keith Busch <kbusch@kernel.org>, Mike Snitzer <snitzer@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        agk@redhat.com, dm-devel@redhat.com
Subject: [PATCH AUTOSEL 4.19 08/11] dm-integrity: set dma_alignment limit in io_hints
Date:   Wed, 23 Nov 2022 07:44:53 -0500
Message-Id: <20221123124458.266492-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221123124458.266492-1-sashal@kernel.org>
References: <20221123124458.266492-1-sashal@kernel.org>
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

[ Upstream commit 29aa778bb66795e6a78b1c99beadc83887827868 ]

This device mapper needs bio vectors to be sized and memory aligned to
the logical block size. Set the minimum required queue limit
accordingly.

Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Mike Snitzer <snitzer@kernel.org>
Link: https://lore.kernel.org/r/20221110184501.2451620-5-kbusch@meta.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-integrity.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 8456e82409e2..7492e6abb5a5 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -2564,6 +2564,7 @@ static void dm_integrity_io_hints(struct dm_target *ti, struct queue_limits *lim
 		limits->logical_block_size = ic->sectors_per_block << SECTOR_SHIFT;
 		limits->physical_block_size = ic->sectors_per_block << SECTOR_SHIFT;
 		blk_limits_io_min(limits, ic->sectors_per_block << SECTOR_SHIFT);
+		limits->dma_alignment = limits->logical_block_size - 1;
 	}
 }
 
-- 
2.35.1

