Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 618AD412491
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353334AbhITSf5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:35:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:49712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1380246AbhITSdA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:33:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EED2C63302;
        Mon, 20 Sep 2021 17:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158894;
        bh=P1hrLYW79xzFWhURSrD3E32TZFMAZ3cLWzEPY9zz+ck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Brxv/OOxcS6NCcTMjyjLE94lwvq/PEYAYbD1mZPARdb+Le3NOKeSyqHQ+JEw3RCpB
         jGpNhhHIR51oOWTm9wFs1lknMsX+IndMl3aFxakIl8Yhfrq56G/YvA8NjPA/sEeNlY
         bXpcy1mY7q9di7uswwMW+ihfWTbQSQ6TZtWTq5J0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 105/122] net: dsa: b53: Fix calculating number of switch ports
Date:   Mon, 20 Sep 2021 18:44:37 +0200
Message-Id: <20210920163919.240672303@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
References: <20210920163915.757887582@linuxfoundation.org>
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
index 52100d4fe5a2..a8e915dd826a 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2556,9 +2556,8 @@ static int b53_switch_init(struct b53_device *dev)
 			dev->cpu_port = 5;
 	}
 
-	/* cpu port is always last */
-	dev->num_ports = dev->cpu_port + 1;
 	dev->enabled_ports |= BIT(dev->cpu_port);
+	dev->num_ports = fls(dev->enabled_ports);
 
 	/* Include non standard CPU port built-in PHYs to be probed */
 	if (is539x(dev) || is531x5(dev)) {
-- 
2.30.2



