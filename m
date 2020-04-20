Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9F31B0BB6
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbgDTMnK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:43:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:36478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728334AbgDTMnI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:43:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF9DE2072B;
        Mon, 20 Apr 2020 12:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386588;
        bh=qKGdh4Za47dTXjFZpK413jDKrBnm5xyHnkOpBgWgldg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FQGTUE/CiVaN13Jii9N+2BBJekK+iHMutGFAJlosUVlXUS431RLgJxPY/D0q+KANe
         t0PMGfBtXEAWv5Y7EP9jwau3qK3FIWoPrVVL0sN04yGx9KRgkXew/ZOfAlhz9/kOlz
         V4/AjPH1UaWvKZgHAt27rcv1LVU/Xl5P5XbMOjB0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Atsushi Nemoto <atsushi.nemoto@sord.co.jp>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 08/71] net: phy: micrel: use genphy_read_status for KSZ9131
Date:   Mon, 20 Apr 2020 14:38:22 +0200
Message-Id: <20200420121510.320227733@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121508.491252919@linuxfoundation.org>
References: <20200420121508.491252919@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Atsushi Nemoto <atsushi.nemoto@sord.co.jp>

[ Upstream commit 68dac3eb50be32957ae6e1e6da9281a3b7c6658b ]

KSZ9131 will not work with some switches due to workaround for KSZ9031
introduced in commit d2fd719bcb0e83cb39cfee22ee800f98a56eceb3
("net/phy: micrel: Add workaround for bad autoneg").
Use genphy_read_status instead of dedicated ksz9031_read_status.

Fixes: bff5b4b37372 ("net: phy: micrel: add Microchip KSZ9131 initial driver")
Signed-off-by: Atsushi Nemoto <atsushi.nemoto@sord.co.jp>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/micrel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1154,7 +1154,7 @@ static struct phy_driver ksphy_driver[]
 	.driver_data	= &ksz9021_type,
 	.probe		= kszphy_probe,
 	.config_init	= ksz9131_config_init,
-	.read_status	= ksz9031_read_status,
+	.read_status	= genphy_read_status,
 	.ack_interrupt	= kszphy_ack_interrupt,
 	.config_intr	= kszphy_config_intr,
 	.get_sset_count = kszphy_get_sset_count,


