Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4557731BCF1
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbhBOPhq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:37:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:49782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231186AbhBOPfw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:35:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E43864ECA;
        Mon, 15 Feb 2021 15:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403110;
        bh=ugxDEj/l2/ri2yZotp1Z6IJkCjAT1oVtKgFdUhhVr1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aZ+izSmUjPHLJYO0fkiqhwMC/xfI3/7szZSXC/COBIwmMb37tDqR0oB2gkKGiEtTc
         TSUwGGF6b+mIObeRBotmLxgBrBiHbPtN+iLGFYdBR05fW3N60ALUGvWFYLEJdmRrCt
         xXHV9RjRR5fwVKPPjpzvxD5nCdq8RMfEYcaWYL9g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claus Stovgaard <claus.stovgaard@gmail.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 030/104] nvme-pci: ignore the subsysem NQN on Phison E16
Date:   Mon, 15 Feb 2021 16:26:43 +0100
Message-Id: <20210215152720.465523635@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claus Stovgaard <claus.stovgaard@gmail.com>

[ Upstream commit c9e95c39280530200cdd0bbd2670e6334a81970b ]

Tested both with Corsairs firmware 11.3 and 13.0 for the Corsairs MP600
and both have the issue as reported by the kernel.

nvme nvme0: missing or invalid SUBNQN field.

Signed-off-by: Claus Stovgaard <claus.stovgaard@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index a32494cde61f7..4a33287371bda 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3247,6 +3247,8 @@ static const struct pci_device_id nvme_id_table[] = {
 	{ PCI_DEVICE(0x144d, 0xa822),   /* Samsung PM1725a */
 		.driver_data = NVME_QUIRK_DELAY_BEFORE_CHK_RDY |
 				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
+	{ PCI_DEVICE(0x1987, 0x5016),	/* Phison E16 */
+		.driver_data = NVME_QUIRK_IGNORE_DEV_SUBNQN, },
 	{ PCI_DEVICE(0x1d1d, 0x1f1f),	/* LighNVM qemu device */
 		.driver_data = NVME_QUIRK_LIGHTNVM, },
 	{ PCI_DEVICE(0x1d1d, 0x2807),	/* CNEX WL */
-- 
2.27.0



