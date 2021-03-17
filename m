Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3F633F5D4
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 17:46:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbhCQQpb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 12:45:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232622AbhCQQpS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Mar 2021 12:45:18 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC0BC06175F
        for <stable@vger.kernel.org>; Wed, 17 Mar 2021 09:45:17 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id ox4so3655142ejb.11
        for <stable@vger.kernel.org>; Wed, 17 Mar 2021 09:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2RKdLF2sp2nWSuacDzuOWi0sXk9JfjBGvDHGz4cIafk=;
        b=k+ThYHIuc2NjaaoljJGSTYAoaeumkGrLMqub4uoq2IJOu9R6RS6ItFvAfsa9qHTzaM
         dmoQUa8W2Vi/BVV1WnZ8tfQGvaDN4N8dfCmVz4sPRHMiafkcczuI3fHJmMu5rNFqo5qD
         r/lPPo2VOIKgTc/4+CPvXYKkjYrcA/dpIP6+U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2RKdLF2sp2nWSuacDzuOWi0sXk9JfjBGvDHGz4cIafk=;
        b=cFdRm07KqekXUeVZhq4DVh3rpViGDoD2GiRV5h338RqeU26gspoAFvW/xkQmWpDcEm
         BYVQW677Q22TfcFsCJ9y3Ea0UaJb+BkrDU0G1CecxHNks/9B16bNYWIzwvw1hxgGZuu8
         nVxm2h+EsfgHWknINj/pXTXFqMalyM0qbFyriWRVz8utf0L+dWCnY6KzMlUSY4+X8hNE
         YZqRT2z8TFHDBsJa6tDYGbDBhHh2JjQbRYaPdMW4XFyZmka1Hh1mtuaDEDYYxUWLWlAi
         VN0AmKOrJqP7Pt81pfoMlHBKYB8L4ZFtoqBoq321/amc7J6dgWc8Ttg+FKcg/ai5yir3
         sc2Q==
X-Gm-Message-State: AOAM532Aqs5xgi+JzZEq3Rk0ZxRmlelKNrbLmAVmyvCHbqom2wunnU7t
        djqHES3fFkppPRYppwn/gEcrig==
X-Google-Smtp-Source: ABdhPJxuo4TqX+Yg1mQ91PFK4dVRStVJ2t6QskXUJYwNt3RwiDJfOQRgc2hpwcP2MOVLPJoil6lMIw==
X-Received: by 2002:a17:906:22d2:: with SMTP id q18mr36389148eja.437.1615999516492;
        Wed, 17 Mar 2021 09:45:16 -0700 (PDT)
Received: from alco.lan ([80.71.134.83])
        by smtp.gmail.com with ESMTPSA id hy25sm12088128ejc.119.2021.03.17.09.45.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 09:45:16 -0700 (PDT)
From:   Ricardo Ribalda <ribalda@chromium.org>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        tfiga@chromium.org
Cc:     Ricardo Ribalda <ribalda@chromium.org>, stable@vger.kernel.org
Subject: [PATCH v6 04/17] media: v4l2-ioctl: check_ext_ctrls: Fix V4L2_CTRL_WHICH_DEF_VAL
Date:   Wed, 17 Mar 2021 17:44:58 +0100
Message-Id: <20210317164511.39967-5-ribalda@chromium.org>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
In-Reply-To: <20210317164511.39967-1-ribalda@chromium.org>
References: <20210317164511.39967-1-ribalda@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Drivers that do not use the ctrl-framework use this function instead.

Default value cannot be changed, return EINVAL as soon as possible.

Cc: stable@vger.kernel.org
Fixes: 6fa6f831f095 ("media: v4l2-ctrls: add core request support")
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 528eb5f420f6..ccd21b4d9c72 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -929,6 +929,13 @@ static bool check_ext_ctrls(struct v4l2_ext_controls *c, unsigned long ioctl)
 			return false;
 		break;
 	case V4L2_CTRL_WHICH_DEF_VAL:
+		/* Default value cannot be changed */
+		if (ioctl == VIDIOC_S_EXT_CTRLS ||
+		    ioctl == VIDIOC_TRY_EXT_CTRLS) {
+			c->error_idx = c->count;
+			return false;
+		}
+		return true;
 	case V4L2_CTRL_WHICH_CUR_VAL:
 		return true;
 	case V4L2_CTRL_WHICH_REQUEST_VAL:
-- 
2.31.0.rc2.261.g7f71774620-goog

