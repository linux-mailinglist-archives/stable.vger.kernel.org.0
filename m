Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31BF7B5BF9
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729107AbfIRGV2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:21:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:40864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729075AbfIRGV1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:21:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA4D720678;
        Wed, 18 Sep 2019 06:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787686;
        bh=QqMP07gQA1eBn0SE74284JJiDQ8ywWG1Pq6Jw9LiISk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c01s1tgod0AiedYt8r3PhCeD8sBohTotr3jj6ojdM/B5zYXQsehwQi37cR1m2NXmI
         8y8wRgdWv0VGFtqqHxTLSFM2sYXfA+NdjBns0vo+KDz/UviGj1/FXTxc3knGBbIyzT
         tIFzABpYfCp0USDGkJIiLlWakUmBPG0ecWoVZR/c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Chulski <stefanc@marvell.com>,
        Shaul Ben-Mayor <shaulb@marvell.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 07/45] net: phylink: Fix flow control resolution
Date:   Wed, 18 Sep 2019 08:18:45 +0200
Message-Id: <20190918061223.549546832@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061222.854132812@linuxfoundation.org>
References: <20190918061222.854132812@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

[ Upstream commit 63b2ed4e10b2e6c913e1d8cdd728e7fba4115a3d ]

Regarding to IEEE 802.3-2015 standard section 2
28B.3 Priority resolution - Table 28-3 - Pause resolution

In case of Local device Pause=1 AsymDir=0, Link partner
Pause=1 AsymDir=1, Local device resolution should be enable PAUSE
transmit, disable PAUSE receive.
And in case of Local device Pause=1 AsymDir=1, Link partner
Pause=1 AsymDir=0, Local device resolution should be enable PAUSE
receive, disable PAUSE transmit.

Fixes: 9525ae83959b ("phylink: add phylink infrastructure")
Signed-off-by: Stefan Chulski <stefanc@marvell.com>
Reported-by: Shaul Ben-Mayor <shaulb@marvell.com>
Acked-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/phylink.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -359,8 +359,8 @@ static void phylink_get_fixed_state(stru
  *  Local device  Link partner
  *  Pause AsymDir Pause AsymDir Result
  *    1     X       1     X     TX+RX
- *    0     1       1     1     RX
- *    1     1       0     1     TX
+ *    0     1       1     1     TX
+ *    1     1       0     1     RX
  */
 static void phylink_resolve_flow(struct phylink *pl,
 	struct phylink_link_state *state)
@@ -381,7 +381,7 @@ static void phylink_resolve_flow(struct
 			new_pause = MLO_PAUSE_TX | MLO_PAUSE_RX;
 		else if (pause & MLO_PAUSE_ASYM)
 			new_pause = state->pause & MLO_PAUSE_SYM ?
-				 MLO_PAUSE_RX : MLO_PAUSE_TX;
+				 MLO_PAUSE_TX : MLO_PAUSE_RX;
 	} else {
 		new_pause = pl->link_config.pause & MLO_PAUSE_TXRX_MASK;
 	}


