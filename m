Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9C9B5921F4
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241209AbiHNPmj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241405AbiHNPlf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:41:35 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDB3422508;
        Sun, 14 Aug 2022 08:33:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0964BCE0B69;
        Sun, 14 Aug 2022 15:32:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B0AC433D6;
        Sun, 14 Aug 2022 15:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660491176;
        bh=d9zByOqMLOF3FIcefgl0t3MfVCirt6tjn609U+L5Uy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=azVUB6yJ0W0BNAG6ozT3JxAufs8cIBp7vBRSLyAKpbnxsv+aGidZPDSLAJDQoi1Z+
         f7FAT3nYZgDKr3okIVVUQijNVBHfGxn84ub7uBNIwX7RH2sB4ewSxZQuLPCsX22yq7
         lokHMDJPC0QPYxmjnkMerHu5Tt7Bw55PKS3K+NeW1Sgq2kzcPhSyKOqgSwrvIpwyaW
         H7VGpludWQ7BRg5gTXte7p/DGKqFMZngGGJDnK2VETDgnR/j06wChf1fE6t9PinHYS
         gk4rQnXQM+vR0SsSba9G8RPYO687q5m9huEsjHMzsIOuMYGDZO+1P1qg0K7WXW3RQF
         T9BR3FCgs1WeQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Dan Vacura <w36195@motorola.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        laurent.pinchart@ideasonboard.com, balbi@kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 06/46] usb: gadget: uvc: calculate the number of request depending on framesize
Date:   Sun, 14 Aug 2022 11:32:07 -0400
Message-Id: <20220814153247.2378312-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814153247.2378312-1-sashal@kernel.org>
References: <20220814153247.2378312-1-sashal@kernel.org>
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
index 99dc9adf56ef..a64b842665b9 100644
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

