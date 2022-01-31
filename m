Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C603A4A40B9
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 11:59:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244170AbiAaK7v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 05:59:51 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60166 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348430AbiAaK7H (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 05:59:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92DB660ABE;
        Mon, 31 Jan 2022 10:59:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41F1C340E8;
        Mon, 31 Jan 2022 10:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643626747;
        bh=ikzpM6yMqqarD5b5oWLdMis0x23B4FdoQI5mEmCsh20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uA8xNufhyh3OWLXNj5OVVHP/eRvMuuQo80ZWgfO5Kn15xOfF6pFFojFH2N7iVs+3O
         U7jSE4hzcH7sHQAUS6hTTWNt8NHTo51EtsGsmqhG6Z6fB79cUwShgp+DojE/dTkNI3
         t9+w5/HgZC5CDlOdhzeZK8TN5NNbaTDYlXdOOXMg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaroslaw Gawin <jaroslawx.gawin@intel.com>,
        Slawomir Laba <slawomirx.laba@intel.com>,
        Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.4 26/64] i40e: Fix issue when maximum queues is exceeded
Date:   Mon, 31 Jan 2022 11:56:11 +0100
Message-Id: <20220131105216.550107980@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105215.644174521@linuxfoundation.org>
References: <20220131105215.644174521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jedrzej Jagielski <jedrzej.jagielski@intel.com>

commit d701658a50a471591094b3eb3961b4926cc8f104 upstream.

Before this patch VF interface vanished when
maximum queue number was exceeded. Driver tried
to add next queues even if there was not enough
space. PF sent incorrect number of queues to
the VF when there were not enough of them.

Add an additional condition introduced to check
available space in 'qp_pile' before proceeding.
This condition makes it impossible to add queues
if they number is greater than the number resulting
from available space.
Also add the search for free space in PF queue
pair piles.

Without this patch VF interfaces are not seen
when available space for queues has been
exceeded and following logs appears permanently
in dmesg:
"Unable to get VF config (-32)".
"VF 62 failed opcode 3, retval: -5"
"Unable to get VF config due to PF error condition, not retrying"

Fixes: 7daa6bf3294e ("i40e: driver core headers")
Fixes: 41c445ff0f48 ("i40e: main driver core")
Signed-off-by: Jaroslaw Gawin <jaroslawx.gawin@intel.com>
Signed-off-by: Slawomir Laba <slawomirx.laba@intel.com>
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/i40e/i40e.h             |    1 
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   14 ----
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |   59 +++++++++++++++++++++
 3 files changed, 61 insertions(+), 13 deletions(-)

