Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 795A832E9A0
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:34:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232501AbhCEMd4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:33:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:44454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230179AbhCEMd1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:33:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F96065019;
        Fri,  5 Mar 2021 12:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947607;
        bh=m39mysxsa2SYNUolR9F15/RBNbBT5Uvi7xeXUQJ2ziA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aSknfi/Ydrfj0AygcqkNsDRmUK8+vNOu+ycLtGoGkt/c6PsmRXNnCBNw0ngKFihnc
         FXGYDYq+uh5ISlYVVjdwmx6zGM5b4SJw6FOroHo3FqreEYvs1zSbBKLgU5+DIWV0dg
         flZFrUyHqcvXXk5FjQQCPi3k0FHDHlOFaZXMS94E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, DENG Qingfang <dqfext@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 19/72] net: ag71xx: remove unnecessary MTU reservation
Date:   Fri,  5 Mar 2021 13:21:21 +0100
Message-Id: <20210305120858.282010478@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120857.341630346@linuxfoundation.org>
References: <20210305120857.341630346@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: DENG Qingfang <dqfext@gmail.com>

commit 04b385f325080157ab1b5f8ce1b1de07ce0d9e27 upstream.

2 bytes of the MTU are reserved for Atheros DSA tag, but DSA core
has already handled that since commit dc0fe7d47f9f.
Remove the unnecessary reservation.

Fixes: d51b6ce441d3 ("net: ethernet: add ag71xx driver")
Signed-off-by: DENG Qingfang <dqfext@gmail.com>
Reviewed-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://lore.kernel.org/r/20210218034514.3421-1-dqfext@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/atheros/ag71xx.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -222,8 +222,6 @@
 #define AG71XX_REG_RX_SM	0x01b0
 #define AG71XX_REG_TX_SM	0x01b4
 
-#define ETH_SWITCH_HEADER_LEN	2
-
 #define AG71XX_DEFAULT_MSG_ENABLE	\
 	(NETIF_MSG_DRV			\
 	| NETIF_MSG_PROBE		\
@@ -784,7 +782,7 @@ static void ag71xx_hw_setup(struct ag71x
 
 static unsigned int ag71xx_max_frame_len(unsigned int mtu)
 {
-	return ETH_SWITCH_HEADER_LEN + ETH_HLEN + VLAN_HLEN + mtu + ETH_FCS_LEN;
+	return ETH_HLEN + VLAN_HLEN + mtu + ETH_FCS_LEN;
 }
 
 static void ag71xx_hw_set_macaddr(struct ag71xx *ag, unsigned char *mac)


