Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99F5F10BC2E
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387453AbfK0VTN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:19:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:38214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733075AbfK0VKn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:10:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 303682176D;
        Wed, 27 Nov 2019 21:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574889042;
        bh=Eq+oqlUR4lrbyBOHaGkVKZwBxWlrw88DbjzlTK/XLkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LnypUPe3RtjEe7GlJnCQ0Hk5xVf8xYbWo4I9OeE8u45rigsPd7Bnu7fpRx/FsZ7V6
         826j9cCJkg5S5ZFSkaPWZ4/B7UX0yTBE0xqxhG5lYzqYafXMaJWlr+SE95FURaMN3s
         61Y52Id2R/LqLo1fDHjhCmQS0BcwnLkYe8Evlw9Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        YueHaibing <yuehaibing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH 5.3 44/95] mdio_bus: Fix init if CONFIG_RESET_CONTROLLER=n
Date:   Wed, 27 Nov 2019 21:32:01 +0100
Message-Id: <20191127202911.090182538@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202845.651587549@linuxfoundation.org>
References: <20191127202845.651587549@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit 6e4ff1c94a0477598ddbe4da47530aecdb4f7dff upstream.

Commit 1d4639567d97 ("mdio_bus: Fix PTR_ERR applied after initialization
to constant") accidentally changed a check from -ENOTSUPP to -ENOSYS,
causing failures if reset controller support is not enabled.  E.g. on
r7s72100/rskrza1:

    sh-eth e8203000.ethernet: MDIO init failed: -524
    sh-eth: probe of e8203000.ethernet failed with error -524

Seen on r8a7740/armadillo, r7s72100/rskrza1, and r7s9210/rza2mevb.

Fixes: 1d4639567d97 ("mdio_bus: Fix PTR_ERR applied after initialization to constant")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: YueHaibing <yuehaibing@huawei.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Marek Behún <marek.behun@nic.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/phy/mdio_bus.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -68,11 +68,12 @@ static int mdiobus_register_reset(struct
 	if (mdiodev->dev.of_node)
 		reset = devm_reset_control_get_exclusive(&mdiodev->dev,
 							 "phy");
-	if (PTR_ERR(reset) == -ENOENT ||
-	    PTR_ERR(reset) == -ENOTSUPP)
-		reset = NULL;
-	else if (IS_ERR(reset))
-		return PTR_ERR(reset);
+	if (IS_ERR(reset)) {
+		if (PTR_ERR(reset) == -ENOENT || PTR_ERR(reset) == -ENOTSUPP)
+			reset = NULL;
+		else
+			return PTR_ERR(reset);
+	}
 
 	mdiodev->reset_ctrl = reset;
 


