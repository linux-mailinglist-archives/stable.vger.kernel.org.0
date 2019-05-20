Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32F1B243A4
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 00:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbfETWuh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 18:50:37 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:45934 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727196AbfETWug (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 May 2019 18:50:36 -0400
Received: by mail-lf1-f66.google.com with SMTP id n22so11485163lfe.12;
        Mon, 20 May 2019 15:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GUZxpMDqtDXRtd7DwTkXbKuXR33GC+jnjVnA6aq1s9o=;
        b=nxKmT32RtCEAuuCt/tDjVV6SFEd84nudD/RH5wl/LxU/ygz6ew2N6mToZpXbfrcm2j
         KdczGzi7A4Z+I62nbrImBLcDeNVl/cRdw45m3tq7OxwUJUAtK6yJMXLLbetlVGPsmXwK
         O+gHBCuwXlWT+DbyJhWlALbIVrmAVTf1bJD6Wn6TBKhNtZ8k9nHq28Xq7qdv/i5rnDZd
         xbVa+3n3qj/ZBaaS9/GUd22XjLYQAi7XXZBY4j34fXYYTwoPCXUr3ly4Ni3lQNPFBe9A
         bnRozVMj02D5nniBuVkouRvXpKC/aeDbU08Rcze4TZkUvVZ3T141oUxJqhQvzBMyuiyt
         Ua7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GUZxpMDqtDXRtd7DwTkXbKuXR33GC+jnjVnA6aq1s9o=;
        b=q3UCOh/YeB0CaaAkyVUEfN+u2lWbMN5W2ELcvMh2Dsz/lKwDYUuNuEZeNw94yLsM0o
         Z5rNlb6XbMHiacZZOBa0ZQvviDnxUGCmg9GK4Hf0UV1EjmJT2UJ90HWmbD8yMwRCwzGv
         9dE3tKR5x/DIfVfeWQKbIB3DO1YxAea9T0JaskKbHSGtC6M8I65EjkIOPUKzuhr81Edr
         1hCy9Ta8utdv6vh6OwGL/adC7gNwh8W7inp5Gk+OhBgxIYWkbPxh0lkjSarz14xb1Ek1
         H3qQx1eekaSsNiHuP083hSN0cxkbmQjCRhIwH6YK645cUsuR+6QFdumk6aDwKd782SUQ
         f4nQ==
X-Gm-Message-State: APjAAAVAdCBg+hG7jGHNj+eVEEeQjJaW49SyhC1KJovyNV/BeNViM99o
        NjRmcFn43nV0xJ9FxyAUIB4=
X-Google-Smtp-Source: APXvYqwU72a9Fj8I690R6OEe7yvwXBXYXvZoJsZEmBq1oUxROyRDx1vAkdHGJzbNjTPk2JuU26vIHg==
X-Received: by 2002:ac2:5385:: with SMTP id g5mr5154504lfh.55.1558392633817;
        Mon, 20 May 2019 15:50:33 -0700 (PDT)
Received: from z50.gdansk-morena.vectranet.pl (109241207190.gdansk.vectranet.pl. [109.241.207.190])
        by smtp.gmail.com with ESMTPSA id t13sm2371646lji.47.2019.05.20.15.50.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 15:50:33 -0700 (PDT)
From:   Janusz Krzysztofik <jmkrzyszt@gmail.com>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 3/9] media: ov6650: Fix crop rectangle alignment not passed back
Date:   Tue, 21 May 2019 00:50:01 +0200
Message-Id: <20190520225007.2308-4-jmkrzyszt@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520225007.2308-1-jmkrzyszt@gmail.com>
References: <20190520225007.2308-1-jmkrzyszt@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 4f996594ceaf ("[media] v4l2: make vidioc_s_crop const")
introduced a writable copy of constified user requested crop rectangle
in order to be able to perform hardware alignments on it.  Later
on, commit 10d5509c8d50 ("[media] v4l2: remove g/s_crop from video
ops") replaced s_crop() video operaion using that const argument with
set_selection() pad operation which had a corresponding argument not
constified, however the original behavior of the driver was not
restored.  Since that time, any hardware alignment applied on a user
requested crop rectangle is not passed back to the user calling
.set_selection() as it should be.

Fix the issue by dropping the copy and replacing all references to it
with references to the crop rectangle embedded in the user argument.

Fixes: 10d5509c8d50 ("[media] v4l2: remove g/s_crop from video ops")
Signed-off-by: Janusz Krzysztofik <jmkrzyszt@gmail.com>
Cc: stable@vger.kernel.org
---
 drivers/media/i2c/ov6650.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/media/i2c/ov6650.c b/drivers/media/i2c/ov6650.c
index 007f0ca24913..751b48483f27 100644
--- a/drivers/media/i2c/ov6650.c
+++ b/drivers/media/i2c/ov6650.c
@@ -468,38 +468,37 @@ static int ov6650_set_selection(struct v4l2_subdev *sd,
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct ov6650 *priv = to_ov6650(client);
-	struct v4l2_rect rect = sel->r;
 	int ret;
 
 	if (sel->which != V4L2_SUBDEV_FORMAT_ACTIVE ||
 	    sel->target != V4L2_SEL_TGT_CROP)
 		return -EINVAL;
 
-	v4l_bound_align_image(&rect.width, 2, W_CIF, 1,
-			      &rect.height, 2, H_CIF, 1, 0);
-	v4l_bound_align_image(&rect.left, DEF_HSTRT << 1,
-			      (DEF_HSTRT << 1) + W_CIF - (__s32)rect.width, 1,
-			      &rect.top, DEF_VSTRT << 1,
-			      (DEF_VSTRT << 1) + H_CIF - (__s32)rect.height, 1,
-			      0);
+	v4l_bound_align_image(&sel->r.width, 2, W_CIF, 1,
+			      &sel->r.height, 2, H_CIF, 1, 0);
+	v4l_bound_align_image(&sel->r.left, DEF_HSTRT << 1,
+			      (DEF_HSTRT << 1) + W_CIF - (__s32)sel->r.width, 1,
+			      &sel->r.top, DEF_VSTRT << 1,
+			      (DEF_VSTRT << 1) + H_CIF - (__s32)sel->r.height,
+			      1, 0);
 
-	ret = ov6650_reg_write(client, REG_HSTRT, rect.left >> 1);
+	ret = ov6650_reg_write(client, REG_HSTRT, sel->r.left >> 1);
 	if (!ret) {
-		priv->rect.left = rect.left;
+		priv->rect.left = sel->r.left;
 		ret = ov6650_reg_write(client, REG_HSTOP,
-				(rect.left + rect.width) >> 1);
+				       (sel->r.left + sel->r.width) >> 1);
 	}
 	if (!ret) {
-		priv->rect.width = rect.width;
-		ret = ov6650_reg_write(client, REG_VSTRT, rect.top >> 1);
+		priv->rect.width = sel->r.width;
+		ret = ov6650_reg_write(client, REG_VSTRT, sel->r.top >> 1);
 	}
 	if (!ret) {
-		priv->rect.top = rect.top;
+		priv->rect.top = sel->r.top;
 		ret = ov6650_reg_write(client, REG_VSTOP,
-				(rect.top + rect.height) >> 1);
+				       (sel->r.top + sel->r.height) >> 1);
 	}
 	if (!ret)
-		priv->rect.height = rect.height;
+		priv->rect.height = sel->r.height;
 
 	return ret;
 }
-- 
2.21.0

