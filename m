Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF6594943D2
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 00:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344275AbiASXVm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jan 2022 18:21:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344210AbiASXVm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jan 2022 18:21:42 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35E26C061574
        for <stable@vger.kernel.org>; Wed, 19 Jan 2022 15:21:42 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id m13-20020a056a00080d00b004be40ef1fd9so2433812pfk.22
        for <stable@vger.kernel.org>; Wed, 19 Jan 2022 15:21:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=R3Y/gOk08NgtXcS6vykPovrhRLCA2DpTaWszWvKKMv8=;
        b=c5zgx/4itJnifU5XQnptwovLjitu5KxUpdScwBHS9ppYLx8ucjI2vrBYnNg7vFwLG7
         VzFrLBx5t7DPwx/PJAna5plHjt7e7TgHwB/G8MXte8rSpYlwAoWRr14WybVs89QLUesC
         pgsTFv1yPQkaCAzYO9fu7jkDmk6hMnMFPUc864hF/qsMPw8X1Jt+FCfsiojcg4ZvbLI8
         102AZ7T1DxZAm95v5nl9qYZeoJWr2IO5mHLblewk4l/t/GU9ST8RtuDlZHyxZZkRdK9Z
         Vfk2b+ssBm7uP69bDqqQQSekf/OqZkeGdNNLY8VgwQdSTBKxSAxeWdSLPREam0I4Tzqy
         FLGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=R3Y/gOk08NgtXcS6vykPovrhRLCA2DpTaWszWvKKMv8=;
        b=GYtK3TqJiM0fqMSyWy5Qmu0deAYZ2dWSmlRGRm2We8JblIjFiEOnDF8no3d2Yx6xdT
         y0UwIPmsOLQhteVCR+FOQ9ZTYf9eqfneFnaAJyhdnAvWQCJDBg2JyDehaVDASY1e1/JH
         3zWeHu0cqSVtTK9hVZdnBAmtLkUQYuhqxJV6vb4WpyF/vnn9tsnGv0WvRhDMf2p1uIix
         d4wn6/Efc5h3KimzLetzDZ2SLoeI77PSktuWpDXPQcghLb4OOn9sbOQ3lx4Ww3GB+ujl
         8WaAFu4zfjvSLNh9Ta3bPR8MuhG2iVLQ0hF88lNasjlQpBHjKhrqQ3BYIi4kXBV1qDQh
         oPXw==
X-Gm-Message-State: AOAM530e2Q8NZr8UnAdp6n5BnqpFf0HAaBWRiFfdbZ9pfUGYNECKLFf0
        5ikVd2Dje5YOzEkrfqRBOTO5VPFIB7g=
X-Google-Smtp-Source: ABdhPJy0tmrWl2qzWMTzlH8xT25SOYiP2Mzw6nzK3q3lsalSqLQ2INJtAheVNXowbPrtzMsxUnxlwxnh370=
X-Received: from adelva.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:b2b])
 (user=adelva job=sendgmr) by 2002:a05:6a00:2408:b0:4c1:e1a1:770 with SMTP id
 z8-20020a056a00240800b004c1e1a10770mr32410337pfh.70.1642634501702; Wed, 19
 Jan 2022 15:21:41 -0800 (PST)
Date:   Wed, 19 Jan 2022 23:21:39 +0000
Message-Id: <20220119232139.1125908-1-adelva@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH] remoteproc: Fix count check in rproc_coredump_write()
From:   Alistair Delva <adelva@google.com>
To:     linux-kernel@vger.kernel.org
Cc:     Rishabh Bhatnagar <rishabhb@codeaurora.org>,
        stable@vger.kernel.org, Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Sibi Sankar <sibis@codeaurora.org>,
        linux-remoteproc@vger.kernel.org, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Check count for 0, to avoid a potential underflow. Make the check the
same as the one in rproc_recovery_write().

Fixes: 3afdc59e4390 ("remoteproc: Add coredump debugfs entry")
Signed-off-by: Alistair Delva <adelva@google.com>
Cc: Rishabh Bhatnagar <rishabhb@codeaurora.org>
Cc: stable@vger.kernel.org
Cc: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Sibi Sankar <sibis@codeaurora.org>
Cc: linux-remoteproc@vger.kernel.org
Cc: kernel-team@android.com
---
 drivers/remoteproc/remoteproc_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/remoteproc/remoteproc_debugfs.c b/drivers/remoteproc/remoteproc_debugfs.c
index b5a1e3b697d9..581930483ef8 100644
--- a/drivers/remoteproc/remoteproc_debugfs.c
+++ b/drivers/remoteproc/remoteproc_debugfs.c
@@ -76,7 +76,7 @@ static ssize_t rproc_coredump_write(struct file *filp,
 	int ret, err = 0;
 	char buf[20];
 
-	if (count > sizeof(buf))
+	if (count < 1 || count > sizeof(buf))
 		return -EINVAL;
 
 	ret = copy_from_user(buf, user_buf, count);
-- 
2.30.2

