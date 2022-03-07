Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D01CF4CFAE4
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239438AbiCGKWr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:22:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239995AbiCGKR7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:17:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3CDE5FAF;
        Mon,  7 Mar 2022 01:57:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0739B80E70;
        Mon,  7 Mar 2022 09:57:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06C6DC340E9;
        Mon,  7 Mar 2022 09:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646647060;
        bh=hKrKLu3U3v6+gViq/sGif42bHuj4V3NfISHQ/XGwL1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RJJ7yeCxN/rd6JOtTDHjg8bBptaC4ZwnQctNu47EML/LGGA0NUj4kfwTr8+IEgdFJ
         HLp+6F/o/DZkj2mrGwigVbKBXBubOjF8dIUc9rGFmKFXraYQ6iVeCmJKDX7BGwAoDW
         +QlPmwNPzX8AXrnHg+lwTQClrnQhuWAefO3qsExQ=
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
Subject: [PATCH 5.16 152/186] iavf: Fix init state closure on remove
Date:   Mon,  7 Mar 2022 10:19:50 +0100
Message-Id: <20220307091658.325473290@linuxfoundation.org>
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

[ Upstream commit 3ccd54ef44ebfa0792c5441b6d9c86618f3378d1 ]

When init states of the adapter work, the errors like lack
of communication with the PF might hop in. If such events
occur the driver restores previous states in order to retry
initialization in a proper way. When remove task kicks in,
this situation could lead to races with unregistering the
netdevice as well as resources cleanup. With the commit
introducing the waiting in remove for init to complete,
this problem turns into an endless waiting if init never
recovers from errors.

Introduce __IAVF_IN_REMOVE_TASK bit to indicate that the
remove thread has started.

Make __IAVF_COMM_FAILED adapter state respect the
__IAVF_IN_REMOVE_TASK bit and set the __IAVF_INIT_FAILED
state and return without any action instead of trying to
recover.

Make __IAVF_INIT_FAILED adapter state respect the
__IAVF_IN_REMOVE_TASK bit and return without any further
actions.

Make the loop in the remove handler break when adapter has
__IAVF_INIT_FAILED state set.

Fixes: 898ef1cb1cb2 ("iavf: Combine init and watchdog state machines")
Signed-off-by: Slawomir Laba <slawomirx.laba@intel.com>
Signed-off-by: Phani Burra <phani.r.burra@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf.h      |  4 ++++
 drivers/net/ethernet/intel/iavf/iavf_main.c | 24 ++++++++++++++++++++-
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index 21e0f3361560..ffc61993019b 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -188,6 +188,10 @@ enum iavf_state_t {
 	__IAVF_RUNNING,		/* opened, working */
 };
 
+enum iavf_critical_section_t {
+	__IAVF_IN_REMOVE_TASK,	/* device being removed */
+};
+
 #define IAVF_CLOUD_FIELD_OMAC		0x01
 #define IAVF_CLOUD_FIELD_IMAC		0x02
 #define IAVF_CLOUD_FIELD_IVLAN	0x04
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index d5055a49ae12..2a9044c8396f 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2019,6 +2019,15 @@ static void iavf_watchdog_task(struct work_struct *work)
 				   msecs_to_jiffies(1));
 		return;
 	case __IAVF_INIT_FAILED:
+		if (test_bit(__IAVF_IN_REMOVE_TASK,
+			     &adapter->crit_section)) {
+			/* Do not update the state and do not reschedule
+			 * watchdog task, iavf_remove should handle this state
+			 * as it can loop forever
+			 */
+			mutex_unlock(&adapter->crit_lock);
+			return;
+		}
 		if (++adapter->aq_wait_count > IAVF_AQ_MAX_ERR) {
 			dev_err(&adapter->pdev->dev,
 				"Failed to communicate with PF; waiting before retry\n");
@@ -2035,6 +2044,17 @@ static void iavf_watchdog_task(struct work_struct *work)
 		queue_delayed_work(iavf_wq, &adapter->watchdog_task, HZ);
 		return;
 	case __IAVF_COMM_FAILED:
+		if (test_bit(__IAVF_IN_REMOVE_TASK,
+			     &adapter->crit_section)) {
+			/* Set state to __IAVF_INIT_FAILED and perform remove
+			 * steps. Remove IAVF_FLAG_PF_COMMS_FAILED so the task
+			 * doesn't bring the state back to __IAVF_COMM_FAILED.
+			 */
+			iavf_change_state(adapter, __IAVF_INIT_FAILED);
+			adapter->flags &= ~IAVF_FLAG_PF_COMMS_FAILED;
+			mutex_unlock(&adapter->crit_lock);
+			return;
+		}
 		reg_val = rd32(hw, IAVF_VFGEN_RSTAT) &
 			  IAVF_VFGEN_RSTAT_VFR_STATE_MASK;
 		if (reg_val == VIRTCHNL_VFR_VFACTIVE ||
@@ -3990,13 +4010,15 @@ static void iavf_remove(struct pci_dev *pdev)
 	struct iavf_hw *hw = &adapter->hw;
 	int err;
 
+	set_bit(__IAVF_IN_REMOVE_TASK, &adapter->crit_section);
 	/* Wait until port initialization is complete.
 	 * There are flows where register/unregister netdev may race.
 	 */
 	while (1) {
 		mutex_lock(&adapter->crit_lock);
 		if (adapter->state == __IAVF_RUNNING ||
-		    adapter->state == __IAVF_DOWN) {
+		    adapter->state == __IAVF_DOWN ||
+		    adapter->state == __IAVF_INIT_FAILED) {
 			mutex_unlock(&adapter->crit_lock);
 			break;
 		}
-- 
2.34.1



