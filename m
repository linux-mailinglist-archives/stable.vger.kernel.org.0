Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0006D2A98
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 15:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387873AbfJJNOi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 09:14:38 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:39234 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727788AbfJJNOi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Oct 2019 09:14:38 -0400
Received: by mail-lj1-f195.google.com with SMTP id y3so6161668ljj.6;
        Thu, 10 Oct 2019 06:14:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7uV6DWb+5d+72lobYH9RlUHuo93UKxieqoJDmd2AkLE=;
        b=oXQr5K5AknmV7WOzIin2s0bc0UXSpL0sEbz5ZC7mWHK/Bna1bF0mswJNeGG1izrqEk
         HglDUe5pmeQk75c8IwkKyig/ND+fh+zwNHC1twqSJuHX4cvleN+woZqaMPzW1MIG3L7a
         bCEeIWmT+CuCv/I3uxDoiq9/NHRPo2uZQi9wWwnZk+W71el3Bl0C4Bh3E116gT49eZgr
         YCZrwzJFxS0DOju8ct9fGhAGby2z+Y4cnCN5GO34He4NKhcAgD1BCjFAOw84RE1OUX/u
         POxbm/sRphFQ+PJqP3RcneVkT3b+MVOHx/wx2H7ljYLexVweplYDx3jyNDhJWnh7Knrf
         +jnA==
X-Gm-Message-State: APjAAAWzC/PNl+MBM3Z6U+4v3lAPhG2whTyBVZ+VMo8aM9O7I36g5CUj
        0Hvq9Ffa025jCOkbtoVUpeI=
X-Google-Smtp-Source: APXvYqzFKhC+O0enYQEtd6+xCyXriydLhbwo0jiMAK6X/4MJHrEhzIRCF056ErjC0uEfoKkbTLxJHw==
X-Received: by 2002:a2e:8ec2:: with SMTP id e2mr5820909ljl.126.1570713275165;
        Thu, 10 Oct 2019 06:14:35 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id k7sm1184634lja.19.2019.10.10.06.14.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Oct 2019 06:14:34 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@xi.terra>)
        id 1iIYHF-0006Ak-Dh; Thu, 10 Oct 2019 15:14:45 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Rob Clark <robdclark@gmail.com>, Sean Paul <sean@poorly.run>,
        Fabien Dessenne <fabien.dessenne@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Harald Freudenberger <freude@linux.ibm.com>
Cc:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org,
        freedreno@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-s390@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>,
        Jordan Crouse <jcrouse@codeaurora.org>
Subject: [PATCH 1/4] drm/msm: fix memleak on release
Date:   Thu, 10 Oct 2019 15:13:30 +0200
Message-Id: <20191010131333.23635-2-johan@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010131333.23635-1-johan@kernel.org>
References: <20191010131333.23635-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If a process is interrupted while accessing the "gpu" debugfs file and
the drm device struct_mutex is contended, release() could return early
and fail to free related resources.

Note that the return value from release() is ignored.

Fixes: 4f776f4511c7 ("drm/msm/gpu: Convert the GPU show function to use the GPU state")
Cc: stable <stable@vger.kernel.org>     # 4.18
Cc: Jordan Crouse <jcrouse@codeaurora.org>
Cc: Rob Clark <robdclark@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/gpu/drm/msm/msm_debugfs.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_debugfs.c b/drivers/gpu/drm/msm/msm_debugfs.c
index 6be879578140..1c74381a4fc9 100644
--- a/drivers/gpu/drm/msm/msm_debugfs.c
+++ b/drivers/gpu/drm/msm/msm_debugfs.c
@@ -47,12 +47,8 @@ static int msm_gpu_release(struct inode *inode, struct file *file)
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
 
-- 
2.23.0

