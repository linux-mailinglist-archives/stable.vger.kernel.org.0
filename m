Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F29E43A14E
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236272AbhJYTiF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:38:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:53296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236731AbhJYTfK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:35:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CAD360187;
        Mon, 25 Oct 2021 19:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190352;
        bh=VhoqVqrypmSilAfw2EPZyvSElbx91urHiTg5R+ZkaUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FdD+38MT/kdGdK2kJYhdxQaI4UCyyAcs1O3pinGFZbO+6yQHc7oekjNrzfE/+hzGQ
         yerH42HYk5c+yOMaf4cjaSmUuUHSALt8Fy9oAz/Z8S/eEQ3GG/+HnU2Q6YIqNSLDDt
         C+mMU3Aq9qPIqlZaol/gMutBgM55vYw3bmGIXeF4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, DENG Qingfang <dqfext@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 54/95] net: dsa: mt7530: correct ds->num_ports
Date:   Mon, 25 Oct 2021 21:14:51 +0200
Message-Id: <20211025191004.554973539@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190956.374447057@linuxfoundation.org>
References: <20211025190956.374447057@linuxfoundation.org>
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
@@ -981,9 +981,6 @@ mt7530_port_enable(struct dsa_switch *ds
 {
 	struct mt7530_priv *priv = ds->priv;
 
-	if (!dsa_is_user_port(ds, port))
-		return 0;
-
 	mutex_lock(&priv->reg_mutex);
 
 	/* Allow the user port gets connected to the cpu port and also
@@ -1006,9 +1003,6 @@ mt7530_port_disable(struct dsa_switch *d
 {
 	struct mt7530_priv *priv = ds->priv;
 
-	if (!dsa_is_user_port(ds, port))
-		return;
-
 	mutex_lock(&priv->reg_mutex);
 
 	/* Clear up all port matrix which could be restored in the next
@@ -2593,7 +2587,7 @@ mt7530_probe(struct mdio_device *mdiodev
 		return -ENOMEM;
 
 	priv->ds->dev = &mdiodev->dev;
-	priv->ds->num_ports = DSA_MAX_PORTS;
+	priv->ds->num_ports = MT7530_NUM_PORTS;
 
 	/* Use medatek,mcm property to distinguish hardware type that would
 	 * casues a little bit differences on power-on sequence.


