Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20A9B535C6C
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 11:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350442AbiE0JBu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 05:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350887AbiE0JAu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 05:00:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6CC91271A6;
        Fri, 27 May 2022 01:57:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 169C061D95;
        Fri, 27 May 2022 08:57:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B37D8C385A9;
        Fri, 27 May 2022 08:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653641842;
        bh=QcOMKaT4J7Ghs3nz7/91Y7A+Xfvmn2VdmyL7SNTPNkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wt5wG4SFNvq7lSywWO7MYWCFKx631lW3IdXA75w8+DhUctYT8FuFPHbCuQY7iXGwD
         4pEbWLvKzLXzEuLry1m7XBd9qDuEStqyBPJSFFi4S7mVgDkbYL6hjipKWipGAT9jhs
         LNWr+x5e2zZVyE4lQSZava3KF2eDldMVJlpc7YDw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Subject: [PATCH 5.10 007/163] media: vim2m: Register video device after setting up internals
Date:   Fri, 27 May 2022 10:48:07 +0200
Message-Id: <20220527084829.196500718@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084828.156494029@linuxfoundation.org>
References: <20220527084828.156494029@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit cf7f34777a5b4100a3a44ff95f3d949c62892bdd upstream.

Prevent NULL (or close to NULL) pointer dereference in various places by
registering the video device only when the V4L2 m2m framework has been set
up.

Fixes: commit 96d8eab5d0a1 ("V4L/DVB: [v5,2/2] v4l: Add a mem-to-mem videobuf framework test device")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/test-drivers/vim2m.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/drivers/media/test-drivers/vim2m.c
+++ b/drivers/media/test-drivers/vim2m.c
@@ -1325,12 +1325,6 @@ static int vim2m_probe(struct platform_d
 	vfd->lock = &dev->dev_mutex;
 	vfd->v4l2_dev = &dev->v4l2_dev;
 
-	ret = video_register_device(vfd, VFL_TYPE_VIDEO, 0);
-	if (ret) {
-		v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
-		goto error_v4l2;
-	}
-
 	video_set_drvdata(vfd, dev);
 	v4l2_info(&dev->v4l2_dev,
 		  "Device registered as /dev/video%d\n", vfd->num);
@@ -1345,6 +1339,12 @@ static int vim2m_probe(struct platform_d
 		goto error_dev;
 	}
 
+	ret = video_register_device(vfd, VFL_TYPE_VIDEO, 0);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
+		goto error_m2m;
+	}
+
 #ifdef CONFIG_MEDIA_CONTROLLER
 	dev->mdev.dev = &pdev->dev;
 	strscpy(dev->mdev.model, "vim2m", sizeof(dev->mdev.model));
@@ -1358,7 +1358,7 @@ static int vim2m_probe(struct platform_d
 						 MEDIA_ENT_F_PROC_VIDEO_SCALER);
 	if (ret) {
 		v4l2_err(&dev->v4l2_dev, "Failed to init mem2mem media controller\n");
-		goto error_dev;
+		goto error_v4l2;
 	}
 
 	ret = media_device_register(&dev->mdev);
@@ -1373,11 +1373,13 @@ static int vim2m_probe(struct platform_d
 error_m2m_mc:
 	v4l2_m2m_unregister_media_controller(dev->m2m_dev);
 #endif
-error_dev:
+error_v4l2:
 	video_unregister_device(&dev->vfd);
 	/* vim2m_device_release called by video_unregister_device to release various objects */
 	return ret;
-error_v4l2:
+error_m2m:
+	v4l2_m2m_release(dev->m2m_dev);
+error_dev:
 	v4l2_device_unregister(&dev->v4l2_dev);
 error_free:
 	kfree(dev);


