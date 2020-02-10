Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 814DB1576FC
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727548AbgBJM4v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:56:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:44168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730024AbgBJMlf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:41:35 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0546C20733;
        Mon, 10 Feb 2020 12:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338495;
        bh=y9Bm0VEPRRwBIkpZOZX5/h6YwU4gJxJiEpIUJiLd6/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZIyE7/blt+jtLtwk46v/jQeUr4fm7LMnO2FLawNMUNn5umm7hN3DbJZa4qhF/RVe6
         kFAiKX2za+6q5BfKny072S7ts+/GFv7dJTM3M9hdFu0smNLxNLbP1ZVwPpXO0b8PtS
         VMdQ3d07PVaJIDFMrntY4r5/gh02q6vDnomftIjM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bean Huo <beanhuo@micron.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Can Guo <cang@codeaurora.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.5 283/367] scsi: ufs: Recheck bkops level if bkops is disabled
Date:   Mon, 10 Feb 2020 04:33:16 -0800
Message-Id: <20200210122450.108920904@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Asutosh Das <asutoshd@codeaurora.org>

commit 24366c2afbb0539fb14eff330d4e3a5db5c0a3ef upstream.

bkops level should be rechecked upon receiving an exception.  Currently the
level is being cached and never updated.

Update bkops each time the level is checked.  Also do not use the cached
bkops level value if it is disabled and then enabled.

Fixes: afdfff59a0e0 (scsi: ufs: handle non spec compliant bkops behaviour by device)
Link: https://lore.kernel.org/r/1574751214-8321-2-git-send-email-cang@qti.qualcomm.com
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Tested-by: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
Signed-off-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/ufs/ufshcd.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5053,6 +5053,7 @@ static int ufshcd_disable_auto_bkops(str
 
 	hba->auto_bkops_enabled = false;
 	trace_ufshcd_auto_bkops_state(dev_name(hba->dev), "Disabled");
+	hba->is_urgent_bkops_lvl_checked = false;
 out:
 	return err;
 }
@@ -5077,6 +5078,7 @@ static void ufshcd_force_reset_auto_bkop
 		hba->ee_ctrl_mask &= ~MASK_EE_URGENT_BKOPS;
 		ufshcd_disable_auto_bkops(hba);
 	}
+	hba->is_urgent_bkops_lvl_checked = false;
 }
 
 static inline int ufshcd_get_bkops_status(struct ufs_hba *hba, u32 *status)
@@ -5123,6 +5125,7 @@ static int ufshcd_bkops_ctrl(struct ufs_
 		err = ufshcd_enable_auto_bkops(hba);
 	else
 		err = ufshcd_disable_auto_bkops(hba);
+	hba->urgent_bkops_lvl = curr_status;
 out:
 	return err;
 }


