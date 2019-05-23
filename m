Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2826A288AD
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391683AbfEWT16 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:27:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:40328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391002AbfEWT15 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:27:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E505C2054F;
        Thu, 23 May 2019 19:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639675;
        bh=n/tMZ4cNVoAA1oHzG4CdFylVAUsgOpQAWjMKe/YoFaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qoT74m1AhJXl2+vCATt68E7fDGbEvsdW5LLjsJ2tDBjKtbSNBz71H25N8Z3HajKSe
         lzw2KIwBdMfX9uD9Cc2jJlc5dDL2qxVMHmvKGk23pVye76fuEeviWk/TZwEK8V9Kxb
         E8C6lEv7kClSpUi4snExZR99vgvC2JDswFLAnzJU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 5.1 053/122] media: imx: Rename functions that add IPU-internal subdevs
Date:   Thu, 23 May 2019 21:06:15 +0200
Message-Id: <20190523181711.730366129@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181705.091418060@linuxfoundation.org>
References: <20190523181705.091418060@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve Longerbeam <slongerbeam@gmail.com>

commit 085b26da62211cb77622008082adff56aefa771d upstream.

For the functions that add and remove the internal IPU subdevice
descriptors, rename them to make clear they are the subdevs internal
to the IPU. Also rename the platform data structure for the internal
IPU subdevices. No functional changes.

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
Acked-by: Philipp Zabel <p.zabel@pengutronix.de>
Cc: stable@vger.kernel.org
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/media/imx/imx-ic-common.c         |    2 +-
 drivers/staging/media/imx/imx-media-dev.c         |    8 ++++----
 drivers/staging/media/imx/imx-media-internal-sd.c |   12 ++++++------
 drivers/staging/media/imx/imx-media-vdic.c        |    2 +-
 drivers/staging/media/imx/imx-media.h             |    6 +++---
 5 files changed, 15 insertions(+), 15 deletions(-)

