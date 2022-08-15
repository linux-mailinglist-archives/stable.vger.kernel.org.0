Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C849C5939F4
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244757AbiHOT3V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343790AbiHOT0O (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:26:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB45A2ED69;
        Mon, 15 Aug 2022 11:41:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4744D61029;
        Mon, 15 Aug 2022 18:41:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 378FCC433B5;
        Mon, 15 Aug 2022 18:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588904;
        bh=yIa20byh02SPEnrPWn+KsrTdc7YW/1nPI3I2EWlrIBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1op+MAWkzb+815QFh157OHyY2JbS57AVxsOxfm4t8GdKlseeS3fG00a1Jhs27452j
         X3bfyF1Oh/eoKtSUYGItwkxfhVgJPu6l3p8G3eK+CqlptiAXTzawecWw1r8hMFlsNF
         GyCMC3Tx0zs4SxFmALnZEQWC/GDbRvINji1/vwsc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 551/779] nvme: disable namespace access for unsupported metadata
Date:   Mon, 15 Aug 2022 20:03:15 +0200
Message-Id: <20220815180400.883704062@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit d39ad2a45c0e38def3e0c95f5b90d9af4274c939 ]

The only fabrics target that supports metadata handling through the
separate integrity buffer is RDMA. It is currently usable only if the
size is 8B per block and formatted for protection information. If an
rdma target were to export a namespace with a different format (ex:
4k+64B), the driver will not be able to submit valid read/write commands
for that namespace.

Suppress setting the metadata feature in the namespace so that the
gendisk capacity will be set to 0. This will prevent read/write access
through the block stack, but will continue to allow ioctl passthrough
commands.

Cc: Max Gurtovoy <mgurtovoy@nvidia.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index ace55ebb1bff..d9aea6c22f52 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1744,9 +1744,20 @@ static int nvme_configure_metadata(struct nvme_ns *ns, struct nvme_id_ns *id)
 		 */
 		if (WARN_ON_ONCE(!(id->flbas & NVME_NS_FLBAS_META_EXT)))
 			return -EINVAL;
-		if (ctrl->max_integrity_segments)
-			ns->features |=
-				(NVME_NS_METADATA_SUPPORTED | NVME_NS_EXT_LBAS);
+
+		ns->features |= NVME_NS_EXT_LBAS;
+
+		/*
+		 * The current fabrics transport drivers support namespace
+		 * metadata formats only if nvme_ns_has_pi() returns true.
+		 * Suppress support for all other formats so the namespace will
+		 * have a 0 capacity and not be usable through the block stack.
+		 *
+		 * Note, this check will need to be modified if any drivers
+		 * gain the ability to use other metadata formats.
+		 */
+		if (ctrl->max_integrity_segments && nvme_ns_has_pi(ns))
+			ns->features |= NVME_NS_METADATA_SUPPORTED;
 	} else {
 		/*
 		 * For PCIe controllers, we can't easily remap the separate
-- 
2.35.1



