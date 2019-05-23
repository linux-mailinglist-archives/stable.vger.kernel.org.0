Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07B2E2783E
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 10:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729820AbfEWIlF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 04:41:05 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:37083 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727232AbfEWIlF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 May 2019 04:41:05 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id A4C6C2F121;
        Thu, 23 May 2019 04:41:03 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 23 May 2019 04:41:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=juavBV
        TrIkwiTBLk2iWMNPnQepCmrBCOjZ17uaAJiBQ=; b=RPXPgk1qjvmVavddKd4qVA
        6+4DS5OSz6OwF1XynggesVsfEFtI5+RaczrUrl1c8n8hOe8h5e8BJCVXSyhT17cK
        7ZgRIN88K8dsm1z5EkYsKmmaXmD/sRNBrDl2TJta+RuxNfV27t/lNbBiB2TWCuIE
        t4p6U2Wk9tDJn2YPtff/LcGpO6KJcCi1L2OQ/WXBKuhvrHzJ7E+Oy5NWECTdDZyp
        gltt2gD+xtgKYs5z92CyMksd4aj+22vXbcpA6yQUyQ23VFbthIFCVsF+z87PK+6T
        2rXr/pWPkeTzbIadH6jWZm0GDy0Aof905dlZSCdkM9BJOzQsmdiu1a6sgqNNYvpA
        ==
X-ME-Sender: <xms:n1zmXGOODoKzulbTIDcdk7vCh6E1IA-Zyv7WkTP1JGQbvybZOPUlpA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddugedgtdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:n1zmXLgWeelsY-XMMNP1F_il51Er9inv8vcT5E_5q3hBQXifo4Yzhg>
    <xmx:n1zmXKuFtFuWkea2vvEm9_YGiPer65fS45RPXDAJGPWxEULo7BfGCg>
    <xmx:n1zmXG5vvPKBPuiV2cOcUbKf8YlbDx3fkQCoi2ZimWg6_DQa_LDfsA>
    <xmx:n1zmXFl_bCwEK6bmDYNrYKC_DyWLMkTfX34LCK9b3NZJKkjcOTxhNg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0C955380084;
        Thu, 23 May 2019 04:41:02 -0400 (EDT)
Subject: FAILED: patch "[PATCH] media: imx: Don't register IPU subdevs/links if CSI port" failed to apply to 4.14-stable tree
To:     slongerbeam@gmail.com, hverkuil-cisco@xs4all.nl,
        mchehab+samsung@kernel.org, p.zabel@pengutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 23 May 2019 10:40:59 +0200
Message-ID: <155860085916912@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From dee747f88167124884a918855c1f438e2f7f39e2 Mon Sep 17 00:00:00 2001
From: Steve Longerbeam <slongerbeam@gmail.com>
Date: Wed, 20 Feb 2019 18:53:32 -0500
Subject: [PATCH] media: imx: Don't register IPU subdevs/links if CSI port
 missing

The second IPU internal sub-devices were being registered and links
to them created even when the second IPU is not present. This is wrong
for i.MX6 S/DL and i.MX53 which have only a single IPU.

Fixes: e130291212df5 ("[media] media: Add i.MX media core driver")

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Cc: stable@vger.kernel.org
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
index fc35508d9396..10a63a4fa90b 100644
--- a/drivers/staging/media/imx/imx-media-dev.c
+++ b/drivers/staging/media/imx/imx-media-dev.c
@@ -477,13 +477,6 @@ static int imx_media_probe(struct platform_device *pdev)
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
diff --git a/drivers/staging/media/imx/imx-media-internal-sd.c b/drivers/staging/media/imx/imx-media-internal-sd.c
index e620f4adb755..dc510dcfe160 100644
--- a/drivers/staging/media/imx/imx-media-internal-sd.c
+++ b/drivers/staging/media/imx/imx-media-internal-sd.c
@@ -298,13 +298,14 @@ static int add_internal_subdev(struct imx_media_dev *imxmd,
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
@@ -322,25 +323,10 @@ static int add_ipu_internal_subdevs(struct imx_media_dev *imxmd, int ipu_id)
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
diff --git a/drivers/staging/media/imx/imx-media-of.c b/drivers/staging/media/imx/imx-media-of.c
index a26bdeb1af34..12383f4785ad 100644
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
@@ -60,12 +49,43 @@ int imx_media_add_of_subdevs(struct imx_media_dev *imxmd,
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
diff --git a/drivers/staging/media/imx/imx-media.h b/drivers/staging/media/imx/imx-media.h
index ccbfc4438c85..dd603a6b3a70 100644
--- a/drivers/staging/media/imx/imx-media.h
+++ b/drivers/staging/media/imx/imx-media.h
@@ -252,7 +252,8 @@ struct imx_media_fim *imx_media_fim_init(struct v4l2_subdev *sd);
 void imx_media_fim_free(struct imx_media_fim *fim);
 
 /* imx-media-internal-sd.c */
-int imx_media_add_ipu_internal_subdevs(struct imx_media_dev *imxmd);
+int imx_media_add_ipu_internal_subdevs(struct imx_media_dev *imxmd,
+				       int ipu_id);
 int imx_media_create_ipu_internal_links(struct imx_media_dev *imxmd,
 					struct v4l2_subdev *sd);
 void imx_media_remove_ipu_internal_subdevs(struct imx_media_dev *imxmd);
diff --git a/drivers/staging/media/imx/imx7-media-csi.c b/drivers/staging/media/imx/imx7-media-csi.c
index 3fba7c27c0ec..1ba62fcdcae8 100644
--- a/drivers/staging/media/imx/imx7-media-csi.c
+++ b/drivers/staging/media/imx/imx7-media-csi.c
@@ -1271,7 +1271,7 @@ static int imx7_csi_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, &csi->sd);
 
 	ret = imx_media_of_add_csi(imxmd, node);
-	if (ret < 0)
+	if (ret < 0 && ret != -ENODEV && ret != -EEXIST)
 		goto cleanup;
 
 	ret = imx_media_dev_notifier_register(imxmd);

