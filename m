Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51D40593AEA
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240177AbiHOUDp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239498AbiHOUCT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:02:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 638AA7CB7F;
        Mon, 15 Aug 2022 11:54:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4FF461228;
        Mon, 15 Aug 2022 18:54:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECDCFC433C1;
        Mon, 15 Aug 2022 18:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589648;
        bh=sCNQHxIcqQE3JOMnC1htlcE1nC/bTIllDvjHDq3ZsNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kp2kNMgi+KK1wTkhw+Wh5ypVbNvhZqSVmcyqBvnsMCV2R2qyto1TyA3qOZDnQzs6g
         +45HT2gfmG+1tpbAaSOlVjATcwxr9b6eZF5KlhzG+vDJIwQH3KlvS6oeumD0w/IhDT
         DdDNXx6c0+Y4XGs+7uSSyJTC6x05CPpM/jWfCEWQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Simon Han <z.han@kunbus.com>,
        Lukas Wunner <lukas@wunner.de>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 768/779] net: phy: smsc: Disable Energy Detect Power-Down in interrupt mode
Date:   Mon, 15 Aug 2022 20:06:52 +0200
Message-Id: <20220815180410.211874258@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

From: Lukas Wunner <lukas@wunner.de>

commit 2642cc6c3bbe0900ba15bab078fd15ad8baccbc5 upstream.

Simon reports that if two LAN9514 USB adapters are directly connected
without an intermediate switch, the link fails to come up and link LEDs
remain dark.  The issue was introduced by commit 1ce8b37241ed ("usbnet:
smsc95xx: Forward PHY interrupts to PHY driver to avoid polling").

The PHY suffers from a known erratum wherein link detection becomes
unreliable if Energy Detect Power-Down is used.  In poll mode, the
driver works around the erratum by briefly disabling EDPD for 640 msec
to detect a neighbor, then re-enabling it to save power.

In interrupt mode, no interrupt is signaled if EDPD is used by both link
partners, so it must not be enabled at all.

We'll recoup the power savings by enabling SUSPEND1 mode on affected
LAN95xx chips in a forthcoming commit.

Fixes: 1ce8b37241ed ("usbnet: smsc95xx: Forward PHY interrupts to PHY driver to avoid polling")
Reported-by: Simon Han <z.han@kunbus.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Link: https://lore.kernel.org/r/439a3f3168c2f9d44b5fd9bb8d2b551711316be6.1655714438.git.lukas@wunner.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/smsc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -110,7 +110,7 @@ static int smsc_phy_config_init(struct p
 	struct smsc_phy_priv *priv = phydev->priv;
 	int rc;
 
-	if (!priv->energy_enable)
+	if (!priv->energy_enable || phydev->irq != PHY_POLL)
 		return 0;
 
 	rc = phy_read(phydev, MII_LAN83C185_CTRL_STATUS);
@@ -210,6 +210,8 @@ static int lan95xx_config_aneg_ext(struc
  * response on link pulses to detect presence of plugged Ethernet cable.
  * The Energy Detect Power-Down mode is enabled again in the end of procedure to
  * save approximately 220 mW of power if cable is unplugged.
+ * The workaround is only applicable to poll mode. Energy Detect Power-Down may
+ * not be used in interrupt mode lest link change detection becomes unreliable.
  */
 static int lan87xx_read_status(struct phy_device *phydev)
 {
@@ -217,7 +219,7 @@ static int lan87xx_read_status(struct ph
 
 	int err = genphy_read_status(phydev);
 
-	if (!phydev->link && priv->energy_enable) {
+	if (!phydev->link && priv->energy_enable && phydev->irq == PHY_POLL) {
 		/* Disable EDPD to wake up PHY */
 		int rc = phy_read(phydev, MII_LAN83C185_CTRL_STATUS);
 		if (rc < 0)


