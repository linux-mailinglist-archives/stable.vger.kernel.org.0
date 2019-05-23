Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD5728955
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391724AbfEWTeR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:34:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:40398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388778AbfEWT17 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:27:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F28320879;
        Thu, 23 May 2019 19:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639678;
        bh=qNYODgqWKhdbPsHa9pHqWA8Zqitjdz0r1FPR3mUqAr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zt1WeJxzN876MzXm8Yhoojx45A1p+mnifg85RqMkxXJHGKDS4oIpuUxy+cWn/UEMG
         UGkQsx7IIs2wbfeFZ2zOqochNVBWoFDur0BihNeh2T8iJIrDX0rVRFteJ28ASfdpxY
         dECfnim4rQUOblBJ/Yi1NPWKKcgOXOQQPusb6hsM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 5.1 054/122] media: imx: Dont register IPU subdevs/links if CSI port missing
Date:   Thu, 23 May 2019 21:06:16 +0200
Message-Id: <20190523181711.867323134@linuxfoundation.org>
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

commit dee747f88167124884a918855c1f438e2f7f39e2 upstream.

The second IPU internal sub-devices were being registered and links
to them created even when the second IPU is not present. This is wrong
for i.MX6 S/DL and i.MX53 which have only a single IPU.

Fixes: e130291212df5 ("[media] media: Add i.MX media core driver")

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Cc: stable@vger.kernel.org
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/media/imx/imx-media-dev.c         |    7 --
 drivers/staging/media/imx/imx-media-internal-sd.c |   22 +-------
 drivers/staging/media/imx/imx-media-of.c          |   58 ++++++++++++++--------
 drivers/staging/media/imx/imx-media.h             |    3 -
 drivers/staging/media/imx/imx7-media-csi.c        |    2 
 5 files changed, 46 insertions(+), 46 deletions(-)

--- a/drivers/staging/media/imx/imx-media-dev.c
+++ b/drivers/staging/media/imx/imx-media-dev.c
@@ -477,13 +477,6 @@ static int imx_media_probe(struct platfo
 		goto cleanup;
 	}
 
-	ret = imx_media_add_ipu_internal_subdevs(imxmd);
-	if (ret) {
-		v4l2_err(&imxmd->v4l2_dev,
-			 "add_ipu_internal_subdevs failed with %d\n", ret);
-		goto cleanup;
-	}
-
 	ret = imx_media_dev_notifier_register(imxmd);
 	if (ret)
 		goto del_int;
--- a/drivers/staging/media/imx/imx-media-internal-sd.c
+++ b/drivers/staging/media/imx/imx-media-internal-sd.c
@@ -298,13 +298,14 @@ static int add_internal_subdev(struct im
 }
 
 /* adds the internal subdevs in one ipu */
