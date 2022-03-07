Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ECD64CFACB
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:24:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233770AbiCGKWe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:22:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241441AbiCGKUd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:20:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D65690CC8;
        Mon,  7 Mar 2022 01:58:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33D3A60919;
        Mon,  7 Mar 2022 09:58:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04683C340F3;
        Mon,  7 Mar 2022 09:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646647094;
        bh=OF4LvnZoUsC5SUr3olPBFDXqhqhZWQIc703tv/w6YmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=amjZPljIJIBfBkS7jiNJd4TZ5M9yZPZLAyGXLqbyLq7k5df5Vl+clXfw2k8kW2Bae
         2qc8H2qefWcJjxtj656Cy9MQ7e2wu20d6xHXIxKSkGy/JIQG1fHz+owCJPgHaN/t9s
         bPnUTPfvGFH0JcSVblutpEfyBIue+IGTfB2GfgCM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Slawomir Laba <slawomirx.laba@intel.com>,
        Phani Burra <phani.r.burra@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 155/186] iavf: Fix __IAVF_RESETTING state usage
Date:   Mon,  7 Mar 2022 10:19:53 +0100
Message-Id: <20220307091658.409862483@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
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

From: Slawomir Laba <slawomirx.laba@intel.com>

[ Upstream commit 14756b2ae265d526b8356e86729090b01778fdf6 ]

The setup of __IAVF_RESETTING state in watchdog task had no
effect and could lead to slow resets in the driver as
the task for __IAVF_RESETTING state only requeues watchdog.
Till now the __IAVF_RESETTING was interpreted by reset task
as running state which could lead to errors with allocating
and resources disposal.

Make watchdog_task queue the reset task when it's necessary.
Do not update the state to __IAVF_RESETTING so the reset task
knows exactly what is the current state of the adapter.

Fixes: 898ef1cb1cb2 ("iavf: Combine init and watchdog state machines")
Signed-off-by: Slawomir Laba <slawomirx.laba@intel.com>
Signed-off-by: Phani Burra <phani.r.burra@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 9ed02a8ca7a3..138db07bdfa8 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1073,8 +1073,7 @@ void iavf_down(struct iavf_adapter *adapter)
 		rss->state = IAVF_ADV_RSS_DEL_REQUEST;
 	spin_unlock_bh(&adapter->adv_rss_lock);
 
-	if (!(adapter->flags & IAVF_FLAG_PF_COMMS_FAILED) &&
-	    adapter->state != __IAVF_RESETTING) {
+	if (!(adapter->flags & IAVF_FLAG_PF_COMMS_FAILED)) {
 		/* cancel any current operation */
 		adapter->current_op = VIRTCHNL_OP_UNKNOWN;
 		/* Schedule operations to close down the HW. Don't wait
@@ -1992,11 +1991,12 @@ static void iavf_watchdog_task(struct work_struct *work)
 	if (adapter->flags & IAVF_FLAG_PF_COMMS_FAILED)
 		iavf_change_state(adapter, __IAVF_COMM_FAILED);
 
-	if (adapter->flags & IAVF_FLAG_RESET_NEEDED &&
-	    adapter->state != __IAVF_RESETTING) {
-		iavf_change_state(adapter, __IAVF_RESETTING);
+	if (adapter->flags & IAVF_FLAG_RESET_NEEDED) {
 		adapter->aq_required = 0;
 		adapter->current_op = VIRTCHNL_OP_UNKNOWN;
+		mutex_unlock(&adapter->crit_lock);
+		queue_work(iavf_wq, &adapter->reset_task);
+		return;
 	}
 
 	switch (adapter->state) {
@@ -2289,8 +2289,7 @@ static void iavf_reset_task(struct work_struct *work)
 	 * ndo_open() returning, so we can't assume it means all our open
 	 * tasks have finished, since we're not holding the rtnl_lock here.
 	 */
-	running = ((adapter->state == __IAVF_RUNNING) ||
-		   (adapter->state == __IAVF_RESETTING));
+	running = adapter->state == __IAVF_RUNNING;
 
 	if (running) {
 		netdev->flags &= ~IFF_UP;
-- 
2.34.1



