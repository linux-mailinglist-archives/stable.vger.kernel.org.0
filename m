Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B36A4F27F4
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233461AbiDEIJv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236305AbiDEICB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:02:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 007DF49FB3;
        Tue,  5 Apr 2022 01:00:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6E44B81B16;
        Tue,  5 Apr 2022 08:00:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C252C340EE;
        Tue,  5 Apr 2022 07:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145600;
        bh=HikB6oo11ig/HGvG2zs9U0P7DdkEpyLT2pAiS7VnFAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oIy1bTWWLi4NKbbNjZIZUtNAy0tT9je4qsUAEaCBNBKDXoRwFf/fpbeF232JA+er2
         7koDUeBMwG4ksTBzU6xnhjg5DHMskvhWGEmhWIQMQUtIiiFban2BtIsEQEFRD9dwBL
         HO0m2ie1do3U76bjuBfcqe72qNRet+199XzVj6c8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0461/1126] net: dsa: Move VLAN filtering syncing out of dsa_switch_bridge_leave
Date:   Tue,  5 Apr 2022 09:20:08 +0200
Message-Id: <20220405070421.157405865@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tobias Waldekranz <tobias@waldekranz.com>

[ Upstream commit 381a730182f1d174e1950cd4e63e885b1c302051 ]

Most of dsa_switch_bridge_leave was, in fact, dealing with the syncing
of VLAN filtering for switches on which that is a global
setting. Separate the two phases to prepare for the cross-chip related
bugfix in the following commit.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/switch.c | 38 +++++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index e3c7d2627a61..9f9b70d6070a 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -113,26 +113,15 @@ static int dsa_switch_bridge_join(struct dsa_switch *ds,
 	return dsa_tag_8021q_bridge_join(ds, info);
 }
 
-static int dsa_switch_bridge_leave(struct dsa_switch *ds,
-				   struct dsa_notifier_bridge_info *info)
+static int dsa_switch_sync_vlan_filtering(struct dsa_switch *ds,
+					  struct dsa_notifier_bridge_info *info)
 {
-	struct dsa_switch_tree *dst = ds->dst;
 	struct netlink_ext_ack extack = {0};
 	bool change_vlan_filtering = false;
 	bool vlan_filtering;
 	struct dsa_port *dp;
 	int err;
 
-	if (dst->index == info->tree_index && ds->index == info->sw_index &&
-	    ds->ops->port_bridge_leave)
-		ds->ops->port_bridge_leave(ds, info->port, info->bridge);
-
-	if ((dst->index != info->tree_index || ds->index != info->sw_index) &&
-	    ds->ops->crosschip_bridge_leave)
-		ds->ops->crosschip_bridge_leave(ds, info->tree_index,
-						info->sw_index, info->port,
-						info->bridge);
-
 	if (ds->needs_standalone_vlan_filtering &&
 	    !br_vlan_enabled(info->bridge.dev)) {
 		change_vlan_filtering = true;
@@ -172,6 +161,29 @@ static int dsa_switch_bridge_leave(struct dsa_switch *ds,
 			return err;
 	}
 
+	return 0;
+}
+
+static int dsa_switch_bridge_leave(struct dsa_switch *ds,
+				   struct dsa_notifier_bridge_info *info)
+{
+	struct dsa_switch_tree *dst = ds->dst;
+	int err;
+
+	if (dst->index == info->tree_index && ds->index == info->sw_index &&
+	    ds->ops->port_bridge_leave)
+		ds->ops->port_bridge_leave(ds, info->port, info->bridge);
+
+	if ((dst->index != info->tree_index || ds->index != info->sw_index) &&
+	    ds->ops->crosschip_bridge_leave)
+		ds->ops->crosschip_bridge_leave(ds, info->tree_index,
+						info->sw_index, info->port,
+						info->bridge);
+
+	err = dsa_switch_sync_vlan_filtering(ds, info);
+	if (err)
+		return err;
+
 	return dsa_tag_8021q_bridge_leave(ds, info);
 }
 
-- 
2.34.1



