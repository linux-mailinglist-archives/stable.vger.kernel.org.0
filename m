Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43B7F12F00E
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:51:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728285AbgABWYi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:24:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:48872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729285AbgABWYi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:24:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15C5E20863;
        Thu,  2 Jan 2020 22:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003877;
        bh=ycOVBy4CVWwCYhlVHnF0BSC7i8E2hr2AaxrJW236qWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Sb9wjKqXN8qY0bkQupUht/qPw48uXUvWUdp9v3QD1LTNMTq9EopP49MHMHrhug2/
         5NcuQFAzMUyoqEqQDFNRea+AQZHsQkLIm0EmseMkl1YMJ8/PDZcUaPDZqm4OxK93Um
         1gWfZzpUol/6TKCSzTMzLFr7hmw5r6pGaZ3XaZoM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Can Guo <cang@codeaurora.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 37/91] scsi: ufs: Fix error handing during hibern8 enter
Date:   Thu,  2 Jan 2020 23:07:19 +0100
Message-Id: <20200102220433.115740116@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220356.856162165@linuxfoundation.org>
References: <20200102220356.856162165@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Subhash Jadavani <subhashj@codeaurora.org>

[ Upstream commit 6d303e4b19d694cdbebf76bcdb51ada664ee953d ]

During clock gating (ufshcd_gate_work()), we first put the link hibern8 by
calling ufshcd_uic_hibern8_enter() and if ufshcd_uic_hibern8_enter()
returns success (0) then we gate all the clocks.  Now let’s zoom in to what
ufshcd_uic_hibern8_enter() does internally: It calls
__ufshcd_uic_hibern8_enter() and if failure is encountered, link recovery
shall put the link back to the highest HS gear and returns success (0) to
ufshcd_uic_hibern8_enter() which is the issue as link is still in active
state due to recovery!  Now ufshcd_uic_hibern8_enter() returns success to
ufshcd_gate_work() and hence it goes ahead with gating the UFS clock while
link is still in active state hence I believe controller would raise UIC
error interrupts. But when we service the interrupt, clocks might have
already been disabled!

This change fixes for this by returning failure from
__ufshcd_uic_hibern8_enter() if recovery succeeds as link is still not in
hibern8, upon receiving the error ufshcd_hibern8_enter() would initiate
retry to put the link state back into hibern8.

Link: https://lore.kernel.org/r/1573798172-20534-8-git-send-email-cang@codeaurora.org
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 9feae23bfd09..d25082e573e0 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3684,15 +3684,24 @@ static int __ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
 			     ktime_to_us(ktime_sub(ktime_get(), start)), ret);
 
 	if (ret) {
+		int err;
+
 		dev_err(hba->dev, "%s: hibern8 enter failed. ret = %d\n",
 			__func__, ret);
 
 		/*
-		 * If link recovery fails then return error so that caller
-		 * don't retry the hibern8 enter again.
+		 * If link recovery fails then return error code returned from
+		 * ufshcd_link_recovery().
+		 * If link recovery succeeds then return -EAGAIN to attempt
+		 * hibern8 enter retry again.
 		 */
-		if (ufshcd_link_recovery(hba))
-			ret = -ENOLINK;
+		err = ufshcd_link_recovery(hba);
+		if (err) {
+			dev_err(hba->dev, "%s: link recovery failed", __func__);
+			ret = err;
+		} else {
+			ret = -EAGAIN;
+		}
 	} else
 		ufshcd_vops_hibern8_notify(hba, UIC_CMD_DME_HIBER_ENTER,
 								POST_CHANGE);
@@ -3706,7 +3715,7 @@ static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
 
 	for (retries = UIC_HIBERN8_ENTER_RETRIES; retries > 0; retries--) {
 		ret = __ufshcd_uic_hibern8_enter(hba);
-		if (!ret || ret == -ENOLINK)
+		if (!ret)
 			goto out;
 	}
 out:
-- 
2.20.1



