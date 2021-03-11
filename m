Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E56923374A3
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 14:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233798AbhCKNul (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 08:50:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233678AbhCKNuk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 08:50:40 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C3CCC061574
        for <stable@vger.kernel.org>; Thu, 11 Mar 2021 05:50:39 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id j3so2849693edp.11
        for <stable@vger.kernel.org>; Thu, 11 Mar 2021 05:50:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Q1DGKsTr9REpSe+LIHgT2CR/kX2zCTaPdy5dQ7gbqsY=;
        b=AnnmfsHK6LUVCoklpMLiOpQgfHg+xYzvpok0NBXBur9Mgw94jQ6KqzH/yvT3EhEz5p
         QaRUT6XQHeVNGLeJ3nl4MTtEeyy241oNjTM2yZJcGr2yf6d/dNMSyKvCchpFrjBIC4x9
         UuuWC6r0LDwi8PjhqHewzmcUbKqYW8AS4BgDY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Q1DGKsTr9REpSe+LIHgT2CR/kX2zCTaPdy5dQ7gbqsY=;
        b=o+UcaONCLXz3sCJLztyejcNMLiTKu/JX10ST5GbUdyDGvgTLjGAX/IKS3CWogM8IrJ
         zYeTzF7sFuIaKgLkdXRkEOdBI0D1DYd507yfUAZiwOv1Po9M+p0ct94SmAa5kIY3/5CL
         dvtUAvsGFPV944oOpN07RmaKrL6uh+dHeBfJoVfTNwxIvA85Il6wegO1uKz013hMDy/+
         3RdCZICB1kahNAwUidd3Yde8RqdP7J6rW/5Sg5ORf2t5Yq0HKgALBviUKfZdCyq7Ln69
         FjT9rSk0dv8TfFWtL9H9EzE/xlpIsqw3hXffvRP+zuiIDgtXlZpbU1DVUt2taThoRNur
         VekA==
X-Gm-Message-State: AOAM533IiY1oBAsBuRw4FIHSc2CcTMxA39aUFgbZyKsXiy3nGbn/lnHn
        rxkNSxTCCA9lACBVcWZDFcl6ICzNluBVY8WnxRM=
X-Google-Smtp-Source: ABdhPJwYp0jCiWbrMqxCRs9bS7ZmwlkvSD21K4wgP8FHeY8o/uiuNF3sJmJx6CZKmiJbuiRP3EOAHw==
X-Received: by 2002:a05:6402:48c:: with SMTP id k12mr8589635edv.237.1615470634904;
        Thu, 11 Mar 2021 05:50:34 -0800 (PST)
Received: from alco.lan ([80.71.134.83])
        by smtp.gmail.com with ESMTPSA id a12sm1308567ejj.121.2021.03.11.05.50.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 05:50:34 -0800 (PST)
From:   Ricardo Ribalda <ribalda@chromium.org>
To:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ricardo Ribalda <ribalda@chromium.org>, stable@vger.kernel.org
Subject: [PATCH] media: v4l2-ioctl: Fix check_ext_ctrls
Date:   Thu, 11 Mar 2021 14:50:32 +0100
Message-Id: <20210311135032.1287187-1-ribalda@chromium.org>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Drivers that do not use the ctrl-framework use this function instead.

- Return error when handling of REQUEST_VAL.
- Do not check for multiple classes when getting the DEF_VAL.

Fixes v4l2-compliance:
Control ioctls (Input 0):
		fail: v4l2-test-controls.cpp(813): doioctl(node, VIDIOC_G_EXT_CTRLS, &ctrls)
	test VIDIOC_G/S/TRY_EXT_CTRLS: FAIL

Cc: stable@vger.kernel.org
Fixes: 6fa6f831f095 ("media: v4l2-ctrls: add core request support")
Suggested-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 31d1342e61e8..6f6b310e2802 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -924,8 +924,10 @@ static int check_ext_ctrls(struct v4l2_ext_controls *c, int allow_priv)
 	 */
 	if (!allow_priv && c->which == V4L2_CID_PRIVATE_BASE)
 		return 0;
-	if (!c->which)
+	if (!c->which || c->which == V4L2_CTRL_WHICH_DEF_VAL)
 		return 1;
+	if (c->which == V4L2_CTRL_WHICH_REQUEST_VAL)
+		return 0;
 	/* Check that all controls are from the same control class. */
 	for (i = 0; i < c->count; i++) {
 		if (V4L2_CTRL_ID2WHICH(c->controls[i].id) != c->which) {
-- 
2.31.0.rc2.261.g7f71774620-goog

