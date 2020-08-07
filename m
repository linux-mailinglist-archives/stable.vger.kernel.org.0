Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD0E123F407
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 22:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725893AbgHGUz1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 16:55:27 -0400
Received: from mga17.intel.com ([192.55.52.151]:62789 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725970AbgHGUz0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Aug 2020 16:55:26 -0400
IronPort-SDR: B0RUVcloexv2aOIzKSylB5+37DoeWQNJIPiIYCb606lB8q1QSzlXYv+o0sV92DRBMHIh09p1J9
 j/a/wVtEKBXQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9706"; a="133260787"
X-IronPort-AV: E=Sophos;i="5.75,447,1589266800"; 
   d="scan'208";a="133260787"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2020 13:55:26 -0700
IronPort-SDR: t7AKDdiaTqrfs1StK5IZwWgvAgnPJ1yaTQ2iKUgIa+2a+TgdGoWyJwF1AagjK5d1CwKqANXxgZ
 kvMlBqNDrJaQ==
X-IronPort-AV: E=Sophos;i="5.75,447,1589266800"; 
   d="scan'208";a="325878069"
Received: from jbrandeb-desk.jf.intel.com ([10.166.244.152])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2020 13:55:26 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     stable@vger.kernel.org
Cc:     Grzegorz Siwik <grzegorz.siwik@intel.com>,
        aleksandr.loktionov@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH stable 4.19 2/4] i40e: Wrong truncation from u16 to u8
Date:   Fri,  7 Aug 2020 13:55:15 -0700
Message-Id: <20200807205517.1740307-3-jesse.brandeburg@intel.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200807205517.1740307-1-jesse.brandeburg@intel.com>
References: <20200807205517.1740307-1-jesse.brandeburg@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grzegorz Siwik <grzegorz.siwik@intel.com>

[ Upstream commit c004804dceee9ca384d97d9857ea2e2795c2651d ]

In this patch fixed wrong truncation method from u16 to u8 during
validation.

It was changed by changing u8 to u32 parameter in method declaration
and arguments were changed to u32.

Fixes: 5c3c48ac6bf56 ("i40e: implement virtual device interface")
Signed-off-by: Grzegorz Siwik <grzegorz.siwik@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index a1b464a91d93..b26e41acd993 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -196,7 +196,7 @@ static inline bool i40e_vc_isvalid_queue_id(struct i40e_vf *vf, u16 vsi_id,
  *
  * check for the valid vector id
  **/
-static inline bool i40e_vc_isvalid_vector_id(struct i40e_vf *vf, u8 vector_id)
+static inline bool i40e_vc_isvalid_vector_id(struct i40e_vf *vf, u32 vector_id)
 {
 	struct i40e_pf *pf = vf->pf;
 
-- 
2.25.4

