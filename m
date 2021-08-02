Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF62E3DD994
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236016AbhHBOBi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:01:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:43164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236695AbhHBN7v (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:59:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DE4B60725;
        Mon,  2 Aug 2021 13:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912557;
        bh=YbJ2oPzxDMUHrGrJo5WNDONfc5xRW4726IXKczgJRq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CdNktkd2Rba4/hkNPB/NakmzdVsMRD/C0875Pw+5S9xFhcN15nZhKRCcNxRdA9yXY
         qsKx2NGRF4TopbuZaEgrQm9kclNE5btaqQpbQAATnlzLIvgi0Ux+gM0dzKUey4PkkP
         WerrZKmeWGYiyzBPfZQ5AneuDQehoo/ZjJ8kHPuk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 045/104] i40e: Fix logic of disabling queues
Date:   Mon,  2 Aug 2021 15:44:42 +0200
Message-Id: <20210802134345.509140824@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>

[ Upstream commit 65662a8dcdd01342b71ee44234bcfd0162e195af ]

Correct the message flow between driver and firmware when disabling
queues.

Previously in case of PF reset (due to required reinit after reconfig),
the error like: "VSI seid 397 Tx ring 60 disable timeout" could show up
occasionally. The error was not a real issue of hardware or firmware,
it was caused by wrong sequence of messages invoked by the driver.

Fixes: 41c445ff0f48 ("i40e: main driver core")
Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 58 ++++++++++++---------
 1 file changed, 34 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index f9fe500d4ec4..951423e5f2c0 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -4454,11 +4454,10 @@ int i40e_control_wait_tx_q(int seid, struct i40e_pf *pf, int pf_q,
 }
 
 /**
- * i40e_vsi_control_tx - Start or stop a VSI's rings
+ * i40e_vsi_enable_tx - Start a VSI's rings
  * @vsi: the VSI being configured
- * @enable: start or stop the rings
  **/
-static int i40e_vsi_control_tx(struct i40e_vsi *vsi, bool enable)
+static int i40e_vsi_enable_tx(struct i40e_vsi *vsi)
 {
 	struct i40e_pf *pf = vsi->back;
 	int i, pf_q, ret = 0;
@@ -4467,7 +4466,7 @@ static int i40e_vsi_control_tx(struct i40e_vsi *vsi, bool enable)
 	for (i = 0; i < vsi->num_queue_pairs; i++, pf_q++) {
 		ret = i40e_control_wait_tx_q(vsi->seid, pf,
 					     pf_q,
-					     false /*is xdp*/, enable);
+					     false /*is xdp*/, true);
 		if (ret)
 			break;
 
@@ -4476,7 +4475,7 @@ static int i40e_vsi_control_tx(struct i40e_vsi *vsi, bool enable)
 
 		ret = i40e_control_wait_tx_q(vsi->seid, pf,
 					     pf_q + vsi->alloc_queue_pairs,
-					     true /*is xdp*/, enable);
+					     true /*is xdp*/, true);
 		if (ret)
 			break;
 	}
@@ -4574,32 +4573,25 @@ int i40e_control_wait_rx_q(struct i40e_pf *pf, int pf_q, bool enable)
 }
 
 /**
- * i40e_vsi_control_rx - Start or stop a VSI's rings
+ * i40e_vsi_enable_rx - Start a VSI's rings
  * @vsi: the VSI being configured
- * @enable: start or stop the rings
  **/
-static int i40e_vsi_control_rx(struct i40e_vsi *vsi, bool enable)
+static int i40e_vsi_enable_rx(struct i40e_vsi *vsi)
 {
 	struct i40e_pf *pf = vsi->back;
 	int i, pf_q, ret = 0;
 
 	pf_q = vsi->base_queue;
 	for (i = 0; i < vsi->num_queue_pairs; i++, pf_q++) {
-		ret = i40e_control_wait_rx_q(pf, pf_q, enable);
+		ret = i40e_control_wait_rx_q(pf, pf_q, true);
 		if (ret) {
 			dev_info(&pf->pdev->dev,
-				 "VSI seid %d Rx ring %d %sable timeout\n",
-				 vsi->seid, pf_q, (enable ? "en" : "dis"));
+				 "VSI seid %d Rx ring %d enable timeout\n",
+				 vsi->seid, pf_q);
 			break;
 		}
 	}
 
-	/* Due to HW errata, on Rx disable only, the register can indicate done
-	 * before it really is. Needs 50ms to be sure
-	 */
-	if (!enable)
-		mdelay(50);
-
 	return ret;
 }
 
@@ -4612,29 +4604,47 @@ int i40e_vsi_start_rings(struct i40e_vsi *vsi)
 	int ret = 0;
 
 	/* do rx first for enable and last for disable */
-	ret = i40e_vsi_control_rx(vsi, true);
+	ret = i40e_vsi_enable_rx(vsi);
 	if (ret)
 		return ret;
-	ret = i40e_vsi_control_tx(vsi, true);
+	ret = i40e_vsi_enable_tx(vsi);
 
 	return ret;
 }
 
+#define I40E_DISABLE_TX_GAP_MSEC	50
+
 /**
  * i40e_vsi_stop_rings - Stop a VSI's rings
  * @vsi: the VSI being configured
  **/
 void i40e_vsi_stop_rings(struct i40e_vsi *vsi)
 {
+	struct i40e_pf *pf = vsi->back;
+	int pf_q, err, q_end;
+
 	/* When port TX is suspended, don't wait */
 	if (test_bit(__I40E_PORT_SUSPENDED, vsi->back->state))
 		return i40e_vsi_stop_rings_no_wait(vsi);
 
-	/* do rx first for enable and last for disable
-	 * Ignore return value, we need to shutdown whatever we can
-	 */
-	i40e_vsi_control_tx(vsi, false);
-	i40e_vsi_control_rx(vsi, false);
+	q_end = vsi->base_queue + vsi->num_queue_pairs;
+	for (pf_q = vsi->base_queue; pf_q < q_end; pf_q++)
+		i40e_pre_tx_queue_cfg(&pf->hw, (u32)pf_q, false);
+
+	for (pf_q = vsi->base_queue; pf_q < q_end; pf_q++) {
+		err = i40e_control_wait_rx_q(pf, pf_q, false);
+		if (err)
+			dev_info(&pf->pdev->dev,
+				 "VSI seid %d Rx ring %d dissable timeout\n",
+				 vsi->seid, pf_q);
+	}
+
+	msleep(I40E_DISABLE_TX_GAP_MSEC);
+	pf_q = vsi->base_queue;
+	for (pf_q = vsi->base_queue; pf_q < q_end; pf_q++)
+		wr32(&pf->hw, I40E_QTX_ENA(pf_q), 0);
+
+	i40e_vsi_wait_queues_disabled(vsi);
 }
 
 /**
-- 
2.30.2