--- a/drivers/staging/media/imx/imx-ic-common.c
+++ b/drivers/staging/media/imx/imx-ic-common.c
@@ -26,7 +26,7 @@ static struct imx_ic_ops *ic_ops[IC_NUM_
 
 static int imx_ic_probe(struct platform_device *pdev)
 {
-	struct imx_media_internal_sd_platformdata *pdata;
+	struct imx_media_ipu_internal_sd_pdata *pdata;
 	struct imx_ic_priv *priv;
 	int ret;
 
--- a/drivers/staging/media/imx/imx-media-dev.c
+++ b/drivers/staging/media/imx/imx-media-dev.c
@@ -477,10 +477,10 @@ static int imx_media_probe(struct platfo
 		goto cleanup;
 	}
 
-	ret = imx_media_add_internal_subdevs(imxmd);
+	ret = imx_media_add_ipu_internal_subdevs(imxmd);
 	if (ret) {
 		v4l2_err(&imxmd->v4l2_dev,
-			 "add_internal_subdevs failed with %d\n", ret);
+			 "add_ipu_internal_subdevs failed with %d\n", ret);
 		goto cleanup;
 	}
 
@@ -491,7 +491,7 @@ static int imx_media_probe(struct platfo
 	return 0;
 
 del_int:
-	imx_media_remove_internal_subdevs(imxmd);
+	imx_media_remove_ipu_internal_subdevs(imxmd);
 cleanup:
 	v4l2_async_notifier_cleanup(&imxmd->notifier);
 	v4l2_device_unregister(&imxmd->v4l2_dev);
@@ -508,7 +508,7 @@ static int imx_media_remove(struct platf
 	v4l2_info(&imxmd->v4l2_dev, "Removing imx-media\n");
 
 	v4l2_async_notifier_unregister(&imxmd->notifier);
-	imx_media_remove_internal_subdevs(imxmd);
+	imx_media_remove_ipu_internal_subdevs(imxmd);
 	v4l2_async_notifier_cleanup(&imxmd->notifier);
 	media_device_unregister(&imxmd->md);
 	v4l2_device_unregister(&imxmd->v4l2_dev);
--- a/drivers/staging/media/imx/imx-media-internal-sd.c
+++ b/drivers/staging/media/imx/imx-media-internal-sd.c
@@ -1,7 +1,7 @@
 /*
  * Media driver for Freescale i.MX5/6 SOC
  *
- * Adds the internal subdevices and the media links between them.
+ * Adds the IPU internal subdevices and the media links between them.
  *
  * Copyright (c) 2016 Mentor Graphics Inc.
  *
@@ -192,7 +192,7 @@ static struct v4l2_subdev *find_sink(str
 
 	/*
 	 * retrieve IPU id from subdev name, note: can't get this from
-	 * struct imx_media_internal_sd_platformdata because if src is
+	 * struct imx_media_ipu_internal_sd_pdata because if src is
 	 * a CSI, it has different struct ipu_client_platformdata which
 	 * does not contain IPU id.
 	 */
@@ -270,7 +270,7 @@ static int add_internal_subdev(struct im
 			       const struct internal_subdev *isd,
 			       int ipu_id)
 {
-	struct imx_media_internal_sd_platformdata pdata;
+	struct imx_media_ipu_internal_sd_pdata pdata;
 	struct platform_device_info pdevinfo = {};
 	struct platform_device *pdev;
 
@@ -328,7 +328,7 @@ static int add_ipu_internal_subdevs(stru
 	return 0;
 }
 
-int imx_media_add_internal_subdevs(struct imx_media_dev *imxmd)
+int imx_media_add_ipu_internal_subdevs(struct imx_media_dev *imxmd)
 {
 	int ret;
 
@@ -343,11 +343,11 @@ int imx_media_add_internal_subdevs(struc
 	return 0;
 
 remove:
-	imx_media_remove_internal_subdevs(imxmd);
+	imx_media_remove_ipu_internal_subdevs(imxmd);
 	return ret;
 }
 
-void imx_media_remove_internal_subdevs(struct imx_media_dev *imxmd)
+void imx_media_remove_ipu_internal_subdevs(struct imx_media_dev *imxmd)
 {
 	struct imx_media_async_subdev *imxasd;
 	struct v4l2_async_subdev *asd;
--- a/drivers/staging/media/imx/imx-media-vdic.c
+++ b/drivers/staging/media/imx/imx-media-vdic.c
@@ -934,7 +934,7 @@ static const struct v4l2_subdev_internal
 
 static int imx_vdic_probe(struct platform_device *pdev)
 {
-	struct imx_media_internal_sd_platformdata *pdata;
+	struct imx_media_ipu_internal_sd_pdata *pdata;
 	struct vdic_priv *priv;
 	int ret;
 
--- a/drivers/staging/media/imx/imx-media.h
+++ b/drivers/staging/media/imx/imx-media.h
@@ -115,7 +115,7 @@ struct imx_media_pad_vdev {
 	struct list_head list;
 };
 
-struct imx_media_internal_sd_platformdata {
+struct imx_media_ipu_internal_sd_pdata {
 	char sd_name[V4L2_SUBDEV_NAME_SIZE];
 	u32 grp_id;
 	int ipu_id;
@@ -252,10 +252,10 @@ struct imx_media_fim *imx_media_fim_init
 void imx_media_fim_free(struct imx_media_fim *fim);
 
 /* imx-media-internal-sd.c */
-int imx_media_add_internal_subdevs(struct imx_media_dev *imxmd);
+int imx_media_add_ipu_internal_subdevs(struct imx_media_dev *imxmd);
 int imx_media_create_ipu_internal_links(struct imx_media_dev *imxmd,
 					struct v4l2_subdev *sd);
-void imx_media_remove_internal_subdevs(struct imx_media_dev *imxmd);
+void imx_media_remove_ipu_internal_subdevs(struct imx_media_dev *imxmd);
 
 /* imx-media-of.c */
 int imx_media_add_of_subdevs(struct imx_media_dev *dev,


