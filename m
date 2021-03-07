Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FDBD330191
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 14:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbhCGN6Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 08:58:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:43598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231522AbhCGN54 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Mar 2021 08:57:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9044E65109;
        Sun,  7 Mar 2021 13:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615125476;
        bh=/xjGsQhzH3lUrbwmUWpibj2e91FMNh5T8knos8eg0H4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KkD511zpujz5C7dqRao1K2RxxBK3f1Zplc9wwb97U4rIaSq2TLWVmvZQ7Rdgy4dpr
         d2CDaeZwrHBeBOJWd681bPgPnT6mzio0l3TItWEuh/mim/7S9xLbE1UqPclgfTWsgs
         k/7fE8Pc6qcvS8cRPFXSFAZ2LKXrkkxMwmvRTxHhA+J23BEbglQlRoSd2ceCrCME8S
         4x/42MbRgqINFB56cW8qD54rPpi4IIP/LZF9mLKYAnov7qTHC7qOvKRfIbKw0bTZXQ
         vn4Rq3l6V1YlzW3pHydqlTBZM0YLfsAmL+lSCuTlO+c0wxnrkCB2lX+fCLR0QPPTjH
         wgI2kR0qlp4TQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julian Einwag <jeinwag-nvme@marcapo.com>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.11 08/12] nvme-pci: mark Seagate Nytro XM1440 as QUIRK_NO_NS_DESC_LIST.
Date:   Sun,  7 Mar 2021 08:57:42 -0500
Message-Id: <20210307135746.967418-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210307135746.967418-1-sashal@kernel.org>
References: <20210307135746.967418-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Einwag <jeinwag-nvme@marcapo.com>

[ Upstream commit 5e112d3fb89703a4981ded60561b5647db3693bf ]

The kernel fails to fully detect these SSDs, only the character devices
are present:

[   10.785605] nvme nvme0: pci function 0000:04:00.0
[   10.876787] nvme nvme1: pci function 0000:81:00.0
[   13.198614] nvme nvme0: missing or invalid SUBNQN field.
[   13.198658] nvme nvme1: missing or invalid SUBNQN field.
[   13.206896] nvme nvme0: Shutdown timeout set to 20 seconds
[   13.215035] nvme nvme1: Shutdown timeout set to 20 seconds
[   13.225407] nvme nvme0: 16/0/0 default/read/poll queues
[   13.233602] nvme nvme1: 16/0/0 default/read/poll queues
[   13.239627] nvme nvme0: Identify Descriptors failed (8194)
[   13.246315] nvme nvme1: Identify Descriptors failed (8194)

Adding the NVME_QUIRK_NO_NS_DESC_LIST fixes this problem.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=205679
Signed-off-by: Julian Einwag <jeinwag-nvme@marcapo.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 6bad4d4dcdf0..7a38d764b486 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3230,7 +3230,8 @@ static const struct pci_device_id nvme_id_table[] = {
 	{ PCI_DEVICE(0x126f, 0x2263),	/* Silicon Motion unidentified */
 		.driver_data = NVME_QUIRK_NO_NS_DESC_LIST, },
 	{ PCI_DEVICE(0x1bb1, 0x0100),   /* Seagate Nytro Flash Storage */
-		.driver_data = NVME_QUIRK_DELAY_BEFORE_CHK_RDY, },
+		.driver_data = NVME_QUIRK_DELAY_BEFORE_CHK_RDY |
+				NVME_QUIRK_NO_NS_DESC_LIST, },
 	{ PCI_DEVICE(0x1c58, 0x0003),	/* HGST adapter */
 		.driver_data = NVME_QUIRK_DELAY_BEFORE_CHK_RDY, },
 	{ PCI_DEVICE(0x1c58, 0x0023),	/* WDC SN200 adapter */
-- 
2.30.1

