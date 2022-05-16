Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C127152906D
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245714AbiEPULH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:11:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351085AbiEPUB7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 16:01:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5146D2B1A0;
        Mon, 16 May 2022 12:58:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 130F1B81614;
        Mon, 16 May 2022 19:58:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68FCBC385AA;
        Mon, 16 May 2022 19:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652731122;
        bh=MyKTPlC8EZNDPNE+iEd7eEIDDSfc4g1x7tgT/j4GIoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j2F/X/SJO5kX4n5VO5PAvRGEb1W3ja2lsUI0Aq7rqg1s6VwOVOc8m3S/4TCHHyIce
         LMSrI+G7F7O4V0c0OEJ/C1oB1xkcqycwYwRY2gy2Gyzzd7ybJtH/txNyn20znmJcqQ
         96FPR19Tp1NWVbG4uSAcnJJlpUM71meIrKn/8E6g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Fabio Estevam <festevam@denx.de>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.17 107/114] net: phy: micrel: Pass .probe for KS8737
Date:   Mon, 16 May 2022 21:37:21 +0200
Message-Id: <20220516193628.546000645@linuxfoundation.org>
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

commit 15f03ffe4bb951e982457f44b6cf6b06ef4cbb93 upstream.

Since commit f1131b9c23fb ("net: phy: micrel: use
kszphy_suspend()/kszphy_resume for irq aware devices") the kszphy_suspend/
resume hooks are used.

These functions require the probe function to be called so that
priv can be allocated.

Otherwise, a NULL pointer dereference happens inside
kszphy_config_reset().

Cc: stable@vger.kernel.org
Fixes: f1131b9c23fb ("net: phy: micrel: use kszphy_suspend()/kszphy_resume for irq aware devices")
Reported-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Fabio Estevam <festevam@denx.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20220504143104.1286960-2-festevam@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/micrel.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1725,6 +1725,7 @@ static struct phy_driver ksphy_driver[]
 	.name		= "Micrel KS8737",
 	/* PHY_BASIC_FEATURES */
 	.driver_data	= &ks8737_type,
+	.probe		= kszphy_probe,
 	.config_init	= kszphy_config_init,
 	.config_intr	= kszphy_config_intr,
 	.handle_interrupt = kszphy_handle_interrupt,


