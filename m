Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 432B0579CE7
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239307AbiGSMpa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:45:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241914AbiGSMot (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:44:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCFC587F73;
        Tue, 19 Jul 2022 05:17:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CE4C61746;
        Tue, 19 Jul 2022 12:17:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82444C341CA;
        Tue, 19 Jul 2022 12:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233047;
        bh=BmG0AIFw+eljF42VL9fIOkV9TDiDb49cHlNYb29j45k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W91Q1x3BaRhLru1GsQhVOWWi2c/UhcANbPxXGSWmpRhXGsaMNicrT4XixbVvuo+Rp
         IjM1CYO3BmzYx2s8Iid02tkynGwC7pHXnyXKzb1uPhFDME6qMGBgcwjyXIgvzncupe
         NX/OV2lqU2Xtccr4wWLRQ9DisLdMdEuchqWLrXEM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Egolf <cegolf@ugholf.net>,
        Keith Busch <kbusch@kernel.org>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 156/167] nvme-pci: phison e16 has bogus namespace ids
Date:   Tue, 19 Jul 2022 13:54:48 +0200
Message-Id: <20220719114711.598252118@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
References: <20220719114656.750574879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 73029c9b23cf1213e5f54c2b59efce08665199e7 ]

Add the quirk.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216049
Reported-by: Chris Egolf <cegolf@ugholf.net>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index c3db9f12dac3..d820131d39b2 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3337,7 +3337,8 @@ static const struct pci_device_id nvme_id_table[] = {
 				NVME_QUIRK_DISABLE_WRITE_ZEROES|
 				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
 	{ PCI_DEVICE(0x1987, 0x5016),	/* Phison E16 */
-		.driver_data = NVME_QUIRK_IGNORE_DEV_SUBNQN, },
+		.driver_data = NVME_QUIRK_IGNORE_DEV_SUBNQN |
+				NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1b4b, 0x1092),	/* Lexar 256 GB SSD */
 		.driver_data = NVME_QUIRK_NO_NS_DESC_LIST |
 				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
-- 
2.35.1



