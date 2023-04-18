Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 403F16E635E
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231839AbjDRMj6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231837AbjDRMj5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:39:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFC8213FA5
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:39:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59FA4632C6
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:39:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DCE7C4339B;
        Tue, 18 Apr 2023 12:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821594;
        bh=HsVua6faaI0o/CBFqWFItpZSAG6ukYzO805q7HFgOLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JXIwFP8BJRTHvJHM4HlUjfMWl+uWlg9gBtaTdA2fNKecedS3EiUDMdFlRNzdUPaLW
         JvJzheFiiiHOjq76vcCPui9FbbWa4oRXZ3i3MrD0ssyRne+me9htYODFaxvUoyuGcL
         sspVh8ryEeuFKj7Jy6uQPNtQlkzcTM7ONoQMGXuI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Radu Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 60/91] net: phy: nxp-c45-tja11xx: add remove callback
Date:   Tue, 18 Apr 2023 14:22:04 +0200
Message-Id: <20230418120307.673961570@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120305.520719816@linuxfoundation.org>
References: <20230418120305.520719816@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Radu Pirea (OSS) <radu-nicolae.pirea@oss.nxp.com>

commit a4506722dc39ca840593f14e3faa4c9ba9408211 upstream.

Unregister PTP clock when the driver is removed.
Purge the RX and TX skb queues.

Fixes: 514def5dd339 ("phy: nxp-c45-tja11xx: add timestamping support")
CC: stable@vger.kernel.org # 5.15+
Signed-off-by: Radu Pirea (OSS) <radu-nicolae.pirea@oss.nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20230406095904.75456-1-radu-nicolae.pirea@oss.nxp.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/nxp-c45-tja11xx.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -1117,6 +1117,17 @@ no_ptp_support:
 	return ret;
 }
 
+static void nxp_c45_remove(struct phy_device *phydev)
+{
+	struct nxp_c45_phy *priv = phydev->priv;
+
+	if (priv->ptp_clock)
+		ptp_clock_unregister(priv->ptp_clock);
+
+	skb_queue_purge(&priv->tx_queue);
+	skb_queue_purge(&priv->rx_queue);
+}
+
 static struct phy_driver nxp_c45_driver[] = {
 	{
 		PHY_ID_MATCH_MODEL(PHY_ID_TJA_1103),
@@ -1139,6 +1150,7 @@ static struct phy_driver nxp_c45_driver[
 		.set_loopback		= genphy_c45_loopback,
 		.get_sqi		= nxp_c45_get_sqi,
 		.get_sqi_max		= nxp_c45_get_sqi_max,
+		.remove			= nxp_c45_remove,
 	},
 };
 


