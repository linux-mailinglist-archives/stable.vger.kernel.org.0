Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DBC066CA27
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbjAPRAU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:00:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232143AbjAPQ7i (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:59:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 019EB2ED69
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:42:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D41BB8105D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:42:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 059C5C433D2;
        Mon, 16 Jan 2023 16:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887342;
        bh=LJs8LQQduOOsZdQL/NNKOGZqKepKg7XFudip+AiDgdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QgbggMJsS66COZcVh7HwrxThScZrUTU9DL/hnddcAjeTBMpPASMVUkIZ/BHABrBkE
         kEVz0chi4fp1FA2cl+LQNVRRiaJkNS7f7UbUenDats0eeTFs2877VukWMSKZFQSPqB
         2lRckaWcmOeVqSDsprY8w6T/ixov5JZsZ5/w6xpA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Maor Gottlieb <maorg@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 113/521] bonding: Export skip slave logic to function
Date:   Mon, 16 Jan 2023 16:46:15 +0100
Message-Id: <20230116154852.295755980@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Gottlieb <maorg@mellanox.com>

[ Upstream commit 119d48fd4298594beccf4f2ecd00627826ce2646 ]

As a preparation for following change that add array of
all slaves, extract code that skip slave to function.

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 47 ++++++++++++++++++---------------
 1 file changed, 26 insertions(+), 21 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index cab5c1cc9fe9..85efa0e0ee2c 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3993,6 +3993,29 @@ static void bond_slave_arr_handler(struct work_struct *work)
 	bond_slave_arr_work_rearm(bond, 1);
 }
 
+static void bond_skip_slave(struct bond_up_slave *slaves,
+			    struct slave *skipslave)
+{
+	int idx;
+
+	/* Rare situation where caller has asked to skip a specific
+	 * slave but allocation failed (most likely!). BTW this is
+	 * only possible when the call is initiated from
+	 * __bond_release_one(). In this situation; overwrite the
+	 * skipslave entry in the array with the last entry from the
+	 * array to avoid a situation where the xmit path may choose
+	 * this to-be-skipped slave to send a packet out.
+	 */
+	for (idx = 0; slaves && idx < slaves->count; idx++) {
+		if (skipslave == slaves->arr[idx]) {
+			slaves->arr[idx] =
+				slaves->arr[slaves->count - 1];
+			slaves->count--;
+			break;
+		}
+	}
+}
+
 /* Build the usable slaves array in control path for modes that use xmit-hash
  * to determine the slave interface -
  * (a) BOND_MODE_8023AD
@@ -4063,27 +4086,9 @@ int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
 	if (old_arr)
 		kfree_rcu(old_arr, rcu);
 out:
-	if (ret != 0 && skipslave) {
-		int idx;
-
-		/* Rare situation where caller has asked to skip a specific
-		 * slave but allocation failed (most likely!). BTW this is
-		 * only possible when the call is initiated from
-		 * __bond_release_one(). In this situation; overwrite the
-		 * skipslave entry in the array with the last entry from the
-		 * array to avoid a situation where the xmit path may choose
-		 * this to-be-skipped slave to send a packet out.
-		 */
-		old_arr = rtnl_dereference(bond->slave_arr);
-		for (idx = 0; old_arr != NULL && idx < old_arr->count; idx++) {
-			if (skipslave == old_arr->arr[idx]) {
-				old_arr->arr[idx] =
-				    old_arr->arr[old_arr->count-1];
-				old_arr->count--;
-				break;
-			}
-		}
-	}
+	if (ret != 0 && skipslave)
+		bond_skip_slave(rtnl_dereference(bond->slave_arr), skipslave);
+
 	return ret;
 }
 
-- 
2.35.1



