Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF7563A98E
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729102AbfFIRCb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:02:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:40432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730057AbfFIRCa (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:02:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0852F207E0;
        Sun,  9 Jun 2019 17:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099749;
        bh=KOWkuXuBtpVMA1akSWD0Yjms8HspRwlAqWzEw0WHYkw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nF8R6nMSt1/629xnIAv1cPKJeSbJ37QoJgqfr/uVQLPqqicdXjpT+FmnhFYVXXneM
         V6X16Q36Vno310egX5PgBdu3bN4WVKwxs+/JRw1s6OFDJD94Vt7a+gatKNSS2AV6L4
         1oaHZWQas+t3KTbN9ebpqs6aTsycjQh2pgmG0VIY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 153/241] b43: shut up clang -Wuninitialized variable warning
Date:   Sun,  9 Jun 2019 18:41:35 +0200
Message-Id: <20190609164152.189529210@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit d825db346270dbceef83b7b750dbc29f1d7dcc0e ]

Clang warns about what is clearly a case of passing an uninitalized
variable into a static function:

drivers/net/wireless/broadcom/b43/phy_lp.c:1852:23: error: variable 'gains' is uninitialized when used here
      [-Werror,-Wuninitialized]
                lpphy_papd_cal(dev, gains, 0, 1, 30);
                                    ^~~~~
drivers/net/wireless/broadcom/b43/phy_lp.c:1838:2: note: variable 'gains' is declared here
        struct lpphy_tx_gains gains, oldgains;
        ^
1 error generated.

However, this function is empty, and its arguments are never evaluated,
so gcc in contrast does not warn here. Both compilers behave in a
reasonable way as far as I can tell, so we should change the code
to avoid the warning everywhere.

We could just eliminate the lpphy_papd_cal() function entirely,
given that it has had the TODO comment in it for 10 years now
and is rather unlikely to ever get done. I'm doing a simpler
change here, and just pass the 'oldgains' variable in that has
been initialized, based on the guess that this is what was
originally meant.

Fixes: 2c0d6100da3e ("b43: LP-PHY: Begin implementing calibration & software RFKILL support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/b43/phy_lp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
index 058a9f2320503..55cb07693ae80 100644
--- a/drivers/net/wireless/b43/phy_lp.c
+++ b/drivers/net/wireless/b43/phy_lp.c
@@ -1834,7 +1834,7 @@ static void lpphy_papd_cal(struct b43_wldev *dev, struct lpphy_tx_gains gains,
 static void lpphy_papd_cal_txpwr(struct b43_wldev *dev)
 {
 	struct b43_phy_lp *lpphy = dev->phy.lp;
-	struct lpphy_tx_gains gains, oldgains;
+	struct lpphy_tx_gains oldgains;
 	int old_txpctl, old_afe_ovr, old_rf, old_bbmult;
 
 	lpphy_read_tx_pctl_mode_from_hardware(dev);
@@ -1848,9 +1848,9 @@ static void lpphy_papd_cal_txpwr(struct b43_wldev *dev)
 	lpphy_set_tx_power_control(dev, B43_LPPHY_TXPCTL_OFF);
 
 	if (dev->dev->chip_id == 0x4325 && dev->dev->chip_rev == 0)
-		lpphy_papd_cal(dev, gains, 0, 1, 30);
+		lpphy_papd_cal(dev, oldgains, 0, 1, 30);
 	else
-		lpphy_papd_cal(dev, gains, 0, 1, 65);
+		lpphy_papd_cal(dev, oldgains, 0, 1, 65);
 
 	if (old_afe_ovr)
 		lpphy_set_tx_gains(dev, oldgains);
-- 
2.20.1



