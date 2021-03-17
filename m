Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2505A33F5D6
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 17:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232349AbhCQQp2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 12:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232588AbhCQQpR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Mar 2021 12:45:17 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3147FC061760
        for <stable@vger.kernel.org>; Wed, 17 Mar 2021 09:45:17 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id lr13so3677810ejb.8
        for <stable@vger.kernel.org>; Wed, 17 Mar 2021 09:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6LTbHcBkbhI/FZJhKqlMKcO/iXlDKvIfShPxPGQCwfU=;
        b=h446286+JeMUfkpECC0Dvil4bzsjcvh9X8FbvNusKHX+x97NsTfbYQ1iGb2kmxbXXy
         UzIQttGHFyOnQouYYkXoFiBlVtCi2qCSB9A2fZ5oy/kzl2KImL2CpEJfOvbrxGOmTcSl
         frQTa9exOxNrMOk5NXg0141v2ce34vceXqC7c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6LTbHcBkbhI/FZJhKqlMKcO/iXlDKvIfShPxPGQCwfU=;
        b=ipzJ+ELBCTGyDNBArGpukvgkX7Fqrhn8z11x7FDPwtXzErCwqWgYpMfDYSKQWe+xlp
         gGzQOyGWski2mIAy81jPI+Uk8xm4bj1r/bFX3VuXWNcEDEY46YZuEdtyi9524Z5SLcjS
         Zia6cbARAOBcHnQvGE3m3AP9vlrK1Ird8tgLfi6fdjjauVxF10h5AM1legyWzibKEgtd
         6CiqfhT5vQ8RzGPCGV7AubMwnL1F6Txu9NoEgTWhmXpyAw5sf7oiTTWf4/cDsT8tPaIS
         oE/O3qYmDAomJlRmrzDwVKlDtR0Q4BiTR4Wi+DyOnLH5ipm5I8RZ6ISnoEY+wF08WDVj
         tW3Q==
X-Gm-Message-State: AOAM531V+LD1naKsD3Lr59x5zOv4DVT8Ui2BI++FaR12YaJx+ceSLaV3
        qS7SMgvRxB9e8XrqJxpjFP6KOw==
X-Google-Smtp-Source: ABdhPJz6xT+6FSrpNmMsQ/x+ZrKh5p+Gr3i7+g/+7nwYL130KZTbLH7b9dgxPKD+mX7n3MXSupooYQ==
X-Received: by 2002:a17:906:5e4a:: with SMTP id b10mr36514341eju.116.1615999515929;
        Wed, 17 Mar 2021 09:45:15 -0700 (PDT)
Received: from alco.lan ([80.71.134.83])
        by smtp.gmail.com with ESMTPSA id hy25sm12088128ejc.119.2021.03.17.09.45.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 09:45:15 -0700 (PDT)
From:   Ricardo Ribalda <ribalda@chromium.org>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        tfiga@chromium.org
Cc:     Ricardo Ribalda <ribalda@chromium.org>, stable@vger.kernel.org
Subject: [PATCH v6 03/17] media: v4l2-ioctl: check_ext_ctrls: Return the right error_idx
Date:   Wed, 17 Mar 2021 17:44:57 +0100
Message-Id: <20210317164511.39967-4-ribalda@chromium.org>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
In-Reply-To: <20210317164511.39967-1-ribalda@chromium.org>
References: <20210317164511.39967-1-ribalda@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Drivers that do not use the ctrl-framework use this function instead.

- Return the right error_idx

If an error is found when validating the list of controls passed with
VIDIOC_G_EXT_CTRLS, then error_idx shall be set to ctrls->count to
indicate to userspace that no actual hardware was touched.

It would have been much nicer of course if error_idx could point to the
control index that failed the validation, but sadly that's not how the
API was designed.

Fixes v4l2-compliance:
Control ioctls (Input 0):
        warn: v4l2-test-controls.cpp(834): error_idx should be equal to count
        warn: v4l2-test-controls.cpp(855): error_idx should be equal to count

Cc: stable@vger.kernel.org
Fixes: 6fa6f831f095 ("media: v4l2-ctrls: add core request support")
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 76e2e595d88d..528eb5f420f6 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -932,13 +932,14 @@ static bool check_ext_ctrls(struct v4l2_ext_controls *c, unsigned long ioctl)
 	case V4L2_CTRL_WHICH_CUR_VAL:
 		return true;
 	case V4L2_CTRL_WHICH_REQUEST_VAL:
+		c->error_idx = c->count;
 		return false;
 	}
 
 	/* Check that all controls are from the same control class. */
 	for (i = 0; i < c->count; i++) {
 		if (V4L2_CTRL_ID2WHICH(c->controls[i].id) != c->which) {
-			c->error_idx = i;
+			c->error_idx = ioctl == VIDIOC_TRY_EXT_CTRLS ? i : c->count;
 			return false;
 		}
 	}
-- 
2.31.0.rc2.261.g7f71774620-goog

