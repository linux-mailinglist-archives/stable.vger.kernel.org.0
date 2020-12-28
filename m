Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0182E42ED
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406949AbgL1Nvh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:51:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:53474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406946AbgL1Nvg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:51:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D600920738;
        Mon, 28 Dec 2020 13:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163456;
        bh=lxHw0/V/hk/NEdIoSlpsmgJRoOCaDyuwA2Ch6V38//g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k2KcE/ys4HvIfDEzLl6NtPHtrrOQYEkkpBbndbwzxGQ7x0i6aSUl+m0ZxGoJPAOfq
         EGHl3MyesVuvPaHhVPTJjxTO8Pcep/8hOZLxxfp4TYzXtSd4UA7PYpDg9CrlFHkz/P
         kkKulBjBKyABqzNSKNuIjotiXz69hHJo5NzFyjAA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 292/453] net: bcmgenet: Fix a resource leak in an error handling path in the probe functin
Date:   Mon, 28 Dec 2020 13:48:48 +0100
Message-Id: <20201228124951.255773317@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
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
index 03f82786c0b98..b27da024aa9d9 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3584,8 +3584,10 @@ static int bcmgenet_probe(struct platform_device *pdev)
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



