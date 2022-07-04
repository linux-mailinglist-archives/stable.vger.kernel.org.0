Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1256A5653A1
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 13:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233736AbiGDLfC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 07:35:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233837AbiGDLfB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 07:35:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 328DCCE2C
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 04:35:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C44B561650
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 11:35:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5858C341CF;
        Mon,  4 Jul 2022 11:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656934500;
        bh=1PncyZb2mWjRX+otYfK41yLOhgRk3HFi9yz8p6qQdrg=;
        h=Subject:To:Cc:From:Date:From;
        b=UeYi33yyQk+2efq7PgH1FLcKQf9wQZAQupJUR4lD8V0jYTI5UnPJ+5sKSoc1u4DNf
         BqiUX+yj0sd5kFx7VpN5w5kbcKQxUqPXHPkR7ITQ4dch94hz9NJNtdaREvZM+tkCdW
         IWlxDE76sDVOyH33GVyaIhFIg0zxL2WdMcMSB9MI=
Subject: FAILED: patch "[PATCH] net: dsa: bcm_sf2: force pause link settings" failed to apply to 5.4-stable tree
To:     opendmb@gmail.com, f.fainelli@gmail.com, kuba@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 Jul 2022 13:34:47 +0200
Message-ID: <165693448771189@kroah.com>
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

From 7c97bc0128b2eecc703106112679a69d446d1a12 Mon Sep 17 00:00:00 2001
From: Doug Berger <opendmb@gmail.com>
Date: Wed, 22 Jun 2022 20:02:04 -0700
Subject: [PATCH] net: dsa: bcm_sf2: force pause link settings

The pause settings reported by the PHY should also be applied to the GMII port
status override otherwise the switch will not generate pause frames towards the
link partner despite the advertisement saying otherwise.

Fixes: 246d7f773c13 ("net: dsa: add Broadcom SF2 switch driver")
Signed-off-by: Doug Berger <opendmb@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20220623030204.1966851-1-f.fainelli@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 87e81c636339..be0edfa093d0 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -878,6 +878,11 @@ static void bcm_sf2_sw_mac_link_up(struct dsa_switch *ds, int port,
 		if (duplex == DUPLEX_FULL)
 			reg |= DUPLX_MODE;
 
+		if (tx_pause)
+			reg |= TXFLOW_CNTL;
+		if (rx_pause)
+			reg |= RXFLOW_CNTL;
+
 		core_writel(priv, reg, offset);
 	}
 

