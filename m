Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DEE25291BF
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244320AbiEPULF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351089AbiEPUB7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 16:01:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7103840912;
        Mon, 16 May 2022 12:58:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C671B81616;
        Mon, 16 May 2022 19:58:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6CAFC385AA;
        Mon, 16 May 2022 19:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652731119;
        bh=P260iAUL3ZqmnZgfQd8Cg8lNIyUPcm3RRa3bK0X6tVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2rOToLGPvuMPwJxIaTzg2y/J/Q0Y/n2NOfCKq8uPPMjFIcNSOJUaI9NDZBydGrLxu
         f0VB/yAdDRpU4zWDfW/3Ni7xMUORT/0N2O0giaPUOWUqVHsgbg92aEB5bBkA8OayWB
         OYQoVb9pYHn4NVE6Kp29tuiL3kGuo+YDiUZeGwVg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@denx.de>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.17 106/114] net: phy: micrel: Do not use kszphy_suspend/resume for KSZ8061
Date:   Mon, 16 May 2022 21:37:20 +0200
Message-Id: <20220516193628.517664127@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
References: <20220516193625.489108457@linuxfoundation.org>
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
@@ -1850,8 +1850,8 @@ static struct phy_driver ksphy_driver[]
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


