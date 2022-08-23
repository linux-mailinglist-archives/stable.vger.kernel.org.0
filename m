Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B636059D589
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242851AbiHWJD6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242773AbiHWJCn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:02:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3013B2AC4A;
        Tue, 23 Aug 2022 01:28:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6146C6148C;
        Tue, 23 Aug 2022 08:27:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 689B2C433C1;
        Tue, 23 Aug 2022 08:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243258;
        bh=mvmEQi8G1j5geB8LqT0jAv7O9847yojaKS1VuX8fESg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cq+4eZHMFjAsPkTqv8U94rF1Or7GQLibZg76jrm1Y58refDIbs8D92d3lDaqDkRQv
         ziloQAbwf8J3Kd+m+hrHWpJbC9JM2nc+QIPTuracDi21JEuHw7NwksUy8/rPGWXqql
         Xiiq26g5CKKuJ9gx/2z6OC5//qYi/g/cqGJQgiO8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergei Antonov <saproj@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.19 219/365] net: dsa: dont warn in dsa_port_set_state_now() when driver doesnt support it
Date:   Tue, 23 Aug 2022 10:02:00 +0200
Message-Id: <20220823080127.343140803@linuxfoundation.org>
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

commit 211987f3ac734000ea1548784b2a4539a974fbc8 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/dsa/port.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -145,11 +145,14 @@ int dsa_port_set_state(struct dsa_port *
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


