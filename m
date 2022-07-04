Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C20DF5653A0
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 13:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbiGDLez (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 07:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234228AbiGDLew (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 07:34:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD75FFD0F
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 04:34:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6960FB80D13
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 11:34:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1441C3411E;
        Mon,  4 Jul 2022 11:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656934489;
        bh=TNQy5qOhZ0VL86xJFwqjhI/8tJpDPa0shGOa6ckiIFE=;
        h=Subject:To:Cc:From:Date:From;
        b=j5PggQ7NiiNaRFbGmvorQuCOeR1FFcSivAWCF0GZ/4pO6OyqPoxlCKMKTkIhV63+8
         JPSNb7r/HHCk6/Sr7ix8Hb/OM18RnwX7xBuwXdrKFUhw/bozKtKATRctSP2HULeNKt
         b0FmGspNm/jx+vnNkaK+004yank/AsKGPUB4SAYo=
Subject: FAILED: patch "[PATCH] net: dsa: bcm_sf2: force pause link settings" failed to apply to 4.9-stable tree
To:     opendmb@gmail.com, f.fainelli@gmail.com, kuba@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 Jul 2022 13:34:46 +0200
Message-ID: <16569344862577@kroah.com>
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


The patch below does not apply to the 4.9-stable tree.
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
 

