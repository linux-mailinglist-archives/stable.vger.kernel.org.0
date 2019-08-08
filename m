Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4B1186A4C
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404799AbfHHTIG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:08:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:42042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404426AbfHHTIF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:08:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E70A21874;
        Thu,  8 Aug 2019 19:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291284;
        bh=SDmMk6I/cJ/zAsx1RQubtJjKH12vd70AZw33WtMT+iA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FMZn/HU0qFQwUCIXWP6n1kU7ZEUq3gQhHE3EaD4OV4PWKxyc+gtvKp8N56DiJWcDy
         S8Tnrai5c1f/D2rONLu1WIJ27c3vf1SN9DB7a8jmelbVk1DEiTd9SXDdcZgzsCSZ40
         cf8Vl3LPeY1sx3tAKN+Y27qYzYyRAFMjCE7JG7Ho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Du=C5=A1an=20Dragi=C4=87?= <dragic.dusan@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 5.2 41/56] r8169: dont use MSI before RTL8168d
Date:   Thu,  8 Aug 2019 21:05:07 +0200
Message-Id: <20190808190454.745103264@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190452.867062037@linuxfoundation.org>
References: <20190808190452.867062037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 003bd5b4a7b4a94b501e3a1e2e7c9df6b2a94ed4 ]

It was reported that after resuming from suspend network fails with
error "do_IRQ: 3.38 No irq handler for vector", see [0]. Enabling WoL
can work around the issue, but the only actual fix is to disable MSI.
So let's mimic the behavior of the vendor driver and disable MSI on
all chip versions before RTL8168d.

[0] https://bugzilla.kernel.org/show_bug.cgi?id=204079

Fixes: 6c6aa15fdea5 ("r8169: improve interrupt handling")
Reported-by: Dušan Dragić <dragic.dusan@gmail.com>
Tested-by: Dušan Dragić <dragic.dusan@gmail.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/r8169.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -7050,13 +7050,18 @@ static int rtl_alloc_irq(struct rtl8169_
 {
 	unsigned int flags;
 
-	if (tp->mac_version <= RTL_GIGA_MAC_VER_06) {
+	switch (tp->mac_version) {
+	case RTL_GIGA_MAC_VER_02 ... RTL_GIGA_MAC_VER_06:
 		rtl_unlock_config_regs(tp);
 		RTL_W8(tp, Config2, RTL_R8(tp, Config2) & ~MSIEnable);
 		rtl_lock_config_regs(tp);
+		/* fall through */
+	case RTL_GIGA_MAC_VER_07 ... RTL_GIGA_MAC_VER_24:
 		flags = PCI_IRQ_LEGACY;
-	} else {
+		break;
+	default:
 		flags = PCI_IRQ_ALL_TYPES;
+		break;
 	}
 
 	return pci_alloc_irq_vectors(tp->pci_dev, 1, 1, flags);


