Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9EFD5653D4
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 13:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbiGDLiM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 07:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233326AbiGDLhy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 07:37:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84C6C1277D
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 04:36:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0A4AB80EE7
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 11:36:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33030C3411E;
        Mon,  4 Jul 2022 11:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656934610;
        bh=+cTiELzVm88BEktV+paHeWYK1G7bTN67O+dZ2tdVMdw=;
        h=Subject:To:Cc:From:Date:From;
        b=vtsZUETo1dMCtMrmY35ul7BadESIKC3idt8GJjcOoRd578FVG0uxgbeHiH2T612I/
         fZPhikF6A/bS7K6yd9YYqALAGYN4Ozt7lnWfNF+azjvZnqTPUELoZtI8xlV9PkNtmP
         g8mrE0Zq+tjnIKDL5+5f0t0pa+Xa8lRth6qL0y+8=
Subject: FAILED: patch "[PATCH] net: dp83822: disable false carrier interrupt" failed to apply to 4.19-stable tree
To:     enguerrand.de-ribaucourt@savoirfairelinux.com, andrew@lunn.ch,
        kuba@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 Jul 2022 13:36:40 +0200
Message-ID: <165693460021711@kroah.com>
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


The patch below does not apply to the 4.19-stable tree.
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

