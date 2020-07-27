Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAE4922EE8C
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729082AbgG0OIn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:08:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:58294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729472AbgG0OIm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:08:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 973732083E;
        Mon, 27 Jul 2020 14:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595858922;
        bh=bkASIU+tcHNYr4Je/uAYwATeDov4hpolKUnT+rpI18o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fXdG92NdjLEur3fUcO8BtQ7iO+bBu5qkvwluBhMJQng4+yPTfbMwPq6JUGiWCeoe0
         M1/GLxgmBbr7WK6cKiexBlS+0J/cAXESp7wDMOKZzz9Z5BQTL6wt/TEdRDICbGiLZT
         hxoP4pwvfThGjJyyZ7PdIvP6oSpEn0hY7zuD43FA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthew Howell <matthew.howell@sealevel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 32/64] serial: exar: Fix GPIO configuration for Sealevel cards based on XR17V35X
Date:   Mon, 27 Jul 2020 16:04:11 +0200
Message-Id: <20200727134912.750933479@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134911.020675249@linuxfoundation.org>
References: <20200727134911.020675249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Howell <matthew.howell@sealevel.com>

[ Upstream commit 5fdbe136ae19ab751daaa4d08d9a42f3e30d17f9 ]

Sealevel XR17V35X based devices are inoperable on kernel versions
4.11 and above due to a change in the GPIO preconfiguration introduced in
commit
7dea8165f1d. This patch fixes this by preconfiguring the GPIO on Sealevel
cards to the value (0x00) used prior to commit 7dea8165f1d

With GPIOs preconfigured as per commit 7dea8165f1d all ports on
Sealevel XR17V35X based devices become stuck in high impedance
mode, regardless of dip-switch or software configuration. This
causes the device to become effectively unusable. This patch (in
various forms) has been distributed to our customers and no issues
related to it have been reported.

Fixes: 7dea8165f1d6 ("serial: exar: Preconfigure xr17v35x MPIOs as output")
Signed-off-by: Matthew Howell <matthew.howell@sealevel.com>
Link: https://lore.kernel.org/r/alpine.DEB.2.21.2007221605270.13247@tstest-VirtualBox
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_exar.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_exar.c b/drivers/tty/serial/8250/8250_exar.c
index 899f36b59af79..ed81128bb42e0 100644
--- a/drivers/tty/serial/8250/8250_exar.c
+++ b/drivers/tty/serial/8250/8250_exar.c
@@ -229,7 +229,17 @@ static void setup_gpio(struct pci_dev *pcidev, u8 __iomem *p)
 	 * devices will export them as GPIOs, so we pre-configure them safely
 	 * as inputs.
 	 */
-	u8 dir = pcidev->vendor == PCI_VENDOR_ID_EXAR ? 0xff : 0x00;
+
+	u8 dir = 0x00;
+
+	if  ((pcidev->vendor == PCI_VENDOR_ID_EXAR) &&
+		(pcidev->subsystem_vendor != PCI_VENDOR_ID_SEALEVEL)) {
+		// Configure GPIO as inputs for Commtech adapters
+		dir = 0xff;
+	} else {
+		// Configure GPIO as outputs for SeaLevel adapters
+		dir = 0x00;
+	}
 
 	writeb(0x00, p + UART_EXAR_MPIOINT_7_0);
 	writeb(0x00, p + UART_EXAR_MPIOLVL_7_0);
-- 
2.25.1



