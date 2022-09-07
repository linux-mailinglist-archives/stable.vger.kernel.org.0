Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 898955B0231
	for <lists+stable@lfdr.de>; Wed,  7 Sep 2022 12:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbiIGK5Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Sep 2022 06:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbiIGK5I (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Sep 2022 06:57:08 -0400
Received: from mail.savoirfairelinux.com (mail.savoirfairelinux.com [208.88.110.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 224F192F59
        for <stable@vger.kernel.org>; Wed,  7 Sep 2022 03:57:06 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id E357E9C0AF3;
        Wed,  7 Sep 2022 06:47:01 -0400 (EDT)
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id Do4jpbiVdNGh; Wed,  7 Sep 2022 06:47:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 68E5E9C098F;
        Wed,  7 Sep 2022 06:47:01 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.savoirfairelinux.com 68E5E9C098F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=savoirfairelinux.com; s=DFC430D2-D198-11EC-948E-34200CB392D2;
        t=1662547621; bh=lcNbKrWv0ucAJs0GcqlwiQvtZ95TxwJFdjgkvv1MZKo=;
        h=From:To:Date:Message-Id:MIME-Version;
        b=yk0E6PNVsaOShiIBKZSDr5gQF1S/UNIoISowp745tcBiAHMc62sUc4U7Cztj+AnM7
         m6xg5C9Y4kG85R4E/KoiQSQcaru9kzYBFeXNHb9fJgrxWMWyMZ2OdKMnJrReonbvna
         OLEonmvWu//4Q8WZk3hhXg/5sCgOgEkjBSU8of5WgNDPFa9JGR4l00mUupeJ6JT52d
         dzWiVeWTgmwpXI5ySodtqAOPtWFtay8B2Nusklv3gt5Cih9rJPtO894s2aQxhcmCH1
         U9I9N66nKMPbIePInjFW8EhrdE9uF/O6/dYYkuLJfqovLaL5e5Y1CcKbRH4HqJM8Q0
         FTlRBzRmvhffA==
X-Virus-Scanned: amavisd-new at mail.savoirfairelinux.com
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id toslLghwvC-6; Wed,  7 Sep 2022 06:47:01 -0400 (EDT)
Received: from sfl-deribaucourt.rennes.sfl (abordeaux-655-1-154-138.w92-162.abo.wanadoo.fr [92.162.199.138])
        by mail.savoirfairelinux.com (Postfix) with ESMTPSA id 941ED9C0A1E;
        Wed,  7 Sep 2022 06:47:00 -0400 (EDT)
From:   Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, andrew@lunn.ch,
        Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v3 2/2] net: dp83822: disable rx error interrupt
Date:   Wed,  7 Sep 2022 12:45:59 +0200
Message-Id: <20220907104558.256807-3-enguerrand.de-ribaucourt@savoirfairelinux.com>
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

Some RX errors, notably when disconnecting the cable, increase the RCSR
register. Once half full (0x7fff), an interrupt flood is generated. I
measured ~3k/s interrupts even after the RX errors transfer was
stopped.

Since we don't read and clear the RCSR register, we should disable this
interrupt.

Fixes: 87461f7a58ab ("net: phy: DP83822 initial driver submission")
Signed-off-by: Enguerrand de Ribaucourt <enguerrand.de-ribaucourt@savoirf=
airelinux.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[backport of 5.10 commit 0e597e2affb90d6ea48df6890d882924acf71e19]
---
 drivers/net/phy/dp83822.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
index cc1522550f2c..da3983352dd4 100644
--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -197,8 +197,7 @@ static int dp83822_config_intr(struct phy_device *phy=
dev)
 		if (misr_status < 0)
 			return misr_status;
=20
-		misr_status |=3D (DP83822_RX_ERR_HF_INT_EN |
-				DP83822_ANEG_COMPLETE_INT_EN |
+		misr_status |=3D (DP83822_ANEG_COMPLETE_INT_EN |
 				DP83822_DUP_MODE_CHANGE_INT_EN |
 				DP83822_SPEED_CHANGED_INT_EN |
 				DP83822_LINK_STAT_INT_EN |
--=20
2.25.1

