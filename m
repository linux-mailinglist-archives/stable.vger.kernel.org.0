Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 263E064343F
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234832AbiLETnf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:43:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233431AbiLETnT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:43:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F3E26F7
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:40:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B9C961335
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:40:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A346C433C1;
        Mon,  5 Dec 2022 19:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670269242;
        bh=T9bSYkZ+amxtMrzcKBgwPR3EGbvabPVWNmiw2eC8kjU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0A6GYRrseQJnQDFnqgvJY4BQekQgO29QPGn4h8mMd59JqszOVBLJ3/x8vRCQNA+rn
         KxaWpLgAq9N8Yl0y37dbtKuSzLhk5qioQ7QO/UfiGhYyejc6t+vGrmCUVqT0R56A77
         K3WSND+4WoMIUc1s+rgFf70iCbA3m0yWBS2Sfc7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jaco Coetzee <jaco.coetzee@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 027/153] nfp: add port from netdev validation for EEPROM access
Date:   Mon,  5 Dec 2022 20:09:11 +0100
Message-Id: <20221205190809.516889238@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
References: <20221205190808.733996403@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaco Coetzee <jaco.coetzee@corigine.com>

[ Upstream commit 0873016d46f6dfafd1bdf4d9b935b3331b226f7c ]

Setting of the port flag `NFP_PORT_CHANGED`, introduced
to ensure the correct reading of EEPROM data, causes a
fatal kernel NULL pointer dereference in cases where
the target netdev type cannot be determined.

Add validation of port struct pointer before attempting
to set the `NFP_PORT_CHANGED` flag. Return that operation
is not supported if the netdev type cannot be determined.

Fixes: 4ae97cae07e1 ("nfp: ethtool: fix the display error of `ethtool -m DEVNAME`")
Signed-off-by: Jaco Coetzee <jaco.coetzee@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index 46d6988829ff..ff8810357181 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -1127,6 +1127,9 @@ nfp_port_get_module_info(struct net_device *netdev,
 	u8 data;
 
 	port = nfp_port_from_netdev(netdev);
+	if (!port)
+		return -EOPNOTSUPP;
+
 	/* update port state to get latest interface */
 	set_bit(NFP_PORT_CHANGED, &port->flags);
 	eth_port = nfp_port_get_eth_port(port);
-- 
2.35.1



