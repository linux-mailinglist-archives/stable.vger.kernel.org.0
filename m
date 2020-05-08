Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E67D41CAF8F
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728437AbgEHMmB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:42:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:38150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728891AbgEHMmA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:42:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C24612495F;
        Fri,  8 May 2020 12:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941720;
        bh=6ZewsSQYo0fGzFE3Jzdt3enRRF+oaoEwW1D8vl8nJW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r0w1lHV6KjtgdYU30DiJV2jeKn6e1jT5+MdIxylFrsL95iGgjM4YcpFizDyRSkrrT
         Zxwl34ERUG2tQ8fWaG/YEZiIkw7hHQymXmWloPRphp4PvCMkRXgx4IgoDX/0s5zi+H
         IhW8rXrqgptnc/W6Z5pDVOlztAE3H0LtVV6p9s5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@mellanox.com>,
        Nogah Frankel <nogahf@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 107/312] mlxsw: spectrum: Dont count internal TX header bytes to stats
Date:   Fri,  8 May 2020 14:31:38 +0200
Message-Id: <20200508123132.022490855@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nogah Frankel <nogahf@mellanox.com>

commit 63dcdd35c1552ca0c911e98ba3389a0729a457f4 upstream.

Stop the SW TX counter from counting the TX header bytes
since they are not being sent out.

Fixes: 56ade8fe3fe1 ("mlxsw: spectrum: Add initial support for Spectrum ASIC")
Reviewed-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: Nogah Frankel <nogahf@mellanox.com>
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -399,7 +399,11 @@ static netdev_tx_t mlxsw_sp_port_xmit(st
 	}
 
 	mlxsw_sp_txhdr_construct(skb, &tx_info);
-	len = skb->len;
+	/* TX header is consumed by HW on the way so we shouldn't count its
+	 * bytes as being sent.
+	 */
+	len = skb->len - MLXSW_TXHDR_LEN;
+
 	/* Due to a race we might fail here because of a full queue. In that
 	 * unlikely case we simply drop the packet.
 	 */


