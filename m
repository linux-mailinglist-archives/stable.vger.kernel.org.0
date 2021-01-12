Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC67D2F3124
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 14:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730532AbhALNQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 08:16:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:53816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390286AbhALM5a (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:57:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7440C23110;
        Tue, 12 Jan 2021 12:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456185;
        bh=CsQndEsie5njlaPw7SSSQtZoRkZoiOZBqeW7sQW2Zgk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HfJacmebrjBwQGQ4L8Ou6zGkRix9CwUq/W0pjLpRjYOisyzQQrb0WRp866K9ERq7u
         OETJyHhy1KfoSNV6mz3xMBkTwIivONFxUPx6ltU95P7SkHGu8qKnj5esdi2mid8dnu
         cWccug1Amjy+OXpEa4HfRf9/mKZroSED7VS9A8KNnjto6jrxBAI6dMO85KxAbAbo8y
         VmPJibyWg+wN/AmgIwRdRlNd4NIRpHgLP3/oJouMQy3ojRD06q0qiC1TOPmlWbG79M
         7vnDQZwmgB0QPqTHd9p+aOBZZXzx1HjAmDNFlBto+KqdtZkFJQe9nCyUJTqmZUAQnS
         4rRADSvSJ7dFg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gopal Tiwari <gtiwari@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 38/51] nvme-pci: mark Samsung PM1725a as IGNORE_DEV_SUBNQN
Date:   Tue, 12 Jan 2021 07:55:20 -0500
Message-Id: <20210112125534.70280-38-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125534.70280-1-sashal@kernel.org>
References: <20210112125534.70280-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gopal Tiwari <gtiwari@redhat.com>

[ Upstream commit 7ee5c78ca3895d44e918c38332921983ed678be0 ]

A system with more than one of these SSDs will only have one usable.
Hence the kernel fails to detect nvme devices due to duplicate cntlids.

[    6.274554] nvme nvme1: Duplicate cntlid 33 with nvme0, rejecting
[    6.274566] nvme nvme1: Removing after probe failure status: -22

Adding the NVME_QUIRK_IGNORE_DEV_SUBNQN quirk to resolves the issue.

Signed-off-by: Gopal Tiwari <gtiwari@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 3be352403839a..143f16a9f8d7e 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3201,7 +3201,8 @@ static const struct pci_device_id nvme_id_table[] = {
 	{ PCI_DEVICE(0x144d, 0xa821),   /* Samsung PM1725 */
 		.driver_data = NVME_QUIRK_DELAY_BEFORE_CHK_RDY, },
 	{ PCI_DEVICE(0x144d, 0xa822),   /* Samsung PM1725a */
-		.driver_data = NVME_QUIRK_DELAY_BEFORE_CHK_RDY, },
+		.driver_data = NVME_QUIRK_DELAY_BEFORE_CHK_RDY |
+				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
 	{ PCI_DEVICE(0x1d1d, 0x1f1f),	/* LighNVM qemu device */
 		.driver_data = NVME_QUIRK_LIGHTNVM, },
 	{ PCI_DEVICE(0x1d1d, 0x2807),	/* CNEX WL */
-- 
2.27.0

