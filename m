Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61A1623F406
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 22:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbgHGUz1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 16:55:27 -0400
Received: from mga17.intel.com ([192.55.52.151]:62789 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbgHGUz0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Aug 2020 16:55:26 -0400
IronPort-SDR: +sk03b5f+TT/sg0vK1yz1dWkVwjk3CxcIIoKP0cl6LvU8FbxAdv9DJvTl7XveRgW8NWVmo4Q3x
 5vpz0IWgkNhQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9706"; a="133260786"
X-IronPort-AV: E=Sophos;i="5.75,447,1589266800"; 
   d="scan'208";a="133260786"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2020 13:55:26 -0700
IronPort-SDR: dJsM9Ouk0NYXcoF7I/zVajyABLLWPlp/zVWC3eijlaBv5OpnOlcHmtHG8+IzL6w4AFo5oNmymI
 2vgtQ/aPuNMw==
X-IronPort-AV: E=Sophos;i="5.75,447,1589266800"; 
   d="scan'208";a="325878066"
Received: from jbrandeb-desk.jf.intel.com ([10.166.244.152])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2020 13:55:26 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     stable@vger.kernel.org
Cc:     Sergey Nemov <sergey.nemov@intel.com>,
        aleksandr.loktionov@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH stable 4.19 1/4] i40e: add num_vectors checker in iwarp handler
Date:   Fri,  7 Aug 2020 13:55:14 -0700
Message-Id: <20200807205517.1740307-2-jesse.brandeburg@intel.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200807205517.1740307-1-jesse.brandeburg@intel.com>
References: <20200807205517.1740307-1-jesse.brandeburg@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Nemov <sergey.nemov@intel.com>

[ Upstream commit 7015ca3df965378bcef072cca9cd63ed098665b5 ]

Field num_vectors from struct virtchnl_iwarp_qvlist_info should not be
larger than num_msix_vectors_vf in the hw struct.  The iwarp uses the
same set of vectors as the LAN VF driver.

Fixes: e3219ce6a7754 ("i40e: Add support for client interface for IWARP driver")
Signed-off-by: Sergey Nemov <sergey.nemov@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 6a677fd540d6..a1b464a91d93 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -442,6 +442,16 @@ static int i40e_config_iwarp_qvlist(struct i40e_vf *vf,
 	u32 next_q_idx, next_q_type;
 	u32 msix_vf, size;
 
+	msix_vf = pf->hw.func_caps.num_msix_vectors_vf;
+
+	if (qvlist_info->num_vectors > msix_vf) {
+		dev_warn(&pf->pdev->dev,
+			 "Incorrect number of iwarp vectors %u. Maximum %u allowed.\n",
+			 qvlist_info->num_vectors,
+			 msix_vf);
+		goto err;
+	}
+
 	size = sizeof(struct virtchnl_iwarp_qvlist_info) +
 	       (sizeof(struct virtchnl_iwarp_qv_info) *
 						(qvlist_info->num_vectors - 1));
-- 
2.25.4

