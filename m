Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD58338D6A
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 13:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbhCLMtF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 07:49:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbhCLMsf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Mar 2021 07:48:35 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4793C061763
        for <stable@vger.kernel.org>; Fri, 12 Mar 2021 04:48:34 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id j3so7782961edp.11
        for <stable@vger.kernel.org>; Fri, 12 Mar 2021 04:48:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DgS4OPGpMnlY/AXfZW8QgtbwbGQ3UnwEJWQevK1FyQM=;
        b=E945yJf+or8Jxcju5mpDSO/6oohXTDfECILGtiYrU68nu/5R38vqePEZ6dvUO/MZN8
         HTPxpFpNt+Mh50Jdxz/B+xyVwW4rUdfnzVZusoZkIeHWcl94QyvQKWW55R8MwXNsBQrz
         EEXKXCJ4vwwbqDAnUS422qV5FgSZ1G/M4PgW0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DgS4OPGpMnlY/AXfZW8QgtbwbGQ3UnwEJWQevK1FyQM=;
        b=jx7OxY+ubxRxZ+Z9YDRw1y7JMWAcXYDwekSqYAEzSQqArQI7Hswkni9o36F2p95Bvc
         FyvG4bKUTyfaoGPdEYpfB3vASX1l4abA1ZCWrAZvtlADhn9CbMCgSAXSx6n0A1OrXWQr
         YTw+5B3pv6CTR8tDSPX0upHyWqmngEJZaqGSWzNWJMf1JNPLEclhnJPzfdqMhjVs/FNi
         Hwmp52/4t1lq1RWtHQe3P2phCyiv6zN1bGQLkEV6pI7VVHoQYdLevnwno8cvc2LbnzUi
         kdFgYs7NdrlkfX+eWXZQbnsdddnDMUXDuJiy1lhLCDaUjtVv78tW+x3aUmzsgHuHGypq
         mEig==
X-Gm-Message-State: AOAM533eaTIc3cL9Nufzsf4jWAKVKlUOqqA4UWSKfTxRIxcug0cRmejw
        FGLJyAGYIk9Dlxj0OmSILxZ93Q==
X-Google-Smtp-Source: ABdhPJx+8HGUcTjQ8PTnKNCrJqTeaZPaHXaEXS2y8cErosfSD+ACa9ZjwZh+7FXP9ixs/+HJZHZLxQ==
X-Received: by 2002:a05:6402:350f:: with SMTP id b15mr13877735edd.6.1615553313665;
        Fri, 12 Mar 2021 04:48:33 -0800 (PST)
Received: from alco.lan ([80.71.134.83])
        by smtp.gmail.com with ESMTPSA id t6sm2924402edq.48.2021.03.12.04.48.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 04:48:33 -0800 (PST)
From:   Ricardo Ribalda <ribalda@chromium.org>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tomasz Figa <tfiga@chromium.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, senozhatsky@chromium.org,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Ricardo Ribalda <ribalda@chromium.org>, stable@vger.kernel.org,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH v3 1/8] media: v4l2-ioctl: Fix check_ext_ctrls
Date:   Fri, 12 Mar 2021 13:48:23 +0100
Message-Id: <20210312124830.1344255-2-ribalda@chromium.org>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
In-Reply-To: <20210312124830.1344255-1-ribalda@chromium.org>
References: <20210312124830.1344255-1-ribalda@chromium.org>
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
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 31d1342e61e8..9406e90ff805 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -917,15 +917,24 @@ static int check_ext_ctrls(struct v4l2_ext_controls *c, int allow_priv)
 	for (i = 0; i < c->count; i++)
 		c->controls[i].reserved2[0] = 0;
 
-	/* V4L2_CID_PRIVATE_BASE cannot be used as control class
-	   when using extended controls.
-	   Only when passed in through VIDIOC_G_CTRL and VIDIOC_S_CTRL
-	   is it allowed for backwards compatibility.
-	 */
-	if (!allow_priv && c->which == V4L2_CID_PRIVATE_BASE)
-		return 0;
-	if (!c->which)
+	switch (c->which) {
+	case V4L2_CID_PRIVATE_BASE:
+		/*
+		 * V4L2_CID_PRIVATE_BASE cannot be used as control class
+		 * when using extended controls.
+		 * Only when passed in through VIDIOC_G_CTRL and VIDIOC_S_CTRL
+		 * is it allowed for backwards compatibility.
+		*/
+		if (!allow_priv)
+			return 0;
+		break;
+	case V4L2_CTRL_WHICH_DEF_VAL:
+	case V4L2_CTRL_WHICH_CUR_VAL:
 		return 1;
+	case V4L2_CTRL_WHICH_REQUEST_VAL:
+		return 0;
+	}
+
 	/* Check that all controls are from the same control class. */
 	for (i = 0; i < c->count; i++) {
 		if (V4L2_CTRL_ID2WHICH(c->controls[i].id) != c->which) {
-- 
2.31.0.rc2.261.g7f71774620-goog

