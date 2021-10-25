Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7E1443A2AC
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238667AbhJYTvA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:51:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:38050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238484AbhJYTs7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:48:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A06C66121E;
        Mon, 25 Oct 2021 19:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190874;
        bh=7dGhASNRKxMtyoG0S7uiTFoPBDnI7rhtYzOpM2p0oP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aJr1ZZQdsZ5j++APVaPfgqwJVajDIv1DMZkVZGV2mV69tTP3Zl9JVjru8I5XfTB+U
         jBfjVe8riPBaxz7Y2O6PZfsKbYY+tA0FgaeA3+1lNgQBgd2itIcnyvhelVVJadTV6l
         KcAVZB9GkQturMVO9O4zyJ3ssTRBQimmZRKB9Aj0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, DENG Qingfang <dqfext@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.14 092/169] net: dsa: mt7530: correct ds->num_ports
Date:   Mon, 25 Oct 2021 21:14:33 +0200
Message-Id: <20211025191028.978360803@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: DENG Qingfang <dqfext@gmail.com>

commit 342afce10d6f61c443c95e244f812d4766f73f53 upstream.

Setting ds->num_ports to DSA_MAX_PORTS made DSA core allocate unnecessary
dsa_port's and call mt7530_port_disable for non-existent ports.

Set it to MT7530_NUM_PORTS to fix that, and dsa_is_user_port check in
port_enable/disable is no longer required.

Cc: stable@vger.kernel.org
Signed-off-by: DENG Qingfang <dqfext@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/mt7530.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1031,9 +1031,6 @@ mt7530_port_enable(struct dsa_switch *ds
 {
 	struct mt7530_priv *priv = ds->priv;
 
-	if (!dsa_is_user_port(ds, port))
-		return 0;
-
 	mutex_lock(&priv->reg_mutex);
 
 	/* Allow the user port gets connected to the cpu port and also
@@ -1056,9 +1053,6 @@ mt7530_port_disable(struct dsa_switch *d
 {
 	struct mt7530_priv *priv = ds->priv;
 
-	if (!dsa_is_user_port(ds, port))
-		return;
-
 	mutex_lock(&priv->reg_mutex);
 
 	/* Clear up all port matrix which could be restored in the next
@@ -3132,7 +3126,7 @@ mt7530_probe(struct mdio_device *mdiodev
 		return -ENOMEM;
 
 	priv->ds->dev = &mdiodev->dev;
-	priv->ds->num_ports = DSA_MAX_PORTS;
+	priv->ds->num_ports = MT7530_NUM_PORTS;
 
 	/* Use medatek,mcm property to distinguish hardware type that would
 	 * casues a little bit differences on power-on sequence.


