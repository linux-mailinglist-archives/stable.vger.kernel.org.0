Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F90E5077A5
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 20:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356378AbiDSSRU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 14:17:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356531AbiDSSQY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 14:16:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B05763EBA0;
        Tue, 19 Apr 2022 11:12:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 629F2B81982;
        Tue, 19 Apr 2022 18:12:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C489C385A9;
        Tue, 19 Apr 2022 18:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650391958;
        bh=MK0OE6TjYTtxohqk28sr/Dd7rzK97V5i8xMRJVD6TPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SF4PrCXLyzxyYaFNiTpbcNpaOt1BOLXb7LQ9iSbrLGUPsWBqkQW1aXy6DNqknTaMc
         /eLRPkxZUt6PR8VmwMlN3VYHHY/7fFTfOTYeK3ekg9EYlU48VytfcNJDALR7JHJg4+
         7YgxkxYOcOHih7RdtDrBuDJD4cGWDqywbe1uCMO6WprfDMpwBsUJJ8FigfKCNG/STi
         p4Ci+qkZJct2pU+ef9WbTlEIcZ6e99FTR6JgN+p4vmDo6WkWM2M85HGyx44hXwwwOO
         roCHq95KI2q6SUFphlUgnLGUythIKDWCPZXowl79y9578erU5+FttRAfrnkce4TlUK
         JoFlbnZZGH3Ig==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Khazhismel Kumykov <khazhy@google.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 33/34] block/compat_ioctl: fix range check in BLKGETSIZE
Date:   Tue, 19 Apr 2022 14:11:00 -0400
Message-Id: <20220419181104.484667-33-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220419181104.484667-1-sashal@kernel.org>
References: <20220419181104.484667-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Khazhismel Kumykov <khazhy@google.com>

[ Upstream commit ccf16413e520164eb718cf8b22a30438da80ff23 ]

kernel ulong and compat_ulong_t may not be same width. Use type directly
to eliminate mismatches.

This would result in truncation rather than EFBIG for 32bit mode for
large disks.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Link: https://lore.kernel.org/r/20220414224056.2875681-1-khazhy@google.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index 4a86340133e4..f8703db99c73 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -629,7 +629,7 @@ long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 		return compat_put_long(argp,
 			(bdev->bd_disk->bdi->ra_pages * PAGE_SIZE) / 512);
 	case BLKGETSIZE:
-		if (bdev_nr_sectors(bdev) > ~0UL)
+		if (bdev_nr_sectors(bdev) > ~(compat_ulong_t)0)
 			return -EFBIG;
 		return compat_put_ulong(argp, bdev_nr_sectors(bdev));
 
-- 
2.35.1

