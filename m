Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63C253301B6
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 14:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231903AbhCGN6u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 08:58:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:43904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231643AbhCGN6R (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Mar 2021 08:58:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55B1B6511D;
        Sun,  7 Mar 2021 13:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615125496;
        bh=jue6DPUWeTBMRrvmuShoXmh5XJ6nKbedmF6zuJ13k3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pRBa/AnpSbQqyZMaPLc0X8m6kKBvrtKrb0PWbaZNbeiv2pgmIoy5RbvjuNAn/QyaN
         j7C3AV062eleMLHsIYHBxQQPrUyqY310ATyhOc9PSgjd/HMu9nxuVKuYMkHTy3gyZj
         FpAHXjAHX66qF6N5pxz7LUEOcH72V0Gvm3QzXUTgtPfzLemm4xvUsYvJDZwCQWZLbb
         Zpheh7rnA3X/6m1a4U+AtqFFTj3cBvykJXM1rLL/Eruti9mzK4GPP6HjTgPtyFX6ep
         4m3mtdJl0J4+CySzpCeGNbWJKUPnAobAwiC4xkb1CTZaTqyhodFoZHK6ZVE5UYA8cr
         QuVZD0P02lGUA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pascal Terjan <pterjan@google.com>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 4/5] nvme-pci: add quirks for Lexar 256GB SSD
Date:   Sun,  7 Mar 2021 08:58:10 -0500
Message-Id: <20210307135812.967702-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210307135812.967702-1-sashal@kernel.org>
References: <20210307135812.967702-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pascal Terjan <pterjan@google.com>

[ Upstream commit 6e6a6828c517fb6819479bf5187df5f39084eb9e ]

Add the NVME_QUIRK_NO_NS_DESC_LIST and NVME_QUIRK_IGNORE_DEV_SUBNQN
quirks for this buggy device.

Reported and tested in https://bugs.mageia.org/show_bug.cgi?id=28417

Signed-off-by: Pascal Terjan <pterjan@google.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 197a5cd253c3..fc18738dcf8f 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3179,6 +3179,9 @@ static const struct pci_device_id nvme_id_table[] = {
 				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
 	{ PCI_DEVICE(0x1987, 0x5016),	/* Phison E16 */
 		.driver_data = NVME_QUIRK_IGNORE_DEV_SUBNQN, },
+	{ PCI_DEVICE(0x1b4b, 0x1092),	/* Lexar 256 GB SSD */
+		.driver_data = NVME_QUIRK_NO_NS_DESC_LIST |
+				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
 	{ PCI_DEVICE(0x1d1d, 0x1f1f),	/* LighNVM qemu device */
 		.driver_data = NVME_QUIRK_LIGHTNVM, },
 	{ PCI_DEVICE(0x1d1d, 0x2807),	/* CNEX WL */
-- 
2.30.1

