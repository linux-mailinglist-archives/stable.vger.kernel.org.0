Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B35F241729C
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343887AbhIXMtq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:49:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:44906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344098AbhIXMsn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:48:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59E2061278;
        Fri, 24 Sep 2021 12:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487630;
        bh=IoU9t2HsCnVcrqarEjYyykrlTBr7BBMfj3jiU4ZGOp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZgVjdUq6XjhhLIeyK+Kn6yHft2WAiFMAUJpkQgS9x8dj8qW0MYMFm8VTXEDxGR6e5
         1hF3y26irYqYAmwFQjeFUjQYy9S/0obWC3kpQmuE9y4Fs/Jr9L4JPKdJHSwN4Duirb
         02ocnvAEylI7U4SaKEGRJyhXA+dWw+moXx4KJEro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 15/27] parisc: Move pci_dev_is_behind_card_dino to where it is used
Date:   Fri, 24 Sep 2021 14:44:09 +0200
Message-Id: <20210924124329.677795679@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124329.173674820@linuxfoundation.org>
References: <20210924124329.173674820@linuxfoundation.org>
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
index 8bed46630857..c11515bdac83 100644
--- a/drivers/parisc/dino.c
+++ b/drivers/parisc/dino.c
@@ -160,15 +160,6 @@ struct dino_device
 	(struct dino_device *)__pdata; })
 
 
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
@@ -452,6 +443,15 @@ static void quirk_cirrus_cardbus(struct pci_dev *dev)
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



