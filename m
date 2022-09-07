Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D19DF5B0232
	for <lists+stable@lfdr.de>; Wed,  7 Sep 2022 12:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbiIGK5Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Sep 2022 06:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbiIGK5I (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Sep 2022 06:57:08 -0400
Received: from mail.savoirfairelinux.com (mail.savoirfairelinux.com [208.88.110.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B32BD8050D
        for <stable@vger.kernel.org>; Wed,  7 Sep 2022 03:57:06 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 06D5D9C05B6;
        Wed,  7 Sep 2022 06:47:01 -0400 (EDT)
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id E3v65n5vnOcT; Wed,  7 Sep 2022 06:47:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 7C4EB9C098F;
        Wed,  7 Sep 2022 06:47:00 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.savoirfairelinux.com 7C4EB9C098F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=savoirfairelinux.com; s=DFC430D2-D198-11EC-948E-34200CB392D2;
        t=1662547620; bh=Oj9jebB6D4MRQuDDcSmupG6G9SM01K9qUPjIpGYLJ2Y=;
        h=From:To:Date:Message-Id:MIME-Version;
        b=m4b8MD0LminBiRyBUvU+frc1jCDEN3ezVeIWqGVyIw6eKcDvxOaTvIARuZlhAes0P
         FhfEDf2AVMrTNXsiwsh7vCk61MRUXDRV3t61xPdH0s0ycKLAoAlGUiPiQ1x/5LGMAr
         8nmNjuyr62oOmkt3ciMJ+3yqcIak4oRJ+Y6y8AmOYdYHNYDT5VgkP+82OvEXjlKKGd
         oQ1ibapHm+nYjHEyaRLXRFl0xVrrqtlQVHmVv3ZZFRs9ly8h0A2nZJIOaQsabjaEU2
         ym5kqNX5rFaMnSltLXD5tn/7qCfpuX8bRCajYpEGwnw0PgKya7nDKYhuyehBrPgKXJ
         c6vsVWUumU3Kg==
X-Virus-Scanned: amavisd-new at mail.savoirfairelinux.com
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id bCSQmpJiTqI0; Wed,  7 Sep 2022 06:47:00 -0400 (EDT)
Received: from sfl-deribaucourt.rennes.sfl (abordeaux-655-1-154-138.w92-162.abo.wanadoo.fr [92.162.199.138])
        by mail.savoirfairelinux.com (Postfix) with ESMTPSA id A4B879C05B6;
        Wed,  7 Sep 2022 06:46:59 -0400 (EDT)
From:   Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, andrew@lunn.ch,
        Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v3 1/2] net: dp83822: disable false carrier interrupt
Date:   Wed,  7 Sep 2022 12:45:58 +0200
Message-Id: <20220907104558.256807-2-enguerrand.de-ribaucourt@savoirfairelinux.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220907104558.256807-1-enguerrand.de-ribaucourt@savoirfairelinux.com>
References: <20220907104558.256807-1-enguerrand.de-ribaucourt@savoirfairelinux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When unplugging an Ethernet cable, false carrier events were produced by
the PHY at a very high rate. Once the false carrier counter full, an
interrupt was triggered every few clock cycles until the cable was
replugged. This resulted in approximately 10k/s interrupts.

Since the false carrier counter (FCSCR) is never used, we can safely
disable this interrupt.

In addition to improving performance, this also solved MDIO read
timeouts I was randomly encountering with an i.MX8 fec MAC because of
the interrupt flood. The interrupt count and MDIO timeout fix were
tested on a v5.4.110 kernel.

Fixes: 87461f7a58ab ("net: phy: DP83822 initial driver submission")
Signed-off-by: Enguerrand de Ribaucourt <enguerrand.de-ribaucourt@savoirf=
airelinux.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[backport of 5.10 commit c96614eeab663646f57f67aa591e015abd8bd0ba]
---
 drivers/net/phy/dp83822.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
index ae17d2f9d534..cc1522550f2c 100644
--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -198,7 +198,6 @@ static int dp83822_config_intr(struct phy_device *phy=
dev)
 			return misr_status;
=20
 		misr_status |=3D (DP83822_RX_ERR_HF_INT_EN |
-				DP83822_FALSE_CARRIER_HF_INT_EN |
 				DP83822_ANEG_COMPLETE_INT_EN |
 				DP83822_DUP_MODE_CHANGE_INT_EN |
 				DP83822_SPEED_CHANGED_INT_EN |
--=20
2.25.1

