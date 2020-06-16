Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8F371FB965
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731815AbgFPQDI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 12:03:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:46064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731603AbgFPPuW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:50:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1F7E208D5;
        Tue, 16 Jun 2020 15:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322622;
        bh=j7OcEmK8XA4y3KDzPwvCTXJWkrh36DMJPbqCnvQSD6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mwPZDAdG/SKFzbXuO9yW/EIwfkbmhlVaPbLwA2rAM2nEcjGtkTI+Ecf5KfB8mO/dy
         A2RfAspG2I4eBfyX8a9RJ/zEFrV6gydZjkUC5tBJyFfyZuSQv0YtXvehqOU71n8bM4
         rhzwwC00V8Jpj0PiOU35OwQ6Bl845RfHev3K6u50=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 040/161] PCI/PM: Adjust pcie_wait_for_link_delay() for caller delay
Date:   Tue, 16 Jun 2020 17:33:50 +0200
Message-Id: <20200616153108.286969525@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.402291280@linuxfoundation.org>
References: <20200616153106.402291280@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>

[ Upstream commit f044baaff1eb7ae5aa7a36f1b7ad5bd8eeb672c4 ]

The caller of pcie_wait_for_link_delay() specifies the time to wait after
the link becomes active.  When the downstream port doesn't support link
active reporting, obviously we can't tell when the link becomes active, so
we waited the worst-case time (1000 ms) plus 100 ms, ignoring the delay
from the caller.

Instead, wait for 1000 ms + the delay from the caller.

Fixes: 4827d63891b6 ("PCI/PM: Add pcie_wait_for_link_delay()")
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index d828ca835a98..fe9fbb74ce72 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -4616,10 +4616,10 @@ static bool pcie_wait_for_link_delay(struct pci_dev *pdev, bool active,
 
 	/*
 	 * Some controllers might not implement link active reporting. In this
-	 * case, we wait for 1000 + 100 ms.
+	 * case, we wait for 1000 ms + any delay requested by the caller.
 	 */
 	if (!pdev->link_active_reporting) {
-		msleep(1100);
+		msleep(timeout + delay);
 		return true;
 	}
 
-- 
2.25.1



