Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 438A2243B6
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 00:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727362AbfETWu7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 18:50:59 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:44681 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727247AbfETWuj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 May 2019 18:50:39 -0400
Received: by mail-lf1-f68.google.com with SMTP id n134so11493253lfn.11;
        Mon, 20 May 2019 15:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rs6UcDEPHghR8cLHYXDtwpVUwKvGeIGqNO+qV7fU/Y8=;
        b=Jqqqv4aIPPFB3lnmqpiKFCGIvWuuiVwTcc37XWGSqmhI0OFXOUAnnjmVw3N/zaTUtz
         G/crC8GJVCjuhf3ukOFRt3otZI9d30YuH7EBKJCwd3OTdupVz+fARRwbn5OOyrNLV+Hl
         IMCqCfTiJ6RJvBuBM63CsA6Fg/HYcYz5XNf6bEvrKGJOq7+MN0WjW5NmyTtx287wnxPm
         iZJaZXXs/GqDNE7RuTx42l1VxspOY7RKv8Y513QClrMSC0B6sS2EQ2wBbJJ5jTFg9R07
         LMGF9SwBqMIWGxXAxswAi9ET/UMhuzUTFlj/12qdcU+tSNNB4zpsWKHaGnSm24QULiK1
         pamQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rs6UcDEPHghR8cLHYXDtwpVUwKvGeIGqNO+qV7fU/Y8=;
        b=h9ODroV/9CpLEuqBqWlHCx3VXvrkxcdsCy5qjFWB5WnMrSWh1J9at0p5ilJYsTr/D+
         wRTxXJCr3n8woDfAQ/Jo+XR98pBqlr0CRe/CrnayDCthsKVSiRZdv5hWUeCkdNhVlPdN
         TB9O35fM6V0a51RojVWGm1Mh8CcagMDzZ/9llLZhDQPN0Jr3e8NhJWPHbFuTqgwVr96+
         JqctAwwOrMF8D4FpPCXL3zcVNAly/0ZvKYOjGu9bRfGTZfbGTsHFnHJyxgsMRHiJrjVI
         nuTSigfe4Sgx7DLKU1K24xdgvz50vPl3Vbh5kXPu+tqvUTqB/3CB29ib99wygxMlANuw
         SOIQ==
X-Gm-Message-State: APjAAAXT/HnQEaoothdXRtZA6pyBwFovDS1Ejt7vnTwtI/JOXTMweP+E
        XbtPrcRNZg5i6LVK9tRvZOUQ3Y7IUBA=
X-Google-Smtp-Source: APXvYqz8K224U3tcSw51U0kihcPnj4Po/Sv2twtRlab76JyrMIb8ojrbaiLr9q6HXXiLZFQKQNz05g==
X-Received: by 2002:ac2:5986:: with SMTP id w6mr39346785lfn.147.1558392637317;
        Mon, 20 May 2019 15:50:37 -0700 (PDT)
Received: from z50.gdansk-morena.vectranet.pl (109241207190.gdansk.vectranet.pl. [109.241.207.190])
        by smtp.gmail.com with ESMTPSA id t13sm2371646lji.47.2019.05.20.15.50.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 15:50:36 -0700 (PDT)
From:   Janusz Krzysztofik <jmkrzyszt@gmail.com>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 6/9] media: ov6650: Fix .get_fmt() V4L2_SUBDEV_FORMAT_TRY support
Date:   Tue, 21 May 2019 00:50:04 +0200
Message-Id: <20190520225007.2308-7-jmkrzyszt@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520225007.2308-1-jmkrzyszt@gmail.com>
References: <20190520225007.2308-1-jmkrzyszt@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit da298c6d98d5 ("[media] v4l2: replace video op g_mbus_fmt by pad
op get_fmt") converted a former ov6650_g_fmt() video operation callback
to an ov6650_get_fmt() pad operation callback.  However, the converted
function disregards a format->which flag that pad operations should
obey and always returns active frame format settings.

That can be fixed by always responding to V4L2_SUBDEV_FORMAT_TRY with
-EINVAL, or providing the response from a pad config argument, likely
updated by a former user call to V4L2_SUBDEV_FORMAT_TRY .set_fmt().
Since implementation of the latter is trivial, go for it.

Fixes: da298c6d98d5 ("[media] v4l2: replace video op g_mbus_fmt by pad op get_fmt")
Signed-off-by: Janusz Krzysztofik <jmkrzyszt@gmail.com>
Cc: stable@vger.kernel.org
---
 drivers/media/i2c/ov6650.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/ov6650.c b/drivers/media/i2c/ov6650.c
index 731b03bef7a5..1915a43bff87 100644
--- a/drivers/media/i2c/ov6650.c
+++ b/drivers/media/i2c/ov6650.c
@@ -528,10 +528,16 @@ static int ov6650_get_fmt(struct v4l2_subdev *sd,
 	*mf = ov6650_def_fmt;
 
 	/* update media bus format code and frame size */
-	mf->width	= priv->rect.width >> priv->half_scale;
-	mf->height	= priv->rect.height >> priv->half_scale;
-	mf->code	= priv->code;
+	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
+		mf->width = cfg->try_fmt.width;
+		mf->height = cfg->try_fmt.height;
+		mf->code = cfg->try_fmt.code;
 
+	} else {
+		mf->width = priv->rect.width >> priv->half_scale;
+		mf->height = priv->rect.height >> priv->half_scale;
+		mf->code = priv->code;
+	}
 	return 0;
 }
 
-- 
2.21.0

