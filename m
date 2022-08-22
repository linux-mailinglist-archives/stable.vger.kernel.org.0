Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39C8759BFEC
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 14:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234611AbiHVM6G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 08:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232206AbiHVM6F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 08:58:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADBD5220F7
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 05:58:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65460B811D6
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 12:58:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4CDDC433C1;
        Mon, 22 Aug 2022 12:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661173082;
        bh=JB7AwwoC6b/2cK7yrxSLlEYOzj6lv6N9/fVJjsg65k8=;
        h=Subject:To:Cc:From:Date:From;
        b=tDGCP61gUkuFBY4cpdHvcvkVZS01BCeEEmOUn8zt7QSQTC5hgEwOTg/ErQgbSAdSd
         93uXssHNU7YQcc8Lkoy74bs2OTdimG6zsTmnUK4f4Joh9vQhHxfCzfzsgRvM7dXevy
         tvjIucOOJpFMqXVqF4f2CylHyy1ysvdYOefmL5LA=
Subject: FAILED: patch "[PATCH] net: dsa: don't warn in dsa_port_set_state_now() when driver" failed to apply to 5.10-stable tree
To:     vladimir.oltean@nxp.com, kuba@kernel.org, saproj@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Aug 2022 14:57:59 +0200
Message-ID: <1661173079203246@kroah.com>
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 211987f3ac734000ea1548784b2a4539a974fbc8 Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Tue, 16 Aug 2022 23:14:45 +0300
Subject: [PATCH] net: dsa: don't warn in dsa_port_set_state_now() when driver
 doesn't support it

ds->ops->port_stp_state_set() is, like most DSA methods, optional, and
if absent, the port is supposed to remain in the forwarding state (as
standalone). Such is the case with the mv88e6060 driver, which does not
offload the bridge layer. DSA warns that the STP state can't be changed
to FORWARDING as part of dsa_port_enable_rt(), when in fact it should not.

The error message is also not up to modern standards, so take the
opportunity to make it more descriptive.

Fixes: fd3645413197 ("net: dsa: change scope of STP state setter")
Reported-by: Sergei Antonov <saproj@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Sergei Antonov <saproj@gmail.com>
Link: https://lore.kernel.org/r/20220816201445.1809483-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/net/dsa/port.c b/net/dsa/port.c
index 2dd76eb1621c..a8895ee3cd60 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -145,11 +145,14 @@ int dsa_port_set_state(struct dsa_port *dp, u8 state, bool do_fast_age)
 static void dsa_port_set_state_now(struct dsa_port *dp, u8 state,
 				   bool do_fast_age)
 {
+	struct dsa_switch *ds = dp->ds;
 	int err;
 
 	err = dsa_port_set_state(dp, state, do_fast_age);
-	if (err)
-		pr_err("DSA: failed to set STP state %u (%d)\n", state, err);
+	if (err && err != -EOPNOTSUPP) {
+		dev_err(ds->dev, "port %d failed to set STP state %u: %pe\n",
+			dp->index, state, ERR_PTR(err));
+	}
 }
 
 int dsa_port_set_mst_state(struct dsa_port *dp,

