Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 553DE59214E
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240291AbiHNPgl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:36:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240830AbiHNPfL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:35:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3CBB1CB25;
        Sun, 14 Aug 2022 08:30:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13E2BB80B4D;
        Sun, 14 Aug 2022 15:30:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3A69C43141;
        Sun, 14 Aug 2022 15:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660491036;
        bh=XfTpIaEcdH4Kr+11fCWTXZMYxUdU3fx7fJjlYGcy0nk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gPoKhwZjxWCwqMPVprLMv65qQrASytTagIWCVMkQVoZUMfBoBcpV9SJz2XYNE9h61
         HdX319kKN0fR/DWGf7HQcdOsoZNCjQ7xC6ZmUf+3joMn91CkzKuDz1XpBE9m2/EnDR
         IaTk8B2mXpa0tzXdIVDW18h2TW4866pHqW+xEk9uHYxAsjSujCDcHtHd9d5YJnS/4u
         SJg6lnc7dvHjMWZIOl+vHgJzFVMOuU6C6Q5pyLacSGKfRhImYInxB1QRVJGCZuDqAP
         M3d8p5Sds0dosMLkuwjFhbgCG4nCnaslc5G24uKZ+aH+lcbPxkWKVl44eArOsoYQSC
         y797YmrF56dRA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Dan Vacura <w36195@motorola.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        laurent.pinchart@ideasonboard.com, balbi@kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 07/56] usb: gadget: uvc: calculate the number of request depending on framesize
Date:   Sun, 14 Aug 2022 11:29:37 -0400
Message-Id: <20220814153026.2377377-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814153026.2377377-1-sashal@kernel.org>
References: <20220814153026.2377377-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

[ Upstream commit 87d76b5f1d8eeb49efa16e2018e188864cbb9401 ]

The current limitation of possible number of requests being handled is
dependent on the gadget speed. It makes more sense to depend on the
typical frame size when calculating the number of requests. This patch
is changing this and is using the previous limits as boundaries for
reasonable minimum and maximum number of requests.

For a 1080p jpeg encoded video stream with a maximum imagesize of
e.g. 800kB with a maxburst of 8 and an multiplier of 1 the resulting
number of requests is calculated to 49.

        800768         1
nreqs = ------ * -------------- ~= 49
          2      (1024 * 8 * 1)

Tested-by: Dan Vacura <w36195@motorola.com>
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Link: https://lore.kernel.org/r/20220529223848.105914-2-m.grzeschik@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/uvc_queue.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/gadget/function/uvc_queue.c b/drivers/usb/gadget/function/uvc_queue.c
index 2cda982f3765..5b78e000cded 100644
--- a/drivers/usb/gadget/function/uvc_queue.c
+++ b/drivers/usb/gadget/function/uvc_queue.c
@@ -44,7 +44,8 @@ static int uvc_queue_setup(struct vb2_queue *vq,
 {
 	struct uvc_video_queue *queue = vb2_get_drv_priv(vq);
 	struct uvc_video *video = container_of(queue, struct uvc_video, queue);
-	struct usb_composite_dev *cdev = video->uvc->func.config->cdev;
+	unsigned int req_size;
+	unsigned int nreq;
 
 	if (*nbuffers > UVC_MAX_VIDEO_BUFFERS)
 		*nbuffers = UVC_MAX_VIDEO_BUFFERS;
@@ -53,10 +54,16 @@ static int uvc_queue_setup(struct vb2_queue *vq,
 
 	sizes[0] = video->imagesize;
 
-	if (cdev->gadget->speed < USB_SPEED_SUPER)
-		video->uvc_num_requests = 4;
-	else
-		video->uvc_num_requests = 64;
+	req_size = video->ep->maxpacket
+		 * max_t(unsigned int, video->ep->maxburst, 1)
+		 * (video->ep->mult);
+
+	/* We divide by two, to increase the chance to run
+	 * into fewer requests for smaller framesizes.
+	 */
+	nreq = DIV_ROUND_UP(DIV_ROUND_UP(sizes[0], 2), req_size);
+	nreq = clamp(nreq, 4U, 64U);
+	video->uvc_num_requests = nreq;
 
 	return 0;
 }
-- 
2.35.1

