Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61069150D53
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730487AbgBCQcv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:32:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:46676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730482AbgBCQcv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:32:51 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68B8E2082E;
        Mon,  3 Feb 2020 16:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747570;
        bh=LhOqOE5Kws2Soqj4/HwGuQ0Mpx90Ny6cQYVhR9F1lZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xiH79BnaynXuf7ztsgWke4o4LI1kZwWUKHY1QQ/lTSnWBAEq1RQ52rNwW+862fm6a
         WHjBHVqFqAQjLABfG6a4GVXTx1pGj6mHK+8NA4Fic0MkgyfpRFXczLC547ZbchRNJJ
         qkruYb4KLO5cPmr2Snp/6DG7uVoOPFdCqAt2qmKo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 47/70] net: dsa: bcm_sf2: Configure IMP port for 2Gb/sec
Date:   Mon,  3 Feb 2020 16:19:59 +0000
Message-Id: <20200203161919.146287783@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161912.158976871@linuxfoundation.org>
References: <20200203161912.158976871@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 8f1880cbe8d0d49ebb7e9ae409b3b96676e5aa97 ]

With the implementation of the system reset controller we lost a setting
that is currently applied by the bootloader and which configures the IMP
port for 2Gb/sec, the default is 1Gb/sec. This is needed given the
number of ports and applications we expect to run so bring back that
setting.

Fixes: 01b0ac07589e ("net: dsa: bcm_sf2: Add support for optional reset controller line")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/bcm_sf2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 02a4187d81bd0..c936090076706 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -72,7 +72,7 @@ static void bcm_sf2_imp_setup(struct dsa_switch *ds, int port)
 
 		/* Force link status for IMP port */
 		reg = core_readl(priv, offset);
-		reg |= (MII_SW_OR | LINK_STS);
+		reg |= (MII_SW_OR | LINK_STS | GMII_SPEED_UP_2G);
 		core_writel(priv, reg, offset);
 
 		/* Enable Broadcast, Multicast, Unicast forwarding to IMP port */
-- 
2.20.1



