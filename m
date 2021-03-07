Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6379233019A
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 14:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231699AbhCGN6U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 08:58:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:43776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231545AbhCGN6J (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Mar 2021 08:58:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3AAE065114;
        Sun,  7 Mar 2021 13:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615125488;
        bh=YAizosHBtd0UotTQX+C7OrmDWffD6n9P8Zg0yC+xJEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q4249fcekZ22lhB+4jqtTAnKIiar+dMhQMAkij/drZAoooqhfVi3UUWApND05/dNR
         Z4OjAhEkKb59wI8sLgRYZlWwoM83FNtiQemhaFtv6+f8fi9s90ijOwT2jF2D5A4CIX
         8bC012v6xwYCyy7dMQRhzcKyE8mJ1VL2EBvNepKKy0WaVoF+jGU7OFh4l25/4ejy1D
         7pxhRIHbQlfugqR62MmBf//4zvgLdTSNExIDhXSua2fXmtQA/2W9mIwNiHF4Yv1QVc
         14nNaeJM7giISUhaaWRh9FCrpVA2xmoj8R5uGUBvLP+YtdjL8DO5SMG6XDTNQiEe8u
         xaYvhhnMqS3ig==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pascal Terjan <pterjan@google.com>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 6/8] nvme-pci: add quirks for Lexar 256GB SSD
Date:   Sun,  7 Mar 2021 08:57:59 -0500
Message-Id: <20210307135801.967583-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210307135801.967583-1-sashal@kernel.org>
References: <20210307135801.967583-1-sashal@kernel.org>
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
index 2aed3b066b85..d4f01fc455c8 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3250,6 +3250,9 @@ static const struct pci_device_id nvme_id_table[] = {
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

