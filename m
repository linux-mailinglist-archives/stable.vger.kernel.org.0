Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22CDC528FFD
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236718AbiEPUIb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:08:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350180AbiEPUAx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 16:00:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45DE246678;
        Mon, 16 May 2022 12:55:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EADAB60EC5;
        Mon, 16 May 2022 19:54:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC574C385AA;
        Mon, 16 May 2022 19:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730878;
        bh=JmpcYXscK83DlcoDFesJzDB+yzA4kDzMTLDl4wun3Rw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ohrXyAK7I4o6WtzKd0DDtboiP6yCVe5OXfj2RyxPcpYTpddGF3aCrvWbprLgMAVL0
         7GiMDcvyojUj66Ep+2Xze0rmfgYayjXUosGyRXymEwc3LXhWrbaG2CGRV9T7D6vCZJ
         tRNSKRDP2ugHkmq0xTsxCn7LwtHebkrSbLshVXoo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 032/114] net: dsa: flush switchdev workqueue on bridge join error path
Date:   Mon, 16 May 2022 21:36:06 +0200
Message-Id: <20220516193626.413082272@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
References: <20220516193625.489108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 630fd4822af2374cd75c682b7665dcb367613765 ]

There is a race between switchdev_bridge_port_offload() and the
dsa_port_switchdev_sync_attrs() call right below it.

When switchdev_bridge_port_offload() finishes, FDB entries have been
replayed by the bridge, but are scheduled for deferred execution later.

However dsa_port_switchdev_sync_attrs -> dsa_port_can_apply_vlan_filtering()
may impose restrictions on the vlan_filtering attribute and refuse
offloading.

When this happens, the delayed FDB entries will dereference dp->bridge,
which is a NULL pointer because we have stopped the process of
offloading this bridge.

Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
Workqueue: dsa_ordered dsa_slave_switchdev_event_work
pc : dsa_port_bridge_host_fdb_del+0x64/0x100
lr : dsa_slave_switchdev_event_work+0x130/0x1bc
Call trace:
 dsa_port_bridge_host_fdb_del+0x64/0x100
 dsa_slave_switchdev_event_work+0x130/0x1bc
 process_one_work+0x294/0x670
 worker_thread+0x80/0x460
---[ end trace 0000000000000000 ]---
Error: dsa_core: Must first remove VLAN uppers having VIDs also present in bridge.

Fix the bug by doing what we do on the normal bridge leave path as well,
which is to wait until the deferred FDB entries complete executing, then
exit.

The placement of dsa_flush_workqueue() after switchdev_bridge_port_unoffload()
guarantees that both the FDB additions and deletions on rollback are waited for.

Fixes: d7d0d423dbaa ("net: dsa: flush switchdev workqueue when leaving the bridge")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/20220507134550.1849834-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/port.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index 4368fd32c4a5..f4bd063f8315 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -367,6 +367,7 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 	switchdev_bridge_port_unoffload(brport_dev, dp,
 					&dsa_slave_switchdev_notifier,
 					&dsa_slave_switchdev_blocking_notifier);
+	dsa_flush_workqueue();
 out_rollback_unbridge:
 	dsa_broadcast(DSA_NOTIFIER_BRIDGE_LEAVE, &info);
 out_rollback:
-- 
2.35.1



