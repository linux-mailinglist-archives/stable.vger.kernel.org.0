Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A749612FB9
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 06:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbiJaFgo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 01:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiJaFgn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 01:36:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BDF27673
        for <stable@vger.kernel.org>; Sun, 30 Oct 2022 22:36:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 508C8B810BF
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 05:36:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96FFEC433D6;
        Mon, 31 Oct 2022 05:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667194599;
        bh=zPxHAcDNzQo3ady73CDyUcp0GNPfi6oBu56dmQZcPsc=;
        h=Subject:To:Cc:From:Date:From;
        b=obVrzMBWSoCYEEgxFp1deCMMf+pp70oYdurlGR45+Gm/0B1Pp6WYtGoEkYksalaa9
         bWcCeZx5ZB36iCtYWq3HGtsy1eHeIELIR1ctA27JKvU5dPeTyG7XyzLAUnKFocyKKK
         svoOvZmavfhpx83bcImBANJOGQoZIUkhvJiLJQnE=
Subject: FAILED: patch "[PATCH] usb: gadget: uvc: fix dropped frame after missed isoc" failed to apply to 5.15-stable tree
To:     w36195@motorola.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Oct 2022 06:37:35 +0100
Message-ID: <166719465523572@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

8e8e923a4996 ("usb: gadget: uvc: fix dropped frame after missed isoc")
96163f835e65 ("usb: gadget: uvc: fix list double add in uvcg_video_pump")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8e8e923a49967b798e7d69f1ce9eff1dd2533547 Mon Sep 17 00:00:00 2001
From: Dan Vacura <w36195@motorola.com>
Date: Tue, 18 Oct 2022 16:50:37 -0500
Subject: [PATCH] usb: gadget: uvc: fix dropped frame after missed isoc

With the re-use of the previous completion status in 0d1c407b1a749
("usb: dwc3: gadget: Return proper request status") it could be possible
that the next frame would also get dropped if the current frame has a
missed isoc error. Ensure that an interrupt is requested for the start
of a new frame.

Fixes: fc78941d8169 ("usb: gadget: uvc: decrease the interrupt load to a quarter")
Cc: <stable@vger.kernel.org>
Signed-off-by: Dan Vacura <w36195@motorola.com>
Link: https://lore.kernel.org/r/20221018215044.765044-2-w36195@motorola.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/gadget/function/uvc_video.c b/drivers/usb/gadget/function/uvc_video.c
index bb037fcc90e6..323977716f5a 100644
--- a/drivers/usb/gadget/function/uvc_video.c
+++ b/drivers/usb/gadget/function/uvc_video.c
@@ -431,7 +431,8 @@ static void uvcg_video_pump(struct work_struct *work)
 
 		/* Endpoint now owns the request */
 		req = NULL;
-		video->req_int_count++;
+		if (buf->state != UVC_BUF_STATE_DONE)
+			video->req_int_count++;
 	}
 
 	if (!req)

