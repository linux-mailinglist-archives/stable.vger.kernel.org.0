Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65FEC176BCF
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 03:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727496AbgCCCwf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Mar 2020 21:52:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:46444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729011AbgCCCt4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Mar 2020 21:49:56 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4725F246E3;
        Tue,  3 Mar 2020 02:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583203796;
        bh=LJQN/i1xcn/izMiQyWEoamWpx6M4xuseQ8kP/lbMldQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QLTuJHWOK7p+uzN//ISIPNBZdvJxb7sJqIKJa2e98yO85+qvJriH7TU/9PrkV3RKy
         yGafZPrHGb3M9KiqJhp3ked54n5R7yv+DnSynvoRr739dPGjhEju52PsgncW8XqiPP
         fbEnjhLSEA5tnc5lyYoEq67uUJjfBl7I3GfQyaWA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Leif Liddy <leif.liddy@gmail.com>,
        Keith Busch <kbusch@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 17/22] nvme-pci: Use single IRQ vector for old Apple models
Date:   Mon,  2 Mar 2020 21:49:28 -0500
Message-Id: <20200303024933.10371-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200303024933.10371-1-sashal@kernel.org>
References: <20200303024933.10371-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 98f7b86a0becc1154b1a6df6e75c9695dfd87e0d ]

People reported that old Apple machines are not working properly
if the non-first IRQ vector is in use.

Set quirk for that models to limit IRQ to use first vector only.

Based on original patch by GitHub user npx001.

Link: https://github.com/Dunedan/mbp-2016-linux/issues/9
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Leif Liddy <leif.liddy@gmail.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 3788c053a0b19..06cf0bc944f94 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2573,7 +2573,8 @@ static const struct pci_device_id nvme_id_table[] = {
 	{ PCI_DEVICE(0x1d1d, 0x2601),	/* CNEX Granby */
 		.driver_data = NVME_QUIRK_LIGHTNVM, },
 	{ PCI_DEVICE_CLASS(PCI_CLASS_STORAGE_EXPRESS, 0xffffff) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_APPLE, 0x2001) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_APPLE, 0x2001),
+		.driver_data = NVME_QUIRK_SINGLE_VECTOR },
 	{ PCI_DEVICE(PCI_VENDOR_ID_APPLE, 0x2003) },
 	{ 0, }
 };
-- 
2.20.1

