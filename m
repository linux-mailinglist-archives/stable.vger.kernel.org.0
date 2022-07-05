Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12A25566DB1
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236658AbiGEM0y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:26:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236648AbiGEMY4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:24:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 308761F613;
        Tue,  5 Jul 2022 05:17:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF60561AAD;
        Tue,  5 Jul 2022 12:17:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C667CC341C7;
        Tue,  5 Jul 2022 12:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023444;
        bh=BX1cOwwr99Bu5wNg/qeLuar04H9j3nT7tHJjtd/K2ME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fO3BbEabpI2HSKscTuoG1otXo3n1gROYVGnr0iUsnRiOw1RnHll6Q21Tpbi0nqyel
         IXaNFUtGVOG8QAkZk+It0LXOr9uYgMcy1hy2PaAB8RP1F+sFWiwoyMSShoKP3rrl1z
         DWVoHUXpfKk6ss+SpmuS6mf4rDC1V0QekspXTjC8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.18 062/102] net: dsa: felix: fix race between reading PSFP stats and port stats
Date:   Tue,  5 Jul 2022 13:58:28 +0200
Message-Id: <20220705115620.167781445@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

commit 58bf4db695287c4bb2a5fc9fc12c78fdd4c36894 upstream.

Both PSFP stats and the port stats read by ocelot_check_stats_work() are
indirectly read through the same mechanism - write to STAT_CFG:STAT_VIEW,
read from SYS:STAT:CNT[n].

It's just that for port stats, we write STAT_VIEW with the index of the
port, and for PSFP stats, we write STAT_VIEW with the filter index.

So if we allow them to run concurrently, ocelot_check_stats_work() may
change the view from vsc9959_psfp_counters_get(), and vice versa.

Fixes: 7d4b564d6add ("net: dsa: felix: support psfp filter on vsc9959")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/20220629183007.3808130-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1883,6 +1883,8 @@ static void vsc9959_psfp_sgi_table_del(s
 static void vsc9959_psfp_counters_get(struct ocelot *ocelot, u32 index,
 				      struct felix_stream_filter_counters *counters)
 {
+	mutex_lock(&ocelot->stats_lock);
+
 	ocelot_rmw(ocelot, SYS_STAT_CFG_STAT_VIEW(index),
 		   SYS_STAT_CFG_STAT_VIEW_M,
 		   SYS_STAT_CFG);
@@ -1897,6 +1899,8 @@ static void vsc9959_psfp_counters_get(st
 		     SYS_STAT_CFG_STAT_VIEW(index) |
 		     SYS_STAT_CFG_STAT_CLEAR_SHOT(0x10),
 		     SYS_STAT_CFG);
+
+	mutex_unlock(&ocelot->stats_lock);
 }
 
 static int vsc9959_psfp_filter_add(struct ocelot *ocelot, int port,


