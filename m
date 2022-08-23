Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74FD259D532
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241320AbiHWJBY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242299AbiHWJAz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:00:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8816E82847;
        Tue, 23 Aug 2022 01:27:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61FD46148B;
        Tue, 23 Aug 2022 08:27:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54FDEC433C1;
        Tue, 23 Aug 2022 08:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243249;
        bh=345bHoukE6/6gcTgtuzxsrdukBDfqb0aeEMIu5LhdZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SHCByOblcUEBxeX9f8eW569cL4C+4MYLJorvyv/xwQ1rHrd2R/gwiZddYXLDMUE+D
         66GxSE40G5Sww0aBFTdUgSOWYTYBgLJXxE4uMOzZwJVbFHF01yOqFnJXNuHI24NJG5
         LPvmKOqjbLyhvk/01A/kPoRQmrNwrxUWFCxY/i9o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.19 217/365] net: mscc: ocelot: fix address of SYS_COUNT_TX_AGING counter
Date:   Tue, 23 Aug 2022 10:01:58 +0200
Message-Id: <20220823080127.275379834@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

commit 173ca86618d751bd183456c9cdbb69952ba283c8 upstream.

This register, used as part of stats->tx_dropped in
ocelot_get_stats64(), has a wrong address. At the address currently
given, there is actually the c_tx_green_prio_6 counter.

Fixes: a556c76adc05 ("net: mscc: Add initial Ocelot switch support")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mscc/vsc7514_regs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


