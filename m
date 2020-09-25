Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5872127882A
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729406AbgIYMxU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:53:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:58634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729404AbgIYMxS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:53:18 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C378F2075E;
        Fri, 25 Sep 2020 12:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038398;
        bh=G99LDT++Lmv9gTgpTAVOUxdz7UenfKe58doTq1McXvo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uC1azpOMZb+HEA59Lad/cyqOgPLv7EtKuxU/tPwPXylIGTT6Qy/tcQOYAk+nAuuxt
         ISvqzVj314vh2EPUduJ9B4VOTja8vseSnXQALVvo8+rZ5e4uxpx4OmIvPcPbU8z27Q
         NtXB9nnqDu7BBtafj+YNsZwvCbObENrTtcqn9MNE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 39/43] net: phy: Do not warn in phy_stop() on PHY_DOWN
Date:   Fri, 25 Sep 2020 14:48:51 +0200
Message-Id: <20200925124729.471990495@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124723.575329814@linuxfoundation.org>
References: <20200925124723.575329814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 5116a8ade333b6c2e180782139c9c516a437b21c ]

When phy_is_started() was added to catch incorrect PHY states,
phy_stop() would not be qualified against PHY_DOWN. It is possible to
reach that state when the PHY driver has been unbound and the network
device is then brought down.

Fixes: 2b3e88ea6528 ("net: phy: improve phy state checking")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/phy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -834,7 +834,7 @@ EXPORT_SYMBOL(phy_free_interrupt);
  */
 void phy_stop(struct phy_device *phydev)
 {
-	if (!phy_is_started(phydev)) {
+	if (!phy_is_started(phydev) && phydev->state != PHY_DOWN) {
 		WARN(1, "called from state %s\n",
 		     phy_state_to_str(phydev->state));
 		return;


