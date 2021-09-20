Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA563411A4F
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243972AbhITQsx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:48:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:36602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243148AbhITQsE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:48:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 648D961252;
        Mon, 20 Sep 2021 16:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156397;
        bh=RDXPhV+XhK+KSulAbJypG6MW1JMnxdbZe8aVEVQvtW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DVSkVYx5V2Iji66xu9/ZTm+GyEhAM24N+Kz/Rchr9aGfDKa7GLHORfhpuacs4e6X5
         2xcC0GQh9pzrFXcbZ+/YGRlPOrS0UPt0rxLVNSHd2BQFVpKlRI3mT0hSNoToqebs/d
         QykgUaHWVS80OQ2TtKpWJcE3wokqXOCjQN7oLeLw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 040/133] media: go7007: remove redundant initialization
Date:   Mon, 20 Sep 2021 18:41:58 +0200
Message-Id: <20210920163913.964733082@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163912.603434365@linuxfoundation.org>
References: <20210920163912.603434365@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit 6f5885a7750545973bf1a942d2f0f129aef0aa06 ]

In go7007_alloc() kzalloc() is used for struct go7007
allocation. It means that there is no need in zeroing
any members, because kzalloc will take care of it.

Removing these reduntant initialization steps increases
execution speed a lot:

	Before:
		+ 86.802 us   |    go7007_alloc();
	After:
		+ 29.595 us   |    go7007_alloc();

Fixes: 866b8695d67e8 ("Staging: add the go7007 video driver")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/go7007/go7007-driver.c | 26 ------------------------
 1 file changed, 26 deletions(-)

diff --git a/drivers/media/usb/go7007/go7007-driver.c b/drivers/media/usb/go7007/go7007-driver.c
index ae1cfa792c58..11429bf28c8a 100644
--- a/drivers/media/usb/go7007/go7007-driver.c
+++ b/drivers/media/usb/go7007/go7007-driver.c
@@ -698,49 +698,23 @@ struct go7007 *go7007_alloc(const struct go7007_board_info *board,
 						struct device *dev)
 {
 	struct go7007 *go;
-	int i;
 
 	go = kzalloc(sizeof(struct go7007), GFP_KERNEL);
 	if (go == NULL)
 		return NULL;
 	go->dev = dev;
 	go->board_info = board;
-	go->board_id = 0;
 	go->tuner_type = -1;
-	go->channel_number = 0;
-	go->name[0] = 0;
 	mutex_init(&go->hw_lock);
 	init_waitqueue_head(&go->frame_waitq);
 	spin_lock_init(&go->spinlock);
 	go->status = STATUS_INIT;
-	memset(&go->i2c_adapter, 0, sizeof(go->i2c_adapter));
-	go->i2c_adapter_online = 0;
-	go->interrupt_available = 0;
 	init_waitqueue_head(&go->interrupt_waitq);
-	go->input = 0;
 	go7007_update_board(go);
-	go->encoder_h_halve = 0;
-	go->encoder_v_halve = 0;
-	go->encoder_subsample = 0;
 	go->format = V4L2_PIX_FMT_MJPEG;
 	go->bitrate = 1500000;
 	go->fps_scale = 1;
-	go->pali = 0;
 	go->aspect_ratio = GO7007_RATIO_1_1;
-	go->gop_size = 0;
-	go->ipb = 0;
-	go->closed_gop = 0;
-	go->repeat_seqhead = 0;
-	go->seq_header_enable = 0;
-	go->gop_header_enable = 0;
-	go->dvd_mode = 0;
-	go->interlace_coding = 0;
-	for (i = 0; i < 4; ++i)
-		go->modet[i].enable = 0;
-	for (i = 0; i < 1624; ++i)
-		go->modet_map[i] = 0;
-	go->audio_deliver = NULL;
-	go->audio_enabled = 0;
 
 	return go;
 }
-- 
2.30.2



