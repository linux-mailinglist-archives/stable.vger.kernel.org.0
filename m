Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48B0059BFF4
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 14:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232206AbiHVM6T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 08:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234696AbiHVM6P (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 08:58:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95C4E334
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 05:58:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3077F61152
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 12:58:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3851CC433D6;
        Mon, 22 Aug 2022 12:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661173093;
        bh=uGOgSrlLOpg0mwgtptAQObCjQh+fF30x80foO/dl8oM=;
        h=Subject:To:Cc:From:Date:From;
        b=D5YdJ06pIsYrUBQSYxWC9WeciwZTF3j5wPrvOVXD5Y9/HrSMDh+17sRSFcFjGZfK2
         4b5jU2sYrz1S42w/2bjJiRGV7Wmxh7rHbtgF5cdonsSs0a60I0Uf4kIJvTsxArV2Dy
         68kK1X2ZlwZw9Q0EIJ/JWPX1eOfqcyS7AWjSQ/84=
Subject: FAILED: patch "[PATCH] net: dsa: don't warn in dsa_port_set_state_now() when driver" failed to apply to 4.19-stable tree
To:     vladimir.oltean@nxp.com, kuba@kernel.org, saproj@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Aug 2022 14:58:00 +0200
Message-ID: <1661173080181235@kroah.com>
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


The patch below does not apply to the 4.19-stable tree.
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

