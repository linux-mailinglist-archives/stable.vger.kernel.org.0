Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 696066BB344
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233066AbjCOMnF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232905AbjCOMmm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:42:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C45FCA2242
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:41:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E395B81E00
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:41:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA45EC433EF;
        Wed, 15 Mar 2023 12:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678884068;
        bh=33pd0KRJlrLYoDXcw041jL3LWxEhNNixn/bwu3atCXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hSaEv2NZ7RHm9O34OLumeWhoVWeiHz4rhnk8zsi8dElLkLuKGmHjRt0SkJNbwqebs
         JX9mSwiSKHSER6Y7fxK+L5pAARPOA0i4aPlIunorSmSih1r8lgqA9rIC9APfWoUGRG
         DVSidVBzlx3IkeqYaWddlwbMEXUabkYpnZMf9yHU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Petr Oros <poros@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 067/141] ice: copy last block omitted in ice_get_module_eeprom()
Date:   Wed, 15 Mar 2023 13:12:50 +0100
Message-Id: <20230315115741.989802704@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Oros <poros@redhat.com>

[ Upstream commit 84cba1840e68430325ac133a11be06bfb2f7acd8 ]

ice_get_module_eeprom() is broken since commit e9c9692c8a81 ("ice:
Reimplement module reads used by ethtool") In this refactor,
ice_get_module_eeprom() reads the eeprom in blocks of size 8.
But the condition that should protect the buffer overflow
ignores the last block. The last block always contains zeros.

Bug uncovered by ethtool upstream commit 9538f384b535
("netlink: eeprom: Defer page requests to individual parsers")
After this commit, ethtool reads a block with length = 1;
to read the SFF-8024 identifier value.

unpatched driver:
$ ethtool -m enp65s0f0np0 offset 0x90 length 8
Offset          Values
------          ------
0x0090:         00 00 00 00 00 00 00 00
$ ethtool -m enp65s0f0np0 offset 0x90 length 12
Offset          Values
------          ------
0x0090:         00 00 01 a0 4d 65 6c 6c 00 00 00 00
$

$ ethtool -m enp65s0f0np0
Offset          Values
------          ------
0x0000:         11 06 06 00 00 00 00 00 00 00 00 00 00 00 00 00
0x0010:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x0020:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x0030:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x0040:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x0050:         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x0060:         00 00 00 00 00 00 00 00 00 00 00 00 00 01 08 00
0x0070:         00 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00

patched driver:
$ ethtool -m enp65s0f0np0 offset 0x90 length 8
Offset          Values
------          ------
0x0090:         00 00 01 a0 4d 65 6c 6c
$ ethtool -m enp65s0f0np0 offset 0x90 length 12
Offset          Values
------          ------
0x0090:         00 00 01 a0 4d 65 6c 6c 61 6e 6f 78
$ ethtool -m enp65s0f0np0
    Identifier                                : 0x11 (QSFP28)
    Extended identifier                       : 0x00
    Extended identifier description           : 1.5W max. Power consumption
    Extended identifier description           : No CDR in TX, No CDR in RX
    Extended identifier description           : High Power Class (> 3.5 W) not enabled
    Connector                                 : 0x23 (No separable connector)
    Transceiver codes                         : 0x88 0x00 0x00 0x00 0x00 0x00 0x00 0x00
    Transceiver type                          : 40G Ethernet: 40G Base-CR4
    Transceiver type                          : 25G Ethernet: 25G Base-CR CA-N
    Encoding                                  : 0x05 (64B/66B)
    BR, Nominal                               : 25500Mbps
    Rate identifier                           : 0x00
    Length (SMF,km)                           : 0km
    Length (OM3 50um)                         : 0m
    Length (OM2 50um)                         : 0m
    Length (OM1 62.5um)                       : 0m
    Length (Copper or Active cable)           : 1m
    Transmitter technology                    : 0xa0 (Copper cable unequalized)
    Attenuation at 2.5GHz                     : 4db
    Attenuation at 5.0GHz                     : 5db
    Attenuation at 7.0GHz                     : 7db
    Attenuation at 12.9GHz                    : 10db
    ........
    ....

Fixes: e9c9692c8a81 ("ice: Reimplement module reads used by ethtool")
Signed-off-by: Petr Oros <poros@redhat.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index a359f1610fc19..8ca61610cec23 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -4314,6 +4314,8 @@ ice_get_module_eeprom(struct net_device *netdev,
 		 * SFP modules only ever use page 0.
 		 */
 		if (page == 0 || !(data[0x2] & 0x4)) {
+			u32 copy_len;
+
 			/* If i2c bus is busy due to slow page change or
 			 * link management access, call can fail. This is normal.
 			 * So we retry this a few times.
@@ -4337,8 +4339,8 @@ ice_get_module_eeprom(struct net_device *netdev,
 			}
 
 			/* Make sure we have enough room for the new block */
-			if ((i + SFF_READ_BLOCK_SIZE) < ee->len)
-				memcpy(data + i, value, SFF_READ_BLOCK_SIZE);
+			copy_len = min_t(u32, SFF_READ_BLOCK_SIZE, ee->len - i);
+			memcpy(data + i, value, copy_len);
 		}
 	}
 	return 0;
-- 
2.39.2



