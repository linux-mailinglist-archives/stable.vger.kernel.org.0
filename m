Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0B72E6580
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:03:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393718AbgL1QCA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:02:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:60432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389536AbgL1Nba (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:31:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3F8920728;
        Mon, 28 Dec 2020 13:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162249;
        bh=DilgPCEYNKulBt2jpnQxaepZv0vFRE1WB3AwTzIHGPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lox8N0qQTEamJs+UfJZLGTKFHBKOm6gfwkvNUwPVSW0PtMmpKLZhRaLY8ZmR55G9b
         6Pr3Lqni9Kt+eXynSb59+qLucKAaSA7j/rLqsFDOK4nKqX/lsXtlToghovkQCkF6xl
         FKsdUI3JoHh8RC2gjWFuI/HWjQWuPegYnVdEIrek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 238/346] net: bcmgenet: Fix a resource leak in an error handling path in the probe functin
Date:   Mon, 28 Dec 2020 13:49:17 +0100
Message-Id: <20201228124931.281102335@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 4375ada01963d1ebf733d60d1bb6e5db401e1ac6 ]

If the 'register_netdev()' call fails, we must undo a previous
'bcmgenet_mii_init()' call.

Fixes: 1c1008c793fa ("net: bcmgenet: add main driver file")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20201212182005.120437-1-christophe.jaillet@wanadoo.fr
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index c7667017c1a3f..c3e824f5e50e8 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3593,8 +3593,10 @@ static int bcmgenet_probe(struct platform_device *pdev)
 	clk_disable_unprepare(priv->clk);
 
 	err = register_netdev(dev);
-	if (err)
+	if (err) {
+		bcmgenet_mii_exit(dev);
 		goto err;
+	}
 
 	return err;
 
-- 
2.27.0



