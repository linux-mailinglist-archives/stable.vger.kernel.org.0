Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D725198F9E
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731019AbgCaJFC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:05:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:45834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730998AbgCaJFB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:05:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AA5321841;
        Tue, 31 Mar 2020 09:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645501;
        bh=7TXbjtTlyiw/EJVmNSsIzVxQlvg19KzvZcYvQzCfOQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LpgQOz4VSH4SWh2vMObKI4jBtDTeEJv26hLan5NtB37Yl5RFM3Dw3QRoxYUQ52D45
         gPoAbytHFT5bdGHmJhKgr7r7+u8re+mndblk0n07YxSoOXmB1k3bUp1+bB42MJLInF
         pyhzBtNfvWjYcu9UbFE9o50op9KrROS3M1H87IuU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 034/170] r8169: re-enable MSI on RTL8168c
Date:   Tue, 31 Mar 2020 10:57:28 +0200
Message-Id: <20200331085427.667281606@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit f13bc68131b0c0d67a77fb43444e109828a983bf ]

The original change fixed an issue on RTL8168b by mimicking the vendor
driver behavior to disable MSI on chip versions before RTL8168d.
This however now caused an issue on a system with RTL8168c, see [0].
Therefore leave MSI disabled on RTL8168b, but re-enable it on RTL8168c.

[0] https://bugzilla.redhat.com/show_bug.cgi?id=1792839

Fixes: 003bd5b4a7b4 ("r8169: don't use MSI before RTL8168d")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/r8169_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -6579,7 +6579,7 @@ static int rtl_alloc_irq(struct rtl8169_
 		RTL_W8(tp, Config2, RTL_R8(tp, Config2) & ~MSIEnable);
 		rtl_lock_config_regs(tp);
 		/* fall through */
-	case RTL_GIGA_MAC_VER_07 ... RTL_GIGA_MAC_VER_24:
+	case RTL_GIGA_MAC_VER_07 ... RTL_GIGA_MAC_VER_17:
 		flags = PCI_IRQ_LEGACY;
 		break;
 	default:


