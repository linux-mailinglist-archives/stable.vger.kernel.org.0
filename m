Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D44D3719DF
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231857AbhECQiF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:38:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:38488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231626AbhECQhI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:37:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09277613CF;
        Mon,  3 May 2021 16:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059761;
        bh=zF10B42BU7PZxpk8L9YI3lbTpw7BWdCgjXh1YWIYcew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NjC9YokV2Fsg5MSz79PvkEtePytCMVKOVm7tqPbGZPf7NAR02F5QdErlOC+43f0tl
         RrhXMyN26YDocZUqX7tQWAhBsmR/8XD8M1CVcHtAHYphdnsFIlqF8mLqnKxSONxUtQ
         D1heyc6qakSK2jiqFGz9g4MJf5Ht/QsP9Ls/chEC0yhmoP8F387BA9tj3IRXBwNeUy
         Ng9ecr5OMnkNhR0HpomLmR1WxrkMxXKqKG/dIR/JOM1dVtMVprslae62Eo5AEIqh2Q
         ziz+Lw4p3yYffhoPZAKTIZIgws9brjPap2akPwH8rfn7vhNQDXQ+Qbk6TNoHcH0Mud
         79QtGrKC2z9Dw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brad Love <brad@nextdimension.cc>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 030/134] media: cx23885: add more quirks for reset DMA on some AMD IOMMU
Date:   Mon,  3 May 2021 12:33:29 -0400
Message-Id: <20210503163513.2851510-30-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163513.2851510-1-sashal@kernel.org>
References: <20210503163513.2851510-1-sashal@kernel.org>
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

