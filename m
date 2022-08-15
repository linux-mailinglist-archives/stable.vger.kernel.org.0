Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF402595094
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231760AbiHPEnU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231236AbiHPEmA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:42:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E546C4E616;
        Mon, 15 Aug 2022 13:36:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B3E1611E2;
        Mon, 15 Aug 2022 20:36:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE5BC433C1;
        Mon, 15 Aug 2022 20:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595804;
        bh=gMMp2Qx9M5AdLKB1yiTry430Xu/koJbBtsrhkCFPWoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yJ/wmyKJgFfsfdYSSh5AU9dHR4ex78esPYaRS4vBoFqd/r1RbEIR5TJLrXyu/XM1h
         RIjsR6EcD8hWVkHhkRmThNxH834Ub3rxFCUipbIT5GdrhstTuJUJbGlHs2Qy/Jp/6v
         DbSD+iB3VHy6SaIfK8zXqyl2KW1gAp1VIYOHyMwg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Bowler <nbowler@draconx.ca>,
        Guixin Liu <kanie@linux.alibaba.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0881/1157] nvme: define compat_ioctl again to unbreak 32-bit userspace.
Date:   Mon, 15 Aug 2022 20:03:57 +0200
Message-Id: <20220815180514.671731161@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
index 6a12a906a11e..9c75d7378d31 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2123,6 +2123,7 @@ static int nvme_report_zones(struct gendisk *disk, sector_t sector,
 static const struct block_device_operations nvme_bdev_ops = {
 	.owner		= THIS_MODULE,
 	.ioctl		= nvme_ioctl,
+	.compat_ioctl	= blkdev_compat_ptr_ioctl,
 	.open		= nvme_open,
 	.release	= nvme_release,
 	.getgeo		= nvme_getgeo,
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index d3e2440d8abb..432ea9793a84 100644
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



