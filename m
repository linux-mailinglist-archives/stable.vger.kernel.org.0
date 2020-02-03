Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8A5E150D0C
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730814AbgBCQlT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:41:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:49916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730930AbgBCQfN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:35:13 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7610E21582;
        Mon,  3 Feb 2020 16:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747712;
        bh=gITOntd6JjepyRqHUzvVgH4Fg1uLC6E0WP0cBUWuEUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ge7Vr+z4dtjgLikgtphmnKQkFkgILyD6hMq29WTy8AvcZOMTGOVbrc3GaqTGYBblL
         D8eGBQgfj1u5uGAVmqrzGZGrw/dhzYCJ75/eSthBuaZ3RO1dyGk3Fiya8xADm1UPY9
         fZmSpCVWuAvW0jL7Yrv/JA8wif4x+r1u6beL4vB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Arkady Gilinksky <arkady.gilinsky@harmonicinc.com>,
        Brett Creeley <brett.creeley@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 38/90] i40e: Fix virtchnl_queue_select bitmap validation
Date:   Mon,  3 Feb 2020 16:19:41 +0000
Message-Id: <20200203161922.708588217@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161917.612554987@linuxfoundation.org>
References: <20200203161917.612554987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

[ Upstream commit d9d6a9aed3f66f8ce5fa3ca6ca26007d75032296 ]

Currently in i40e_vc_disable_queues_msg() we are incorrectly
validating the virtchnl queue select bitmaps. The
virtchnl_queue_select rx_queues and tx_queue bitmap is being
compared against ICE_MAX_VF_QUEUES, but the problem is that
these bitmaps can have a value greater than I40E_MAX_VF_QUEUES.
Fix this by comparing the bitmaps against BIT(I40E_MAX_VF_QUEUES).

Also, add the function i40e_vc_validate_vqs_bitmaps() that checks to see
if both virtchnl_queue_select bitmaps are empty along with checking that
the bitmaps only have valid bits set. This function can then be used in
both the queue enable and disable flows.

Suggested-by: Arkady Gilinksky <arkady.gilinsky@harmonicinc.com>
Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 22 +++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 3d24408388226..3515ace0f0201 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -2322,6 +2322,22 @@ static int i40e_ctrl_vf_rx_rings(struct i40e_vsi *vsi, unsigned long q_map,
 	return ret;
 }
 
+/**
+ * i40e_vc_validate_vqs_bitmaps - validate Rx/Tx queue bitmaps from VIRTHCHNL
+ * @vqs: virtchnl_queue_select structure containing bitmaps to validate
+ *
+ * Returns true if validation was successful, else false.
+ */
+static bool i40e_vc_validate_vqs_bitmaps(struct virtchnl_queue_select *vqs)
+{
+	if ((!vqs->rx_queues && !vqs->tx_queues) ||
+	    vqs->rx_queues >= BIT(I40E_MAX_VF_QUEUES) ||
+	    vqs->tx_queues >= BIT(I40E_MAX_VF_QUEUES))
+		return false;
+
+	return true;
+}
+
 /**
  * i40e_vc_enable_queues_msg
  * @vf: pointer to the VF info
@@ -2347,7 +2363,7 @@ static int i40e_vc_enable_queues_msg(struct i40e_vf *vf, u8 *msg)
 		goto error_param;
 	}
 
-	if ((0 == vqs->rx_queues) && (0 == vqs->tx_queues)) {
+	if (i40e_vc_validate_vqs_bitmaps(vqs)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto error_param;
 	}
@@ -2409,9 +2425,7 @@ static int i40e_vc_disable_queues_msg(struct i40e_vf *vf, u8 *msg)
 		goto error_param;
 	}
 
-	if ((vqs->rx_queues == 0 && vqs->tx_queues == 0) ||
-	    vqs->rx_queues > I40E_MAX_VF_QUEUES ||
-	    vqs->tx_queues > I40E_MAX_VF_QUEUES) {
+	if (i40e_vc_validate_vqs_bitmaps(vqs)) {
 		aq_ret = I40E_ERR_PARAM;
 		goto error_param;
 	}
-- 
2.20.1



