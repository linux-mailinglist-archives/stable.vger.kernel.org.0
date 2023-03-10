Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C260D6B4A73
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:23:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234199AbjCJPXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:23:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234229AbjCJPXE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:23:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3845213DF2
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:12:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5EF91B822EC
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:12:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CEB0C433EF;
        Fri, 10 Mar 2023 15:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678461128;
        bh=eOs9ZlG6rA7Ow/z/n2/GUd5uFdqDN94f2HPZOl0GIrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SB2yztFSYQcmZKLgz5pzkFeIC7fKcu/crf9LMq1cuz9KCVkuJ3tzzP8ASQSy4bt5I
         2ukSk3jfqjUSO/9O2vhxT6bftIJXikW/7eAkeyXnMV3RYyzc6SR8ZWHy0Qo+ELQnac
         DPsg4hUBywMWxF+26LwghtcZUp49V7m7AC45QuBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Benjamin Berg <benjamin.berg@intel.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 035/136] um: virtio_uml: move device breaking into workqueue
Date:   Fri, 10 Mar 2023 14:42:37 +0100
Message-Id: <20230310133708.110386051@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133706.811226272@linuxfoundation.org>
References: <20230310133706.811226272@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit abdeb4fa5e1b5b4918034f02236fd886f40c20c1 ]

We should not be calling virtio_break_device from an IRQ context.
Move breaking the device into the workqueue so that it is done from
a reasonable context.

Fixes: af9fb41ed315 ("um: virtio_uml: Fix broken device handling in time-travel")
Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/virtio_uml.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/um/drivers/virtio_uml.c b/arch/um/drivers/virtio_uml.c
index c16ae3676ee08..204e9dfbff1a0 100644
--- a/arch/um/drivers/virtio_uml.c
+++ b/arch/um/drivers/virtio_uml.c
@@ -170,7 +170,6 @@ static void vhost_user_check_reset(struct virtio_uml_device *vu_dev,
 
 	vu_dev->registered = 0;
 
-	virtio_break_device(&vu_dev->vdev);
 	schedule_work(&pdata->conn_broken_wk);
 }
 
@@ -1134,6 +1133,15 @@ void virtio_uml_set_no_vq_suspend(struct virtio_device *vdev,
 
 static void vu_of_conn_broken(struct work_struct *wk)
 {
+	struct virtio_uml_platform_data *pdata;
+	struct virtio_uml_device *vu_dev;
+
+	pdata = container_of(wk, struct virtio_uml_platform_data, conn_broken_wk);
+
+	vu_dev = platform_get_drvdata(pdata->pdev);
+
+	virtio_break_device(&vu_dev->vdev);
+
 	/*
 	 * We can't remove the device from the devicetree so the only thing we
 	 * can do is warn.
@@ -1264,8 +1272,14 @@ static int vu_unregister_cmdline_device(struct device *dev, void *data)
 static void vu_conn_broken(struct work_struct *wk)
 {
 	struct virtio_uml_platform_data *pdata;
+	struct virtio_uml_device *vu_dev;
 
 	pdata = container_of(wk, struct virtio_uml_platform_data, conn_broken_wk);
+
+	vu_dev = platform_get_drvdata(pdata->pdev);
+
+	virtio_break_device(&vu_dev->vdev);
+
 	vu_unregister_cmdline_device(&pdata->pdev->dev, NULL);
 }
 
-- 
2.39.2



