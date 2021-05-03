Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACCF9371B09
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232349AbhECQnJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:43:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:37566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232370AbhECQkl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:40:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9C0A6140F;
        Mon,  3 May 2021 16:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059861;
        bh=zF10B42BU7PZxpk8L9YI3lbTpw7BWdCgjXh1YWIYcew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kWgTA2c2dWOHSYxLa7gpPTqLzo8D5uvnL21jt2ZSfseBiLHASbOXkFzfBwEmtlYa8
         DUmV+RaSxpt7qBNEcdHlOc2ujOiLf7TgKYGzg9mzOqIEZ21BZejLEIx5IgZTJP5Uym
         5A3o9OnCQI1ipaSyIC1I0b9buG8zOtGkgoW1T9tZ+9O1hiq9/fEVyTnlP9Z63HRywY
         WC6gKR9VJ+NLVrjXhudas6YzRkCctr7GJPIPsiqMLVLWDGEQhHQ6dAynHuVcopHm6L
         2BD4ReU3vBF7Uvpi5LurT5BIPGoyR5+xvjw+zRr8CXB7lJl9j2xbqOrOUM/fVa9cM7
         GDrQYyZAhtqEw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brad Love <brad@nextdimension.cc>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 027/115] media: cx23885: add more quirks for reset DMA on some AMD IOMMU
Date:   Mon,  3 May 2021 12:35:31 -0400
Message-Id: <20210503163700.2852194-27-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163700.2852194-1-sashal@kernel.org>
References: <20210503163700.2852194-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

