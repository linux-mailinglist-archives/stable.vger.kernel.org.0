Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C54E5903B8
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237827AbiHKQ00 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 12:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237777AbiHKQYd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 12:24:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C835BBC9C;
        Thu, 11 Aug 2022 09:06:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 72CCFB821AF;
        Thu, 11 Aug 2022 16:06:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D0F9C43470;
        Thu, 11 Aug 2022 16:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660233979;
        bh=Kj5q74Qy2aZX54PmtScsZ+Zvch9i/A7Kp8Bi2wcTWjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JQa5GPaI0nj6JCz2AIB5P0qfAT7z/aVWPSWJXEc5PGHuh9PNL2kpH/ZoLXCNJmiVk
         Rrpe1i7qQufCj6GfHx2PIa79jxaepN9FguKtY/OhShr0KJvEDqEalr5UQzZFgpHx7B
         Z8fjsrCLzdIfDJiKRmWPAh9vXaGgkC7naLGBWHZRsqAAj3OenIRy4MatNb5w1dsKUu
         UFx1VBBOxph3r4lGjlPacP+ncfqX7wPkWbcETanud8lJ/2zvZrbyxTgeRbuAb5/U0/
         WzWicP36xjao8TX2dUMqpLKHa9D2QI+cwCvl9R0MhsU8re0Cn810iJuWM+BvU+lwsp
         wtme0VZ0BQ75A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, crope@iki.fi,
        linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 19/46] media: airspy: respect the DMA coherency rules
Date:   Thu, 11 Aug 2022 12:03:43 -0400
Message-Id: <20220811160421.1539956-19-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811160421.1539956-1-sashal@kernel.org>
References: <20220811160421.1539956-1-sashal@kernel.org>
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
index 751703db06f5..c7499787bffe 100644
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

