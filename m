Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66BE01AC3CD
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2898755AbgDPNsv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:48:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:34696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2633435AbgDPNsn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:48:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 016872222D;
        Thu, 16 Apr 2020 13:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044921;
        bh=aBs0U7UDsdXOR98ZbF/DFAx8LAlxF0lzVvph7LALPJo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=htVR+alqBX/oiDa51QHy2MGYgI6iSrvRYa0hcnfdnkae+Sdm8moHmHbZhak6aEALk
         h7bcFZdU98bbCqERKxe1SNGXwskiSjQph2sAtBHmDurxuPGZo2UpqdGbrJfCro5b6F
         Z7pS+AHjn7o1kFjCFcPHfCXAOYnmHgLJXR8XLicE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Tranchetti <stranche@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Guenter Roeck <linux@roeck-us.net>,
        Alex Elder <elder@linaro.org>
Subject: [PATCH 5.4 156/232] net: qualcomm: rmnet: Allow configuration updates to existing devices
Date:   Thu, 16 Apr 2020 15:24:10 +0200
Message-Id: <20200416131334.525581286@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>

commit 2abb5792387eb188b12051337d5dcd2cba615cb0 upstream.

This allows the changelink operation to succeed if the mux_id was
specified as an argument. Note that the mux_id must match the
existing mux_id of the rmnet device or should be an unused mux_id.

Fixes: 1dc49e9d164c ("net: rmnet: do not allow to change mux id if mux id is duplicated")
Reported-and-tested-by: Alex Elder <elder@linaro.org>
Signed-off-by: Sean Tranchetti <stranche@codeaurora.org>
Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c |   31 ++++++++++++---------
 1 file changed, 19 insertions(+), 12 deletions(-)

--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
@@ -279,7 +279,6 @@ static int rmnet_changelink(struct net_d
 {
 	struct rmnet_priv *priv = netdev_priv(dev);
 	struct net_device *real_dev;
-	struct rmnet_endpoint *ep;
 	struct rmnet_port *port;
 	u16 mux_id;
 
@@ -294,19 +293,27 @@ static int rmnet_changelink(struct net_d
 
 	if (data[IFLA_RMNET_MUX_ID]) {
 		mux_id = nla_get_u16(data[IFLA_RMNET_MUX_ID]);
-		if (rmnet_get_endpoint(port, mux_id)) {
-			NL_SET_ERR_MSG_MOD(extack, "MUX ID already exists");
-			return -EINVAL;
-		}
-		ep = rmnet_get_endpoint(port, priv->mux_id);
-		if (!ep)
-			return -ENODEV;
 
-		hlist_del_init_rcu(&ep->hlnode);
-		hlist_add_head_rcu(&ep->hlnode, &port->muxed_ep[mux_id]);
+		if (mux_id != priv->mux_id) {
+			struct rmnet_endpoint *ep;
+
+			ep = rmnet_get_endpoint(port, priv->mux_id);
+			if (!ep)
+				return -ENODEV;
+
+			if (rmnet_get_endpoint(port, mux_id)) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "MUX ID already exists");
+				return -EINVAL;
+			}
+
+			hlist_del_init_rcu(&ep->hlnode);
+			hlist_add_head_rcu(&ep->hlnode,
+					   &port->muxed_ep[mux_id]);
 
-		ep->mux_id = mux_id;
-		priv->mux_id = mux_id;
+			ep->mux_id = mux_id;
+			priv->mux_id = mux_id;
+		}
 	}
 
 	if (data[IFLA_RMNET_FLAGS]) {


