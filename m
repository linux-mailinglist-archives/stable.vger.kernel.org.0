Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3654ABC7B
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:48:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244199AbiBGLhm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:37:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384594AbiBGL3X (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:29:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86168C02B5D1;
        Mon,  7 Feb 2022 03:27:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E522B80EBD;
        Mon,  7 Feb 2022 11:27:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47739C004E1;
        Mon,  7 Feb 2022 11:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233247;
        bh=a/ZBpKbDDQqi+MpGt1DElsti8XZTAvY6yZ+reuerCY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p5o0Zh5Mf7NzRn4EdtNdw7rNkieDEJ8Y4Tgtt/87MbaOjnKiNDOdzHkQOjxmlTvZR
         bp980SrQoklv1Tfqo9lhSh02VnXi6e5tmmoxkoAidKZvow0zG5DiG7pdbqMTOXR31l
         6cr8EPKtk85Cg2FyCHdSIcp36HXOM950Zr7C/ieM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lior Nahmanson <liorna@nvidia.com>,
        Raed Salem <raeds@nvidia.com>,
        Antoine Tenart <atenart@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 064/110] net: macsec: Fix offload support for NETDEV_UNREGISTER event
Date:   Mon,  7 Feb 2022 12:06:37 +0100
Message-Id: <20220207103804.446898871@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103802.280120990@linuxfoundation.org>
References: <20220207103802.280120990@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Lior Nahmanson <liorna@nvidia.com>

commit 9cef24c8b76c1f6effe499d2f131807c90f7ce9a upstream.

Current macsec netdev notify handler handles NETDEV_UNREGISTER event by
releasing relevant SW resources only, this causes resources leak in case
of macsec HW offload, as the underlay driver was not notified to clean
it's macsec offload resources.

Fix by calling the underlay driver to clean it's relevant resources
by moving offload handling from macsec_dellink() to macsec_common_dellink()
when handling NETDEV_UNREGISTER event.

Fixes: 3cf3227a21d1 ("net: macsec: hardware offloading infrastructure")
Signed-off-by: Lior Nahmanson <liorna@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Antoine Tenart <atenart@kernel.org>
Link: https://lore.kernel.org/r/1643542141-28956-1-git-send-email-raeds@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/macsec.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3870,6 +3870,18 @@ static void macsec_common_dellink(struct
 	struct macsec_dev *macsec = macsec_priv(dev);
 	struct net_device *real_dev = macsec->real_dev;
 
+	/* If h/w offloading is available, propagate to the device */
+	if (macsec_is_offloaded(macsec)) {
+		const struct macsec_ops *ops;
+		struct macsec_context ctx;
+
+		ops = macsec_get_ops(netdev_priv(dev), &ctx);
+		if (ops) {
+			ctx.secy = &macsec->secy;
+			macsec_offload(ops->mdo_del_secy, &ctx);
+		}
+	}
+
 	unregister_netdevice_queue(dev, head);
 	list_del_rcu(&macsec->secys);
 	macsec_del_dev(macsec);
@@ -3884,18 +3896,6 @@ static void macsec_dellink(struct net_de
 	struct net_device *real_dev = macsec->real_dev;
 	struct macsec_rxh_data *rxd = macsec_data_rtnl(real_dev);
 
-	/* If h/w offloading is available, propagate to the device */
-	if (macsec_is_offloaded(macsec)) {
-		const struct macsec_ops *ops;
-		struct macsec_context ctx;
-
-		ops = macsec_get_ops(netdev_priv(dev), &ctx);
-		if (ops) {
-			ctx.secy = &macsec->secy;
-			macsec_offload(ops->mdo_del_secy, &ctx);
-		}
-	}
-
 	macsec_common_dellink(dev, head);
 
 	if (list_empty(&rxd->secys)) {


