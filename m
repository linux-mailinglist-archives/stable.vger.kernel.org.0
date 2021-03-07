Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBF84330193
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 14:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbhCGN6R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 08:58:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:43636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231526AbhCGN56 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Mar 2021 08:57:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECEDB6510A;
        Sun,  7 Mar 2021 13:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615125478;
        bh=Noy7VcIB02OQkZj4tP6uPONYLse8hIx5KNQ+rhvWrVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sv2qE/3/KB4iLF4e90n08KFatix/IveOmXOk3rnD+1onZyVO8wUglbj4QWvvOfTau
         LBz8nQp1UKVEEBaN372IFBFADJk8Wb4hWavP7qFt6zfpmMEFFdNhuuRJJ4Azluhikl
         Px/Ee3Is6UFeVBXT5uzCHRww3TlKq11WZtd8bEuXCXLQp/JMxMH6/Hc7vdIhtBY23Z
         fSvsossWCuKWwM5F2qPT2gmV0SlBI0D7yN3TFKlRWmsoPzQyyqdWZh4CKsAC37n1md
         jgdJ/5p3ps79BxFaSCo/WScCwS+lVmL4j/IOZThoPMygp92X0UbAqhO4qYTaiFMmn9
         LMre/VE22Y9fA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pascal Terjan <pterjan@google.com>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.11 10/12] nvme-pci: add quirks for Lexar 256GB SSD
Date:   Sun,  7 Mar 2021 08:57:44 -0500
Message-Id: <20210307135746.967418-10-sashal@kernel.org>
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
index 14c5b52400ef..806a5d071ef6 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3245,6 +3245,9 @@ static const struct pci_device_id nvme_id_table[] = {
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

