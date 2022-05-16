Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24499529074
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347073AbiEPUFg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348898AbiEPT7C (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:59:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C035C1707D;
        Mon, 16 May 2022 12:52:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59F6460AB8;
        Mon, 16 May 2022 19:52:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6061FC34100;
        Mon, 16 May 2022 19:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730741;
        bh=toU+LSytb3raG+3uTnxifuzxSNtqE2Qud5xMlmbay4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SQkjT62ACUf6V86KXDF7J14Glutm4XK35rHWlaZYEKf+gUeVnD+G5SCV1PJ4irZ6u
         RfR1nwKiQapY1TjpshXFs2F+Ll61OQ+ZzcSQQk6PZEDbEJGS+aRnk6CPE4YEWwypl3
         0rohF1gvvHCwHAeWHkWgZJM84WrJ1aT17dDcsDn0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@denx.de>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 092/102] net: phy: micrel: Do not use kszphy_suspend/resume for KSZ8061
Date:   Mon, 16 May 2022 21:37:06 +0200
Message-Id: <20220516193626.639614033@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193623.989270214@linuxfoundation.org>
References: <20220516193623.989270214@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@denx.de>

commit e333eed63a091a09bd0db191b7710c594c6e995b upstream.

Since commit f1131b9c23fb ("net: phy: micrel: use
kszphy_suspend()/kszphy_resume for irq aware devices") the following
NULL pointer dereference is observed on a board with KSZ8061:

 # udhcpc -i eth0
udhcpc: started, v1.35.0
8<--- cut here ---
Unable to handle kernel NULL pointer dereference at virtual address 00000008
pgd = f73cef4e
[00000008] *pgd=00000000
Internal error: Oops: 5 [#1] SMP ARM
Modules linked in:
CPU: 0 PID: 196 Comm: ifconfig Not tainted 5.15.37-dirty #94
Hardware name: Freescale i.MX6 SoloX (Device Tree)
PC is at kszphy_config_reset+0x10/0x114
LR is at kszphy_resume+0x24/0x64
...

The KSZ8061 phy_driver structure does not have the .probe/..driver_data
fields, which means that priv is not allocated.

This causes the NULL pointer dereference inside kszphy_config_reset().

Fix the problem by using the generic suspend/resume functions as before.

Another alternative would be to provide the .probe and .driver_data
information into the structure, but to be on the safe side, let's
just restore Ethernet functionality by using the generic suspend/resume.

Cc: stable@vger.kernel.org
Fixes: f1131b9c23fb ("net: phy: micrel: use kszphy_suspend()/kszphy_resume for irq aware devices")
Signed-off-by: Fabio Estevam <festevam@denx.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20220504143104.1286960-1-festevam@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/micrel.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1669,8 +1669,8 @@ static struct phy_driver ksphy_driver[]
 	.config_init	= ksz8061_config_init,
 	.config_intr	= kszphy_config_intr,
 	.handle_interrupt = kszphy_handle_interrupt,
-	.suspend	= kszphy_suspend,
-	.resume		= kszphy_resume,
+	.suspend	= genphy_suspend,
+	.resume		= genphy_resume,
 }, {
 	.phy_id		= PHY_ID_KSZ9021,
 	.phy_id_mask	= 0x000ffffe,


