Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 087FD243A8
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 00:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727305AbfETWum (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 18:50:42 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:36227 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727196AbfETWul (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 May 2019 18:50:41 -0400
Received: by mail-lf1-f68.google.com with SMTP id y10so11554113lfl.3;
        Mon, 20 May 2019 15:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ac7TQ4ujVvfet50jbWLw6JGAohNWebHPX6f3FbrcGJ4=;
        b=rCzSQ67vnZGlOVXsugoFieUtvj6BnTCOzPtCHFUgnONFYK2ZLbURgrsHgDb0hTl5Ax
         XObRKBZZPUov1LAGlHh5hXpNdIVZjMrFrq1arc42OfApH/iQ2SMGxSmmQYgG8QjomtKs
         okL+AwOlLGCjTK7mI5Huivq/P9GVNNLPSoLIRsmoCFkGVWMClPMIH2QqhJPQzUlE51oC
         vhJx36kwK5ULdpc28QTV3XhjxnynZCZVKPSFzq4AGvW/v0NmXwYUsNY5cWPr1mqFGLoa
         vy4q3y/WQwWFkzEdodsfANW34e7ZjFYXNhCpZANvDV6g+UNsAoIRuJFlV5mSig/bbaIv
         n4lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ac7TQ4ujVvfet50jbWLw6JGAohNWebHPX6f3FbrcGJ4=;
        b=G727zb27rxuK8iK4q5t7qKf5tyVEO3gg0oQAzoVJe/Pr4JP9YkiUWtBuePfXrD8KgI
         1fB7o2hrUK4c8QmIeFfVH1ZYptHHYXaNTPqGgkEVb9OLwcIuDkE0j1D7J9Fs8N1j0yZu
         bbXDNn46Sm1svDy7mgxyORIiFQ6KpxddPCqietUDFqldC2T5yzlIHATfbFmb+jHq3fAR
         lM5opmAa4atZX5LOXdtfQ4Iey0pm0LKc4xRGYYZu+EMRMiSmVIxk7AOKWy811BG+xwRY
         1uu184edp7UmR8hX1RPSOgWW88Bc73MqTO8/v+5DCGYcrv0CL47DwfVTEOCRvje4cYu/
         hwOQ==
X-Gm-Message-State: APjAAAXfl68guosXpDQ0aCipSZ4hfeJNn7IHi98zINN4vxrNYdJPdkAp
        YK0dhZxN99paZFG3RHj/KytzKjpXA18=
X-Google-Smtp-Source: APXvYqzHU+ovEVdBl7FXjv7pkKgem5lpEp9jZD3+A6zu+27COPsYF9G73Dtu787XGlGX571LfzIH6Q==
X-Received: by 2002:a19:1dc3:: with SMTP id d186mr36984133lfd.101.1558392638542;
        Mon, 20 May 2019 15:50:38 -0700 (PDT)
Received: from z50.gdansk-morena.vectranet.pl (109241207190.gdansk.vectranet.pl. [109.241.207.190])
        by smtp.gmail.com with ESMTPSA id t13sm2371646lji.47.2019.05.20.15.50.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 15:50:37 -0700 (PDT)
From:   Janusz Krzysztofik <jmkrzyszt@gmail.com>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 7/9] media: ov6650: Fix default format not applied on device probe
Date:   Tue, 21 May 2019 00:50:05 +0200
Message-Id: <20190520225007.2308-8-jmkrzyszt@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520225007.2308-1-jmkrzyszt@gmail.com>
References: <20190520225007.2308-1-jmkrzyszt@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It is not clear what pixel format is actually configured in hardware on
reset.  MEDIA_BUS_FMT_YUYV8_2X8, assumed on device probe since the
driver was intiially submitted, is for sure not the one.

Fix it by explicitly applying a known, driver default frame format just
after initial device reset.

Fixes: 2f6e2404799a ("[media] SoC Camera: add driver for OV6650 sensor")
Signed-off-by: Janusz Krzysztofik <jmkrzyszt@gmail.com>
Cc: stable@vger.kernel.org
---
 drivers/media/i2c/ov6650.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ov6650.c b/drivers/media/i2c/ov6650.c
index 1915a43bff87..b199332f62d7 100644
--- a/drivers/media/i2c/ov6650.c
+++ b/drivers/media/i2c/ov6650.c
@@ -876,6 +876,11 @@ static int ov6650_video_probe(struct v4l2_subdev *sd)
 	ret = ov6650_reset(client);
 	if (!ret)
 		ret = ov6650_prog_dflt(client);
+	if (!ret) {
+		struct v4l2_mbus_framefmt mf = ov6650_def_fmt;
+
+		ret = ov6650_s_fmt(sd, &mf);
+	}
 	if (!ret)
 		ret = v4l2_ctrl_handler_setup(&priv->hdl);
 
@@ -1030,8 +1035,6 @@ static int ov6650_probe(struct i2c_client *client,
 	priv->rect.top	  = DEF_VSTRT << 1;
 	priv->rect.width  = W_CIF;
 	priv->rect.height = H_CIF;
-	priv->half_scale  = false;
-	priv->code	  = MEDIA_BUS_FMT_YUYV8_2X8;
 
 	priv->subdev.internal_ops = &ov6650_internal_ops;
 	priv->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
-- 
2.21.0

