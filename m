Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5DD3961D3
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233150AbhEaOrK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:47:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:40308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234226AbhEaOpJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:45:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12B0B61C80;
        Mon, 31 May 2021 13:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469297;
        bh=C3Kq6hxcf24debxLvrHsGOT//D+zzRi1v/d5Dutpdjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y+RBhY+lTUHXEHsSF5Aj+G4jo6ta8q/6i57GIMTtv0VvZPgTpsK2m0i1RpN+whV2U
         DZVSlxpIGpZqUaIhmmDPkCXORK1GwpeikL30URdAp7qOdljRwNUkibpmy5gFs7nS7i
         KeBhFViAK87qD+K+4PJuh8UHnUTCoxnfl5EbZa/Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.12 145/296] net: dsa: sja1105: error out on unsupported PHY mode
Date:   Mon, 31 May 2021 15:13:20 +0200
Message-Id: <20210531130708.742981131@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

commit 6729188d2646709941903052e4b78e1d82c239b9 upstream.

The driver continues probing when a port is configured for an
unsupported PHY interface type, instead it should stop.

Fixes: 8aa9ebccae87 ("net: dsa: Introduce driver for NXP SJA1105 5-port L2 switch")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/sja1105/sja1105_main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -208,6 +208,7 @@ static int sja1105_init_mii_settings(str
 		default:
 			dev_err(dev, "Unsupported PHY mode %s!\n",
 				phy_modes(ports[i].phy_mode));
+			return -EINVAL;
 		}
 
 		/* Even though the SerDes port is able to drive SGMII autoneg


