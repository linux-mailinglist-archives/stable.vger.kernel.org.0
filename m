Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA1F66DEEBE
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbjDLIol (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:44:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbjDLIoa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:44:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B46586AC
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:44:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FB05630AC
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:43:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49073C4339B;
        Wed, 12 Apr 2023 08:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289021;
        bh=AZNT+Cl+hXJedy9fRIdLCIO8HMocsopZS18/9NMKlp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HrXt9HtUumP+gjxxm9zM0nIe5II83ix+b+QrYLp4p+4jxYCwDUUQxCpnvPvq6qxNL
         bA/10VyS7bpqUZSsuJaZsR4FcYxlcTjBly2s57NdWX35V6RlN4J5iIN0/b474VOGO0
         DuvehT5XJbhM/8+0OmoPXMv+Z0JYAqLWiAXpAJsA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Laurence Oberman <loberman@redhat.com>,
        Keith Busch <kbusch@kernel.org>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 106/164] nvme: fix discard support without oncs
Date:   Wed, 12 Apr 2023 10:33:48 +0200
Message-Id: <20230412082841.122616210@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit d3205ab75e99a47539ec91ef85ba488f4ddfeaa9 ]

The device can report discard support without setting the ONCS DSM bit.
When not set, the driver clears max_discard_size expecting it to be set
later. We don't know the size until we have the namespace format,
though, so setting it is deferred until configuring one, but the driver
was abandoning the discard settings due to that initial clearing.

Move the max_discard_size calculation above the check for a '0' discard
size.

Fixes: 1a86924e4f46475 ("nvme: fix interpretation of DMRSL")
Reported-by: Laurence Oberman <loberman@redhat.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Tested-by: Laurence Oberman <loberman@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index a95e48b51da66..cb71ce3413c2d 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1711,6 +1711,9 @@ static void nvme_config_discard(struct gendisk *disk, struct nvme_ns *ns)
 	struct request_queue *queue = disk->queue;
 	u32 size = queue_logical_block_size(queue);
 
+	if (ctrl->dmrsl && ctrl->dmrsl <= nvme_sect_to_lba(ns, UINT_MAX))
+		ctrl->max_discard_sectors = nvme_lba_to_sect(ns, ctrl->dmrsl);
+
 	if (ctrl->max_discard_sectors == 0) {
 		blk_queue_max_discard_sectors(queue, 0);
 		return;
@@ -1725,9 +1728,6 @@ static void nvme_config_discard(struct gendisk *disk, struct nvme_ns *ns)
 	if (queue->limits.max_discard_sectors)
 		return;
 
-	if (ctrl->dmrsl && ctrl->dmrsl <= nvme_sect_to_lba(ns, UINT_MAX))
-		ctrl->max_discard_sectors = nvme_lba_to_sect(ns, ctrl->dmrsl);
-
 	blk_queue_max_discard_sectors(queue, ctrl->max_discard_sectors);
 	blk_queue_max_discard_segments(queue, ctrl->max_discard_segments);
 
-- 
2.39.2



