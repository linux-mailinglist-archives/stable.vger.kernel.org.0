Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C91D3C4EFF
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237792AbhGLHWn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:22:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:54930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244412AbhGLHSW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:18:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B86B6610A6;
        Mon, 12 Jul 2021 07:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074131;
        bh=m593HXh605N706u9Z5K+udc58sr9qg8MiTIeO8cxRrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SkluLXk4g9FuSW1CxbxNqwvhdeBjTrqm7LgdvK5TAPsXd2gSSARgELuwxJyI0a7rl
         3iGvcC7hHPlgej/bEEddSpduzz+PSyI8q1oYkQr37jHq9KVSSU1CshZX7wDD6ymV7I
         gB1XXKV8TZXlV1c5K3JaLTlMuUJjo8FxZ/2Cii28=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian-Hong Pan <jhp@endlessos.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 474/700] net: bcmgenet: Fix attaching to PYH failed on RPi 4B
Date:   Mon, 12 Jul 2021 08:09:17 +0200
Message-Id: <20210712061027.011982141@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jian-Hong Pan <jhp@endlessos.org>

[ Upstream commit b2ac9800cfe0f8da16abc4e74e003440361c112e ]

The Broadcom UniMAC MDIO bus from mdio-bcm-unimac module comes too late.
So, GENET cannot find the ethernet PHY on UniMAC MDIO bus. This leads
GENET fail to attach the PHY as following log:

bcmgenet fd580000.ethernet: GENET 5.0 EPHY: 0x0000
...
could not attach to PHY
bcmgenet fd580000.ethernet eth0: failed to connect to PHY
uart-pl011 fe201000.serial: no DMA platform data
libphy: bcmgenet MII bus: probed
...
unimac-mdio unimac-mdio.-19: Broadcom UniMAC MDIO bus

This patch adds the soft dependency to load mdio-bcm-unimac module
before genet module to avoid the issue.

Fixes: 9a4e79697009 ("net: bcmgenet: utilize generic Broadcom UniMAC MDIO controller driver")
Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=213485
Signed-off-by: Jian-Hong Pan <jhp@endlessos.org>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index fcca023f22e5..41f7f078cd27 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -4296,3 +4296,4 @@ MODULE_AUTHOR("Broadcom Corporation");
 MODULE_DESCRIPTION("Broadcom GENET Ethernet controller driver");
 MODULE_ALIAS("platform:bcmgenet");
 MODULE_LICENSE("GPL");
+MODULE_SOFTDEP("pre: mdio-bcm-unimac");
-- 
2.30.2



