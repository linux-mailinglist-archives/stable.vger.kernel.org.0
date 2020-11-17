Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 718412B6085
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729409AbgKQNKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:10:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:39172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729405AbgKQNKE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:10:04 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAC7C2225B;
        Tue, 17 Nov 2020 13:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605618603;
        bh=HncPNSTv4gSj6izBMchSDlU9Gv2hwDnuhNQcRQT3F/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hEnU4yKPfK76oaAMEWEvvMJ7iKJkvj4aJvr3BgpyxWhL37HnCoMwxpNv5n51G+jAW
         ZS77BJU+FWX9WZAPsqtRuIvE0XI5V6ACbe+C3AOPRUEa5Gi13se2hFSp5PukNpaUAm
         s27jGg4ElWhQsjRDcVmeZWZCzM1lk4D5Hp3wJxGI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martyna Szapar <martyna.szapar@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 23/78] i40e: Memory leak in i40e_config_iwarp_qvlist
Date:   Tue, 17 Nov 2020 14:04:49 +0100
Message-Id: <20201117122110.246187544@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122109.116890262@linuxfoundation.org>
References: <20201117122109.116890262@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martyna Szapar <martyna.szapar@intel.com>

commit 0b63644602cfcbac849f7ea49272a39e90fa95eb upstream.

Added freeing the old allocation of vf->qvlist_info in function
i40e_config_iwarp_qvlist before overwriting it with
the new allocation.

Signed-off-by: Martyna Szapar <martyna.szapar@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
[bwh: Backported to 4.9: adjust context]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 23 ++++++++++++-------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index e6798b0d1cae0..e3e02ec8f1498 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -417,6 +417,7 @@ static int i40e_config_iwarp_qvlist(struct i40e_vf *vf,
 	u32 v_idx, i, reg_idx, reg;
 	u32 next_q_idx, next_q_type;
 	u32 msix_vf, size;
+	int ret = 0;
 
 	msix_vf = pf->hw.func_caps.num_msix_vectors_vf;
 
@@ -425,16 +426,19 @@ static int i40e_config_iwarp_qvlist(struct i40e_vf *vf,
 			 "Incorrect number of iwarp vectors %u. Maximum %u allowed.\n",
 			 qvlist_info->num_vectors,
 			 msix_vf);
-		goto err;
+		ret = -EINVAL;
+		goto err_out;
 	}
 
 	size = sizeof(struct i40e_virtchnl_iwarp_qvlist_info) +
 	       (sizeof(struct i40e_virtchnl_iwarp_qv_info) *
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
@@ -445,8 +449,10 @@ static int i40e_config_iwarp_qvlist(struct i40e_vf *vf,
 		v_idx = qv_info->v_idx;
 
 		/* Validate vector id belongs to this vf */
-		if (!i40e_vc_isvalid_vector_id(vf, v_idx))
-			goto err;
+		if (!i40e_vc_isvalid_vector_id(vf, v_idx)) {
+			ret = -EINVAL;
+			goto err_free;
+		}
 
 		vf->qvlist_info->qv_info[i] = *qv_info;
 
@@ -488,10 +494,11 @@ static int i40e_config_iwarp_qvlist(struct i40e_vf *vf,
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
-- 
2.27.0



