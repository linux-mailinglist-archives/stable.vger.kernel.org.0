Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18B34243AF
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 00:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725776AbfETWuu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 18:50:50 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:33055 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727290AbfETWum (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 May 2019 18:50:42 -0400
Received: by mail-lf1-f67.google.com with SMTP id x132so11556489lfd.0;
        Mon, 20 May 2019 15:50:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0nvd2DYrQvBH3dGTq9kzH5LJTcPqp85dy7QqoUBDBjE=;
        b=Gf+D6X9cPWOqVeDlgxTt8SSlfaMmhq74xwJEyiub9sUNQtEQtb7BHREXlA2qOsYpRq
         iV9LVEUzVJle/phhlhT2jNKTrZ0nLJYsV7jpyDA/rIMza51ypf9V9FvkECp/vwrOlifC
         RWg1sfuJxKFTRTYLbkXny5ociZNJKijjBymCxDkkYaazzjsMfZiJjFe8886z6P7bLn0Q
         1NpwXMbulCRl66rIZJPkNj5WcbP+iJoGzpC4f9bxAs8oTjjnPPELabv7WztIxgJInFuV
         zglLjr75d+bGtsDPSG4n1wfae1bOi4RoTIilaFvmxNPXHOv5NeSWmjWPOJ7V1dCXKm9A
         0tpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0nvd2DYrQvBH3dGTq9kzH5LJTcPqp85dy7QqoUBDBjE=;
        b=kMv49BsI8OL/qiKEIIe50ZvaLwtNwN1IFpEk2W1YDGaDthrcgWFz0vHt9Xla8cI6Fp
         DQEtmCdCHHGp4w2jDGviednlfjL+8jzJXKkQ3/n8SQz1FGXH1MwSTsYvt763nR2UBZ2X
         zSG4q6XhOii9p+JLta1QH++sHeyOeBrIDNuoMaRkugfQ9JQ/XpHp8gsvQzqMmvnz92dX
         OsU+Iyc2E3pvN5SiorjGEV7TBBxFm0Q5URFI/22EQ71eir6T0STrXXr89E0SC5TsIPy1
         KIUvQeuE82byDgfouF4AthjuxjUFzEL8Ht9zsJ7JkP4d4z+bcvakr3wT58i5LUqHMIvQ
         t/bQ==
X-Gm-Message-State: APjAAAU3+/r7XaE8sOMiKR8fs8xrrymdOurORzJo3FixqY+sHW5PPe9Q
        aX9/r8YErXHkRqdpLiqNvv7mUmseC8k=
X-Google-Smtp-Source: APXvYqxa9LT+bPNXDliaTm/tL9mvtu029my8EaqgjAr+0M2zIQlcx0PatYurCNghiXTGbhinkCx65w==
X-Received: by 2002:a19:385e:: with SMTP id d30mr37032015lfj.119.1558392640822;
        Mon, 20 May 2019 15:50:40 -0700 (PDT)
Received: from z50.gdansk-morena.vectranet.pl (109241207190.gdansk.vectranet.pl. [109.241.207.190])
        by smtp.gmail.com with ESMTPSA id t13sm2371646lji.47.2019.05.20.15.50.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 15:50:40 -0700 (PDT)
From:   Janusz Krzysztofik <jmkrzyszt@gmail.com>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 9/9] media: ov6650: Fix stored crop rectangle not in sync with hardware
Date:   Tue, 21 May 2019 00:50:07 +0200
Message-Id: <20190520225007.2308-10-jmkrzyszt@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520225007.2308-1-jmkrzyszt@gmail.com>
References: <20190520225007.2308-1-jmkrzyszt@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The driver stores crop rectangle settings supposed to be in line with
hardware state in a device private structure.  Since the driver initial
submission, crop rectangle width and height settings are not updated
correctly when rectangle offset settings are applied on hardware.  If
an error occurs while the device is updated, the stored settings my no
longer reflect hardware state and consecutive calls to .get_selection()
as well as .get/set_fmt() may return incorrect information.  That in
turn may affect ability of a bridge device to use correct DMA transfer
settings if such incorrect informamtion on active frame format returned
by .get/set_fmt() is used.

Assuming a failed update of the device means its actual settings haven't
changed, update crop rectangle width and height settings stored in the
device private structure correctly while the rectangle offset is
successfully applied on hardware so the stored values always reflect
actual hardware state to the extent possible.

Fixes: 2f6e2404799a ("[media] SoC Camera: add driver for OV6650 sensor")
Signed-off-by: Janusz Krzysztofik <jmkrzyszt@gmail.com>
Cc: stable@vger.kernel.org
---
 drivers/media/i2c/ov6650.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/i2c/ov6650.c b/drivers/media/i2c/ov6650.c
index 65d43390dbeb..c728f718716b 100644
--- a/drivers/media/i2c/ov6650.c
+++ b/drivers/media/i2c/ov6650.c
@@ -494,6 +494,7 @@ static int ov6650_set_selection(struct v4l2_subdev *sd,
 
 	ret = ov6650_reg_write(client, REG_HSTRT, sel->r.left >> 1);
 	if (!ret) {
+		priv->rect.width += priv->rect.left - sel->r.left;
 		priv->rect.left = sel->r.left;
 		ret = ov6650_reg_write(client, REG_HSTOP,
 				       (sel->r.left + sel->r.width) >> 1);
@@ -503,6 +504,7 @@ static int ov6650_set_selection(struct v4l2_subdev *sd,
 		ret = ov6650_reg_write(client, REG_VSTRT, sel->r.top >> 1);
 	}
 	if (!ret) {
+		priv->rect.height += priv->rect.top - sel->r.top;
 		priv->rect.top = sel->r.top;
 		ret = ov6650_reg_write(client, REG_VSTOP,
 				       (sel->r.top + sel->r.height) >> 1);
-- 
2.21.0

