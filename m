Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 143DC5943A2
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348404AbiHOWXl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:23:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349954AbiHOWVj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:21:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 694C8124F47;
        Mon, 15 Aug 2022 12:43:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B91F0B80EA9;
        Mon, 15 Aug 2022 19:43:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26AC4C4314A;
        Mon, 15 Aug 2022 19:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592629;
        bh=GCy6sU5OdNa/ZBPCY8OyIwcHn4s6OCqwZVqGYBE9r3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dsuOX6wsRsDUtXyTD2kOAfN9PTJBtHYQYaBypot4d3jvSeg3WIIL8XqCtztIQri0V
         ffd7HiZ2AbETroSLZ/tj+cs7kS/0xe82F58xVE/vKdICI3rlzk0lSoAM7R2/MszZrd
         Ppgk4+s8GMT8VrvQj3XPinDUX18BXhChw926Ko4w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Bowler <nbowler@draconx.ca>,
        Guixin Liu <kanie@linux.alibaba.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0818/1095] nvme: define compat_ioctl again to unbreak 32-bit userspace.
Date:   Mon, 15 Aug 2022 20:03:37 +0200
Message-Id: <20220815180503.121600294@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Bowler <nbowler@draconx.ca>

[ Upstream commit a25d4261582cf00dad884c194d21084836663d3d ]

Commit 89b3d6e60550 ("nvme: simplify the compat ioctl handling") removed
the initialization of compat_ioctl from the nvme block_device_operations
structures.

Presumably the expectation was that 32-bit ioctls would be directed
through the regular handler but this is not the case: failing to assign
.compat_ioctl actually means that the compat case is disabled entirely,
and any attempt to submit nvme ioctls from 32-bit userspace fails
outright with -ENOTTY.

For example:

  % smartctl -x /dev/nvme0n1
  [...]
  Read NVMe Identify Controller failed: NVME_IOCTL_ADMIN_CMD: Inappropriate ioctl for device

The blkdev_compat_ptr_ioctl helper can be used to direct compat calls
through the main ioctl handler and makes things work again.

Fixes: 89b3d6e60550 ("nvme: simplify the compat ioctl handling")
Signed-off-by: Nick Bowler <nbowler@draconx.ca>
Reviewed-by: Guixin Liu <kanie@linux.alibaba.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c      | 1 +
 drivers/nvme/host/multipath.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index c9831daafbc6..cf7be9b4f5d3 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2093,6 +2093,7 @@ static int nvme_report_zones(struct gendisk *disk, sector_t sector,
 static const struct block_device_operations nvme_bdev_ops = {
 	.owner		= THIS_MODULE,
 	.ioctl		= nvme_ioctl,
+	.compat_ioctl	= blkdev_compat_ptr_ioctl,
 	.open		= nvme_open,
 	.release	= nvme_release,
 	.getgeo		= nvme_getgeo,
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index d464fdf978fb..b0fe23439c4a 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -408,6 +408,7 @@ const struct block_device_operations nvme_ns_head_ops = {
 	.open		= nvme_ns_head_open,
 	.release	= nvme_ns_head_release,
 	.ioctl		= nvme_ns_head_ioctl,
+	.compat_ioctl	= blkdev_compat_ptr_ioctl,
 	.getgeo		= nvme_getgeo,
 	.report_zones	= nvme_ns_head_report_zones,
 	.pr_ops		= &nvme_pr_ops,
-- 
2.35.1



