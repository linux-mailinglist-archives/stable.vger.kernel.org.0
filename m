Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48B61395EAE
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232870AbhEaOB6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:01:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:60392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232421AbhEaN7z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:59:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBC8061402;
        Mon, 31 May 2021 13:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468176;
        bh=Ill1eplk4IdYv6idJ17y/9StCsRZ9eo1Srla6Dpkocc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tp4OPbUqRn65BHg2FJanln4P0Q9HWr8z9EU2EObBgtdwiMB0rNyNXgWFuLJ127UjE
         v2aFPNB29F/7XVBm69l/TGn6wDYrZ+2hzMX0QnwOj/2rYWomB5XuZzi2RrEzzu0kET
         A8MhdI5eZoCKnOHjP8E/aXrSDR5Kq4f7O6ZuetxM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 117/252] net: dsa: sja1105: add error handling in sja1105_setup()
Date:   Mon, 31 May 2021 15:13:02 +0200
Message-Id: <20210531130701.963639794@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
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
@@ -2922,13 +2922,13 @@ static int sja1105_setup(struct dsa_swit
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
@@ -2949,7 +2949,7 @@ static int sja1105_setup(struct dsa_swit
 
 	rc = sja1105_devlink_setup(ds);
 	if (rc < 0)
-		return rc;
+		goto out_static_config_free;
 
 	/* The DSA/switchdev model brings up switch ports in standalone mode by
 	 * default, and that means vlan_filtering is 0 since they're not under
@@ -2958,6 +2958,17 @@ static int sja1105_setup(struct dsa_swit
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