-static int add_ipu_internal_subdevs(struct imx_media_dev *imxmd, int ipu_id)
+int imx_media_add_ipu_internal_subdevs(struct imx_media_dev *imxmd,
+				       int ipu_id)
 {
 	enum isd_enum i;
+	int ret;
 
 	for (i = 0; i < num_isd; i++) {
 		const struct internal_subdev *isd = &int_subdev[i];
-		int ret;
 
 		/*
 		 * the CSIs are represented in the device-tree, so those
@@ -322,25 +323,10 @@ static int add_ipu_internal_subdevs(stru
 		}
 
 		if (ret)
-			return ret;
+			goto remove;
 	}
 
 	return 0;
-}
-
-int imx_media_add_ipu_internal_subdevs(struct imx_media_dev *imxmd)
-{
-	int ret;
-
-	ret = add_ipu_internal_subdevs(imxmd, 0);
-	if (ret)
-		goto remove;
-
-	ret = add_ipu_internal_subdevs(imxmd, 1);
-	if (ret)
-		goto remove;
-
-	return 0;
 
 remove:
 	imx_media_remove_ipu_internal_subdevs(imxmd);
--- a/drivers/staging/media/imx/imx-media-of.c
+++ b/drivers/staging/media/imx/imx-media-of.c
@@ -23,36 +23,25 @@
 int imx_media_of_add_csi(struct imx_media_dev *imxmd,
 			 struct device_node *csi_np)
 {
-	int ret;
-
 	if (!of_device_is_available(csi_np)) {
 		dev_dbg(imxmd->md.dev, "%s: %pOFn not enabled\n", __func__,
 			csi_np);
-		/* unavailable is not an error */
-		return 0;
+		return -ENODEV;
 	}
 
 	/* add CSI fwnode to async notifier */
-	ret = imx_media_add_async_subdev(imxmd, of_fwnode_handle(csi_np), NULL);
-	if (ret) {
-		if (ret == -EEXIST) {
-			/* already added, everything is fine */
-			return 0;
-		}
-
-		/* other error, can't continue */
-		return ret;
-	}
-
-	return 0;
+	return imx_media_add_async_subdev(imxmd, of_fwnode_handle(csi_np),
+					  NULL);
 }
 EXPORT_SYMBOL_GPL(imx_media_of_add_csi);
 
 int imx_media_add_of_subdevs(struct imx_media_dev *imxmd,
 			     struct device_node *np)
 {
+	bool ipu_found[2] = {false, false};
 	struct device_node *csi_np;
 	int i, ret;
+	u32 ipu_id;
 
 	for (i = 0; ; i++) {
 		csi_np = of_parse_phandle(np, "ports", i);
@@ -60,12 +49,43 @@ int imx_media_add_of_subdevs(struct imx_
 			break;
 
 		ret = imx_media_of_add_csi(imxmd, csi_np);
-		of_node_put(csi_np);
-		if (ret)
-			return ret;
+		if (ret) {
+			/* unavailable or already added is not an error */
+			if (ret == -ENODEV || ret == -EEXIST) {
+				of_node_put(csi_np);
+				continue;
+			}
+
+			/* other error, can't continue */
+			goto err_out;
+		}
+
+		ret = of_alias_get_id(csi_np->parent, "ipu");
+		if (ret < 0)
+			goto err_out;
+		if (ret > 1) {
+			ret = -EINVAL;
+			goto err_out;
+		}
+
+		ipu_id = ret;
+
+		if (!ipu_found[ipu_id]) {
+			ret = imx_media_add_ipu_internal_subdevs(imxmd,
+								 ipu_id);
+			if (ret)
+				goto err_out;
+		}
+
+		ipu_found[ipu_id] = true;
 	}
 
 	return 0;
+
+err_out:
+	imx_media_remove_ipu_internal_subdevs(imxmd);
+	of_node_put(csi_np);
+	return ret;
 }
 
 /*
--- a/drivers/staging/media/imx/imx-media.h
+++ b/drivers/staging/media/imx/imx-media.h
@@ -252,7 +252,8 @@ struct imx_media_fim *imx_media_fim_init
 void imx_media_fim_free(struct imx_media_fim *fim);
 
 /* imx-media-internal-sd.c */
-int imx_media_add_ipu_internal_subdevs(struct imx_media_dev *imxmd);
+int imx_media_add_ipu_internal_subdevs(struct imx_media_dev *imxmd,
+				       int ipu_id);
 int imx_media_create_ipu_internal_links(struct imx_media_dev *imxmd,
 					struct v4l2_subdev *sd);
 void imx_media_remove_ipu_internal_subdevs(struct imx_media_dev *imxmd);
--- a/drivers/staging/media/imx/imx7-media-csi.c
+++ b/drivers/staging/media/imx/imx7-media-csi.c
@@ -1271,7 +1271,7 @@ static int imx7_csi_probe(struct platfor
 	platform_set_drvdata(pdev, &csi->sd);
 
 	ret = imx_media_of_add_csi(imxmd, node);
-	if (ret < 0)
+	if (ret < 0 && ret != -ENODEV && ret != -EEXIST)
 		goto cleanup;
 
 	ret = imx_media_dev_notifier_register(imxmd);


