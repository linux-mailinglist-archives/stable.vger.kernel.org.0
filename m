Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C93F04F27D8
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233606AbiDEIJS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236351AbiDEICG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:02:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85FB149FB3;
        Tue,  5 Apr 2022 01:00:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48B4AB81B18;
        Tue,  5 Apr 2022 08:00:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5861C34111;
        Tue,  5 Apr 2022 08:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145606;
        bh=NW9L56q7ySvb2Jz96h+/0TUHuIwTaKUNVVBYloTIWEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yOhnAuUDfYgny3q0znB1cxrKZmz1rLYWTIMfLrkklOyAY5omRrg0A639yY/b9WMu3
         zeyjLuDFnhhSMHih0XnVudxBepmHgYtQPpG/kJRW00jAQxzs6PqF/HMafLQshmik9n
         bktqqi2urNC5+MqxoRdrzS6NkYZiV0+FzdOKFU1c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0462/1126] net: dsa: Avoid cross-chip syncing of VLAN filtering
Date:   Tue,  5 Apr 2022 09:20:09 +0200
Message-Id: <20220405070421.187137582@linuxfoundation.org>
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

[ Upstream commit 108dc8741c203e9d6ce4e973367f1bac20c7192b ]

Changes to VLAN filtering are not applicable to cross-chip
notifications.

On a system like this:

.-----.   .-----.   .-----.
| sw1 +---+ sw2 +---+ sw3 |
'-1-2-'   '-1-2-'   '-1-2-'

Before this change, upon sw1p1 leaving a bridge, a call to
dsa_port_vlan_filtering would also be made to sw2p1 and sw3p1.

In this scenario:

.---------.   .-----.   .-----.
|   sw1   +---+ sw2 +---+ sw3 |
'-1-2-3-4-'   '-1-2-'   '-1-2-'

When sw1p4 would leave a bridge, dsa_port_vlan_filtering would be
called for sw2 and sw3 with a non-existing port - leading to array
out-of-bounds accesses and crashes on mv88e6xxx.

Fixes: d371b7c92d19 ("net: dsa: Unset vlan_filtering when ports leave the bridge")
Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/switch.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 9f9b70d6070a..517cc83d13cc 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -180,9 +180,11 @@ static int dsa_switch_bridge_leave(struct dsa_switch *ds,
 						info->sw_index, info->port,
 						info->bridge);
 
-	err = dsa_switch_sync_vlan_filtering(ds, info);
-	if (err)
-		return err;
+	if (ds->dst->index == info->tree_index && ds->index == info->sw_index) {
+		err = dsa_switch_sync_vlan_filtering(ds, info);
+		if (err)
+			return err;
+	}
 
 	return dsa_tag_8021q_bridge_leave(ds, info);
 }
-- 
2.34.1



