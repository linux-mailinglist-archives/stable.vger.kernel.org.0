Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6D93961D5
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233232AbhEaOrL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:47:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:40310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234224AbhEaOpI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:45:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B83661C81;
        Mon, 31 May 2021 13:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469300;
        bh=GC20++aDWXWjAwVWjhff/cyE8r7hxikoUf77SG5cBCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sgRAaE0npCQxlTvZfVZU6xBtCKqaqM10HRKmgQx+NC0QJYsj6gIimC+Gcq1EtmaVj
         hRLXVC5O+E9rjmv5JSLlwEu4v816c5DgMcCS6v4FgQrvLsX4XpXJE8glp1RGbyt6d3
         +EdmbLk4eYobIdPurzcgNt4ihwVnc5CGPy4IxbOY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.12 146/296] net: dsa: sja1105: add error handling in sja1105_setup()
Date:   Mon, 31 May 2021 15:13:21 +0200
Message-Id: <20210531130708.772941823@linuxfoundation.org>
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

commit cec279a898a3b004411682f212215ccaea1cd0fb upstream.

If any of sja1105_static_config_load(), sja1105_clocking_setup() or
sja1105_devlink_setup() fails, we can't just return in the middle of
sja1105_setup() or memory will leak. Add a cleanup path.

Fixes: 0a7bdbc23d8a ("net: dsa: sja1105: move devlink param code to sja1105_devlink.c")
Fixes: 8aa9ebccae87 ("net: dsa: Introduce driver for NXP SJA1105 5-port L2 switch")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/sja1105/sja1105_main.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2986,13 +2986,13 @@ static int sja1105_setup(struct dsa_swit
 	rc = sja1105_static_config_load(priv, ports);
 	if (rc < 0) {
 		dev_err(ds->dev, "Failed to load static config: %d\n", rc);
-		return rc;
+		goto out_ptp_clock_unregister;
 	}
 	/* Configure the CGU (PHY link modes and speeds) */
 	rc = sja1105_clocking_setup(priv);
 	if (rc < 0) {
 		dev_err(ds->dev, "Failed to configure MII clocking: %d\n", rc);
-		return rc;
+		goto out_static_config_free;
 	}
 	/* On SJA1105, VLAN filtering per se is always enabled in hardware.
 	 * The only thing we can do to disable it is lie about what the 802.1Q
@@ -3013,7 +3013,7 @@ static int sja1105_setup(struct dsa_swit
 
 	rc = sja1105_devlink_setup(ds);
 	if (rc < 0)
-		return rc;
+		goto out_static_config_free;
 
 	/* The DSA/switchdev model brings up switch ports in standalone mode by
 	 * default, and that means vlan_filtering is 0 since they're not under
@@ -3022,6 +3022,17 @@ static int sja1105_setup(struct dsa_swit
 	rtnl_lock();
 	rc = sja1105_setup_8021q_tagging(ds, true);
 	rtnl_unlock();
+	if (rc)
+		goto out_devlink_teardown;
+
+	return 0;
+
+out_devlink_teardown:
+	sja1105_devlink_teardown(ds);
+out_ptp_clock_unregister:
+	sja1105_ptp_clock_unregister(ds);
+out_static_config_free:
+	sja1105_static_config_free(&priv->static_config);
 
 	return rc;
 }


