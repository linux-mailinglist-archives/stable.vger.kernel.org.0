Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2563ED4E2
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237025AbhHPNGP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:06:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:56748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237328AbhHPNFg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:05:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2B3A63292;
        Mon, 16 Aug 2021 13:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119105;
        bh=w1sIXQYp8mVTz7idXQYrWyp3HBVP2rORx89dx15yiR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yFwlnE87UAUWcZVAmrnV+GbtdqGyT/eJWUt4SKFIPU0S3pNDOfqUXqwNTqnfsfbMF
         VFSgGgpa213VHz3QdIyH9O/HdZ+fUcU0g4yPs5hFJfJrSnK5N5rVHrGbia+GAgjefI
         0yX0owOOuVjGYAYO8VKm2DXuBu9hClbptRvxfuMA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Hutchings <ben.hutchings@mind.be>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 21/62] net: phy: micrel: Fix link detection on ksz87xx switch"
Date:   Mon, 16 Aug 2021 15:01:53 +0200
Message-Id: <20210816125428.912210031@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125428.198692661@linuxfoundation.org>
References: <20210816125428.198692661@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Hutchings <ben.hutchings@mind.be>

[ Upstream commit 2383cb9497d113360137a2be308b390faa80632d ]

Commit a5e63c7d38d5 "net: phy: micrel: Fix detection of ksz87xx
switch" broke link detection on the external ports of the KSZ8795.

The previously unused phy_driver structure for these devices specifies
config_aneg and read_status functions that appear to be designed for a
fixed link and do not work with the embedded PHYs in the KSZ8795.

Delete the use of these functions in favour of the generic PHY
implementations which were used previously.

Fixes: a5e63c7d38d5 ("net: phy: micrel: Fix detection of ksz87xx switch")
Signed-off-by: Ben Hutchings <ben.hutchings@mind.be>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/micrel.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 910ab2182158..f95bd1b0fb96 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1184,8 +1184,6 @@ static struct phy_driver ksphy_driver[] = {
 	.name		= "Micrel KSZ87XX Switch",
 	/* PHY_BASIC_FEATURES */
 	.config_init	= kszphy_config_init,
-	.config_aneg	= ksz8873mll_config_aneg,
-	.read_status	= ksz8873mll_read_status,
 	.match_phy_device = ksz8795_match_phy_device,
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
-- 
2.30.2



