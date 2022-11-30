Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C027763DD77
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:27:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiK3S1n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:27:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbiK3S1a (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:27:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDB8E8D649
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:27:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E59B61B7C
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:27:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E354C433D6;
        Wed, 30 Nov 2022 18:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669832847;
        bh=A/31FoIveb2WxbqlnDMAVcULgHiMi/pFgsarCiSUo8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CnIitrXAeOBxpw6u6YZwfmUKuv7rjiRCrCFUJfQUe8sMhBXsTpP44cZQS5DFpOzRU
         mJqeoGrOeoa867U3l7oxE12YQ8g5iJELRWDibOF1udzjMolj4DsDJKlHKE7mAQpF5t
         evPueivq8OEE5e0EEJnx7T9D5fGu53RCsGqkxyt4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jaco Coetzee <jaco.coetzee@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 061/162] nfp: add port from netdev validation for EEPROM access
Date:   Wed, 30 Nov 2022 19:22:22 +0100
Message-Id: <20221130180530.161353252@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
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
index 3977aa2f59bd..311873ff57e3 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -1225,6 +1225,9 @@ nfp_port_get_module_info(struct net_device *netdev,
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



