Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2DB96E6439
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232022AbjDRMrT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232024AbjDRMrS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:47:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F63BB85
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:47:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD372633BE
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:47:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCA01C433EF;
        Tue, 18 Apr 2023 12:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822030;
        bh=iR4IM8oGd+g5QpnWhT6XMCPUGdpnTUEwRh5uBDb0uu4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WnJnjS3D5dH7H9ENJZX/9/F4vitj/LvW+nZJL12dWrEu3xOqGg2sGw2HVjaPVD/YK
         DkEh4/jf0i3ZWBBQ8bTpoQuBiXYjY8fizSQ96/8YICsEc3iyeJbYcPT5mp0iN54oN+
         DHVXCkN/ydIBMoFyQedJ+Sx8t90yy5qah2Ri83K8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Juraj Pecigos <kernel@juraj.dev>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 130/134] nvme-pci: mark Lexar NM760 as IGNORE_DEV_SUBNQN
Date:   Tue, 18 Apr 2023 14:23:06 +0200
Message-Id: <20230418120317.708163933@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juraj Pecigos <kernel@juraj.dev>

[ Upstream commit 1231363aec86704a6b0467a12e3ca7bdf890e01d ]

A system with more than one of these SSDs will only have one usable.
The kernel fails to detect more than one nvme device due to duplicate
cntlids.

before:
[    9.395229] nvme 0000:01:00.0: platform quirk: setting simple suspend
[    9.395262] nvme nvme0: pci function 0000:01:00.0
[    9.395282] nvme 0000:03:00.0: platform quirk: setting simple suspend
[    9.395305] nvme nvme1: pci function 0000:03:00.0
[    9.409873] nvme nvme0: Duplicate cntlid 1 with nvme1, subsys nqn.2022-07.com.siliconmotion:nvm-subsystem-sn-                    , rejecting
[    9.409982] nvme nvme0: Removing after probe failure status: -22
[    9.427487] nvme nvme1: allocated 64 MiB host memory buffer.
[    9.445088] nvme nvme1: 16/0/0 default/read/poll queues
[    9.449898] nvme nvme1: Ignoring bogus Namespace Identifiers

after:
[    1.161890] nvme 0000:01:00.0: platform quirk: setting simple suspend
[    1.162660] nvme nvme0: pci function 0000:01:00.0
[    1.162684] nvme 0000:03:00.0: platform quirk: setting simple suspend
[    1.162707] nvme nvme1: pci function 0000:03:00.0
[    1.191354] nvme nvme0: allocated 64 MiB host memory buffer.
[    1.193378] nvme nvme1: allocated 64 MiB host memory buffer.
[    1.211044] nvme nvme1: 16/0/0 default/read/poll queues
[    1.211080] nvme nvme0: 16/0/0 default/read/poll queues
[    1.216145] nvme nvme0: Ignoring bogus Namespace Identifiers
[    1.216261] nvme nvme1: Ignoring bogus Namespace Identifiers

Adding the NVME_QUIRK_IGNORE_DEV_SUBNQN quirk to resolves the issue.

Signed-off-by: Juraj Pecigos <kernel@juraj.dev>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Stable-dep-of: 74391b3e6985 ("nvme-pci: add NVME_QUIRK_BOGUS_NID for T-FORCE Z330 SSD")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 60452f6a9f711..1bef32cd10252 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3550,7 +3550,8 @@ static const struct pci_device_id nvme_id_table[] = {
 	{ PCI_DEVICE(0x1d97, 0x1d97), /* Lexar NM620 */
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1d97, 0x2269), /* Lexar NM760 */
-		.driver_data = NVME_QUIRK_BOGUS_NID, },
+		.driver_data = NVME_QUIRK_BOGUS_NID |
+				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMAZON, 0x0061),
 		.driver_data = NVME_QUIRK_DMA_ADDRESS_BITS_48, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMAZON, 0x0065),
-- 
2.39.2



