Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D41733801B
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 23:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbhCKWT5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 17:19:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbhCKWT4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 17:19:56 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D51C061761
        for <stable@vger.kernel.org>; Thu, 11 Mar 2021 14:19:55 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id mj10so49459532ejb.5
        for <stable@vger.kernel.org>; Thu, 11 Mar 2021 14:19:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Q1DGKsTr9REpSe+LIHgT2CR/kX2zCTaPdy5dQ7gbqsY=;
        b=VyGTzG3UDxX2AVr/ENSs72dd1Xpbh/janpCSJN1eZp+E6uer3fLRgARDoZJ+5ZwiYv
         vzqBpH6PYgtZ7YSKTsxEnxQqpOeF6dwNDSqN2NsmcIxPK8e1RUSMGEGp+8XjtF+WRRHn
         uzHw65F1WA9YUAsU1WevX+GWCDlLrUChJmIsk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q1DGKsTr9REpSe+LIHgT2CR/kX2zCTaPdy5dQ7gbqsY=;
        b=miaVJdyRwua43M1wEbkNxj6Z14naLCXYFcVQ+kzjUg0eQ4mMZkjqsm7gBt2+oBMsqX
         m28dBtYyfnshYE2z8zS4Gdoq5MHa+zP+u7ZanyEyUJ+3XIZCoa5xcIOgXVZ1AynlH1IF
         1Fs7hHg6m8QsAnI47yIdGxzmGcYSpxiOH19UJE0Nm5eOwlzquaGPiKheKn5dt1Kk2o3Z
         ngZKH6zkVUwa+/Y9cLNvBUJGVjBsFulzl5S/G8qnTITbqxAgTZY2QBpy/hACChhliLcA
         DensFFp/aIywUzbmFdEd1Pd1VEUw2+u0D2m/4Ze+ZCXKNkY7Fz0nhQZ2eaeehtluSEb4
         WPlg==
X-Gm-Message-State: AOAM532KGXIak6Tx42VGJD9NRKB3/D3SUX8fjs5tiVjDG+X6hvXwUjL7
        ynFGI3rPNQWPGxWekCJzSFpHFw==
X-Google-Smtp-Source: ABdhPJwqUWbm4aX6+ZLzkvDNfelWe4g7YJZNCrItVs9vWeFw0IfFuqck7yySaJCTWIHYnSY0SgokJw==
X-Received: by 2002:a17:906:ad85:: with SMTP id la5mr5256074ejb.37.1615501194661;
        Thu, 11 Mar 2021 14:19:54 -0800 (PST)
Received: from alco.lan ([80.71.134.83])
        by smtp.gmail.com with ESMTPSA id b18sm1942174ejb.77.2021.03.11.14.19.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 14:19:54 -0800 (PST)
From:   Ricardo Ribalda <ribalda@chromium.org>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tomasz Figa <tfiga@chromium.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, senozhatsky@chromium.org,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Ricardo Ribalda <ribalda@chromium.org>, stable@vger.kernel.org,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH v2 1/6] media: v4l2-ioctl: Fix check_ext_ctrls
Date:   Thu, 11 Mar 2021 23:19:41 +0100
Message-Id: <20210311221946.1319924-2-ribalda@chromium.org>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
In-Reply-To: <20210311221946.1319924-1-ribalda@chromium.org>
References: <20210311221946.1319924-1-ribalda@chromium.org>
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

