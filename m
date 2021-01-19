Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FFDC2FC49B
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 00:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728420AbhASXQv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 18:16:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730354AbhASXQj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jan 2021 18:16:39 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAABEC061757
        for <stable@vger.kernel.org>; Tue, 19 Jan 2021 15:15:58 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id v3so12774102qtw.4
        for <stable@vger.kernel.org>; Tue, 19 Jan 2021 15:15:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=op9FrWddONIxn+M8Vu02lYB/ZI0KbLq2QEuyw8GYI6U=;
        b=gSLoZAf+wj0Cbx2kVAUO7Dsd7pakalqeRQQkkuunp88VqihH7F2ZHeWrw0As42brAc
         mascdqYp1O05Na+QPckX6BwIB6wqQyFjHYqq/8j8V/kqFAINiWDSJcRQLchfOu0ou8VE
         SoXku3WcTYYdkrD0IkVedX6o1vaY1bo4nVFb8thY+haOcepesljR17g9ysr/snKAzrDk
         NzxvGC49rA59N0maw2bvdnbK/SoWPr689qh23QFhrbWslvOHYJn6qiGmli0MBItzGm2z
         Ha07mxP0ZsUcc4m3o/mdZ2M2IzwlSYw2azq5sJKZKeS/R8O8W4gMDEjWpKC1I3v74H3V
         1zdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=op9FrWddONIxn+M8Vu02lYB/ZI0KbLq2QEuyw8GYI6U=;
        b=kAcbrmwyNNpNjRq90TVW7KrIalOLHusjVWMAgonVJmrp4feA+ZJ9QIuAsIY3Qp8WPf
         PPIjxibNdDXnO/ZgLY4H0mA5f6dEpd3xrS+WvVYRxR+h7CHN0Gxcv5rJ8ZAdu1jYQmaV
         FBUqXbXcWXMXRH+DPyeWKiVLbrO+hTAALaDcJdgSgXSMqtvTvvZ8kv7nX5CaOwfQbZve
         dQZO0t6OsU7FU1wgAUfmDkOHsagZXEnNpoJ7jj9B0xhsYmmHNrwdTRfhnwEoie8JRZb9
         /7+7VObHDAT3SO1lshxOYhFcG5O5knLMf+M72/bt2QK4X7K77LWR0vXPgrTUc1OljH0D
         uuYg==
X-Gm-Message-State: AOAM5300e440FOLA4z84KAtCuUBTkBg9Ynyp1HlUzD+/ORgz9pWN4Jl9
        ejY2VbZUip4a2IFcVqTh/30=
X-Google-Smtp-Source: ABdhPJwVXkoBnaF2j0YgiNzq1aipHcEFIpv7P7shzdyZMMOBZ52EL6ReDaQj1uoeprYvDBSWL5wzeg==
X-Received: by 2002:ac8:71d6:: with SMTP id i22mr6608227qtp.206.1611098158009;
        Tue, 19 Jan 2021 15:15:58 -0800 (PST)
Received: from localhost.localdomain ([177.194.79.136])
        by smtp.gmail.com with ESMTPSA id e38sm94564qtb.30.2021.01.19.15.15.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 15:15:57 -0800 (PST)
From:   Fabio Estevam <festevam@gmail.com>
To:     robdclark@gmail.com
Cc:     sean@poorly.run, airlied@linux.ie, mkrishn@codeaurora.org,
        dri-devel@lists.freedesktop.org, bjorn.andersson@linaro.org,
        jcrouse@codeaurora.org, kernel@pengutronix.de, daniel@ffwll.ch,
        jonathan@marek.ca, kalyan_t@codeaurora.org,
        Fabio Estevam <festevam@gmail.com>, stable@vger.kernel.org
Subject: [PATCH v2 2/2] drm/msm: Call suspend/resume conditionally
Date:   Tue, 19 Jan 2021 20:13:41 -0300
Message-Id: <20210119231341.2498036-2-festevam@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210119231341.2498036-1-festevam@gmail.com>
References: <20210119231341.2498036-1-festevam@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When putting iMX5 into suspend, the following flow is
observed:

[   70.023427] [<c07755f0>] (msm_atomic_commit_tail) from [<c06e7218>]
(commit_tail+0x9c/0x18c)
[   70.031890] [<c06e7218>] (commit_tail) from [<c0e2920c>]
(drm_atomic_helper_commit+0x1a0/0x1d4)
[   70.040627] [<c0e2920c>] (drm_atomic_helper_commit) from
[<c06e74d4>] (drm_atomic_helper_disable_all+0x1c4/0x1d4)
[   70.050913] [<c06e74d4>] (drm_atomic_helper_disable_all) from
[<c0e2943c>] (drm_atomic_helper_suspend+0xb8/0x170)
[   70.061198] [<c0e2943c>] (drm_atomic_helper_suspend) from
[<c06e84bc>] (drm_mode_config_helper_suspend+0x24/0x58)

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

Fix the problem by calling drm_mode_config_helper_suspend/resume()
conditionally.

Cc: <stable@vger.kernel.org>
Fixes: ca8199f13498 ("drm/msm/dpu: ensure device suspend happens during PM sleep")
Signed-off-by: Fabio Estevam <festevam@gmail.com>
---
Changes since v1:
- Newly introduced in this series.

 drivers/gpu/drm/msm/msm_drv.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_drv.c b/drivers/gpu/drm/msm/msm_drv.c
index c082b72b9e3b..0d1a94e06912 100644
--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -1072,14 +1072,17 @@ static int __maybe_unused msm_pm_prepare(struct device *dev)
 {
 	struct drm_device *ddev = dev_get_drvdata(dev);
 
-	return drm_mode_config_helper_suspend(ddev);
+	if (of_device_get_match_data(dev))
+		return drm_mode_config_helper_suspend(ddev);
+	return 0;
 }
 
 static void __maybe_unused msm_pm_complete(struct device *dev)
 {
 	struct drm_device *ddev = dev_get_drvdata(dev);
 
-	drm_mode_config_helper_resume(ddev);
+	if (of_device_get_match_data(dev))
+		drm_mode_config_helper_resume(ddev);
 }
 
 static const struct dev_pm_ops msm_pm_ops = {
-- 
2.25.1

