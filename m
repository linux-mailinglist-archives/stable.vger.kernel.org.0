Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 847124D028B
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 16:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243698AbiCGPR7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 10:17:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242843AbiCGPRy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 10:17:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D0E48CD96
        for <stable@vger.kernel.org>; Mon,  7 Mar 2022 07:17:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC48BB815B4
        for <stable@vger.kernel.org>; Mon,  7 Mar 2022 15:16:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30722C340EB;
        Mon,  7 Mar 2022 15:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646666217;
        bh=KuwHL+6f6ePZEGVfn5D1X9NLVM8YWD6shz5ncgRNax0=;
        h=Subject:To:Cc:From:Date:From;
        b=JyHakN9tBfAyxqrlcedhEtAYOZoSB2UhldgiuH2KPDOVAAHRkVVCl8O+o2NCQhKFa
         Ns47xP3N7h4f2SuNlrf5yEtHafrdqsy/8fIw+1IrLtLvnMMevRty5MdsX7/tOiEVbz
         JRJqSKiQCZmcUe1Ha0+zZ4EJoICLAlwEuhF5Dc1Q=
Subject: FAILED: patch "[PATCH] ibmvnic: define flush_reset_queue helper" failed to apply to 4.19-stable tree
To:     sukadev@linux.ibm.com, davem@davemloft.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 07 Mar 2022 16:16:54 +0100
Message-ID: <164666621419440@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 83da53f7e4bd86dca4b2edc1e2bb324fb3c033a1 Mon Sep 17 00:00:00 2001
From: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Date: Thu, 24 Feb 2022 22:23:53 -0800
Subject: [PATCH] ibmvnic: define flush_reset_queue helper

Define and use a helper to flush the reset queue.

Fixes: 2770a7984db5 ("ibmvnic: Introduce hard reset recovery")
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index c73c699600a8..42c3ac9ebb75 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2735,12 +2735,23 @@ static void __ibmvnic_delayed_reset(struct work_struct *work)
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
 
@@ -2783,12 +2794,9 @@ static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
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

