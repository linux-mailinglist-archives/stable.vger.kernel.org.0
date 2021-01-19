Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 123A22FC290
	for <lists+stable@lfdr.de>; Tue, 19 Jan 2021 22:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728134AbhASVgj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 16:36:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391763AbhASRwZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jan 2021 12:52:25 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08046C06137D
        for <stable@vger.kernel.org>; Tue, 19 Jan 2021 09:47:38 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id e15so14298314qte.9
        for <stable@vger.kernel.org>; Tue, 19 Jan 2021 09:47:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Yeg/VtiYIWCTT8IDKqMsAHwup1ZdQsI7JD3r5qOl2Aw=;
        b=GI5mKlTTU8pn3IApiTYvorvKsArEFXZPnNbpKRIOdkE3QuQg5Lcf3g5rdV08KKFYR2
         XnfM+gReGIugL8F9eIh2pjrfNfUm4HhycmB+dhEzBcqzkcrMR2w2yttv8jQt1N3p4LJM
         ZzfWmxRBp8NRFr9eRzn9lrRXIJis61/YFhfgULs5c7yxmpPIlwIOP+Wt3b5NCcfGFiPT
         B/Fjf/edurxMYg2xm+PAu+NX2GwJ1hu8TXPNpAT1ZDwLAb198RN/m+VIxleng9VWL+3/
         7yJIm3/WMIqwU4U04/r+KAldmgqYCxIkKO/ZEFASF8BUXKW8MWtNyT5UTRYwtdQM8b6V
         8nPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Yeg/VtiYIWCTT8IDKqMsAHwup1ZdQsI7JD3r5qOl2Aw=;
        b=pO+i07HAtjLyO8SWXgt1w5AsoO41TgFNZCwEPd/jBK5yBp0wdi7qlcZz4t2G4AO6LC
         ZLJIFyKsYR/KObxRrqQpam1djjpJph2c1J1uk/bP6gGA+mGmk2CMaPfnACfzkaqmN+4H
         yiCzy1RzCdBdWTX4+s3RElNmsN7Y+1f6Z+uiBuminM5vealYn8+ySwmk6yp0Us0pT75J
         KGKIs7zaZ3En8iqJVUokXK8KTSQ9CfKaLYV6Dytqw309Q7Tla4av6nXZMFpUExcZKbRU
         s5qtLPTI0OOKIfovjW6I8E7zWqyX6KgiS2SLMEivrdBdAnWFD5GzY81bMkrBGX1cQTDF
         l2hw==
X-Gm-Message-State: AOAM53272XJUDKP4+yUcMe5YhirqVVwg+S0CLDQjXyg9P4kptUc3ZGxs
        /JflOKIDcL825jHbfOLmU1k=
X-Google-Smtp-Source: ABdhPJyfGQZt3zTLX+BWFBt7zR0QnEIrt8r94am/1p/rkOnHgjtoNgZ1JF/XwqKJ3FSLVWhhl+vOJw==
X-Received: by 2002:aed:2e47:: with SMTP id j65mr5352944qtd.231.1611078457170;
        Tue, 19 Jan 2021 09:47:37 -0800 (PST)
Received: from localhost.localdomain ([177.194.79.136])
        by smtp.gmail.com with ESMTPSA id u5sm13501582qkb.120.2021.01.19.09.47.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 09:47:36 -0800 (PST)
From:   Fabio Estevam <festevam@gmail.com>
To:     robdclark@gmail.com
Cc:     sean@poorly.run, airlied@linux.ie, mkrishn@codeaurora.org,
        dri-devel@lists.freedesktop.org, bjorn.andersson@linaro.org,
        jcrouse@codeaurora.org, kernel@pengutronix.de, daniel@ffwll.ch,
        Fabio Estevam <festevam@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] drm/msm: Call shutdown conditionally
Date:   Tue, 19 Jan 2021 14:44:55 -0300
Message-Id: <20210119174455.2423205-1-festevam@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Calling the drm_atomic_helper_shutdown() on i.MX5 leads to
the following flow:

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

