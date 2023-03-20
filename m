Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBDF16C16C7
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232217AbjCTPJC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232281AbjCTPIn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:08:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 449A72E814
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:04:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 721F3615A2
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:04:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80CFEC433EF;
        Mon, 20 Mar 2023 15:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324642;
        bh=GzgUCOqJrzHm0Pd6QBPAuVlYqElSWq5Bcd+gM8Zl5g4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jsMDfDIhQSjmZUssFZPdj+Jq4bwNrsPQo09rV1nhUQN8AZE9+KphgzDb/1AI5gEdJ
         wAyaMdryafu6G2iOVYMtYL+LFslnC1fecxEtDCndjcgY3domBYtxztugSLGMBLd2G6
         hOERng19fj9sGJ5gyHGxK0SLhtk19juefq/gP8Nw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Simon Horman <simon.horman@corigine.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 33/99] net: dsa: mv88e6xxx: fix max_mtu of 1492 on 6165, 6191, 6220, 6250, 6290
Date:   Mon, 20 Mar 2023 15:54:11 +0100
Message-Id: <20230320145444.760072326@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145443.333824603@linuxfoundation.org>
References: <20230320145443.333824603@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 7e9517375a14f44ee830ca1c3278076dd65fcc8f ]

There are 3 classes of switch families that the driver is aware of, as
far as mv88e6xxx_change_mtu() is concerned:

- MTU configuration is available per port. Here, the
  chip->info->ops->port_set_jumbo_size() method will be present.

- MTU configuration is global to the switch. Here, the
  chip->info->ops->set_max_frame_size() method will be present.

- We don't know how to change the MTU. Here, none of the above methods
  will be present.

Switch families MV88E6165, MV88E6191, MV88E6220, MV88E6250 and MV88E6290
fall in category 3.

The blamed commit has adjusted the MTU for all 3 categories by EDSA_HLEN
(8 bytes), resulting in a new maximum MTU of 1492 being reported by the
driver for these switches.

I don't have the hardware to test, but I do have a MV88E6390 switch on
which I can simulate this by commenting out its .port_set_jumbo_size
definition from mv88e6390_ops. The result is this set of messages at
probe time:

mv88e6085 d0032004.mdio-mii:10: nonfatal error -34 setting MTU to 1500 on port 1
mv88e6085 d0032004.mdio-mii:10: nonfatal error -34 setting MTU to 1500 on port 2
mv88e6085 d0032004.mdio-mii:10: nonfatal error -34 setting MTU to 1500 on port 3
mv88e6085 d0032004.mdio-mii:10: nonfatal error -34 setting MTU to 1500 on port 4
mv88e6085 d0032004.mdio-mii:10: nonfatal error -34 setting MTU to 1500 on port 5
mv88e6085 d0032004.mdio-mii:10: nonfatal error -34 setting MTU to 1500 on port 6
mv88e6085 d0032004.mdio-mii:10: nonfatal error -34 setting MTU to 1500 on port 7
mv88e6085 d0032004.mdio-mii:10: nonfatal error -34 setting MTU to 1500 on port 8

It is highly implausible that there exist Ethernet switches which don't
support the standard MTU of 1500 octets, and this is what the DSA
framework says as well - the error comes from dsa_slave_create() ->
dsa_slave_change_mtu(slave_dev, ETH_DATA_LEN).

But the error messages are alarming, and it would be good to suppress
them.

As a consequence of this unlikeliness, we reimplement mv88e6xxx_get_max_mtu()
and mv88e6xxx_change_mtu() on switches from the 3rd category as follows:
the maximum supported MTU is 1500, and any request to set the MTU to a
value larger than that fails in dev_validate_mtu().

Fixes: b9c587fed61c ("dsa: mv88e6xxx: Include tagger overhead when setting MTU for DSA and CPU ports")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 371b345635e62..a253476a52b01 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2734,7 +2734,7 @@ static int mv88e6xxx_get_max_mtu(struct dsa_switch *ds, int port)
 		return 10240 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
 	else if (chip->info->ops->set_max_frame_size)
 		return 1632 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
-	return 1522 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
+	return ETH_DATA_LEN;
 }
 
 static int mv88e6xxx_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
@@ -2742,6 +2742,17 @@ static int mv88e6xxx_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int ret = 0;
 
+	/* For families where we don't know how to alter the MTU,
+	 * just accept any value up to ETH_DATA_LEN
+	 */
+	if (!chip->info->ops->port_set_jumbo_size &&
+	    !chip->info->ops->set_max_frame_size) {
+		if (new_mtu > ETH_DATA_LEN)
+			return -EINVAL;
+
+		return 0;
+	}
+
 	if (dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port))
 		new_mtu += EDSA_HLEN;
 
@@ -2750,9 +2761,6 @@ static int mv88e6xxx_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 		ret = chip->info->ops->port_set_jumbo_size(chip, port, new_mtu);
 	else if (chip->info->ops->set_max_frame_size)
 		ret = chip->info->ops->set_max_frame_size(chip, new_mtu);
-	else
-		if (new_mtu > 1522)
-			ret = -EINVAL;
 	mv88e6xxx_reg_unlock(chip);
 
 	return ret;
-- 
2.39.2



