Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB3C4CF926
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239884AbiCGKDp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:03:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240441AbiCGKBC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:01:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99A952DD;
        Mon,  7 Mar 2022 01:48:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32E536066C;
        Mon,  7 Mar 2022 09:48:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E6B4C340E9;
        Mon,  7 Mar 2022 09:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646489;
        bh=mgAMrKNurZEf0/kgPYTJkkqOiR24zy7cuzq1QRlKIL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HV7H0rOQ6pNzmGagQkTsgGdmNq6YghFDRuaGFINBk6C+v8YNDgOhlyC+uwSVnYeIT
         zPa2vawXh95rZgw20TnI+SvFH+M0N8lNSYNNjlJUCvEyiVtvxmgLmEQdFPeqklaufm
         aGZreZ4ctJRlhu0ID+dxQTN/FiSvoWVYHlkeT4DM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 219/262] ibmvnic: define flush_reset_queue helper
Date:   Mon,  7 Mar 2022 10:19:23 +0100
Message-Id: <20220307091709.204168248@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.ibm.com>

[ Upstream commit 83da53f7e4bd86dca4b2edc1e2bb324fb3c033a1 ]

Define and use a helper to flush the reset queue.

Fixes: 2770a7984db5 ("ibmvnic: Introduce hard reset recovery")
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index e98f7d3f935d..088c764fe3cd 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2557,12 +2557,23 @@ static void __ibmvnic_delayed_reset(struct work_struct *work)
 	__ibmvnic_reset(&adapter->ibmvnic_reset);
 }
 
+static void flush_reset_queue(struct ibmvnic_adapter *adapter)
+{
+	struct list_head *entry, *tmp_entry;
+
+	if (!list_empty(&adapter->rwi_list)) {
+		list_for_each_safe(entry, tmp_entry, &adapter->rwi_list) {
+			list_del(entry);
+			kfree(list_entry(entry, struct ibmvnic_rwi, list));
+		}
+	}
+}
+
 static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
 			 enum ibmvnic_reset_reason reason)
 {
-	struct list_head *entry, *tmp_entry;
-	struct ibmvnic_rwi *rwi, *tmp;
 	struct net_device *netdev = adapter->netdev;
+	struct ibmvnic_rwi *rwi, *tmp;
 	unsigned long flags;
 	int ret;
 
@@ -2605,12 +2616,9 @@ static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
 	/* if we just received a transport event,
 	 * flush reset queue and process this reset
 	 */
-	if (adapter->force_reset_recovery && !list_empty(&adapter->rwi_list)) {
-		list_for_each_safe(entry, tmp_entry, &adapter->rwi_list) {
-			list_del(entry);
-			kfree(list_entry(entry, struct ibmvnic_rwi, list));
-		}
-	}
+	if (adapter->force_reset_recovery)
+		flush_reset_queue(adapter);
+
 	rwi->reset_reason = reason;
 	list_add_tail(&rwi->list, &adapter->rwi_list);
 	netdev_dbg(adapter->netdev, "Scheduling reset (reason %s)\n",
-- 
2.34.1



