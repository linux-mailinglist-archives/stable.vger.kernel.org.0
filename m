Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C25381013B7
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727529AbfKSF0j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:26:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:44782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725873AbfKSF0j (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:26:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15A5622309;
        Tue, 19 Nov 2019 05:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141198;
        bh=IxqNtubm1ik/2pU1sDOhqVUVrkUUGyiic2eiJsNd5K4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AKeVeSC0JcOSoAaLaMsmEkR7UcYTG48N/FrjhaD5z2LKrO65fkFBKcIe+f7XRwdij
         zO2j3kZ3tuqiZ7nkUBT7KbV4dZvIykv9V8QxJQ7X6nAvNmkBIZf4P8pyvA7a5cvuGc
         BgRfO5eYUDcEtDoVq0A9kvm+iB4vd4afIXlS9VVk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 078/422] i40evf: Validate the number of queues a PF sends
Date:   Tue, 19 Nov 2019 06:14:35 +0100
Message-Id: <20191119051404.571990012@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>

[ Upstream commit 3c818910911c93bb5099c6637ec350f90c0e71fc ]

A PF can send any number of queues to the VF and the VF may not
be able to support that many. Check to see that the number of
queues is less than or equal to the max number of queues the
VF can have.

Signed-off-by: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/intel/i40evf/i40evf_virtchnl.c   | 32 +++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40evf/i40evf_virtchnl.c b/drivers/net/ethernet/intel/i40evf/i40evf_virtchnl.c
index 565677de5ba37..94dabc9d89f73 100644
--- a/drivers/net/ethernet/intel/i40evf/i40evf_virtchnl.c
+++ b/drivers/net/ethernet/intel/i40evf/i40evf_virtchnl.c
@@ -153,6 +153,32 @@ int i40evf_send_vf_config_msg(struct i40evf_adapter *adapter)
 					  NULL, 0);
 }
 
+/**
+ * i40evf_validate_num_queues
+ * @adapter: adapter structure
+ *
+ * Validate that the number of queues the PF has sent in
+ * VIRTCHNL_OP_GET_VF_RESOURCES is not larger than the VF can handle.
+ **/
+static void i40evf_validate_num_queues(struct i40evf_adapter *adapter)
+{
+	if (adapter->vf_res->num_queue_pairs > I40EVF_MAX_REQ_QUEUES) {
+		struct virtchnl_vsi_resource *vsi_res;
+		int i;
+
+		dev_info(&adapter->pdev->dev, "Received %d queues, but can only have a max of %d\n",
+			 adapter->vf_res->num_queue_pairs,
+			 I40EVF_MAX_REQ_QUEUES);
+		dev_info(&adapter->pdev->dev, "Fixing by reducing queues to %d\n",
+			 I40EVF_MAX_REQ_QUEUES);
+		adapter->vf_res->num_queue_pairs = I40EVF_MAX_REQ_QUEUES;
+		for (i = 0; i < adapter->vf_res->num_vsis; i++) {
+			vsi_res = &adapter->vf_res->vsi_res[i];
+			vsi_res->num_queue_pairs = I40EVF_MAX_REQ_QUEUES;
+		}
+	}
+}
+
 /**
  * i40evf_get_vf_config
  * @adapter: private adapter structure
@@ -195,6 +221,11 @@ int i40evf_get_vf_config(struct i40evf_adapter *adapter)
 	err = (i40e_status)le32_to_cpu(event.desc.cookie_low);
 	memcpy(adapter->vf_res, event.msg_buf, min(event.msg_len, len));
 
+	/* some PFs send more queues than we should have so validate that
+	 * we aren't getting too many queues
+	 */
+	if (!err)
+		i40evf_validate_num_queues(adapter);
 	i40e_vf_parse_hw_config(hw, adapter->vf_res);
 out_alloc:
 	kfree(event.msg_buf);
@@ -1329,6 +1360,7 @@ void i40evf_virtchnl_completion(struct i40evf_adapter *adapter,
 			  I40E_MAX_VF_VSI *
 			  sizeof(struct virtchnl_vsi_resource);
 		memcpy(adapter->vf_res, msg, min(msglen, len));
+		i40evf_validate_num_queues(adapter);
 		i40e_vf_parse_hw_config(&adapter->hw, adapter->vf_res);
 		/* restore current mac address */
 		ether_addr_copy(adapter->hw.mac.addr, netdev->dev_addr);
-- 
2.20.1



