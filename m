Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 342A86D47AA
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233103AbjDCOWR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233094AbjDCOWQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:22:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55F8C312A1
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:21:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5BD561A2D
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:21:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC396C433EF;
        Mon,  3 Apr 2023 14:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531717;
        bh=rdiOb6aB6IMXNSRwUVLojaJ0MoxQY4JfMOqOQjjqpiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ji7uYws04fMHsgI3GcM+H8IsA0ITC3YUT4iAhsdIuRRIijjVxxVkoHKEuSZomhOW/
         ipf/zu9X95K1CWp3f6sfPZNZm7oHYm9CmfDYok4NfsgxfgyDLRiUwjvrlAnTCxNX+C
         ajCtqK5FN4re8S36F59qJtKizwPC96tFzcaWHcB0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Steffen=20B=C3=A4tz?= <steffen@innosonix.de>,
        Fabio Estevam <festevam@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 084/104] net: dsa: mv88e6xxx: Enable IGMP snooping on user ports only
Date:   Mon,  3 Apr 2023 16:09:16 +0200
Message-Id: <20230403140407.429960034@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140403.549815164@linuxfoundation.org>
References: <20230403140403.549815164@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steffen Bätz <steffen@innosonix.de>

[ Upstream commit 7bcad0f0e6fbc1d613e49e0ee35c8e5f2e685bb0 ]

Do not set the MV88E6XXX_PORT_CTL0_IGMP_MLD_SNOOP bit on CPU or DSA ports.

This allows the host CPU port to be a regular IGMP listener by sending out
IGMP Membership Reports, which would otherwise not be forwarded by the
mv88exxx chip, but directly looped back to the CPU port itself.

Fixes: 54d792f257c6 ("net: dsa: Centralise global and port setup code into mv88e6xxx.")
Signed-off-by: Steffen Bätz <steffen@innosonix.de>
Signed-off-by: Fabio Estevam <festevam@denx.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20230329150140.701559-1-festevam@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index b336ed071fa89..ea32be579e7b1 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2433,9 +2433,14 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 	 * If this is the upstream port for this switch, enable
 	 * forwarding of unknown unicasts and multicasts.
 	 */
-	reg = MV88E6XXX_PORT_CTL0_IGMP_MLD_SNOOP |
-		MV88E6185_PORT_CTL0_USE_TAG | MV88E6185_PORT_CTL0_USE_IP |
+	reg = MV88E6185_PORT_CTL0_USE_TAG | MV88E6185_PORT_CTL0_USE_IP |
 		MV88E6XXX_PORT_CTL0_STATE_FORWARDING;
+	/* Forward any IPv4 IGMP or IPv6 MLD frames received
+	 * by a USER port to the CPU port to allow snooping.
+	 */
+	if (dsa_is_user_port(ds, port))
+		reg |= MV88E6XXX_PORT_CTL0_IGMP_MLD_SNOOP;
+
 	err = mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_CTL0, reg);
 	if (err)
 		return err;
-- 
2.39.2



