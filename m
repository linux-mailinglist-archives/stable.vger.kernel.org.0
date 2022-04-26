Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EECD050F740
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 11:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345659AbiDZJIF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347851AbiDZJGP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 05:06:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45DAE167F12;
        Tue, 26 Apr 2022 01:46:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9598460C42;
        Tue, 26 Apr 2022 08:46:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DDA1C385A4;
        Tue, 26 Apr 2022 08:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962775;
        bh=YPTj9OOrUeZwZkfCIZpAkWUxMPpzXgHJJrP8oXqzkWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SzBLoDyu7yHHqZZDU7EsskIjk1rrqRD+c9JEXSvO6NsQAgNAt5FVhRpOAffhJhwsT
         hIUBpsMlYOVlEaRF12P1iD1BU0nTfu9x8rvKMXs5lkfXyB/0P//2j3dsIG4fuslBUp
         rctaDUejtCGMiYjVkpavvFw1UvwbXB+S2BZYCWYA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?=E9=87=91=E9=9F=AC?= <me@kingtous.cn>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 085/146] nvme-pci: disable namespace identifiers for the MAXIO MAP1002/1202
Date:   Tue, 26 Apr 2022 10:21:20 +0200
Message-Id: <20220426081752.450072201@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit a98a945b80f8684121d477ae68ebc01da953da1f ]

The MAXIO MAP1002/1202 controllers reports completely bogus Namespace
identifiers that even change after suspend cycles.  Disable using
the Identifiers entirely.

Reported-by: 金韬 <me@kingtous.cn>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Tested-by: 金韬 <me@kingtous.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 6a99ed680915..6be611f49a45 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3443,6 +3443,10 @@ static const struct pci_device_id nvme_id_table[] = {
 		.driver_data = NVME_QUIRK_NO_DEEPEST_PS, },
 	{ PCI_DEVICE(0x2646, 0x2263),   /* KINGSTON A2000 NVMe SSD  */
 		.driver_data = NVME_QUIRK_NO_DEEPEST_PS, },
+	{ PCI_DEVICE(0x1e4B, 0x1002),   /* MAXIO MAP1002 */
+		.driver_data = NVME_QUIRK_BOGUS_NID, },
+	{ PCI_DEVICE(0x1e4B, 0x1202),   /* MAXIO MAP1202 */
+		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMAZON, 0x0061),
 		.driver_data = NVME_QUIRK_DMA_ADDRESS_BITS_48, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMAZON, 0x0065),
-- 
2.35.1



