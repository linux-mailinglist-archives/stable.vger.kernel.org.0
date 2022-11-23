Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44F95635E11
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 13:56:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238177AbiKWMxt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 07:53:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238616AbiKWMxG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 07:53:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 237586B22B;
        Wed, 23 Nov 2022 04:45:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8E9661C63;
        Wed, 23 Nov 2022 12:44:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E9ECC43144;
        Wed, 23 Nov 2022 12:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207492;
        bh=CMG4KlXzdjrLU+BbGM5x3YrB+VQ5PD1Jpy7xHJBs9dM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SVTCOgRUxrzA3nKdtCoChuPqrahYsI3Wk6JGUsBBBPwbrw3h/+xpYZgy4sqp/3TlV
         Cx6m6lwZCTefaI4JOXqjiyAhYqqw/tvH5wQZ7XCNHGsrKvP9Db8goBTHfcMxcgNBIP
         ZDYdwNkqQRl/Jg+r0Tap6ItrO77BrznNSqwVvqwl+hbHErqxftN4GoTV/JgPc2INW5
         PX/sksQA3kBMdUZ7OrD8vrKj2EXqOF3Gxq/EJYbzO+10ypqqAzpS9aA1cXN4KzIqCO
         JP51YGzOPgn6vYolC9I4CQOrYQM5/U11lAhVCc/a1E46QSopZyreqVvewnOB/kA3vu
         eP3soTFWVYroQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Keith Busch <kbusch@kernel.org>, Mike Snitzer <snitzer@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        agk@redhat.com, dm-devel@redhat.com
Subject: [PATCH AUTOSEL 5.4 12/15] dm-integrity: set dma_alignment limit in io_hints
Date:   Wed, 23 Nov 2022 07:44:22 -0500
Message-Id: <20221123124427.266286-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221123124427.266286-1-sashal@kernel.org>
References: <20221123124427.266286-1-sashal@kernel.org>
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
index acbda91e7643..b0f4311cb418 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -3065,6 +3065,7 @@ static void dm_integrity_io_hints(struct dm_target *ti, struct queue_limits *lim
 		limits->logical_block_size = ic->sectors_per_block << SECTOR_SHIFT;
 		limits->physical_block_size = ic->sectors_per_block << SECTOR_SHIFT;
 		blk_limits_io_min(limits, ic->sectors_per_block << SECTOR_SHIFT);
+		limits->dma_alignment = limits->logical_block_size - 1;
 	}
 }
 
-- 
2.35.1

