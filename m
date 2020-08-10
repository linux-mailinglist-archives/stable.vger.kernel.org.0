Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46FE424094A
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729166AbgHJPbG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:31:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:38254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728661AbgHJPbD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:31:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FB69207FF;
        Mon, 10 Aug 2020 15:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073463;
        bh=tYygRtCCqYPvmOEPK2ySkKydBlf7eZqGSMwcgYZbsb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SnoB2x53wtEBhH7zGS1ktboosmHONliEvHZMXxermW0684mHY42SyLIAEuv9JycZJ
         acEro8tE0sA6DHQ+LRxoHBP9SgaavQKDKo5mhnhpGX9CNTSEis5vgKFZupQCJLWiLx
         qgHrIUTJNs2hFOvWiCPXaJz+8+9MuHOSK1SnIRSs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Martyna Szapar <martyna.szapar@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH 4.19 47/48] i40e: Memory leak in i40e_config_iwarp_qvlist
Date:   Mon, 10 Aug 2020 17:22:09 +0200
Message-Id: <20200810151806.541597863@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151804.199494191@linuxfoundation.org>
References: <20200810151804.199494191@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martyna Szapar <martyna.szapar@intel.com>

[ Upstream commit 0b63644602cfcbac849f7ea49272a39e90fa95eb ]

Added freeing the old allocation of vf->qvlist_info in function
i40e_config_iwarp_qvlist before overwriting it with
the new allocation.

Fixes: e3219ce6a7754 ("i40e: Add support for client interface for IWARP driver")
Signed-off-by: Martyna Szapar <martyna.szapar@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |   23 +++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -441,6 +441,7 @@ static int i40e_config_iwarp_qvlist(stru
 	u32 v_idx, i, reg_idx, reg;
 	u32 next_q_idx, next_q_type;
 	u32 msix_vf, size;
+	int ret = 0;
 
 	msix_vf = pf->hw.func_caps.num_msix_vectors_vf;
 
@@ -449,16 +450,19 @@ static int i40e_config_iwarp_qvlist(stru
 			 "Incorrect number of iwarp vectors %u. Maximum %u allowed.\n",
 			 qvlist_info->num_vectors,
 			 msix_vf);
-		goto err;
+		ret = -EINVAL;
+		goto err_out;
 	}
 
 	size = sizeof(struct virtchnl_iwarp_qvlist_info) +
 	       (sizeof(struct virtchnl_iwarp_qv_info) *
 						(qvlist_info->num_vectors - 1));
+	kfree(vf->qvlist_info);
 	vf->qvlist_info = kzalloc(size, GFP_KERNEL);
-	if (!vf->qvlist_info)
-		return -ENOMEM;
-
+	if (!vf->qvlist_info) {
+		ret = -ENOMEM;
+		goto err_out;
+	}
 	vf->qvlist_info->num_vectors = qvlist_info->num_vectors;
 
 	msix_vf = pf->hw.func_caps.num_msix_vectors_vf;
@@ -469,8 +473,10 @@ static int i40e_config_iwarp_qvlist(stru
 		v_idx = qv_info->v_idx;
 
 		/* Validate vector id belongs to this vf */
-		if (!i40e_vc_isvalid_vector_id(vf, v_idx))
-			goto err;
+		if (!i40e_vc_isvalid_vector_id(vf, v_idx)) {
+			ret = -EINVAL;
+			goto err_free;
+		}
 
 		vf->qvlist_info->qv_info[i] = *qv_info;
 
@@ -512,10 +518,11 @@ static int i40e_config_iwarp_qvlist(stru
 	}
 
 	return 0;
-err:
+err_free:
 	kfree(vf->qvlist_info);
 	vf->qvlist_info = NULL;
-	return -EINVAL;
+err_out:
+	return ret;
 }
 
 /**


