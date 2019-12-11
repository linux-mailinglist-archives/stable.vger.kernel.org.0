Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E41D11B08B
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732769AbfLKPXx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:23:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:55002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732765AbfLKPXw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:23:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E15E52077B;
        Wed, 11 Dec 2019 15:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077831;
        bh=e07y4gJPcq4hbYaQiPLxrbah0eenCAvDjwLXIkX9kJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RwJys9fNba/iAaJ5sv8KaSYqTP4SygYBHgY3vtKNhVfxrdN3Jinco2QbxEUo9vZ+d
         0H+2lTBZkqdJX0CXaRLG/JMyUH6J4wk8Y5Nn7HUu2Bu52DX8vg0Rt5lN3MyQGdBKxU
         JzB2qNpvQPM2d1XOVr/3l7s1x4LZzh59bCDAp7bM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Krzysztof Goreczny <krzysztof.goreczny@intel.com>,
        Kaike Wan <kaike.wan@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 186/243] IB/hfi1: Ignore LNI errors before DC8051 transitions to Polling state
Date:   Wed, 11 Dec 2019 16:05:48 +0100
Message-Id: <20191211150351.727106361@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kaike Wan <kaike.wan@intel.com>

[ Upstream commit c1a797c0818e0122c7ec8422edd971cfec9b15ea ]

When it is requested to change its physical state back to Offline while in
the process to go up, DC8051 will set the ERROR field in the
DC8051_DBG_ERR_INFO_SET_BY_8051 register. This ERROR field will remain
until the next time when DC8051 transitions from Offline to Polling.
Subsequently, when the host requests DC8051 to change its physical state
to Polling again, it may receive a DC8051 interrupt with the stale ERROR
field still in DC8051_DBG_ERR_INFO_SET_BY_8051. If the host link state has
been changed to Polling, this stale ERROR will force the host to
transition to Offline state, resulting in a vicious cycle of Polling
->Offline->Polling->Offline. On the other hand, if the host link state is
still Offline when the stale ERROR is received, the stale ERROR will be
ignored, and the link will come up correctly.  This patch implements the
correct behavior by changing host link state to Polling only after DC8051
changes its physical state to Polling.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Krzysztof Goreczny <krzysztof.goreczny@intel.com>
Signed-off-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/chip.c | 47 ++++++++++++++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 6aa5a8a242ffd..6b89353611333 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -1074,6 +1074,8 @@ static void log_state_transition(struct hfi1_pportdata *ppd, u32 state);
 static void log_physical_state(struct hfi1_pportdata *ppd, u32 state);
 static int wait_physical_linkstate(struct hfi1_pportdata *ppd, u32 state,
 				   int msecs);
+static int wait_phys_link_out_of_offline(struct hfi1_pportdata *ppd,
+					 int msecs);
 static void read_planned_down_reason_code(struct hfi1_devdata *dd, u8 *pdrrc);
 static void read_link_down_reason(struct hfi1_devdata *dd, u8 *ldr);
 static void handle_temp_err(struct hfi1_devdata *dd);
@@ -10769,13 +10771,15 @@ int set_link_state(struct hfi1_pportdata *ppd, u32 state)
 			break;
 
 		ppd->port_error_action = 0;
-		ppd->host_link_state = HLS_DN_POLL;
 
 		if (quick_linkup) {
 			/* quick linkup does not go into polling */
 			ret = do_quick_linkup(dd);
 		} else {
 			ret1 = set_physical_link_state(dd, PLS_POLLING);
+			if (!ret1)
+				ret1 = wait_phys_link_out_of_offline(ppd,
+								     3000);
 			if (ret1 != HCMD_SUCCESS) {
 				dd_dev_err(dd,
 					   "Failed to transition to Polling link state, return 0x%x\n",
@@ -10783,6 +10787,14 @@ int set_link_state(struct hfi1_pportdata *ppd, u32 state)
 				ret = -EINVAL;
 			}
 		}
+
+		/*
+		 * Change the host link state after requesting DC8051 to
+		 * change its physical state so that we can ignore any
+		 * interrupt with stale LNI(XX) error, which will not be
+		 * cleared until DC8051 transitions to Polling state.
+		 */
+		ppd->host_link_state = HLS_DN_POLL;
 		ppd->offline_disabled_reason =
 			HFI1_ODR_MASK(OPA_LINKDOWN_REASON_NONE);
 		/*
@@ -12914,6 +12926,39 @@ static int wait_phys_link_offline_substates(struct hfi1_pportdata *ppd,
 	return read_state;
 }
 
+/*
+ * wait_phys_link_out_of_offline - wait for any out of offline state
+ * @ppd: port device
+ * @msecs: the number of milliseconds to wait
+ *
+ * Wait up to msecs milliseconds for any out of offline physical link
+ * state change to occur.
+ * Returns 0 if at least one state is reached, otherwise -ETIMEDOUT.
+ */
+static int wait_phys_link_out_of_offline(struct hfi1_pportdata *ppd,
+					 int msecs)
+{
+	u32 read_state;
+	unsigned long timeout;
+
+	timeout = jiffies + msecs_to_jiffies(msecs);
+	while (1) {
+		read_state = read_physical_state(ppd->dd);
+		if ((read_state & 0xF0) != PLS_OFFLINE)
+			break;
+		if (time_after(jiffies, timeout)) {
+			dd_dev_err(ppd->dd,
+				   "timeout waiting for phy link out of offline. Read state 0x%x, %dms\n",
+				   read_state, msecs);
+			return -ETIMEDOUT;
+		}
+		usleep_range(1950, 2050); /* sleep 2ms-ish */
+	}
+
+	log_state_transition(ppd, read_state);
+	return read_state;
+}
+
 #define CLEAR_STATIC_RATE_CONTROL_SMASK(r) \
 (r &= ~SEND_CTXT_CHECK_ENABLE_DISALLOW_PBC_STATIC_RATE_CONTROL_SMASK)
 
-- 
2.20.1



