Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2015F4173FB
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345563AbhIXNB1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:01:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:52926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345815AbhIXM7b (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:59:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3D6861371;
        Fri, 24 Sep 2021 12:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488003;
        bh=BGaO2d5KMqAdaiWzfa1+0RVyVlGMslFN3ltylz4C+zY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cyGYajhcBXGtgMw7bgkzYrqvyMESnrH+YbTr9KnQ95WRv9A3zYagLYmDl79SMSHkM
         k2bCXsaU4gKQnC7aI+c3N8hyGtLxqbM453d8EHs3qg4/c5M03gcDyivNIQC13i3EpL
         EsNhzq5HzBGB4BsxK/+0xXn1ewynstFxBqy1iWGQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 046/100] parisc: Move pci_dev_is_behind_card_dino to where it is used
Date:   Fri, 24 Sep 2021 14:43:55 +0200
Message-Id: <20210924124342.990271626@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 907872baa9f1538eed02ec737b8e89eba6c6e4b9 ]

parisc build test images fail to compile with the following error.

drivers/parisc/dino.c:160:12: error:
	'pci_dev_is_behind_card_dino' defined but not used

Move the function just ahead of its only caller to avoid the error.

Fixes: 5fa1659105fa ("parisc: Disable HP HSC-PCI Cards to prevent kernel crash")
Cc: Helge Deller <deller@gmx.de>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/parisc/dino.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/parisc/dino.c b/drivers/parisc/dino.c
index 889d7ce282eb..952a92504df6 100644
--- a/drivers/parisc/dino.c
+++ b/drivers/parisc/dino.c
@@ -156,15 +156,6 @@ static inline struct dino_device *DINO_DEV(struct pci_hba_data *hba)
 	return container_of(hba, struct dino_device, hba);
 }
 
-/* Check if PCI device is behind a Card-mode Dino. */
-static int pci_dev_is_behind_card_dino(struct pci_dev *dev)
-{
-	struct dino_device *dino_dev;
-
-	dino_dev = DINO_DEV(parisc_walk_tree(dev->bus->bridge));
-	return is_card_dino(&dino_dev->hba.dev->id);
-}
-
 /*
  * Dino Configuration Space Accessor Functions
  */
@@ -447,6 +438,15 @@ static void quirk_cirrus_cardbus(struct pci_dev *dev)
 DECLARE_PCI_FIXUP_ENABLE(PCI_VENDOR_ID_CIRRUS, PCI_DEVICE_ID_CIRRUS_6832, quirk_cirrus_cardbus );
 
 #ifdef CONFIG_TULIP
+/* Check if PCI device is behind a Card-mode Dino. */
+static int pci_dev_is_behind_card_dino(struct pci_dev *dev)
+{
+	struct dino_device *dino_dev;
+
+	dino_dev = DINO_DEV(parisc_walk_tree(dev->bus->bridge));
+	return is_card_dino(&dino_dev->hba.dev->id);
+}
+
 static void pci_fixup_tulip(struct pci_dev *dev)
 {
 	if (!pci_dev_is_behind_card_dino(dev))
-- 
2.33.0



