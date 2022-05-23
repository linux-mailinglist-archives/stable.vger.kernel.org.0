Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D21B5316FA
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240514AbiEWRSP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:18:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240818AbiEWRQn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:16:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2133062CF3;
        Mon, 23 May 2022 10:16:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 375ABB81201;
        Mon, 23 May 2022 17:13:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BD01C36AE7;
        Mon, 23 May 2022 17:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653325986;
        bh=4EXUEMeTAeXLlshx1uphD/BXa5br98ezO+Wp1Q0cG0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xq0sK5RVxnQ6WMyeBsg5GguITDQmcOCb7/WiK9tFjzOwU4izhpaxJdeZngMI6iqbx
         NTi1gMCD2JvgGT4YHv64zdw082w+H0MhrONsqpjAlz4aquQQhZrV9A78T/e1LwuVHs
         9lO5mYzkTD2u9Od56Tqkqy9GkQiBylUuwWWGunuQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Ido Schimmel <idosch@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 33/44] net: bridge: Clear offload_fwd_mark when passing frame up bridge interface.
Date:   Mon, 23 May 2022 19:05:17 +0200
Message-Id: <20220523165759.209845783@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165752.797318097@linuxfoundation.org>
References: <20220523165752.797318097@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

[ Upstream commit fbb3abdf2223cd0dfc07de85fe5a43ba7f435bdf ]

It is possible to stack bridges on top of each other. Consider the
following which makes use of an Ethernet switch:

       br1
     /    \
    /      \
   /        \
 br0.11    wlan0
   |
   br0
 /  |  \
p1  p2  p3

br0 is offloaded to the switch. Above br0 is a vlan interface, for
vlan 11. This vlan interface is then a slave of br1. br1 also has a
wireless interface as a slave. This setup trunks wireless lan traffic
over the copper network inside a VLAN.

A frame received on p1 which is passed up to the bridge has the
skb->offload_fwd_mark flag set to true, indicating that the switch has
dealt with forwarding the frame out ports p2 and p3 as needed. This
flag instructs the software bridge it does not need to pass the frame
back down again. However, the flag is not getting reset when the frame
is passed upwards. As a result br1 sees the flag, wrongly interprets
it, and fails to forward the frame to wlan0.

When passing a frame upwards, clear the flag. This is the Rx
equivalent of br_switchdev_frame_unmark() in br_dev_xmit().

Fixes: f1c2eddf4cb6 ("bridge: switchdev: Use an helper to clear forward mark")
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://lore.kernel.org/r/20220518005840.771575-1-andrew@lunn.ch
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_input.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 2532c1a19645..14c2fdc268ea 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -47,6 +47,13 @@ static int br_pass_frame_up(struct sk_buff *skb)
 	u64_stats_update_end(&brstats->syncp);
 
 	vg = br_vlan_group_rcu(br);
+
+	/* Reset the offload_fwd_mark because there could be a stacked
+	 * bridge above, and it should not think this bridge it doing
+	 * that bridge's work forwarding out its ports.
+	 */
+	br_switchdev_frame_unmark(skb);
+
 	/* Bridge is just like any other port.  Make sure the
 	 * packet is allowed except in promisc modue when someone
 	 * may be running packet capture.
-- 
2.35.1



