Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 160993D2A31
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234203AbhGVQKA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:10:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:48486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234432AbhGVQHb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:07:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5843161DC9;
        Thu, 22 Jul 2021 16:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972486;
        bh=dz7n49lrC5kMGsQDt5xeNZ5QswGlpYf8AS2xbNZf7IY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=meR2coOGA0uza0oqMwM5u4xzlE/MchKODosvWNx2CZiPK3Yui56plmBfsPD0J3DdM
         yIJaweVo2ppWwb1srXP/RynndiSYyK8INO+zNFSf93WLPNcp4Z9K1JN5jwZJGXvQRl
         L6Isq+UPMvQ169u/zAA1JCzm82NDVUFMiY1aW5zw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.13 132/156] net: dsa: properly check for the bridge_leave methods in dsa_switch_bridge_leave()
Date:   Thu, 22 Jul 2021 18:31:47 +0200
Message-Id: <20210722155632.622802116@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

commit bcb9928a155444dbd212473e60241ca0a7f641e1 upstream.

This was not caught because there is no switch driver which implements
the .port_bridge_join but not .port_bridge_leave method, but it should
nonetheless be fixed, as in certain conditions (driver development) it
might lead to NULL pointer dereference.

Fixes: f66a6a69f97a ("net: dsa: permit cross-chip bridging between all trees in the system")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/dsa/switch.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -110,11 +110,11 @@ static int dsa_switch_bridge_leave(struc
 	int err, port;
 
 	if (dst->index == info->tree_index && ds->index == info->sw_index &&
-	    ds->ops->port_bridge_join)
+	    ds->ops->port_bridge_leave)
 		ds->ops->port_bridge_leave(ds, info->port, info->br);
 
 	if ((dst->index != info->tree_index || ds->index != info->sw_index) &&
-	    ds->ops->crosschip_bridge_join)
+	    ds->ops->crosschip_bridge_leave)
 		ds->ops->crosschip_bridge_leave(ds, info->tree_index,
 						info->sw_index, info->port,
 						info->br);


