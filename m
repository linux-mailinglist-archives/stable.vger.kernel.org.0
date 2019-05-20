Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71F43243BB
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 00:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727404AbfETWvM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 18:51:12 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:36220 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbfETWuf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 May 2019 18:50:35 -0400
Received: by mail-lf1-f65.google.com with SMTP id y10so11554002lfl.3;
        Mon, 20 May 2019 15:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Vxf6jf0I3TNkNsrZiapyq8fbjujSIosIG2y16ynybBA=;
        b=cPKte+l2qZ4j+ifr+H9BD/YTN4+qCpvm4PqiW4AsAGuOwDsFPhaAkyVA5Uqe69hgN6
         WjG+vSt/obII1rjN06w4ZNtggFlIMXhjxmeOpnP3TAa2cL2EH4I4EC/3lqf+dJvtWvyE
         DSY4KwzMUD06suAcdr/fY9/loNVjfDTRZqQpwZUgzEfcwfoMjZwc346NKwZQnRfzK+IS
         IrtuMWYeFuSbkvz96K0fvOTkbKPFAz82Oiy2OqhieGfVJ0Gq60ttHtwoHjajpx8lVAie
         zIHBD7ceytsULxLRheDaOo7/Eu3b8xIp1hApNVO4CcFysAqlMRxdu7ybyJYBuZC84Bcy
         ye9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Vxf6jf0I3TNkNsrZiapyq8fbjujSIosIG2y16ynybBA=;
        b=frdtAuuFrLeLZvGlLlZ3Yfot5uMz9HJCLclpuBk+ODBTQNRkXq9vQKKOHX7Y4fY9rp
         gWXW+a+V672g3NhwMRcUS/LBMpYFFGcNZPJmS+jmOelvL0Npz+ydMK/BSH3OvUL0dJK5
         Q6MSXzytTgrFN1AI7JmpWDHA3kJUAlAmI0tSY0EDF+F3EmrAWU+cHBiosnNoa+6Tr7ru
         AQ/upy9wspJKgLb95DeW0c7hrt4bkcacyG+2XQ98cBM9Wzr8bJZji/FvAS5RHGrZPrGg
         jqkUDF64yw9skoVaYyvMgFsvOqSoHbSyhCERq411HQ18vg7+RXgemFVfDtRJUsBo4wyK
         PiJQ==
X-Gm-Message-State: APjAAAV7zkcrwHtipLPSEMxYLyYzqiORJVg7IY4rN3q6VZ+WOfrMgLjZ
        U+J1sNBgcGI1hPA0j1L0lVM=
X-Google-Smtp-Source: APXvYqxlM6gWuNzP4Te1EnZSGJxSQC5D3uHa5MNgaDvgeQmCARPSQA6Kt3myJWreUEXW1NxDCA963g==
X-Received: by 2002:ac2:4c93:: with SMTP id d19mr19052117lfl.116.1558392632679;
        Mon, 20 May 2019 15:50:32 -0700 (PDT)
Received: from z50.gdansk-morena.vectranet.pl (109241207190.gdansk.vectranet.pl. [109.241.207.190])
        by smtp.gmail.com with ESMTPSA id t13sm2371646lji.47.2019.05.20.15.50.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 15:50:32 -0700 (PDT)
From:   Janusz Krzysztofik <jmkrzyszt@gmail.com>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 2/9] media: ov6650: Fix control handler not freed on init error
Date:   Tue, 21 May 2019 00:50:00 +0200
Message-Id: <20190520225007.2308-3-jmkrzyszt@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520225007.2308-1-jmkrzyszt@gmail.com>
References: <20190520225007.2308-1-jmkrzyszt@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since commit afd9690c72c3 ("[media] ov6650: convert to the control
framework"), if an error occurs during initialization of a control
handler, resources possibly allocated to the handler are not freed
before device initialiaton is aborted.  Fix it.

Fixes: afd9690c72c3 ("[media] ov6650: convert to the control framework")
Signed-off-by: Janusz Krzysztofik <jmkrzyszt@gmail.com>
Cc: stable@vger.kernel.org
---
 drivers/media/i2c/ov6650.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/ov6650.c b/drivers/media/i2c/ov6650.c
index a3d00afcb0c8..007f0ca24913 100644
--- a/drivers/media/i2c/ov6650.c
+++ b/drivers/media/i2c/ov6650.c
@@ -992,8 +992,10 @@ static int ov6650_probe(struct i2c_client *client,
 			V4L2_CID_GAMMA, 0, 0xff, 1, 0x12);
 
 	priv->subdev.ctrl_handler = &priv->hdl;
-	if (priv->hdl.error)
-		return priv->hdl.error;
+	if (priv->hdl.error) {
+		ret = priv->hdl.error;
+		goto ectlhdlfree;
+	}
 
 	v4l2_ctrl_auto_cluster(2, &priv->autogain, 0, true);
 	v4l2_ctrl_auto_cluster(3, &priv->autowb, 0, true);
@@ -1012,8 +1014,10 @@ static int ov6650_probe(struct i2c_client *client,
 	priv->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 
 	ret = v4l2_async_register_subdev(&priv->subdev);
-	if (ret)
-		v4l2_ctrl_handler_free(&priv->hdl);
+	if (!ret)
+		return 0;
+ectlhdlfree:
+	v4l2_ctrl_handler_free(&priv->hdl);
 
 	return ret;
 }
-- 
2.21.0

