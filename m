Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85125697AB
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 17:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732202AbfGONwc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 09:52:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:46740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731945AbfGONwb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 09:52:31 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9BB520651;
        Mon, 15 Jul 2019 13:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563198751;
        bh=KzOSdrebX3KMW/gaQ5FM80gPMnZS1CDMWI74NLOCh6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rn30hy8HIDnXDCY2X3fa8WmVJbLr88zacguG5AAwK1SjrtjgueqcArVnD+uWOjQGz
         OUhRKDFITlSqJKCJEn9pIn0p7054H4nvEF/uxHA1jIlSBixNo/n/ilY9pUyzVpSGyo
         jij3L+rK3ttUBU8x4cR2AgYNqyaOBT6GdKBOgcJQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Young Xiao <92siuyang@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 094/249] media: davinci: vpif_capture: fix memory leak in vpif_probe()
Date:   Mon, 15 Jul 2019 09:44:19 -0400
Message-Id: <20190715134655.4076-94-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Young Xiao <92siuyang@gmail.com>

[ Upstream commit 64f883cd98c6d43013fb0cea788b63e50ebc068c ]

If vpif_probe() fails on v4l2_device_register() and vpif_probe_complete(),
then memory allocated at initialize_vpif() for global vpif_obj.dev[i]
become unreleased.

The patch adds deallocation of vpif_obj.dev[i] on the error path.

Signed-off-by: Young Xiao <92siuyang@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/davinci/vpif_capture.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index 61809d2050fa..f0f7ef638c56 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -1376,6 +1376,14 @@ static int initialize_vpif(void)
 	return err;
 }
 
+static inline void free_vpif_objs(void)
+{
+	int i;
+
+	for (i = 0; i < VPIF_CAPTURE_MAX_DEVICES; i++)
+		kfree(vpif_obj.dev[i]);
+}
+
 static int vpif_async_bound(struct v4l2_async_notifier *notifier,
 			    struct v4l2_subdev *subdev,
 			    struct v4l2_async_subdev *asd)
@@ -1645,7 +1653,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 	err = v4l2_device_register(vpif_dev, &vpif_obj.v4l2_dev);
 	if (err) {
 		v4l2_err(vpif_dev->driver, "Error registering v4l2 device\n");
-		goto cleanup;
+		goto vpif_free;
 	}
 
 	while ((res = platform_get_resource(pdev, IORESOURCE_IRQ, res_idx))) {
@@ -1692,7 +1700,9 @@ static __init int vpif_probe(struct platform_device *pdev)
 				  "registered sub device %s\n",
 				   subdevdata->name);
 		}
-		vpif_probe_complete();
+		err = vpif_probe_complete();
+		if (err)
+			goto probe_subdev_out;
 	} else {
 		vpif_obj.notifier.ops = &vpif_async_ops;
 		err = v4l2_async_notifier_register(&vpif_obj.v4l2_dev,
@@ -1711,6 +1721,8 @@ static __init int vpif_probe(struct platform_device *pdev)
 	kfree(vpif_obj.sd);
 vpif_unregister:
 	v4l2_device_unregister(&vpif_obj.v4l2_dev);
+vpif_free:
+	free_vpif_objs();
 cleanup:
 	v4l2_async_notifier_cleanup(&vpif_obj.notifier);
 
-- 
2.20.1

