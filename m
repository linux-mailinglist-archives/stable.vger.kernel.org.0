Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBC7441707
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:30:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232575AbhKAJcN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:32:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:37004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232573AbhKAJaL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:30:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACB2761220;
        Mon,  1 Nov 2021 09:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758609;
        bh=co5XU0tEn72Qt5XfOc+ZIE3lJi3Ee7ou3FMfIWm5/fw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nyQCaz509Y4poxOL9lMOZvMGY+n6RvEbE8vBKzdiMIaixlBkFXtFMs8H9aiI9Hxyy
         GGk4/Y1waS6/E396N/oLJeZEBTRt/g96dVeYeX77/5Xafxag2oDrz+V6yeVcbA4rMM
         XB49LIY3r3VDwcW1HM4iIJMXE7k2ddSuGTpkJ3io=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuiko Oshino <yuiko.oshino@microchip.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 35/51] net: ethernet: microchip: lan743x: Fix driver crash when lan743x_pm_resume fails
Date:   Mon,  1 Nov 2021 10:17:39 +0100
Message-Id: <20211101082508.968526343@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082500.203657870@linuxfoundation.org>
References: <20211101082500.203657870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuiko Oshino <yuiko.oshino@microchip.com>

commit d6423d2ec39cce2bfca418c81ef51792891576bc upstream.

The driver needs to clean up and return when the initialization fails on resume.

Fixes: 23f0703c125b ("lan743x: Add main source files for new lan743x driver")
Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/microchip/lan743x_main.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -3001,6 +3001,8 @@ static int lan743x_pm_resume(struct devi
 	if (ret) {
 		netif_err(adapter, probe, adapter->netdev,
 			  "lan743x_hardware_init returned %d\n", ret);
+		lan743x_pci_cleanup(adapter);
+		return ret;
 	}
 
 	/* open netdev when netdev is at running state while resume.


