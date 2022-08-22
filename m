Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B78B59BFE6
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 14:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbiHVM5M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 08:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234543AbiHVM5J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 08:57:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EFFB3054A
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 05:57:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C30F4B81134
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 12:57:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1700C433D6;
        Mon, 22 Aug 2022 12:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661173021;
        bh=T/SpBPO5uyxtf9ghlY3gbVetb6AVSOcUe9ZNLHJDOpI=;
        h=Subject:To:Cc:From:Date:From;
        b=orbGI3/M0rnxNoy4briKbK1Q9hTC/7NR36UC2IZrWcq2fbD7c+3io9mAUX0fhCOaP
         AX9ckRR1LXI4TvuQQT8szYGtD0sn3A58C9P5Rn0El1QbkEewzLU0bx5rqgWHXzwwhp
         On/cDhzirS1stBpjCt14Q7582bj38S6H7QoOfM88=
Subject: FAILED: patch "[PATCH] net: mscc: ocelot: fix address of SYS_COUNT_TX_AGING counter" failed to apply to 5.15-stable tree
To:     vladimir.oltean@nxp.com, kuba@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Aug 2022 14:56:58 +0200
Message-ID: <166117301816284@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 173ca86618d751bd183456c9cdbb69952ba283c8 Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Tue, 16 Aug 2022 16:53:47 +0300
Subject: [PATCH] net: mscc: ocelot: fix address of SYS_COUNT_TX_AGING counter

This register, used as part of stats->tx_dropped in
ocelot_get_stats64(), has a wrong address. At the address currently
given, there is actually the c_tx_green_prio_6 counter.

Fixes: a556c76adc05 ("net: mscc: Add initial Ocelot switch support")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/drivers/net/ethernet/mscc/vsc7514_regs.c b/drivers/net/ethernet/mscc/vsc7514_regs.c
index 38ab20b48cd4..8ff935f7f150 100644
--- a/drivers/net/ethernet/mscc/vsc7514_regs.c
+++ b/drivers/net/ethernet/mscc/vsc7514_regs.c
@@ -202,7 +202,7 @@ const u32 vsc7514_sys_regmap[] = {
 	REG(SYS_COUNT_TX_512_1023,			0x00012c),
 	REG(SYS_COUNT_TX_1024_1526,			0x000130),
 	REG(SYS_COUNT_TX_1527_MAX,			0x000134),
-	REG(SYS_COUNT_TX_AGING,				0x000170),
+	REG(SYS_COUNT_TX_AGING,				0x000178),
 	REG(SYS_RESET_CFG,				0x000508),
 	REG(SYS_CMID,					0x00050c),
 	REG(SYS_VLAN_ETYPE_CFG,				0x000510),

