Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 905042E1637
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728916AbgLWCUQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:20:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:46410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728906AbgLWCUP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:20:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5194423357;
        Wed, 23 Dec 2020 02:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690000;
        bh=4cFHR5YE9cqHcWM2vuonEFf7LB+PRgE6dNlV76YCjsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jQ5pJNx+Hx4LxSja5cXMxRzWIDlQHajHSolMri4yZzzEBw/3XGefDVqvDEneug7ku
         1G+X3Fzjllk75XNFzRaRCGgrSiqrs+cBpnW3BRdvMb9dSi3HMQ699hHBCEzKarYTBX
         GBQRVhD0PN9TqdP8eRSC/9N2cZOyeCFCGAjBFW2GKiBP4vlSmu7MN2E47uqMqLgBaq
         RXqHEHO6m2OQ8+Eevrz7VonIIGZaYOD9v6NTpu9++yIT79HZMIb4A7prpDLfQPNTQg
         y0tI7ywLuWViX40Lh+YjoI7w8MlPp3jD+U+FxF6s3OFfc48i0En3jrLqOpwPJQp6KK
         ndnUo7XFZGLsg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Lee Kruse <daniel.lee.kruse@protonmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 082/130] media: cx23885: add more quirks for reset DMA on some AMD IOMMU
Date:   Tue, 22 Dec 2020 21:17:25 -0500
Message-Id: <20201223021813.2791612-82-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 7e0b0b7cc2a35..ead0acb7807c8 100644
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
2.27.0

