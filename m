Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7BF10B999
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730594AbfK0UzD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:55:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:45440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730570AbfK0UzD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:55:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 549DA21556;
        Wed, 27 Nov 2019 20:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888102;
        bh=VAuPGxZCIYsAgk/b9uxIyvWkBkmJL4yAMIffas4UNes=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c17+S9psA6h07DglUtDqTSkn5YfnMMPTEckw7tMMxqsVP2opSvwVqa+Irkcs9tuq/
         rgZvb/M51I3ERqNcQ24F4BBeUBN2+njLMkuases9juO3DWFKRPeKZd77Fpe0hvFFw2
         w5sF2K7UicaJakCXEqKQdaQ4E7NHoXMN6i5/jhpk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vandana BN <bnvandana@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 4.14 188/211] media: vivid: Set vid_cap_streaming and vid_out_streaming to true
Date:   Wed, 27 Nov 2019 21:32:01 +0100
Message-Id: <20191127203111.472635191@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
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
@@ -239,9 +239,6 @@ static int vid_cap_start_streaming(struc
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
@@ -158,9 +158,6 @@ static int vid_out_start_streaming(struc
 	if (vb2_is_streaming(&dev->vb_vid_cap_q))
 		dev->can_loop_video = vivid_vid_can_loop(dev);
 
-	if (dev->kthread_vid_out)
-		return 0;
-
 	dev->vid_out_seq_count = 0;
 	dprintk(dev, 1, "%s\n", __func__);
 	if (dev->start_streaming_error) {


