Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9FA358306C
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242615AbiG0Rhw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:37:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242529AbiG0Rha (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:37:30 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E18B245042;
        Wed, 27 Jul 2022 09:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 49A94CE2309;
        Wed, 27 Jul 2022 16:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54E90C433D6;
        Wed, 27 Jul 2022 16:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940614;
        bh=+8SJxx9RJkr5LTCCI4UBjOurlm0KCiWs5ONe1w8diZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uH4d9B9eg429FSpp8IddUCmqwyKO5uq9ZDvQu7Ec2uYTr1BZVs48F2sd4BD5NEJya
         Fas1SA7ByhgOHzieYhbNquOMmwxLpsEouYJLd/Z85kkQ37M7+uT4HbjNvQclIa4jdU
         5E9dr4ldkmvTjIHvJDacbnzWivlFlS3Kbb/jmxZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 086/158] net: lan966x: Fix usage of lan966x->mac_lock when entry is removed
Date:   Wed, 27 Jul 2022 18:12:30 +0200
Message-Id: <20220727161024.927677733@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Horatiu Vultur <horatiu.vultur@microchip.com>

[ Upstream commit 99343cfa4f7560abf933fff7ab3ea58a6905c917 ]

To remove an entry to the MAC table, it is required first to setup the
entry and then issue a command for the MAC to forget the entry.
So if it happens for two threads to remove simultaneously an entry
in MAC table then it would be a race condition.
Fix this by using lan966x->mac_lock to protect the HW access.

Fixes: e18aba8941b40 ("net: lan966x: add mactable support")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/microchip/lan966x/lan966x_mac.c  | 24 +++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
index 4f8fd5cde950..d0b8eba0a66d 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
@@ -119,11 +119,13 @@ int lan966x_mac_learn(struct lan966x *lan966x, int port,
 	return __lan966x_mac_learn(lan966x, port, false, mac, vid, type);
 }
 
-int lan966x_mac_forget(struct lan966x *lan966x,
-		       const unsigned char mac[ETH_ALEN],
-		       unsigned int vid,
-		       enum macaccess_entry_type type)
+static int lan966x_mac_forget_locked(struct lan966x *lan966x,
+				     const unsigned char mac[ETH_ALEN],
+				     unsigned int vid,
+				     enum macaccess_entry_type type)
 {
+	lockdep_assert_held(&lan966x->mac_lock);
+
 	lan966x_mac_select(lan966x, mac, vid);
 
 	/* Issue a forget command */
@@ -134,6 +136,20 @@ int lan966x_mac_forget(struct lan966x *lan966x,
 	return lan966x_mac_wait_for_completion(lan966x);
 }
 
+int lan966x_mac_forget(struct lan966x *lan966x,
+		       const unsigned char mac[ETH_ALEN],
+		       unsigned int vid,
+		       enum macaccess_entry_type type)
+{
+	int ret;
+
+	spin_lock(&lan966x->mac_lock);
+	ret = lan966x_mac_forget_locked(lan966x, mac, vid, type);
+	spin_unlock(&lan966x->mac_lock);
+
+	return ret;
+}
+
 int lan966x_mac_cpu_learn(struct lan966x *lan966x, const char *addr, u16 vid)
 {
 	return lan966x_mac_learn(lan966x, PGID_CPU, addr, vid, ENTRYTYPE_LOCKED);
-- 
2.35.1



