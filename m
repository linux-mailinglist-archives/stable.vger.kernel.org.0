Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D97C11AEEA
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729950AbfLKPJQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:09:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:57096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729481AbfLKPJN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:09:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B562208C3;
        Wed, 11 Dec 2019 15:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576076952;
        bh=2G4Bl/xqP/dd7SjrZsEOEoYlNf1aFFYxNs8ztnSFFbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e8dim312IJ/kQot/bD5bq2eTinFl6Md2/QwqmJQJs+f2lJJesPwYCFj59TwHlul25
         n1yatfvlWjzd177/O9Z8a79YfAD4GOMBSW+p2plSJ3GqMx+0/JRrUXLwbH0FIBBArd
         J3R5TEGSTzEQzwCFXiGoQAD2hsIIpyX70zzDcqJs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jordan Crouse <jcrouse@codeaurora.org>,
        Rob Clark <robdclark@gmail.com>,
        Johan Hovold <johan@kernel.org>,
        Sean Paul <seanpaul@chromium.org>
Subject: [PATCH 5.4 54/92] drm/msm: fix memleak on release
Date:   Wed, 11 Dec 2019 16:05:45 +0100
Message-Id: <20191211150245.038759780@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.977775294@linuxfoundation.org>
References: <20191211150221.977775294@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit a64fc11b9a520c55ca34d82e5ca32274f49b6b15 upstream.

If a process is interrupted while accessing the "gpu" debugfs file and
the drm device struct_mutex is contended, release() could return early
and fail to free related resources.

Note that the return value from release() is ignored.

Fixes: 4f776f4511c7 ("drm/msm/gpu: Convert the GPU show function to use the GPU state")
Cc: stable <stable@vger.kernel.org>     # 4.18
Cc: Jordan Crouse <jcrouse@codeaurora.org>
Cc: Rob Clark <robdclark@gmail.com>
Reviewed-by: Rob Clark <robdclark@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Sean Paul <seanpaul@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20191010131333.23635-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/msm/msm_debugfs.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/gpu/drm/msm/msm_debugfs.c
+++ b/drivers/gpu/drm/msm/msm_debugfs.c
@@ -47,12 +47,8 @@ static int msm_gpu_release(struct inode
 	struct msm_gpu_show_priv *show_priv = m->private;
 	struct msm_drm_private *priv = show_priv->dev->dev_private;
 	struct msm_gpu *gpu = priv->gpu;
-	int ret;
-
-	ret = mutex_lock_interruptible(&show_priv->dev->struct_mutex);
-	if (ret)
-		return ret;
 
+	mutex_lock(&show_priv->dev->struct_mutex);
 	gpu->funcs->gpu_state_put(show_priv->state);
 	mutex_unlock(&show_priv->dev->struct_mutex);
 