--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -182,7 +182,6 @@ enum i40e_interrupt_policy {
 
 struct i40e_lump_tracking {
 	u16 num_entries;
-	u16 search_hint;
 	u16 list[0];
 #define I40E_PILE_VALID_BIT  0x8000
 #define I40E_IWARP_IRQ_PILE_ID  (I40E_PILE_VALID_BIT - 2)
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -204,10 +204,6 @@ int i40e_free_virt_mem_d(struct i40e_hw
  * @id: an owner id to stick on the items assigned
  *
  * Returns the base item index of the lump, or negative for error
- *
- * The search_hint trick and lack of advanced fit-finding only work
- * because we're highly likely to have all the same size lump requests.
- * Linear search time and any fragmentation should be minimal.
  **/
 static int i40e_get_lump(struct i40e_pf *pf, struct i40e_lump_tracking *pile,
 			 u16 needed, u16 id)
@@ -222,8 +218,7 @@ static int i40e_get_lump(struct i40e_pf
 		return -EINVAL;
 	}
 
-	/* start the linear search with an imperfect hint */
-	i = pile->search_hint;
+	i = 0;
 	while (i < pile->num_entries) {
 		/* skip already allocated entries */
 		if (pile->list[i] & I40E_PILE_VALID_BIT) {
@@ -242,7 +237,6 @@ static int i40e_get_lump(struct i40e_pf
 			for (j = 0; j < needed; j++)
 				pile->list[i+j] = id | I40E_PILE_VALID_BIT;
 			ret = i;
-			pile->search_hint = i + j;
 			break;
 		}
 
@@ -265,7 +259,7 @@ static int i40e_put_lump(struct i40e_lum
 {
 	int valid_id = (id | I40E_PILE_VALID_BIT);
 	int count = 0;
-	int i;
+	u16 i;
 
 	if (!pile || index >= pile->num_entries)
 		return -EINVAL;
@@ -277,8 +271,6 @@ static int i40e_put_lump(struct i40e_lum
 		count++;
 	}
 
-	if (count && index < pile->search_hint)
-		pile->search_hint = index;
 
 	return count;
 }
@@ -11382,7 +11374,6 @@ static int i40e_init_interrupt_scheme(st
 		return -ENOMEM;
 
 	pf->irq_pile->num_entries = vectors;
-	pf->irq_pile->search_hint = 0;
 
 	/* track first vector for misc interrupts, ignore return */
 	(void)i40e_get_lump(pf, pf->irq_pile, 1, I40E_PILE_VALID_BIT - 1);
@@ -12133,7 +12124,6 @@ static int i40e_sw_init(struct i40e_pf *
 		goto sw_init_done;
 	}
 	pf->qp_pile->num_entries = pf->hw.func_caps.num_tx_qp;
-	pf->qp_pile->search_hint = 0;
 
 	pf->tx_timeout_recovery_level = 1;
 
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -2486,6 +2486,59 @@ error_param:
 }
 
 /**
+ * i40e_check_enough_queue - find big enough queue number
+ * @vf: pointer to the VF info
+ * @needed: the number of items needed
+ *
+ * Returns the base item index of the queue, or negative for error
+ **/
+static int i40e_check_enough_queue(struct i40e_vf *vf, u16 needed)
+{
+	unsigned int  i, cur_queues, more, pool_size;
+	struct i40e_lump_tracking *pile;
+	struct i40e_pf *pf = vf->pf;
+	struct i40e_vsi *vsi;
+
+	vsi = pf->vsi[vf->lan_vsi_idx];
+	cur_queues = vsi->alloc_queue_pairs;
+
+	/* if current allocated queues are enough for need */
+	if (cur_queues >= needed)
+		return vsi->base_queue;
+
+	pile = pf->qp_pile;
+	if (cur_queues > 0) {
+		/* if the allocated queues are not zero
+		 * just check if there are enough queues for more
+		 * behind the allocated queues.
+		 */
+		more = needed - cur_queues;
+		for (i = vsi->base_queue + cur_queues;
+			i < pile->num_entries; i++) {
+			if (pile->list[i] & I40E_PILE_VALID_BIT)
+				break;
+
+			if (more-- == 1)
+				/* there is enough */
+				return vsi->base_queue;
+		}
+	}
+
+	pool_size = 0;
+	for (i = 0; i < pile->num_entries; i++) {
+		if (pile->list[i] & I40E_PILE_VALID_BIT) {
+			pool_size = 0;
+			continue;
+		}
+		if (needed <= ++pool_size)
+			/* there is enough */
+			return i;
+	}
+
+	return -ENOMEM;
+}
+
+/**
  * i40e_vc_request_queues_msg
  * @vf: pointer to the VF info
  * @msg: pointer to the msg buffer
@@ -2519,6 +2572,12 @@ static int i40e_vc_request_queues_msg(st
 			 req_pairs - cur_pairs,
 			 pf->queues_left);
 		vfres->num_queue_pairs = pf->queues_left + cur_pairs;
+	} else if (i40e_check_enough_queue(vf, req_pairs) < 0) {
+		dev_warn(&pf->pdev->dev,
+			 "VF %d requested %d more queues, but there is not enough for it.\n",
+			 vf->vf_id,
+			 req_pairs - cur_pairs);
+		vfres->num_queue_pairs = cur_pairs;
 	} else {
 		/* successful request */
 		vf->num_req_queues = req_pairs;


