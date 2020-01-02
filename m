Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D38B12F0D1
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727718AbgABWSn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:18:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:34154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728362AbgABWSm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:18:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5783421582;
        Thu,  2 Jan 2020 22:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003521;
        bh=0LXVk6jEhqxeLmaZ4jPfN2Vp4to1fWueQPFCjiLDdgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0kUI8KHQd5bODERye9O7mQ7hWHQyoNiOyUrh3Hdmv+Dl4xDsQA8Jf9WyAGAPzyJF0
         3otDhMdcTQ9L73Wsj2MUIDjHQxPGzZnVi05a++vX+Z7kYHRsRs+4DXco/R8f8D5EaN
         Gzzaj1pCq5e97ljrWdW/Viy6ErOHMwDlQglUgRgQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Auhagen <sven.auhagen@voleatech.de>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH 5.4 176/191] net: marvell: mvpp2: phylink requires the link interrupt
Date:   Thu,  2 Jan 2020 23:07:38 +0100
Message-Id: <20200102215848.146757519@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

[ Upstream commit f3f2364ea14d1cf6bf966542f31eadcf178f1577 ]

phylink requires the MAC to report when its link status changes when
operating in inband modes.  Failure to report link status changes
means that phylink has no idea when the link events happen, which
results in either the network interface's carrier remaining up or
remaining permanently down.

For example, with a fiber module, if the interface is brought up and
link is initially established, taking the link down at the far end
will cut the optical power.  The SFP module's LOS asserts, we
deactivate the link, and the network interface reports no carrier.

When the far end is brought back up, the SFP module's LOS deasserts,
but the MAC may be slower to establish link.  If this happens (which
in my tests is a certainty) then phylink never hears that the MAC
has established link with the far end, and the network interface is
stuck reporting no carrier.  This means the interface is
non-functional.

Avoiding the link interrupt when we have phylink is basically not
an option, so remove the !port->phylink from the test.

Fixes: 4bb043262878 ("net: mvpp2: phylink support")
Tested-by: Sven Auhagen <sven.auhagen@voleatech.de>
Tested-by: Antoine Tenart <antoine.tenart@bootlin.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -3674,7 +3674,7 @@ static int mvpp2_open(struct net_device
 		valid = true;
 	}
 
-	if (priv->hw_version == MVPP22 && port->link_irq && !port->phylink) {
+	if (priv->hw_version == MVPP22 && port->link_irq) {
 		err = request_irq(port->link_irq, mvpp2_link_status_isr, 0,
 				  dev->name, port);
 		if (err) {


