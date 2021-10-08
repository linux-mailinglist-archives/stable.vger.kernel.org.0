Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07531426760
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 12:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239614AbhJHKIH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 06:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239608AbhJHKIG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 06:08:06 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF978C061760
        for <stable@vger.kernel.org>; Fri,  8 Oct 2021 03:06:11 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id u7so7752852pfg.13
        for <stable@vger.kernel.org>; Fri, 08 Oct 2021 03:06:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0tE+OjKJHdX0YaSq/SP0LPgcFSSGhc57aktXdnN08Jk=;
        b=gOYHix4WHmVCBUetpODWqRHCtKw2zkRnlOzILi/AukbRmbFzIF1A3ycyJH5Uic3j49
         /kAhOSbW2sTpnedQcMvZ5FWgr/YAuVFNZuMd12Z5tSVWB+vGT1a5SazFy1uhjMuCZP4h
         d37OVXxIsaoh1xvhKMJvG9b2iq4QG4qjX47Ec=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0tE+OjKJHdX0YaSq/SP0LPgcFSSGhc57aktXdnN08Jk=;
        b=VAKajwH0jNh8HypKg/pE5IMKvmN8eOLwDZ7tcAoh2P1hter6JE3qDCDGMD7YfBedGB
         nosBG15Bu//L7cgCD6272OmqdGHq3/kWEDFwcARIDf6lH9VjOuc4k9sX2OvAujJF9G4d
         3E7OwVyhagCml+fUJwIoTRm42Ty6/DNYO0Dm2tUGHMbUHuUiSFS+8JIjRBPrpJfkpaHv
         lveMbmpXPBvbqE/Sb7pD8KpdSElXf8SLduGLP99LQ1ZHMnw4BwmzJjDbhNxiTJxM6cdj
         vbswYNrOJ5l2qGVjm42Kk5SunKSpmjzEm91+wRXYBD/Mhrl1nr5esc/zeF7rBS67++vX
         2Wrw==
X-Gm-Message-State: AOAM532yIzLVxsZx8E8V9SvZ/aXCPxCUC4YTHd8KObZ/62NX311C887Q
        qhSzgfaU+L73dOKobY0KFce3yA==
X-Google-Smtp-Source: ABdhPJzc7HT14HLpHSLUpV1/gyAWAvzuj5fhMf9NUQpi8wdgeaB/B5vf3GAOwmoRaa36zy9hWqZPcA==
X-Received: by 2002:a63:d34f:: with SMTP id u15mr3879802pgi.200.1633687571528;
        Fri, 08 Oct 2021 03:06:11 -0700 (PDT)
Received: from wenstp920.tpe.corp.google.com ([2401:fa00:1:10:ad8d:f936:2048:d735])
        by smtp.gmail.com with ESMTPSA id a7sm2082255pfn.150.2021.10.08.03.06.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 03:06:11 -0700 (PDT)
From:   Chen-Yu Tsai <wenst@chromium.org>
To:     Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Chen-Yu Tsai <wenst@chromium.org>, linux-media@vger.kernel.org,
        linux-rockchip@lists.infradead.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        stable@vger.kernel.org
Subject: [PATCH 2/2] media: rkvdec: Support dynamic resolution changes
Date:   Fri,  8 Oct 2021 18:04:23 +0800
Message-Id: <20211008100423.739462-3-wenst@chromium.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211008100423.739462-1-wenst@chromium.org>
References: <20211008100423.739462-1-wenst@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The mem-to-mem stateless decoder API specifies support for dynamic
resolution changes. In particular, the decoder should accept format
changes on the OUTPUT queue even when buffers have been allocated,
as long as it is not streaming.

Relax restrictions for S_FMT as described in the previous paragraph,
and as long as the codec format remains the same. This aligns it with
the Hantro and Cedrus decoders. This change was mostly based on commit
ae02d49493b5 ("media: hantro: Fix s_fmt for dynamic resolution changes").

Since rkvdec_s_fmt() is now just a wrapper around the output/capture
variants without any additional shared functionality, drop the wrapper
and call the respective functions directly.

Fixes: cd33c830448b ("media: rkvdec: Add the rkvdec driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
---
 drivers/staging/media/rkvdec/rkvdec.c | 40 +++++++++++++--------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/media/rkvdec/rkvdec.c b/drivers/staging/media/rkvdec/rkvdec.c
index 7131156c1f2c..3f3f96488d74 100644
--- a/drivers/staging/media/rkvdec/rkvdec.c
+++ b/drivers/staging/media/rkvdec/rkvdec.c
@@ -280,31 +280,20 @@ static int rkvdec_try_output_fmt(struct file *file, void *priv,
 	return 0;
 }
 
-static int rkvdec_s_fmt(struct file *file, void *priv,
-			struct v4l2_format *f,
-			int (*try_fmt)(struct file *, void *,
-				       struct v4l2_format *))
+static int rkvdec_s_capture_fmt(struct file *file, void *priv,
+				struct v4l2_format *f)
 {
 	struct rkvdec_ctx *ctx = fh_to_rkvdec_ctx(priv);
 	struct vb2_queue *vq;
+	int ret;
 
-	if (!try_fmt)
-		return -EINVAL;
-
-	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
+	/* Change not allowed if queue is busy */
+	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx,
+			     V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE);
 	if (vb2_is_busy(vq))
 		return -EBUSY;
 
-	return try_fmt(file, priv, f);
-}
-
-static int rkvdec_s_capture_fmt(struct file *file, void *priv,
-				struct v4l2_format *f)
-{
-	struct rkvdec_ctx *ctx = fh_to_rkvdec_ctx(priv);
-	int ret;
-
-	ret = rkvdec_s_fmt(file, priv, f, rkvdec_try_capture_fmt);
+	ret = rkvdec_try_capture_fmt(file, priv, f);
 	if (ret)
 		return ret;
 
@@ -319,9 +308,20 @@ static int rkvdec_s_output_fmt(struct file *file, void *priv,
 	struct v4l2_m2m_ctx *m2m_ctx = ctx->fh.m2m_ctx;
 	const struct rkvdec_coded_fmt_desc *desc;
 	struct v4l2_format *cap_fmt;
-	struct vb2_queue *peer_vq;
+	struct vb2_queue *peer_vq, *vq;
 	int ret;
 
+	/*
+	 * In order to support dynamic resolution change, the decoder admits
+	 * a resolution change, as long as the pixelformat remains. Can't be
+	 * done if streaming.
+	 */
+	vq = v4l2_m2m_get_vq(m2m_ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE);
+	if (vb2_is_streaming(vq) ||
+	    (vb2_is_busy(vq) &&
+	     f->fmt.pix_mp.pixelformat != ctx->coded_fmt.fmt.pix_mp.pixelformat))
+		return -EBUSY;
+
 	/*
 	 * Since format change on the OUTPUT queue will reset the CAPTURE
 	 * queue, we can't allow doing so when the CAPTURE queue has buffers
@@ -331,7 +331,7 @@ static int rkvdec_s_output_fmt(struct file *file, void *priv,
 	if (vb2_is_busy(peer_vq))
 		return -EBUSY;
 
-	ret = rkvdec_s_fmt(file, priv, f, rkvdec_try_output_fmt);
+	ret = rkvdec_try_output_fmt(file, priv, f);
 	if (ret)
 		return ret;
 
-- 
2.33.0.882.g93a45727a2-goog

