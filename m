Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 032F72FC48A
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 00:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbhASXOV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 18:14:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729957AbhASXNy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jan 2021 18:13:54 -0500
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CB9BC061573
        for <stable@vger.kernel.org>; Tue, 19 Jan 2021 15:13:12 -0800 (PST)
Received: by mail-qk1-x72e.google.com with SMTP id k193so2577598qke.6
        for <stable@vger.kernel.org>; Tue, 19 Jan 2021 15:13:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zFDeRRXpIwJ9CiC4D5FKzuA49LZcu+/pdjtRByjt0xo=;
        b=sqoHROC9LkFMGRZVIpGm0kyyjpzP41GfuKZ6mpuqTy3cS8R7YsvLzEgPG0D25QKUTw
         7+IuUbBr3hZNyJnPEqcqXm0gkA+zzQAheq9QCFPcA7Wbpv1GAS5/kRv+h46uknGyg08y
         w3ZjMPDmm0//W9KTj6/wqUJfxQ+6GWVTny5GJvSuWIjWaO0VX2n9nrXGQ02xQSpzU4/i
         /7ojzbLEryT9wZYreis+nUEM4SEi4Wy2Av7legkmZKHJlPmHos8exBA2sjZpYddGy6kz
         329Mec5o4iU4riYH/AJsLFGly3xA2050pddCbb9vFr0PVCurQIWH1BFot1ZDJ3wqBPA3
         Oeeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zFDeRRXpIwJ9CiC4D5FKzuA49LZcu+/pdjtRByjt0xo=;
        b=EbEWuG+rACQaAjUOjHUKBaFu93aU8oRCEGhAEYtBMWferU3N89RjgvN9/fu6Ga5+1h
         ONALGH0KNtyp0JXAx1WEaNYlG72HcrLz81lhI3ty3Zj7y4mTeYAcsxgEJdnleleQ94lH
         7cxS4yqpNV3R55/BJd9Fgz+SfzFtGacZDnSXCKJaOfruZDC+ykNGx/u0HEvvyf9fzUoz
         rI6QIOESOVw9X0S5JNJ5OFo5Q47yvx51WIesXhEQcSW0PTvPIA2tInWerwcfUej9AJdm
         XeyCXLQIWdxW6atBvkpipJUU9D/53brfj54lbQZyN9uG2K6ktinI20nUcjRwmpKqGxrV
         dm/w==
X-Gm-Message-State: AOAM532XDCub+Dr1wRnxLhserHq1IeS6IHb8dQZJClf3ExZCowkF7Q6j
        TVdj2/vGKzDR8atNvLsKfgJyvGuxdXY=
X-Google-Smtp-Source: ABdhPJxgRZBW3+fVONVNJTB6QzcuDx+eY1pKQbv+mTe76B4trG+p0wwmu64ftSl1PErrEcQFCLuxcQ==
X-Received: by 2002:a37:8703:: with SMTP id j3mr6871202qkd.455.1611097991587;
        Tue, 19 Jan 2021 15:13:11 -0800 (PST)
Received: from localhost.localdomain ([177.194.79.136])
        by smtp.gmail.com with ESMTPSA id q185sm149865qka.96.2021.01.19.15.13.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 15:13:10 -0800 (PST)
From:   Fabio Estevam <festevam@gmail.com>
To:     robdclark@gmail.com
Cc:     sean@poorly.run, airlied@linux.ie, mkrishn@codeaurora.org,
        dri-devel@lists.freedesktop.org, bjorn.andersson@linaro.org,
        jcrouse@codeaurora.org, kernel@pengutronix.de, daniel@ffwll.ch,
        jonathan@marek.ca, kalyan_t@codeaurora.org,
        Fabio Estevam <festevam@gmail.com>, stable@vger.kernel.org
Subject: [PATCH v2 1/2] drm/msm: Call shutdown conditionally
Date:   Tue, 19 Jan 2021 20:10:54 -0300
Message-Id: <20210119231055.2497880-1-festevam@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Issuing a 'reboot' command in i.MX5 leads to the following flow:

[   24.557742] [<c0769b78>] (msm_atomic_commit_tail) from [<c06db0b4>]
(commit_tail+0xa4/0x1b0)
[   24.566349] [<c06db0b4>] (commit_tail) from [<c06dbed0>]
(drm_atomic_helper_commit+0x154/0x188)
[   24.575193] [<c06dbed0>] (drm_atomic_helper_commit) from
[<c06db604>] (drm_atomic_helper_disable_all+0x154/0x1c0)
[   24.585599] [<c06db604>] (drm_atomic_helper_disable_all) from
[<c06db704>] (drm_atomic_helper_shutdown+0x94/0x12c)
[   24.596094] [<c06db704>] (drm_atomic_helper_shutdown) from

In the i.MX5 case, priv->kms is not populated (as i.MX5 does not use any
of the Qualcomm display controllers), causing a NULL pointer
dereference in msm_atomic_commit_tail():

[   24.268964] 8<--- cut here ---
[   24.274602] Unable to handle kernel NULL pointer dereference at
virtual address 00000000
[   24.283434] pgd = (ptrval)
[   24.286387] [00000000] *pgd=ca212831
[   24.290788] Internal error: Oops: 17 [#1] SMP ARM
[   24.295609] Modules linked in:
[   24.298777] CPU: 0 PID: 197 Comm: init Not tainted 5.11.0-rc2-next-20210111 #333
[   24.306276] Hardware name: Freescale i.MX53 (Device Tree Support)
[   24.312442] PC is at msm_atomic_commit_tail+0x54/0xb9c
[   24.317743] LR is at commit_tail+0xa4/0x1b0

Fix the problem by calling drm_atomic_helper_shutdown() conditionally.

Cc: <stable@vger.kernel.org>
Fixes: 9d5cbf5fe46e ("drm/msm: add shutdown support for display platform_driver")
Suggested-by: Rob Clark <robdclark@gmail.com>
Signed-off-by: Fabio Estevam <festevam@gmail.com>
---
Changes since v1:
- Explain in the commit log that the problem happens after a 'reboot' command.

 drivers/gpu/drm/msm/msm_drv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/msm_drv.c b/drivers/gpu/drm/msm/msm_drv.c
index 108c405e03dd..c082b72b9e3b 100644
--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -1311,7 +1311,8 @@ static void msm_pdev_shutdown(struct platform_device *pdev)
 {
 	struct drm_device *drm = platform_get_drvdata(pdev);
 
-	drm_atomic_helper_shutdown(drm);
+	if (get_mdp_ver(pdev))
+		drm_atomic_helper_shutdown(drm);
 }
 
 static const struct of_device_id dt_match[] = {
-- 
2.25.1

