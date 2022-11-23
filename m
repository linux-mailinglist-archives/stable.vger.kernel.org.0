Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD23F635851
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237306AbiKWJyz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:54:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236534AbiKWJxs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:53:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A94FF1121C4
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:50:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 477F861A02
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:50:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 229DAC433D6;
        Wed, 23 Nov 2022 09:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197005;
        bh=sIAEPt/H/gTLrZ7FU7JS9WhysTyzp6yf8yks1QJRfgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NsEF+O9CJqIPwIMQ5YSNZ7Jw4jkcAYruwqfbDwqGuBgQJh65g6ZAu3SpJ8HF77lr6
         tes4TQVuS3hmY8Q8a0CaNmTkQhmijREBmK8fGXoZVaI7/SCCFFx3oPB7Ckts+UB/xF
         NVBFssLmwyNBF3z5E3w2nnbMM+RMp8c42VosrWqY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jaco Coetzee <jaco.coetzee@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 141/314] nfp: change eeprom length to max length enumerators
Date:   Wed, 23 Nov 2022 09:49:46 +0100
Message-Id: <20221123084631.936479132@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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

[ Upstream commit f3a72878a3de720661b7ed0d6b7f7c506ddb8a52 ]

Extend the size of QSFP EEPROM for types SSF8436 and SFF8636
from 256 to 640 bytes in order to expose all the EEPROM pages by
ethtool.

For SFF-8636 and SFF-8436 specifications, the driver exposes
256 bytes of EEPROM data for ethtool's get_module_eeprom()
callback, resulting in "netlink error: Invalid argument" when
an EEPROM read with an offset larger than 256 bytes is attempted.

Changing the length enumerators to the _MAX_LEN
variants exposes all 640 bytes of the EEPROM allowing upper
pages 1, 2 and 3 to be read.

Fixes: 96d971e307cc ("ethtool: Add fallback to get_module_eeprom from netlink command")
Signed-off-by: Jaco Coetzee <jaco.coetzee@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index b1b1b648e40c..b19bff0db1fd 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -1440,15 +1440,15 @@ nfp_port_get_module_info(struct net_device *netdev,
 
 		if (data < 0x3) {
 			modinfo->type = ETH_MODULE_SFF_8436;
-			modinfo->eeprom_len = ETH_MODULE_SFF_8436_LEN;
+			modinfo->eeprom_len = ETH_MODULE_SFF_8436_MAX_LEN;
 		} else {
 			modinfo->type = ETH_MODULE_SFF_8636;
-			modinfo->eeprom_len = ETH_MODULE_SFF_8636_LEN;
+			modinfo->eeprom_len = ETH_MODULE_SFF_8636_MAX_LEN;
 		}
 		break;
 	case NFP_INTERFACE_QSFP28:
 		modinfo->type = ETH_MODULE_SFF_8636;
-		modinfo->eeprom_len = ETH_MODULE_SFF_8636_LEN;
+		modinfo->eeprom_len = ETH_MODULE_SFF_8636_MAX_LEN;
 		break;
 	default:
 		netdev_err(netdev, "Unsupported module 0x%x detected\n",
-- 
2.35.1



