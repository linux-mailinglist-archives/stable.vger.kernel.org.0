Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93FB2176B1E
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 03:48:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728454AbgCCCsb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Mar 2020 21:48:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:44370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728449AbgCCCsb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Mar 2020 21:48:31 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D799E24680;
        Tue,  3 Mar 2020 02:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583203710;
        bh=CWEtkoDz7AAcoaT1SOeJLtCyrIg9HCHGi9wZwmIhtwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mQdyIADm6ZfVghfLtNESl1venYawusPYXn7gyAAu1zGNAQZCh+6ncghXvVeTDuNnc
         uKLQwfX8NsB7L+C3+KM+v9RUO7p+lErSi2nkHzyIt7q66G2OjUU6y4RZ5b6yZcQg7I
         EaF3PMrndd0u/Ze/NQninMdP81Lsq852jFJKBZCE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Leif Liddy <leif.liddy@gmail.com>,
        Keith Busch <kbusch@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 41/58] nvme-pci: Use single IRQ vector for old Apple models
Date:   Mon,  2 Mar 2020 21:47:23 -0500
Message-Id: <20200303024740.9511-41-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200303024740.9511-1-sashal@kernel.org>
References: <20200303024740.9511-1-sashal@kernel.org>
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
index 944f89fc15946..654f14cef9d2a 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3113,7 +3113,8 @@ static const struct pci_device_id nvme_id_table[] = {
 		.driver_data = NVME_QUIRK_NO_DEEPEST_PS |
 				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
 	{ PCI_DEVICE_CLASS(PCI_CLASS_STORAGE_EXPRESS, 0xffffff) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_APPLE, 0x2001) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_APPLE, 0x2001),
+		.driver_data = NVME_QUIRK_SINGLE_VECTOR },
 	{ PCI_DEVICE(PCI_VENDOR_ID_APPLE, 0x2003) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_APPLE, 0x2005),
 		.driver_data = NVME_QUIRK_SINGLE_VECTOR |
-- 
2.20.1

