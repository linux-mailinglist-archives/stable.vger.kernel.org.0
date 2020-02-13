Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4C9A15C54C
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:55:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729102AbgBMPyp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:54:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:42106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728601AbgBMPZt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:25:49 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B28A620848;
        Thu, 13 Feb 2020 15:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607548;
        bh=2IxQKgMwkp6kqKujbIj3ytnQTTCdHJONx8Zpa1knna4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nicNUWYl+fo7uMohmkgwORhITPQQRwCrbJesC0vEPnWv2ghHeW7J/yW4XmOsQmijK
         DfD7CtZRvJJwKBZbQEnEkPuAAWQ8fX4TfFm1hhl8PoHmpmclCCD/0OK9tNyrnwcsAq
         fjftnBT2n8iBWrFGdFuBJSSkEc67TReFziLW/BKo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 112/173] net: dsa: bcm_sf2: Only 7278 supports 2Gb/sec IMP port
Date:   Thu, 13 Feb 2020 07:20:15 -0800
Message-Id: <20200213152000.754463274@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151931.677980430@linuxfoundation.org>
References: <20200213151931.677980430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit de34d7084edd069dac5aa010cfe32bd8c4619fa6 ]

The 7445 switch clocking profiles do not allow us to run the IMP port at
2Gb/sec in a way that it is reliable and consistent. Make sure that the
setting is only applied to the 7278 family.

Fixes: 8f1880cbe8d0 ("net: dsa: bcm_sf2: Configure IMP port for 2Gb/sec")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/bcm_sf2.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -137,7 +137,9 @@ static void bcm_sf2_imp_setup(struct dsa
 
 		/* Force link status for IMP port */
 		reg = core_readl(priv, offset);
-		reg |= (MII_SW_OR | LINK_STS | GMII_SPEED_UP_2G);
+		reg |= (MII_SW_OR | LINK_STS);
+		if (priv->type == BCM7278_DEVICE_ID)
+			reg |= GMII_SPEED_UP_2G;
 		core_writel(priv, reg, offset);
 
 		/* Enable Broadcast, Multicast, Unicast forwarding to IMP port */


