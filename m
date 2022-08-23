Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7741859D674
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346279AbiHWJJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:09:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347706AbiHWJHy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:07:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 052A185A9B;
        Tue, 23 Aug 2022 01:30:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8436D61475;
        Tue, 23 Aug 2022 08:30:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CECAC433C1;
        Tue, 23 Aug 2022 08:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243422;
        bh=x+inPP9lpVSclSuJHHc1IGDwhLIHcBfFqLoOpXMbt/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uqcTgx0vSxFjEeULFGK8QVMIKQ+GZdhz6vtPyOZmKnaVDEMlmiEFzdZiEqXzp4ijN
         lRidbGSKjw1p1vNlaz/2iyGzQ1Udza4bJuAkmCEsaskStR2Gy6bq7iV4czYELrZ8qp
         JI9mqKBNntE7LCY+gkrdPKcmgQLM/2nOamDZ+rwU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Vacura <w36195@motorola.com>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 265/365] usb: gadget: uvc: calculate the number of request depending on framesize
Date:   Tue, 23 Aug 2022 10:02:46 +0200
Message-Id: <20220823080129.262270738@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 951934aa4454..ec500ee499ee 100644
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



