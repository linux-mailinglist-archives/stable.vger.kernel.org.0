Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 122E62E142E
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729703AbgLWCWb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:22:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:51318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728175AbgLWCWb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:22:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00A3D22285;
        Wed, 23 Dec 2020 02:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690135;
        bh=P5unjbZXH+XbGIoXl0W3FbS6BfbWKr7hscTz0MlxwNI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qjXHVEvRxvJ3HdkAR9r7/MyGhI6sSgPLZ+BhG7vJHzH1tBt1DXF82wAwTn1bbOpzZ
         Tap7lUg1dS4u2sx7clyK5HNskgqvG61SS+x/aNogFtM/r9RsEjaOVb1Vh5FxJNNj2w
         otgVeIRZCrcNooiSHxAnB8AUyfR7AS0F7qPGp3Y3FXbzyWotMyx/slAgh6TD8jr+Xj
         YA9wanySzZiAtmorP9ATdspAChu+2Nlnv232IBwXwBzzSKJbXh+4ZPewusG8BO1jJm
         xJVy2sczq6RgS+XNwgNIg3zTwuW8bVw9pAWGW1J5cXaTZOF0Xfth44oerRw/awmYUf
         GOYKT1szTdKUQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Lee Kruse <daniel.lee.kruse@protonmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 58/87] media: cx23885: add more quirks for reset DMA on some AMD IOMMU
Date:   Tue, 22 Dec 2020 21:20:34 -0500
Message-Id: <20201223022103.2792705-58-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022103.2792705-1-sashal@kernel.org>
References: <20201223022103.2792705-1-sashal@kernel.org>
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
index fd5c52b21436b..a1d738969d7b1 100644
--- a/drivers/media/pci/cx23885/cx23885-core.c
+++ b/drivers/media/pci/cx23885/cx23885-core.c
@@ -2084,6 +2084,10 @@ static struct {
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

