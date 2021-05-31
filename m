Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12A4B3961D4
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233363AbhEaOrL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:47:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:40312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234227AbhEaOpJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:45:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25FEE61C84;
        Mon, 31 May 2021 13:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469302;
        bh=U7ubMBqioOt7j6nprRGfQT/T68oUMEcDQugGFGj0zs0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BUvLyviiAyROsAR7tkIt0b9WVyiJbzIf9hgikaVt9ZdJZHUOpxfUoQqN5FWCPQuOL
         3DHr8ibRVPsrEDJNdU0N90ZqnobwmdNvnaROLDKpfk+GjEjtMBAMUl6YPdY6GnORGV
         qdL4bk4lDumtrr6WHbEhZgj5Hk/3ctBKKy8zgET8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.12 147/296] net: dsa: sja1105: call dsa_unregister_switch when allocating memory fails
Date:   Mon, 31 May 2021 15:13:22 +0200
Message-Id: <20210531130708.811823022@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

commit dc596e3fe63f88e3d1e509f64e7f761cd4135538 upstream.

Unlike other drivers which pretty much end their .probe() execution with
dsa_register_switch(), the sja1105 does some extra stuff. When that
fails with -ENOMEM, the driver is quick to return that, forgetting to
call dsa_unregister_switch(). Not critical, but a bug nonetheless.

Fixes: 4d7525085a9b ("net: dsa: sja1105: offload the Credit-Based Shaper qdisc")
Fixes: a68578c20a96 ("net: dsa: Make deferred_xmit private to sja1105")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/sja1105/sja1105_main.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -3683,8 +3683,10 @@ static int sja1105_probe(struct spi_devi
 		priv->cbs = devm_kcalloc(dev, priv->info->num_cbs_shapers,
 					 sizeof(struct sja1105_cbs_entry),
 					 GFP_KERNEL);
-		if (!priv->cbs)
-			return -ENOMEM;
+		if (!priv->cbs) {
+			rc = -ENOMEM;
+			goto out_unregister_switch;
+		}
 	}
 
 	/* Connections between dsa_port and sja1105_port */
@@ -3709,7 +3711,7 @@ static int sja1105_probe(struct spi_devi
 			dev_err(ds->dev,
 				"failed to create deferred xmit thread: %d\n",
 				rc);
-			goto out;
+			goto out_destroy_workers;
 		}
 		skb_queue_head_init(&sp->xmit_queue);
 		sp->xmit_tpid = ETH_P_SJA1105;
@@ -3719,7 +3721,8 @@ static int sja1105_probe(struct spi_devi
 	}
 
 	return 0;
-out:
+
+out_destroy_workers:
 	while (port-- > 0) {
 		struct sja1105_port *sp = &priv->ports[port];
 
@@ -3728,6 +3731,10 @@ out:
 
 		kthread_destroy_worker(sp->xmit_worker);
 	}
+
+out_unregister_switch:
+	dsa_unregister_switch(ds);
+
 	return rc;
 }
 


