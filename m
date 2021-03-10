Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4751B333DFF
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233274AbhCJNZQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:25:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:46164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233007AbhCJNYq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:24:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 659B964FEF;
        Wed, 10 Mar 2021 13:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382685;
        bh=pNeHKl7PBP6p8g7DY5rL5HNpimmaaw/uXF3RzwUa24Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VT7fM/4HJSzWw9UElrDHxBNvQSdNz5IF4xmD4jno8qnw4T8rmi+9DbdRPASaRnGsw
         PvnyGwN3z8rkKCglguFJhdX5IL6fz/1h62v7of1aNeG6ZmnVLYreo/ZvmK4pWf5HTg
         ZM/c3eEQwlhL2LmmRkwksDD2yilK4V5A3mRO6Aq0=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Daniel Lee Kruse <daniel.lee.kruse@protonmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 22/49] media: cx23885: add more quirks for reset DMA on some AMD IOMMU
Date:   Wed, 10 Mar 2021 14:23:33 +0100
Message-Id: <20210310132322.655298973@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132321.948258062@linuxfoundation.org>
References: <20210310132321.948258062@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Daniel Lee Kruse <daniel.lee.kruse@protonmail.com>

[ Upstream commit dbf0b3a7b719eb3f72cb53c2ce7d34a012a9c261 ]

On AMD Family 15h (Models 30h-3fh), I/O Memory Management Unit
RiSC engine sometimes stalls, requiring a reset.

As result, MythTV and w-scan won't scan channels on the AMD Kaveri
APU with the Hauppauge QuadHD TV tuner card.

For the solution I added the Input/Output Memory Management Unit's PCI
Identity of 0x1423 to the broken_dev_id[] array, which is used by
a quirks logic meant to fix similar problems with other AMD
chipsets.

Signed-off-by: Daniel Lee Kruse <daniel.lee.kruse@protonmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/cx23885/cx23885-core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
index 4b0c53f61fb7..4e8132d4b2df 100644
--- a/drivers/media/pci/cx23885/cx23885-core.c
+++ b/drivers/media/pci/cx23885/cx23885-core.c
@@ -2074,6 +2074,10 @@ static struct {
 	 * 0x1451 is PCI ID for the IOMMU found on Ryzen
 	 */
 	{ PCI_VENDOR_ID_AMD, 0x1451 },
+	/* According to sudo lspci -nn,
+	 * 0x1423 is the PCI ID for the IOMMU found on Kaveri
+	 */
+	{ PCI_VENDOR_ID_AMD, 0x1423 },
 };
 
 static bool cx23885_does_need_dma_reset(void)
-- 
2.30.1



