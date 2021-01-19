Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0D212FC4A0
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 00:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727460AbhASXRm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 18:17:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730327AbhASXQg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jan 2021 18:16:36 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F8CCC061575
        for <stable@vger.kernel.org>; Tue, 19 Jan 2021 15:15:54 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id e17so5942004qto.3
        for <stable@vger.kernel.org>; Tue, 19 Jan 2021 15:15:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zFDeRRXpIwJ9CiC4D5FKzuA49LZcu+/pdjtRByjt0xo=;
        b=EUpoc6ZmND4/VQFJlNvyzA1vM7qWFDa/JLRRBwFMkWpVdv1v4LoWIcmIzkguUXq4O2
         tyCX3jHlX+jcXwNSTt507WhTtYKJ6hNRmnimOffTJaoQsly+XNAPPohBnwSDAR3Pw7mf
         GAAYeakFrr5Nw6EaAksJJ4qmBCLvBjNorGfCYAM92sqSqZ9UJaK0jUAIpXQuV9lZ1Y7m
         M5X2YQqK9t+4MWgNCi1LesjtdXpibBLzox8J/xrVALmGUWZbwi9quSbOpMF1GCtFbGDI
         Gja0M1RRHfTMFryrqq8gUdkILJHBnrAxTMolFg3Z0vV/ZPFMmjSYIBRNlMKaoDqyzbux
         6eZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zFDeRRXpIwJ9CiC4D5FKzuA49LZcu+/pdjtRByjt0xo=;
        b=YvLLwdji+mpxbiDHBT8iGvaYUVsnpJKkHseeEUbm07G6nEVTrbYxi6DOeFsE52AZcV
         /f+x7ll6Sg22QPSNXCCIpSTQpWKPnIoBECYXlU7movOmG3qVu06hPweq/xZUmns70ugW
         ibpipCE2gzxhV/p0SCwUtzo/8o8Q6IvytepW7xJn37zve7lJR7aVOKsyXcLgKOo7lVj/
         oPrOaJbSdeQKRTHCgMAgSLFs1R5xrob+TFUMzBtgTGvhFU1IC2W5RceHSjQucKwWqF4g
         5qxqv6TefEEO+0Mvwfw2bOwrFjVDjdA1ikief04qpVqiLMfZARlTAd8639w3bzzEYLQZ
         Rb8A==
X-Gm-Message-State: AOAM532Fs4dKbDVCRSaX031xxLlMtDjXpG8VV/2DPsBXV0SCP1WZRaMW
        Br7NikS0wx53jditLkkthe0=
X-Google-Smtp-Source: ABdhPJxRxBvysOQ/vcLW6AKkF0q0Axqn6H/FqkJq5ehZ2p0mvcqwsD3v6dCpUYb+zlxOYcf6ECom8g==
X-Received: by 2002:ac8:5c41:: with SMTP id j1mr6663954qtj.306.1611098153671;
        Tue, 19 Jan 2021 15:15:53 -0800 (PST)
Received: from localhost.localdomain ([177.194.79.136])
        by smtp.gmail.com with ESMTPSA id e38sm94564qtb.30.2021.01.19.15.15.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 15:15:52 -0800 (PST)
From:   Fabio Estevam <festevam@gmail.com>
To:     robdclark@gmail.com
Cc:     sean@poorly.run, airlied@linux.ie, mkrishn@codeaurora.org,
        dri-devel@lists.freedesktop.org, bjorn.andersson@linaro.org,
        jcrouse@codeaurora.org, kernel@pengutronix.de, daniel@ffwll.ch,
        jonathan@marek.ca, kalyan_t@codeaurora.org,
        Fabio Estevam <festevam@gmail.com>, stable@vger.kernel.org
Subject: [PATCH v2 1/2] drm/msm: Call shutdown conditionally
Date:   Tue, 19 Jan 2021 20:13:40 -0300
Message-Id: <20210119231341.2498036-1-festevam@gmail.com>
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

