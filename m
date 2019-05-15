Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B606F1F015
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730648AbfEOLjk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:39:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:41494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732656AbfEOLaC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:30:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B735220843;
        Wed, 15 May 2019 11:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919802;
        bh=UH5XIeSq/ssCBru59d4EIMimGVZsa7U5Hko6QUt3ygI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u8jyptoBBet1GCA1Z+J0DHf+BHsMyIvhViXUck4wo6oBKsYFlzIqfFb0pkX4fVtTG
         oKR1yCKKeVv5E8B+iwMa2sfyb5qgLsexnuTHt5vpMuR+4YgcEp0J+No0Jt1KkxIcxx
         oaAN7LOp5czKaFwhBYPyv9oJ/3rUDRXRVIXVujnc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: [PATCH 5.0 099/137] net: mvpp2: fix validate for PPv2.1
Date:   Wed, 15 May 2019 12:56:20 +0200
Message-Id: <20190515090700.717144179@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
References: <20190515090651.633556783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 8b318f30ab4ef9bbc1241e6f8c1db366dbd347f2 ]

The Phylink validate function is the Marvell PPv2 driver makes a check
on the GoP id. This is valid an has to be done when using PPv2.2 engines
but makes no sense when using PPv2.1. The check done when using an RGMII
interface makes sure the GoP id is not 0, but this breaks PPv2.1. Fixes
it.

Fixes: 0fb628f0f250 ("net: mvpp2: fix phylink handling of invalid PHY modes")
Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 931beac3359d1..70031e2b22944 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -4370,7 +4370,7 @@ static void mvpp2_phylink_validate(struct net_device *dev,
 	case PHY_INTERFACE_MODE_RGMII_ID:
 	case PHY_INTERFACE_MODE_RGMII_RXID:
 	case PHY_INTERFACE_MODE_RGMII_TXID:
-		if (port->gop_id == 0)
+		if (port->priv->hw_version == MVPP22 && port->gop_id == 0)
 			goto empty_set;
 		break;
 	default:
-- 
2.20.1



