Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46C8D747AA
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 09:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726001AbfGYHBI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 03:01:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:34168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725808AbfGYHBI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 03:01:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B13ED22ADA;
        Thu, 25 Jul 2019 07:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564038067;
        bh=ugyMF2EfQY4MlJK2bPQNjgsKvD78Jc/idypvrZesNVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kycfTpfBmvARacsQG9IVBCWiyzC6Ue2lqAtycEGURBprWehi/vMk9WajY3/tRS+LC
         9z09gLWKcGOdHBvybm1zEuIfPqt1QBd2T3VYK4GRwmvzZj50fetoxyWCTdJD0a3/4N
         9E4TVy3DJwlZmLdqJ6lQY7mpm9VHSMJPZPiZC/24=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Young Xiao <92siuyang@gmail.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 091/413] media: davinci: vpif_capture: fix memory leak in vpif_probe()
Date:   Wed, 24 Jul 2019 21:16:22 +0200
Message-Id: <20190724191741.555720549@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 64f883cd98c6d43013fb0cea788b63e50ebc068c ]

If vpif_probe() fails on v4l2_device_register() and vpif_probe_complete(),
then memory allocated at initialize_vpif() for global vpif_obj.dev[i]
become unreleased.

The patch adds deallocation of vpif_obj.dev[i] on the error path.

Signed-off-by: Young Xiao <92siuyang@gmail.com>
Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
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



