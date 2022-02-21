Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D16194BDC00
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349553AbiBUJ2C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:28:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243856AbiBUJ1W (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:27:22 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E12A2633A;
        Mon, 21 Feb 2022 01:11:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5A376CE0E7D;
        Mon, 21 Feb 2022 09:11:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B20AC340E9;
        Mon, 21 Feb 2022 09:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434706;
        bh=gWrhBUVDvQ6S4mikWmV2cQBDKkGwyarz86IOQR8HysI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ADDzWmrBSUeHltOwMG6NYHj6yrtcvHXyfvx14OSYB08AeobRG64pnomPPlDHNmhR8
         QVaILV6OeFA8AA9UBaITeOGiRKG1FFhucstW/DnJ5R+hI+kcsQ5tKWJmiE09oIoXjG
         tu4HS5dbjL3qoIewnFpVzMVoShGskedO3ASko3X8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 102/196] net: phy: mediatek: remove PHY mode check on MT7531
Date:   Mon, 21 Feb 2022 09:48:54 +0100
Message-Id: <20220221084934.352555481@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
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

From: DENG Qingfang <dqfext@gmail.com>

commit 525b108e6d95b643eccbd84fb10aa9aa101b18dd upstream.

The function mt7531_phy_mode_supported in the DSA driver set supported
mode to PHY_INTERFACE_MODE_GMII instead of PHY_INTERFACE_MODE_INTERNAL
for the internal PHY, so this check breaks the PHY initialization:

mt7530 mdio-bus:00 wan (uninitialized): failed to connect to PHY: -EINVAL

Remove the check to make it work again.

Reported-by: Hauke Mehrtens <hauke@hauke-m.de>
Fixes: e40d2cca0189 ("net: phy: add MediaTek Gigabit Ethernet PHY driver")
Signed-off-by: DENG Qingfang <dqfext@gmail.com>
Acked-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Tested-by: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/mediatek-ge.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/net/phy/mediatek-ge.c
+++ b/drivers/net/phy/mediatek-ge.c
@@ -55,9 +55,6 @@ static int mt7530_phy_config_init(struct
 
 static int mt7531_phy_config_init(struct phy_device *phydev)
 {
-	if (phydev->interface != PHY_INTERFACE_MODE_INTERNAL)
-		return -EINVAL;
-
 	mtk_gephy_config_init(phydev);
 
 	/* PHY link down power saving enable */


