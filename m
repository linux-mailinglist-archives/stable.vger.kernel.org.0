Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56C8B19C9B8
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388853AbgDBTRG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:17:06 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40269 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388621AbgDBTRG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:17:06 -0400
Received: by mail-wm1-f67.google.com with SMTP id a81so4925494wmf.5
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=TV3arK5WUb34bvJty3z/ZBkIfATI4h4LTn5/l2uId24=;
        b=cx6kp2JT7RZH7M7jjfuVQmwfEjefw6ue5UWWPbe+DFqiBnsq9PpBA+SPt+mzCBsr31
         NUZk/FTNklIwdcYrb0VWZaBJjmGf4tGZjr8mcRTVe2DVNyqKSFnPotMZ9SCR3jGVgM09
         ulvWTN70gvAN24ZpvWXG8hO0Tiu9cALQKSNLYaYQYYKy7IVM5HC2H2lOfY60QEzyd2TL
         EwQKSWl/Xm/y4nZG0TjmFsm/8LOdkJo3XOAbLxFfWqDCshXfpeFQYsUMKEtyOSnYnzo1
         prUc88jiqDIQKiVFJq4ctgJNrW3D7QWTcZiE2zACmWKCjlyAIyAGBIfIOgp7HnR4rNHU
         p/1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TV3arK5WUb34bvJty3z/ZBkIfATI4h4LTn5/l2uId24=;
        b=kV75ok5OSNhyS0/ShSKfzuRVx6kuCdv7wuDvqGXp6RuKpfYPvIA49cfLvz/yYxm4Tf
         m774NRugNk6+Yc6ibzr2eC69984tkg5evHlZ3nkC9yAg0LEAssy7dyDxCRDtRUuQk+aV
         KaVuMRB7hq4mprNYCyUazXy4//Dy6AQQOZhELmEZr/n7J8JVjdHuolPb8PRgkmgr8aYv
         ++KjFd3Fw60eqGSlHLJOMpoVorpIe1WL93wGPzz4ClR1sDfc8Xq3pwW/A7GAZgO15qLI
         vFP0aUTD5hFh5z2Di1k+Lnlw0pZrbkUOa2yTGeBPMfbLjKkwOIb79c2q7dWtc/cdPdgE
         fsyw==
X-Gm-Message-State: AGi0PuabyM9tXWP70V7SpUzTob0HRu+BcbdrIbVkgEDWQecNhXlNYKU4
        PEMizhwFMkW6nBlI9tehiRNSqxF8AcjiDA==
X-Google-Smtp-Source: APiQypI7d4d6XKzWPatZAO1guJcFAKGHrOHtFh/q8l+TRRUtYbfGte2otLFsa9szeSD9Ka9zOExuRw==
X-Received: by 2002:a7b:c8cd:: with SMTP id f13mr4952969wml.181.1585855024068;
        Thu, 02 Apr 2020 12:17:04 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id y1sm879050wmd.14.2020.04.02.12.17.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:17:03 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.9 10/24] scsi: ufs: Fix error handing during hibern8 enter
Date:   Thu,  2 Apr 2020 20:17:33 +0100
Message-Id: <20200402191747.789097-10-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191747.789097-1-lee.jones@linaro.org>
References: <20200402191747.789097-1-lee.jones@linaro.org>
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

