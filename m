Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11B284CF742
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237493AbiCGJpW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:45:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239094AbiCGJjM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:39:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B3BD6D191;
        Mon,  7 Mar 2022 01:34:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9488B80E70;
        Mon,  7 Mar 2022 09:33:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13ED6C340E9;
        Mon,  7 Mar 2022 09:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645615;
        bh=HPXmOkP3wrkQiz6RZ2g/fuX9WBPu5Ha+Bz20V8cASm8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F0dalyef/PLb7PFq9H7ETh+Zfm36Kpu1yV14cy3Yijme9E6ElND06nxpl44hf3zyp
         Du9cEqE/whLl2YuHd3YkqnbnwXFuPV+PbhV2Uh/fivUmj6W42i1Vmz9jM6mBaSOuNG
         m6mjmRaGyas2rci3ndrApLVkI0cW9QW7KC/HtjZ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 088/105] ibmvnic: define flush_reset_queue helper
Date:   Mon,  7 Mar 2022 10:19:31 +0100
Message-Id: <20220307091646.654996804@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091644.179885033@linuxfoundation.org>
References: <20220307091644.179885033@linuxfoundation.org>
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
index de58824f4c18..f07468316656 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2304,12 +2304,23 @@ static void __ibmvnic_delayed_reset(struct work_struct *work)
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
 
@@ -2353,12 +2364,9 @@ static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
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
 	netdev_dbg(adapter->netdev, "Scheduling reset (reason %d)\n", reason);
-- 
2.34.1



