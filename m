Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E72617FD0B
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729444AbgCJNZd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:25:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:37082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727915AbgCJM53 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:57:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D594024697;
        Tue, 10 Mar 2020 12:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845049;
        bh=Koa6TxqCHcmUw80XbjdAm6xuun/7CjzKOrAKIXVjuok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pr/uPkKH34DO3UKt5eH/Ycz898bS9KHetEWl5FPEu84Wpu9keH9C4b0Iyqk6WkOnK
         6htjG/hEsxXjMX/WjK5n8bbbmllFL7TUw39+0+NiwCD5jmitR/c1Adf33Kd8KerSAn
         GRQ2ZLeSsgKRkY9LfUZiE1TaaBSJ22GxJJ8SXSKs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Leif Liddy <leif.liddy@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Keith Busch <kbusch@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 044/189] nvme-pci: Use single IRQ vector for old Apple models
Date:   Tue, 10 Mar 2020 13:38:01 +0100
Message-Id: <20200310123643.935276474@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index ec4165e879163..d3f23d6254e47 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3121,7 +3121,8 @@ static const struct pci_device_id nvme_id_table[] = {
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



