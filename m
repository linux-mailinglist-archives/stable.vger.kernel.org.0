Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FCB71B4310
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 13:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbgDVLUT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 07:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726809AbgDVLUS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 07:20:18 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B43C03C1A8
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 04:20:17 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id e26so1862694wmk.5
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 04:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TV3arK5WUb34bvJty3z/ZBkIfATI4h4LTn5/l2uId24=;
        b=IjRxUlfxT0VzohBNY6XWGijBBX7vY0HNfEMJ1Xc/Cw15G+o/ZoIS+s2m5xSSypl9PK
         d9sTsdv1cOLsn72R/yZvHPh/67rxQdU7mGCNpC0LdVyMEgCUtxBpbEbxUutqoSZtS3BN
         9YwJtxjQ+mPQ/+zNQsLNBa1Irc9mdrSYQYa+iCf2Gd556KrcuZ91n9/GLJ9Y7zMOGSE7
         zXTH9sF9PWkNXLs9ELaF29BOhKJn7sXyyPK0POXTfBPTIhEcdWUPA8TWg/gGFfol767T
         ZLdYkSBSE6v8hzPuLCvTXQII97cdAnalCVDhKemsQljcW2mLfibJFGCQgJORpbWKWRDk
         wBjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TV3arK5WUb34bvJty3z/ZBkIfATI4h4LTn5/l2uId24=;
        b=D7pGwO53+x52mcoCywVcG9FE6OkBS8lHjSlK4fK9SEfZk6jX7pW9n9AKY/kclC//+d
         qUYqjgb+sodhnfGTHUmd8Jx3LEV6R7H7Og3wdTkzn3layrshNC874UTb1wyRNSE9YISB
         u3M40bsCBAlf4x8cT6eiYWGxyQ/Ots8ajF4oQ+92pcWOVeQZOK9ecG4fStwFOeni70u+
         h176ait99OAt30eJHWhNvjj9+VkMoxZ3RKZn2ecXWW5BJjGx3tg7Gf/UPwg6vpjlzFl8
         7z5j78dRzIqbiwadxo4ZN5U38W9otS2bL/W3q1AjNQB/QScwNpl+uJ2dGYOrC/en5Uzq
         18+g==
X-Gm-Message-State: AGi0PuYVRzayk2ihgD9hVbW4x71BFgIgHV16gI3RtoSiCXflbwHDcKzh
        tjSWiowBsAseC2UYzTDK+ZdNQsuUZX8=
X-Google-Smtp-Source: APiQypLcW8igEZMu4FP103SmW4rM9nmFPQ5INpRPyNXcdUecGGhfZXJqSKw5uWnlWWf+PuXisYq3hw==
X-Received: by 2002:a7b:cb88:: with SMTP id m8mr10087464wmi.103.1587554415547;
        Wed, 22 Apr 2020 04:20:15 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id n6sm8247255wrs.81.2020.04.22.04.20.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 04:20:14 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Subhash Jadavani <subhashj@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.9 10/21] scsi: ufs: Fix error handing during hibern8 enter
Date:   Wed, 22 Apr 2020 12:19:46 +0100
Message-Id: <20200422111957.569589-11-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200422111957.569589-1-lee.jones@linaro.org>
References: <20200422111957.569589-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
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
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/ufs/ufshcd.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 394df57894e6b..0b268f0151c67 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2804,15 +2804,24 @@ static int __ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
 	ret = ufshcd_uic_pwr_ctrl(hba, &uic_cmd);
 
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
 	}
 
 	return ret;
@@ -2824,7 +2833,7 @@ static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
 
 	for (retries = UIC_HIBERN8_ENTER_RETRIES; retries > 0; retries--) {
 		ret = __ufshcd_uic_hibern8_enter(hba);
-		if (!ret || ret == -ENOLINK)
+		if (!ret)
 			goto out;
 	}
 out:
-- 
2.25.1

