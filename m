Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2973378603
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234369AbhEJLDU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:03:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:52158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234830AbhEJK5J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:57:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C94AF6194A;
        Mon, 10 May 2021 10:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643780;
        bh=zF10B42BU7PZxpk8L9YI3lbTpw7BWdCgjXh1YWIYcew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yQHOIFp6nsy4tbC77woEx/bUzfc5SRCecMAe+hCNeTyUXrnMk+cHIREkONUtEVZrc
         c9uIJ3pyVvCzvDNa400KMmZANbX182wLn2VFKWL32fbPfQkAh27AYw+Q9rz/28T/+A
         859hrXAgEXquIYDuHIGICXsA7j3oXZG+n6Uvx6GQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brad Love <brad@nextdimension.cc>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 155/342] media: cx23885: add more quirks for reset DMA on some AMD IOMMU
Date:   Mon, 10 May 2021 12:19:05 +0200
Message-Id: <20210510102015.219113302@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brad Love <brad@nextdimension.cc>

[ Upstream commit 5f864cfbf59bfed2057bd214ce7fbf6ad420d54b ]

The folowing AMD IOMMU are affected by the RiSC engine stall, requiring a
reset to maintain continual operation. After being added to the
broken_dev_id list the systems are functional long term.

0x1481 is the PCI ID for the IOMMU found on Starship/Matisse

0x1419 is the PCI ID for the IOMMU found on 15h (Models 10h-1fh) family

0x5a23 is the PCI ID for the IOMMU found on RD890S/RD990

Signed-off-by: Brad Love <brad@nextdimension.cc>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/cx23885/cx23885-core.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
index 22f55a7840a6..d0ca260ecf70 100644
--- a/drivers/media/pci/cx23885/cx23885-core.c
+++ b/drivers/media/pci/cx23885/cx23885-core.c
@@ -2077,6 +2077,15 @@ static struct {
 	 * 0x1423 is the PCI ID for the IOMMU found on Kaveri
 	 */
 	{ PCI_VENDOR_ID_AMD, 0x1423 },
+	/* 0x1481 is the PCI ID for the IOMMU found on Starship/Matisse
+	 */
+	{ PCI_VENDOR_ID_AMD, 0x1481 },
+	/* 0x1419 is the PCI ID for the IOMMU found on 15h (Models 10h-1fh) family
+	 */
+	{ PCI_VENDOR_ID_AMD, 0x1419 },
+	/* 0x5a23 is the PCI ID for the IOMMU found on RD890S/RD990
+	 */
+	{ PCI_VENDOR_ID_ATI, 0x5a23 },
 };
 
 static bool cx23885_does_need_dma_reset(void)
-- 
2.30.2



