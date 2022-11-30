Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3700763DE1F
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:34:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbiK3SeU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:34:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbiK3SeA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:34:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2213E27B23
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:33:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B38BA61D3D
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:33:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0BD7C433D6;
        Wed, 30 Nov 2022 18:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833235;
        bh=+5UgjmHzDMCUgjCTNTZ9rCitNZotq/ZNj2ltOhrj0UU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LVRh9Lmon2JzdrFBwZ+lKBellrUQ31zjCPGyUWsuti8fPheFAoaQP9QXZ4FJwNwek
         0IfySwqjnn/d4c2rBj91vDFyA2ULtOebxWno+zFE40R2oe4a9EFKO64+k2SY75hgLS
         /vGsxzCewuK/aigD302jMdMvgoDzrdibRrc/RBG0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Arman Hajishafieha <arman.hajishafieha@hotmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 017/206] nvme-pci: disable namespace identifiers for the MAXIO MAP1001
Date:   Wed, 30 Nov 2022 19:21:09 +0100
Message-Id: <20221130180533.435872651@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 70ce3455345d056b5fc427c3bb4a3ff4d126b6d5 ]

The MAXIO MAP1001 controllers reports completely bogus Namespace
identifiers that even change after suspend cycles.  Disable using
the Identifiers entirely.

Reported-by: Arman Hajishafieha <arman.hajishafieha@hotmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Tested-by: Arman Hajishafieha <arman.hajishafieha@hotmail.com>
Stable-dep-of: 8d6e38f636ac ("nvme-pci: add NVME_QUIRK_BOGUS_NID for Netac NV7000")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 278302771841..66e252af9218 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3365,6 +3365,8 @@ static const struct pci_device_id nvme_id_table[] = {
 		.driver_data = NVME_QUIRK_NO_DEEPEST_PS, },
 	{ PCI_DEVICE(0x2646, 0x2263),   /* KINGSTON A2000 NVMe SSD  */
 		.driver_data = NVME_QUIRK_NO_DEEPEST_PS, },
+	{ PCI_DEVICE(0x1e4B, 0x1001),   /* MAXIO MAP1001 */
+		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1e4B, 0x1002),   /* MAXIO MAP1002 */
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1e4B, 0x1202),   /* MAXIO MAP1202 */
-- 
2.35.1



