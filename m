Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA01E411EA6
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242660AbhITRdK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:33:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:36656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347917AbhITRbK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:31:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C15E561354;
        Mon, 20 Sep 2021 17:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157468;
        bh=ecmi35bxILaHy9AuAQzTQ28jfOPwEE6Hq14CBlST40E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BOvh/CAZYc3t0I2u+Qg6XVJ9ZyOl2k5MibvRShu8TPP2NIlT1/A6coAPThIMtZIJ6
         bes1JuH7z+Gupule6e75miU0gpPsJMTerFEDofCc3bSxUR2t8TdQouPEGpS7uCTkhq
         WlH3N+tuiCEl+XeeZpaHUSnd95zjfEKFP5NIn3qA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 214/217] net: dsa: b53: Fix calculating number of switch ports
Date:   Mon, 20 Sep 2021 18:43:55 +0200
Message-Id: <20210920163931.875096365@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163924.591371269@linuxfoundation.org>
References: <20210920163924.591371269@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit cdb067d31c0fe4cce98b9d15f1f2ef525acaa094 ]

It isn't true that CPU port is always the last one. Switches BCM5301x
have 9 ports (port 6 being inactive) and they use port 5 as CPU by
default (depending on design some other may be CPU ports too).

A more reliable way of determining number of ports is to check for the
last set bit in the "enabled_ports" bitfield.

This fixes b53 internal state, it will allow providing accurate info to
the DSA and is required to fix BCM5301x support.

Fixes: 967dd82ffc52 ("net: dsa: b53: Add support for Broadcom RoboSwitch")
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 820aed3e2352..9fff49229435 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1843,9 +1843,8 @@ static int b53_switch_init(struct b53_device *dev)
 			dev->cpu_port = 5;
 	}
 
-	/* cpu port is always last */
-	dev->num_ports = dev->cpu_port + 1;
 	dev->enabled_ports |= BIT(dev->cpu_port);
+	dev->num_ports = fls(dev->enabled_ports);
 
 	dev->ports = devm_kzalloc(dev->dev,
 				  sizeof(struct b53_port) * dev->num_ports,
-- 
2.30.2



