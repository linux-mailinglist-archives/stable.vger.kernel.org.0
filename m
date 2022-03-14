Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42AA54D81E9
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 12:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239909AbiCNL5u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 07:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239902AbiCNL5m (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 07:57:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 907B348309;
        Mon, 14 Mar 2022 04:56:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FC446112C;
        Mon, 14 Mar 2022 11:56:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D09DC340E9;
        Mon, 14 Mar 2022 11:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647258980;
        bh=UC48QFXafZ1nCCaW4a1oGCzPI8Ch5rwFvbVq4lOLDho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DpnA8PNN3e2WzttpkJmBzGREcu7opy5KjJcRZt0cqU67W3eTkQxvNOYSqAqIn3QYx
         bby0tfNHMDgap7iyy35FWecBxkiMN/HSWpzp85XbC4AAQEOK9Vz+xRMfe7reAEtALa
         1U4Y+Up18P0xgxtbeH860ueQuvdpSHTL/o100SqI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeremy Linton <jeremy.linton@arm.com>,
        Peter Robinson <pbrobinson@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 20/43] net: bcmgenet: Dont claim WOL when its not available
Date:   Mon, 14 Mar 2022 12:53:31 +0100
Message-Id: <20220314112734.984750692@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112734.415677317@linuxfoundation.org>
References: <20220314112734.415677317@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremy Linton <jeremy.linton@arm.com>

[ Upstream commit 00b022f8f876a3a036b0df7f971001bef6398605 ]

Some of the bcmgenet platforms don't correctly support WOL, yet
ethtool returns:

"Supports Wake-on: gsf"

which is false.

Ideally if there isn't a wol_irq, or there is something else that
keeps the device from being able to wakeup it should display:

"Supports Wake-on: d"

This patch checks whether the device can wakup, before using the
hard-coded supported flags. This corrects the ethtool reporting, as
well as the WOL configuration because ethtool verifies that the mode
is supported before attempting it.

Fixes: c51de7f3976b ("net: bcmgenet: add Wake-on-LAN support code")
Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
Tested-by: Peter Robinson <pbrobinson@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20220310045535.224450-1-jeremy.linton@arm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
index 164988f3b4fa..a2da09da4907 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
@@ -41,6 +41,13 @@
 void bcmgenet_get_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
+	struct device *kdev = &priv->pdev->dev;
+
+	if (!device_can_wakeup(kdev)) {
+		wol->supported = 0;
+		wol->wolopts = 0;
+		return;
+	}
 
 	wol->supported = WAKE_MAGIC | WAKE_MAGICSECURE;
 	wol->wolopts = priv->wolopts;
-- 
2.34.1



