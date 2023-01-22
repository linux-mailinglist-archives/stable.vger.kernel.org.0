Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07638676EB9
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbjAVPNj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:13:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230420AbjAVPNi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:13:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAB6321A28
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:13:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5739760C63
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:13:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6676FC433D2;
        Sun, 22 Jan 2023 15:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400416;
        bh=ug1rfvJhHBMIBHm/kDFORvtLY3Fr6ccx2iPnA1reSr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y/cOBuwZe/Zl7kw3aESusvY4CLS85rOYPHGCyjHkDglT3kY5GI9jcrpXYcUYvhvQP
         DaNxg3uBHlWcCeKMr+xipslPHlps3dDQn9u/hZqarlUz0fmHKz7qC1L9Zp19gAHJKf
         CHZQY2/JoVqU0LiDmZ2wKXq/i0FVAJDKhdTp6CWA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable <stable@kernel.org>,
        Daniel Scally <dan.scally@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH 5.10 66/98] usb: gadget: g_webcam: Send color matching descriptor per frame
Date:   Sun, 22 Jan 2023 16:04:22 +0100
Message-Id: <20230122150232.238059676@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150229.351631432@linuxfoundation.org>
References: <20230122150229.351631432@linuxfoundation.org>
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

From: Daniel Scally <dan.scally@ideasonboard.com>

commit e95765e97d9cb93258a4840440d410fa6ff7e819 upstream.

Currently the color matching descriptor is only sent across the wire
a single time, following the descriptors for each format and frame.
According to the UVC 1.5 Specification 3.9.2.6 ("Color Matching
Descriptors"):

"Only one instance is allowed for a given format and if present,
the Color Matching descriptor shall be placed following the Video
and Still Image Frame descriptors for that format".

Add another reference to the color matching descriptor after the
yuyv frames so that it's correctly transmitted for that format
too.

Fixes: a9914127e834 ("USB gadget: Webcam device")
Cc: stable <stable@kernel.org>
Signed-off-by: Daniel Scally <dan.scally@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
Link: https://lore.kernel.org/r/20221216160528.479094-1-dan.scally@ideasonboard.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/legacy/webcam.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/gadget/legacy/webcam.c
+++ b/drivers/usb/gadget/legacy/webcam.c
@@ -293,6 +293,7 @@ static const struct uvc_descriptor_heade
 	(const struct uvc_descriptor_header *) &uvc_format_yuv,
 	(const struct uvc_descriptor_header *) &uvc_frame_yuv_360p,
 	(const struct uvc_descriptor_header *) &uvc_frame_yuv_720p,
+	(const struct uvc_descriptor_header *) &uvc_color_matching,
 	(const struct uvc_descriptor_header *) &uvc_format_mjpg,
 	(const struct uvc_descriptor_header *) &uvc_frame_mjpg_360p,
 	(const struct uvc_descriptor_header *) &uvc_frame_mjpg_720p,
@@ -305,6 +306,7 @@ static const struct uvc_descriptor_heade
 	(const struct uvc_descriptor_header *) &uvc_format_yuv,
 	(const struct uvc_descriptor_header *) &uvc_frame_yuv_360p,
 	(const struct uvc_descriptor_header *) &uvc_frame_yuv_720p,
+	(const struct uvc_descriptor_header *) &uvc_color_matching,
 	(const struct uvc_descriptor_header *) &uvc_format_mjpg,
 	(const struct uvc_descriptor_header *) &uvc_frame_mjpg_360p,
 	(const struct uvc_descriptor_header *) &uvc_frame_mjpg_720p,
@@ -317,6 +319,7 @@ static const struct uvc_descriptor_heade
 	(const struct uvc_descriptor_header *) &uvc_format_yuv,
 	(const struct uvc_descriptor_header *) &uvc_frame_yuv_360p,
 	(const struct uvc_descriptor_header *) &uvc_frame_yuv_720p,
+	(const struct uvc_descriptor_header *) &uvc_color_matching,
 	(const struct uvc_descriptor_header *) &uvc_format_mjpg,
 	(const struct uvc_descriptor_header *) &uvc_frame_mjpg_360p,
 	(const struct uvc_descriptor_header *) &uvc_frame_mjpg_720p,


