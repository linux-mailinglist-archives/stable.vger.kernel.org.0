Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86F1135C045
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238118AbhDLJMH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:12:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:34520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239295AbhDLJHI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:07:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C961961360;
        Mon, 12 Apr 2021 09:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218223;
        bh=X5XYvbpyLkFVqEtU8EUG36FmqVXax333HXJV90P/TdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dKRwGg3jkJ33hP4hqGQpHJVQkSt1L8euo2spQVYsRPx8bEhRmf+n0sd2kbkaLkJ3D
         SGH+NSI1T1IN0KB737wpFhsDu3OMrgnfkxEbpIXb4BWm3eN2LmlM4MCbZH4mRHltDl
         vZTlEQhIoK0LkF3uuOCqEceDZiqtIWzkUe+2Hob8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eryk Rybak <eryk.roch.rybak@intel.com>,
        Grzegorz Szczurek <grzegorzx.szczurek@intel.com>,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 117/210] i40e: Fix kernel oops when i40e driver removes VFs
Date:   Mon, 12 Apr 2021 10:40:22 +0200
Message-Id: <20210412084019.897159579@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eryk Rybak <eryk.roch.rybak@intel.com>

[ Upstream commit 347b5650cd158d1d953487cc2bec567af5c5bf96 ]

Fix the reason of kernel oops when i40e driver removed VFs.
Added new __I40E_VFS_RELEASING state to signalize releasing
process by PF, that it makes possible to exit of reset VF procedure.
Without this patch, it is possible to suspend the VFs reset by
releasing VFs resources procedure. Retrying the reset after the
timeout works on the freed VF memory causing a kernel oops.

Fixes: d43d60e5eb95 ("i40e: ensure reset occurs when disabling VF")
Signed-off-by: Eryk Rybak <eryk.roch.rybak@intel.com>
Signed-off-by: Grzegorz Szczurek <grzegorzx.szczurek@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e.h             | 1 +
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 9 +++++++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index 118473dfdcbd..fe1258778cbc 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -142,6 +142,7 @@ enum i40e_state_t {
 	__I40E_VIRTCHNL_OP_PENDING,
 	__I40E_RECOVERY_MODE,
 	__I40E_VF_RESETS_DISABLED,	/* disable resets during i40e_remove */
+	__I40E_VFS_RELEASING,
 	/* This must be last as it determines the size of the BITMAP */
 	__I40E_STATE_SIZE__,
 };
diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 1b6ec9be155a..5d301a466f5c 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -137,6 +137,7 @@ void i40e_vc_notify_vf_reset(struct i40e_vf *vf)
  **/
 static inline void i40e_vc_disable_vf(struct i40e_vf *vf)
 {
+	struct i40e_pf *pf = vf->pf;
 	int i;
 
 	i40e_vc_notify_vf_reset(vf);
@@ -147,6 +148,11 @@ static inline void i40e_vc_disable_vf(struct i40e_vf *vf)
 	 * ensure a reset.
 	 */
 	for (i = 0; i < 20; i++) {
+		/* If PF is in VFs releasing state reset VF is impossible,
+		 * so leave it.
+		 */
+		if (test_bit(__I40E_VFS_RELEASING, pf->state))
+			return;
 		if (i40e_reset_vf(vf, false))
 			return;
 		usleep_range(10000, 20000);
@@ -1574,6 +1580,8 @@ void i40e_free_vfs(struct i40e_pf *pf)
 
 	if (!pf->vf)
 		return;
+
+	set_bit(__I40E_VFS_RELEASING, pf->state);
 	while (test_and_set_bit(__I40E_VF_DISABLE, pf->state))
 		usleep_range(1000, 2000);
 
@@ -1631,6 +1639,7 @@ void i40e_free_vfs(struct i40e_pf *pf)
 		}
 	}
 	clear_bit(__I40E_VF_DISABLE, pf->state);
+	clear_bit(__I40E_VFS_RELEASING, pf->state);
 }
 
 #ifdef CONFIG_PCI_IOV
-- 
2.30.2



