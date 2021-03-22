Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC3D1344267
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232031AbhCVMlZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:41:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:34112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231952AbhCVMjn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:39:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDF8D6199E;
        Mon, 22 Mar 2021 12:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416706;
        bh=leKN0Fx6DSiN3oW7iFYouk5s13fS9rgo5IESovw6lJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DTM9DaZ/LRcvM7tA/huCriaRe0EXnDvBxIbJxhCExFaVuFQioRHKXtlwY6cHZXIOI
         Soxx6OsePL3tQ8x0B96M44yxIiwex2WqbAd2w97szj35TkQ7N7hv4NBMkZlz6gASmz
         28U9drLe2VAnFnPf8iZVpIhVVtUJbIZ4wNOeAdHo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Melki <christian.melki@t2data.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 089/157] net: phy: micrel: set soft_reset callback to genphy_soft_reset for KSZ8081
Date:   Mon, 22 Mar 2021 13:27:26 +0100
Message-Id: <20210322121936.605468113@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Melki <christian.melki@t2data.com>

[ Upstream commit 764d31cacfe48440745c4bbb55a62ac9471c9f19 ]

Following a similar reinstate for the KSZ9031.

Older kernels would use the genphy_soft_reset if the PHY did not implement
a .soft_reset.

Bluntly removing that default may expose a lot of situations where various
PHYs/board implementations won't recover on various changes.
Like with this implementation during a 4.9.x to 5.4.x LTS transition.
I think it's a good thing to remove unwanted soft resets but wonder if it
did open a can of worms?

Atleast this fixes one iMX6 FEC/RMII/8081 combo.

Fixes: 6e2d85ec0559 ("net: phy: Stop with excessive soft reset")
Signed-off-by: Christian Melki <christian.melki@t2data.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20210224205536.9349-1-christian.melki@t2data.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/micrel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index a7f74b3b97af..47ae1d1723c5 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1263,6 +1263,7 @@ static struct phy_driver ksphy_driver[] = {
 	.probe		= kszphy_probe,
 	.config_init	= ksz8081_config_init,
 	.ack_interrupt	= kszphy_ack_interrupt,
+	.soft_reset	= genphy_soft_reset,
 	.config_intr	= kszphy_config_intr,
 	.get_sset_count = kszphy_get_sset_count,
 	.get_strings	= kszphy_get_strings,
-- 
2.30.1



