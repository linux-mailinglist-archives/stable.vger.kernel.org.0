Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5A748333E
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234414AbiACOfW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:35:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235204AbiACOc5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:32:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D82EC0613B1;
        Mon,  3 Jan 2022 06:31:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 496B7B80F10;
        Mon,  3 Jan 2022 14:31:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B36DC36AEB;
        Mon,  3 Jan 2022 14:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220308;
        bh=PCsg7mP5kp3DsFEp1CL3f1nO5DWFr3xgjXtQvQMX0to=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SzaHUTeNTMZl2Cbavh6AToa2efzeQiFr3OMmlhBjZZInevxZX5q/uYsPioYTIP3n3
         +IiUMER8lheeFtxDeIeB6HFKaUZFw31M8Fh2rYRbbq/Z5ARPz/S1Xx/izW3rGTwMFf
         ofOhKHcuCAWvvdBUsL7mxh+eGFDPLBobLHuc64cc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 28/73] net: phy: fixed_phy: Fix NULL vs IS_ERR() checking in __fixed_phy_register
Date:   Mon,  3 Jan 2022 15:23:49 +0100
Message-Id: <20220103142057.816768294@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142056.911344037@linuxfoundation.org>
References: <20220103142056.911344037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit b45396afa4177f2b1ddfeff7185da733fade1dc3 ]

The fixed_phy_get_gpiod function() returns NULL, it doesn't return error
pointers, using NULL checking to fix this.i

Fixes: 5468e82f7034 ("net: phy: fixed-phy: Drop GPIO from fixed_phy_add()")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20211224021500.10362-1-linmq006@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/fixed_phy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/fixed_phy.c b/drivers/net/phy/fixed_phy.c
index c65fb5f5d2dc5..a0c256bd54417 100644
--- a/drivers/net/phy/fixed_phy.c
+++ b/drivers/net/phy/fixed_phy.c
@@ -239,8 +239,8 @@ static struct phy_device *__fixed_phy_register(unsigned int irq,
 	/* Check if we have a GPIO associated with this fixed phy */
 	if (!gpiod) {
 		gpiod = fixed_phy_get_gpiod(np);
-		if (IS_ERR(gpiod))
-			return ERR_CAST(gpiod);
+		if (!gpiod)
+			return ERR_PTR(-EINVAL);
 	}
 
 	/* Get the next available PHY address, up to PHY_MAX_ADDR */
-- 
2.34.1



