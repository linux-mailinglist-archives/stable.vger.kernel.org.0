Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03A95590010
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 17:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235900AbiHKPgD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235979AbiHKPfY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:35:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A7D59C226;
        Thu, 11 Aug 2022 08:32:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B6E2B82166;
        Thu, 11 Aug 2022 15:32:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2386FC433D6;
        Thu, 11 Aug 2022 15:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660231968;
        bh=+swndNcso2VMvw6qiI+KLuZ0dfE4W3c+gUqq1fw8uOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ELUR7gUVd7GTuMcczghZsHWcDgTlAdh/Uy9YvHhN8/82RPoCsJf7DPAqBJKHCQJ3c
         5TG+0+xGW8O2z/kOW3P3vXiSJyUR9pPMkzA1w+HRxLtt9LFt5m0qqnFMvLepz8Hx7q
         6iF2+dHqtuSJRniCYpNLTeaxs/P4Aagel5CL38B1G3ClNFOBWYPaX12c6+n7/bNGAE
         /TXSmI1nK592Wbd/uhg4BNq/inTf4QyBAMMB2Ykh9aaHdLUWmVdX0EuJ1vrddFM+b9
         ruJN9J2iItjQjbqQr9cYzJ9jWPH0Xz35FhqDDmtyoALuCpAYFVlAAYwIEKQ8U2l1cv
         N9YL71SQLTokQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, crope@iki.fi,
        linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 033/105] media: airspy: respect the DMA coherency rules
Date:   Thu, 11 Aug 2022 11:27:17 -0400
Message-Id: <20220811152851.1520029-33-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811152851.1520029-1-sashal@kernel.org>
References: <20220811152851.1520029-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit ca9dc8d06ab64543a6a31adac5003349c5671218 ]

If we want to avoid memory corruption
on incoherent architectures, buffers for DMA
must not reside
- on the stack
- embedded within other structures

Allocate them separately.

v2: fix uninitialized return value

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/airspy/airspy.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/airspy/airspy.c b/drivers/media/usb/airspy/airspy.c
index d568452618d1..240a7cc56777 100644
--- a/drivers/media/usb/airspy/airspy.c
+++ b/drivers/media/usb/airspy/airspy.c
@@ -123,7 +123,7 @@ struct airspy {
 
 	/* USB control message buffer */
 	#define BUF_SIZE 128
-	u8 buf[BUF_SIZE];
+	u8 *buf;
 
 	/* Current configuration */
 	unsigned int f_adc;
@@ -856,6 +856,7 @@ static void airspy_video_release(struct v4l2_device *v)
 
 	v4l2_ctrl_handler_free(&s->hdl);
 	v4l2_device_unregister(&s->v4l2_dev);
+	kfree(s->buf);
 	kfree(s);
 }
 
@@ -963,7 +964,10 @@ static int airspy_probe(struct usb_interface *intf,
 {
 	struct airspy *s;
 	int ret;
-	u8 u8tmp, buf[BUF_SIZE];
+	u8 u8tmp, *buf;
+
+	buf = NULL;
+	ret = -ENOMEM;
 
 	s = kzalloc(sizeof(struct airspy), GFP_KERNEL);
 	if (s == NULL) {
@@ -971,6 +975,13 @@ static int airspy_probe(struct usb_interface *intf,
 		return -ENOMEM;
 	}
 
+	s->buf = kzalloc(BUF_SIZE, GFP_KERNEL);
+	if (!s->buf)
+		goto err_free_mem;
+	buf = kzalloc(BUF_SIZE, GFP_KERNEL);
+	if (!buf)
+		goto err_free_mem;
+
 	mutex_init(&s->v4l2_lock);
 	mutex_init(&s->vb_queue_lock);
 	spin_lock_init(&s->queued_bufs_lock);
@@ -1068,6 +1079,8 @@ static int airspy_probe(struct usb_interface *intf,
 	v4l2_ctrl_handler_free(&s->hdl);
 	v4l2_device_unregister(&s->v4l2_dev);
 err_free_mem:
+	kfree(buf);
+	kfree(s->buf);
 	kfree(s);
 	return ret;
 }
-- 
2.35.1

