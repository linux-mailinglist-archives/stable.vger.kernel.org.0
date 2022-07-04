Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36B705653CF
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 13:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234289AbiGDLht (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 07:37:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234508AbiGDLhb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 07:37:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18DAE1261B
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 04:36:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5E4661629
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 11:36:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA5C3C3411E;
        Mon,  4 Jul 2022 11:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656934602;
        bh=u/7OyRd8mze/OGW5sDeEEKNS8WDTqN/33ymU8jsQmOI=;
        h=Subject:To:Cc:From:Date:From;
        b=ZPD+pS9PAverjyiPnOQPT7nttlAzwtrsQSxedAKNjhLZKRj16DYuZty/Aj/h4f5hu
         UxtEy0pmpnVj9hd8n/j8/uCVoXkQanktXZh4+lWVtCL2XX48NVxCBU8H30YsPrvt0P
         b2Cz7Zf8LxMPTXMilzLg1Z8vFHgCK6ma05f6GCUg=
Subject: FAILED: patch "[PATCH] net: dp83822: disable false carrier interrupt" failed to apply to 5.4-stable tree
To:     enguerrand.de-ribaucourt@savoirfairelinux.com, andrew@lunn.ch,
        kuba@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 Jul 2022 13:36:39 +0200
Message-ID: <1656934599185175@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c96614eeab663646f57f67aa591e015abd8bd0ba Mon Sep 17 00:00:00 2001
From: Enguerrand de Ribaucourt <enguerrand.de-ribaucourt@savoirfairelinux.com>
Date: Thu, 23 Jun 2022 15:46:44 +0200
Subject: [PATCH] net: dp83822: disable false carrier interrupt

When unplugging an Ethernet cable, false carrier events were produced by
the PHY at a very high rate. Once the false carrier counter full, an
interrupt was triggered every few clock cycles until the cable was
replugged. This resulted in approximately 10k/s interrupts.

Since the false carrier counter (FCSCR) is never used, we can safely
disable this interrupt.

In addition to improving performance, this also solved MDIO read
timeouts I was randomly encountering with an i.MX8 fec MAC because of
the interrupt flood. The interrupt count and MDIO timeout fix were
tested on a v5.4.110 kernel.

Fixes: 87461f7a58ab ("net: phy: DP83822 initial driver submission")
Signed-off-by: Enguerrand de Ribaucourt <enguerrand.de-ribaucourt@savoirfairelinux.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
index e6ad3a494d32..95ef507053a6 100644
--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -230,7 +230,6 @@ static int dp83822_config_intr(struct phy_device *phydev)
 			return misr_status;
 
 		misr_status |= (DP83822_RX_ERR_HF_INT_EN |
-				DP83822_FALSE_CARRIER_HF_INT_EN |
 				DP83822_LINK_STAT_INT_EN |
 				DP83822_ENERGY_DET_INT_EN |
 				DP83822_LINK_QUAL_INT_EN);

