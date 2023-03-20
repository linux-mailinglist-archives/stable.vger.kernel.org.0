Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE1BE6C184E
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:23:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232739AbjCTPXW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:23:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232724AbjCTPWy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:22:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6FDFA5CF
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:16:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB603B80EE1
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:16:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D7DC433EF;
        Mon, 20 Mar 2023 15:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325380;
        bh=XNO6FNRo6VpeSNRFLv1P8DqjJQ6kZcfjL15csuKJjwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ui/mcQjF5gQpIh8h69oGkvcRbxl1E5EUzg/K8kakntxZPFrOGp6dKYjS+la4dAKrv
         yymnaVFBnyzbpLQ0r3cOhzv4X/jznCnDpUfuICQUpMzLo+uMgRSl4KHRymgnqj8NDN
         dNCtCWlgT8hy+Soy9ZCRj6PQdXviUI4hhwErXxO0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Simon Horman <simon.horman@corigine.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 078/198] net: dsa: dont error out when drivers return ETH_DATA_LEN in .port_max_mtu()
Date:   Mon, 20 Mar 2023 15:53:36 +0100
Message-Id: <20230320145510.800895802@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 636e8adf7878eab3614250234341bde45537f47a ]

Currently, when dsa_slave_change_mtu() is called on a user port where
dev->max_mtu is 1500 (as returned by ds->ops->port_max_mtu()), the code
will stumble upon this check:

	if (new_master_mtu > mtu_limit)
		return -ERANGE;

because new_master_mtu is adjusted for the tagger overhead but mtu_limit
is not.

But it would be good if the logic went through, for example if the DSA
master really depends on an MTU adjustment to accept DSA-tagged frames.

To make the code pass through the check, we need to adjust mtu_limit for
the overhead as well, if the minimum restriction was caused by the DSA
user port's MTU (dev->max_mtu). A DSA user port MTU and a DSA master MTU
are always offset by the protocol overhead.

Currently no drivers return 1500 .port_max_mtu(), but this is only
temporary and a bug in itself - mv88e6xxx should have done that, but
since commit b9c587fed61c ("dsa: mv88e6xxx: Include tagger overhead when
setting MTU for DSA and CPU ports") it no longer does. This is a
preparation for fixing that.

Fixes: bfcb813203e6 ("net: dsa: configure the MTU for switch ports")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/slave.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index a9fde48cffd43..5fe075bf479ec 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1852,6 +1852,7 @@ int dsa_slave_change_mtu(struct net_device *dev, int new_mtu)
 	int new_master_mtu;
 	int old_master_mtu;
 	int mtu_limit;
+	int overhead;
 	int cpu_mtu;
 	int err;
 
@@ -1880,9 +1881,10 @@ int dsa_slave_change_mtu(struct net_device *dev, int new_mtu)
 			largest_mtu = slave_mtu;
 	}
 
-	mtu_limit = min_t(int, master->max_mtu, dev->max_mtu);
+	overhead = dsa_tag_protocol_overhead(cpu_dp->tag_ops);
+	mtu_limit = min_t(int, master->max_mtu, dev->max_mtu + overhead);
 	old_master_mtu = master->mtu;
-	new_master_mtu = largest_mtu + dsa_tag_protocol_overhead(cpu_dp->tag_ops);
+	new_master_mtu = largest_mtu + overhead;
 	if (new_master_mtu > mtu_limit)
 		return -ERANGE;
 
@@ -1917,8 +1919,7 @@ int dsa_slave_change_mtu(struct net_device *dev, int new_mtu)
 
 out_port_failed:
 	if (new_master_mtu != old_master_mtu)
-		dsa_port_mtu_change(cpu_dp, old_master_mtu -
-				    dsa_tag_protocol_overhead(cpu_dp->tag_ops));
+		dsa_port_mtu_change(cpu_dp, old_master_mtu - overhead);
 out_cpu_failed:
 	if (new_master_mtu != old_master_mtu)
 		dev_set_mtu(master, old_master_mtu);
-- 
2.39.2



