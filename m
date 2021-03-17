Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 198A333F5D3
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 17:46:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232688AbhCQQp2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 12:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232584AbhCQQpQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Mar 2021 12:45:16 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D96C061764
        for <stable@vger.kernel.org>; Wed, 17 Mar 2021 09:45:16 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id si25so3699000ejb.1
        for <stable@vger.kernel.org>; Wed, 17 Mar 2021 09:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RsUSbbA0uHXEjQnHfQBh5T5niyqZj1SUeATSCdO5Phc=;
        b=jg6ZPj1GHBpg+UNu/STxxmogka909uzVVaw+ssSVXAdM/KMtvydNTh88SL+rFl8xMH
         +QfuHHwPAzxYC2YmhThgtl813p63/Ry8nU/UskQir83ZmLPQXxSxACUDnkQC6eMNisRd
         7QtVD6O7UFXWb4tsFPCVzueoAvMgOwjE9Uowo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RsUSbbA0uHXEjQnHfQBh5T5niyqZj1SUeATSCdO5Phc=;
        b=nigTX2m4/JjMwNyrEFD4qI7i609HDzCtLCfzsX+siauqnT6LP9/0uOrVN0Ev6fHBxV
         CO4p/hlNzKrGJUbxUme5EAUCipw85qVtg3ol0lfrRtYZBEnfqqusHIJBDeEmK4HfdFOG
         7LvKl1M1idEcjJZLyth8HkujcidcQR1qaSyJTPOs+9ZJ0+Vuobh/Qb0zusumE/q0cIku
         ICmFSyjPTkcV42fIndq4xxYQVSrpW/gTh7YYwBjGRN6FJA5OImw+GjPSpjeG/sOfRZL3
         zBswJW6MBo+un1O6J55JX6SbSa4gLXnaZ4RhXJNlEerJnr5fZcsfhZQX1RdDDh8EFokp
         nAzw==
X-Gm-Message-State: AOAM5325NbL4NtJ7sjo8x69VSeO/DHZzK5eQcQEcvjof120oE53URUNz
        Xh+zEO1Tlmc9LWApdL6lOnJ3xw==
X-Google-Smtp-Source: ABdhPJynhE7YLiG6iyloZwjrJRRnijrWnDf9IIf390NyBfGxnbXR6RgActfTxqcn3/4CR4Vnj4aivw==
X-Received: by 2002:a17:906:fc1c:: with SMTP id ov28mr36496205ejb.342.1615999515294;
        Wed, 17 Mar 2021 09:45:15 -0700 (PDT)
Received: from alco.lan ([80.71.134.83])
        by smtp.gmail.com with ESMTPSA id hy25sm12088128ejc.119.2021.03.17.09.45.14
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
Subject: [PATCH v6 02/17] media: v4l2-ioctl: check_ext_ctrls: Return -EINVAL on V4L2_CTRL_WHICH_REQUEST_VAL
Date:   Wed, 17 Mar 2021 17:44:56 +0100
Message-Id: <20210317164511.39967-3-ribalda@chromium.org>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
In-Reply-To: <20210317164511.39967-1-ribalda@chromium.org>
References: <20210317164511.39967-1-ribalda@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Drivers that do not use the ctrl-framework use this function instead.

- Return -EINVAL for request_api calls

Fixes v4l2-compliance:
Buffer ioctls (Input 0):
		fail: v4l2-test-buffers.cpp(1994): ret != EINVAL && ret != EBADR && ret != ENOTTY
	test Requests: FAIL

Cc: stable@vger.kernel.org
Fixes: 6fa6f831f095 ("media: v4l2-ctrls: add core request support")
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 403f957a1012..76e2e595d88d 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -931,6 +931,8 @@ static bool check_ext_ctrls(struct v4l2_ext_controls *c, unsigned long ioctl)
 	case V4L2_CTRL_WHICH_DEF_VAL:
 	case V4L2_CTRL_WHICH_CUR_VAL:
 		return true;
+	case V4L2_CTRL_WHICH_REQUEST_VAL:
+		return false;
 	}
 
 	/* Check that all controls are from the same control class. */
-- 
2.31.0.rc2.261.g7f71774620-goog

