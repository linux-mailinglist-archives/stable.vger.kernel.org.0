Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB01635E65
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 13:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238077AbiKWMsx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 07:48:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238097AbiKWMrb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 07:47:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A349473412;
        Wed, 23 Nov 2022 04:43:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A37261C64;
        Wed, 23 Nov 2022 12:43:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF15C43470;
        Wed, 23 Nov 2022 12:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207406;
        bh=nrFKuFLGeUDfQMylmgEpCpzUriM+cnRrWV9ROTuWGN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EhfYu97nAkPUtkfsGzPdhhFJewzpWU3aKJrw7AVGTXn8z62CtsgjrV8Oc2c0XBRYf
         8ryyWPS5ceH9Aa1zCQlx1rXeJ9cwgZ0rfnWd40C9BOr6PV3fiTZZ2Dhx6rBz6J3pMb
         Om8JKuCzRevRzvDZewu6fFf5OK10ui0iPOYgM5JMX+fKUgUd3gqBL0I4bb7/1rzQLp
         JBL5fstHYPECScOcEHNqnsP8eeIM5XHKWePAybhMNLb8DD9tgQxvQR+nAq4iECGYbN
         pEv0J5Ll7yPDNxDrlQpaoph3H+PWARxJKndXM1HfVpIavGPR6cESckroyrbSiuEOHb
         9h5AYHU2r+Hgw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Keith Busch <kbusch@kernel.org>, Mike Snitzer <snitzer@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        agk@redhat.com, dm-devel@redhat.com
Subject: [PATCH AUTOSEL 5.15 24/31] dm-integrity: set dma_alignment limit in io_hints
Date:   Wed, 23 Nov 2022 07:42:25 -0500
Message-Id: <20221123124234.265396-24-sashal@kernel.org>
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
index d5b827086962..cac8cca03fe8 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -3354,6 +3354,7 @@ static void dm_integrity_io_hints(struct dm_target *ti, struct queue_limits *lim
 		limits->logical_block_size = ic->sectors_per_block << SECTOR_SHIFT;
 		limits->physical_block_size = ic->sectors_per_block << SECTOR_SHIFT;
 		blk_limits_io_min(limits, ic->sectors_per_block << SECTOR_SHIFT);
+		limits->dma_alignment = limits->logical_block_size - 1;
 	}
 }
 
-- 
2.35.1

