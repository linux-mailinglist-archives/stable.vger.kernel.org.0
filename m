Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23FAF6E6377
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231842AbjDRMks (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231844AbjDRMkr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:40:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 894E413C2A
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:40:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 060B9632E8
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:40:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BCA8C433EF;
        Tue, 18 Apr 2023 12:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821645;
        bh=mV/Ldfb14BbN4Kxyug1FeCumKaSU4xTjQ7l2zJYLGpI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1vVu+qrKrXW/tqDNPDpLosckmyG2+dGCX2kvTbQzlaWOAFyEBxeq/xmaHBzEjj0xl
         MN8pWwmK1409yPlBsxWXJI/1PEcBidvvtuAJycej2PGBQdkOtXL1BvW8lj91wQQi5R
         +4YYc27fKx+YbgCYlgQ7OIGt1VuMG4q6lSKQh7vk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shyamin Ayesh <me@shyamin.com>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 80/91] nvme-pci: add NVME_QUIRK_BOGUS_NID for Lexar NM610
Date:   Tue, 18 Apr 2023 14:22:24 +0200
Message-Id: <20230418120308.323473117@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120305.520719816@linuxfoundation.org>
References: <20230418120305.520719816@linuxfoundation.org>
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

From: Shyamin Ayesh <me@shyamin.com>

[ Upstream commit 200dccd07df21b504a2168960059f0a971bf415d ]

Lexar NM610 reports bogus eui64 values that appear to be the same across
all drives. Quirk them out so they are not marked as "non globally unique"
duplicates.

Signed-off-by: Shyamin Ayesh <me@shyamin.com>
[patch formatting]
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Stable-dep-of: 74391b3e6985 ("nvme-pci: add NVME_QUIRK_BOGUS_NID for T-FORCE Z330 SSD")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 4e75d329562fa..4023cce17cf8b 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3394,6 +3394,8 @@ static const struct pci_device_id nvme_id_table[] = {
 		.driver_data = NVME_QUIRK_NO_DEEPEST_PS, },
 	{ PCI_DEVICE(0xc0a9, 0x540a),   /* Crucial P2 */
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
+	{ PCI_DEVICE(0x1d97, 0x2263), /* Lexar NM610 */
+		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMAZON, 0x0061),
 		.driver_data = NVME_QUIRK_DMA_ADDRESS_BITS_48, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMAZON, 0x0065),
-- 
2.39.2



