Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4BFD10BC79
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:21:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731430AbfK0VUz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:20:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:34548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728381AbfK0VIK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:08:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FEDE216F4;
        Wed, 27 Nov 2019 21:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888889;
        bh=bHDf1tUIQibMKmL2A/8ywKjSfjEElAGZ1UT0EPzYFHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JUx8Cq7E0OJ9ioK8kqFTyHtpCGKIluS218V9df6GA1szycBmPYcLWIGAO+Y03f0/B
         JavTvXMqw2Vw45PnavkMAk5XhPiyJC7Cd71hA4rROBPOJpCZaIij/VoojNjzlNMQCo
         pVzPawVrrAuZRGjg66Uecx5mtXrBUQ4D8S2UMOtQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vandana BN <bnvandana@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 4.19 283/306] media: vivid: Set vid_cap_streaming and vid_out_streaming to true
Date:   Wed, 27 Nov 2019 21:32:13 +0100
Message-Id: <20191127203135.453138297@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vandana BN <bnvandana@gmail.com>

commit b4add02d2236fd5f568db141cfd8eb4290972eb3 upstream.

When vbi stream is started, followed by video streaming,
the vid_cap_streaming and vid_out_streaming were not being set to true,
which would cause the video stream to stop when vbi stream is stopped.
This patch allows to set vid_cap_streaming and vid_out_streaming to true.
According to Hans Verkuil it appears that these 'if (dev->kthread_vid_cap)'
checks are a left-over from the original vivid development and should never
have been there.

Signed-off-by: Vandana BN <bnvandana@gmail.com>
Cc: <stable@vger.kernel.org>      # for v3.18 and up
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/platform/vivid/vivid-vid-cap.c |    3 ---
 drivers/media/platform/vivid/vivid-vid-out.c |    3 ---
 2 files changed, 6 deletions(-)

--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -222,9 +222,6 @@ static int vid_cap_start_streaming(struc
 	if (vb2_is_streaming(&dev->vb_vid_out_q))
 		dev->can_loop_video = vivid_vid_can_loop(dev);
 
-	if (dev->kthread_vid_cap)
-		return 0;
-
 	dev->vid_cap_seq_count = 0;
 	dprintk(dev, 1, "%s\n", __func__);
 	for (i = 0; i < VIDEO_MAX_FRAME; i++)
--- a/drivers/media/platform/vivid/vivid-vid-out.c
+++ b/drivers/media/platform/vivid/vivid-vid-out.c
@@ -146,9 +146,6 @@ static int vid_out_start_streaming(struc
 	if (vb2_is_streaming(&dev->vb_vid_cap_q))
 		dev->can_loop_video = vivid_vid_can_loop(dev);
 
-	if (dev->kthread_vid_out)
-		return 0;
-
 	dev->vid_out_seq_count = 0;
 	dprintk(dev, 1, "%s\n", __func__);
 	if (dev->start_streaming_error) {


