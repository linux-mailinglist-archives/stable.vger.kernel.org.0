Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 453EA65D941
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239246AbjADQWy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:22:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239697AbjADQWf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:22:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B84BC1C100
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:22:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66D0AB81722
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:22:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8A2AC433EF;
        Wed,  4 Jan 2023 16:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849352;
        bh=RN0M+J3vqCCJpEcexJuW+gDn1bDAXANMXvjsflhV+/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pMazN72jnbF2l3CmqSqL97b84EjGXepbCUQcsJODLcs0Y4j2xmB+pRY0IhJV/eGNS
         1CVmWftxoYqEjVFpfEgf9gxt5qQm3X9lAsHAz4N1AcPSzIBlWsVgz+/JvJF9DvHY2F
         bRJzoR1CVlV8uWpkaNwTneo+DTkGgmkvvXsQPd2k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Maximilian Luz <luzmaximilian@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 6.0 094/177] ipu3-imgu: Fix NULL pointer dereference in imgu_subdev_set_selection()
Date:   Wed,  4 Jan 2023 17:06:25 +0100
Message-Id: <20230104160510.486726882@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maximilian Luz <luzmaximilian@gmail.com>

commit dc608edf7d45ba0c2ad14c06eccd66474fec7847 upstream.

Calling v4l2_subdev_get_try_crop() and v4l2_subdev_get_try_compose()
with a subdev state of NULL leads to a NULL pointer dereference. This
can currently happen in imgu_subdev_set_selection() when the state
passed in is NULL, as this method first gets pointers to both the "try"
and "active" states and only then decides which to use.

The same issue has been addressed for imgu_subdev_get_selection() with
commit 30d03a0de650 ("ipu3-imgu: Fix NULL pointer dereference in active
selection access"). However the issue still persists in
imgu_subdev_set_selection().

Therefore, apply a similar fix as done in the aforementioned commit to
imgu_subdev_set_selection(). To keep things a bit cleaner, introduce
helper functions for "crop" and "compose" access and use them in both
imgu_subdev_set_selection() and imgu_subdev_get_selection().

Fixes: 0d346d2a6f54 ("media: v4l2-subdev: add subdev-wide state struct")
Cc: stable@vger.kernel.org # for v5.14 and later
Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/ipu3/ipu3-v4l2.c |   57 +++++++++++++++++++--------------
 1 file changed, 34 insertions(+), 23 deletions(-)

--- a/drivers/staging/media/ipu3/ipu3-v4l2.c
+++ b/drivers/staging/media/ipu3/ipu3-v4l2.c
@@ -188,6 +188,28 @@ static int imgu_subdev_set_fmt(struct v4
 	return 0;
 }
 
+static struct v4l2_rect *
+imgu_subdev_get_crop(struct imgu_v4l2_subdev *sd,
+		     struct v4l2_subdev_state *sd_state, unsigned int pad,
+		     enum v4l2_subdev_format_whence which)
+{
+	if (which == V4L2_SUBDEV_FORMAT_TRY)
+		return v4l2_subdev_get_try_crop(&sd->subdev, sd_state, pad);
+	else
+		return &sd->rect.eff;
+}
+
+static struct v4l2_rect *
+imgu_subdev_get_compose(struct imgu_v4l2_subdev *sd,
+			struct v4l2_subdev_state *sd_state, unsigned int pad,
+			enum v4l2_subdev_format_whence which)
+{
+	if (which == V4L2_SUBDEV_FORMAT_TRY)
+		return v4l2_subdev_get_try_compose(&sd->subdev, sd_state, pad);
+	else
+		return &sd->rect.bds;
+}
+
 static int imgu_subdev_get_selection(struct v4l2_subdev *sd,
 				     struct v4l2_subdev_state *sd_state,
 				     struct v4l2_subdev_selection *sel)
@@ -200,18 +222,12 @@ static int imgu_subdev_get_selection(str
 
 	switch (sel->target) {
 	case V4L2_SEL_TGT_CROP:
-		if (sel->which == V4L2_SUBDEV_FORMAT_TRY)
-			sel->r = *v4l2_subdev_get_try_crop(sd, sd_state,
-							   sel->pad);
-		else
-			sel->r = imgu_sd->rect.eff;
+		sel->r = *imgu_subdev_get_crop(imgu_sd, sd_state, sel->pad,
+					       sel->which);
 		return 0;
 	case V4L2_SEL_TGT_COMPOSE:
-		if (sel->which == V4L2_SUBDEV_FORMAT_TRY)
-			sel->r = *v4l2_subdev_get_try_compose(sd, sd_state,
-							      sel->pad);
-		else
-			sel->r = imgu_sd->rect.bds;
+		sel->r = *imgu_subdev_get_compose(imgu_sd, sd_state, sel->pad,
+						  sel->which);
 		return 0;
 	default:
 		return -EINVAL;
@@ -223,10 +239,9 @@ static int imgu_subdev_set_selection(str
 				     struct v4l2_subdev_selection *sel)
 {
 	struct imgu_device *imgu = v4l2_get_subdevdata(sd);
-	struct imgu_v4l2_subdev *imgu_sd = container_of(sd,
-							struct imgu_v4l2_subdev,
-							subdev);
-	struct v4l2_rect *rect, *try_sel;
+	struct imgu_v4l2_subdev *imgu_sd =
+		container_of(sd, struct imgu_v4l2_subdev, subdev);
+	struct v4l2_rect *rect;
 
 	dev_dbg(&imgu->pci_dev->dev,
 		 "set subdev %u sel which %u target 0x%4x rect [%ux%u]",
@@ -238,22 +253,18 @@ static int imgu_subdev_set_selection(str
 
 	switch (sel->target) {
 	case V4L2_SEL_TGT_CROP:
-		try_sel = v4l2_subdev_get_try_crop(sd, sd_state, sel->pad);
-		rect = &imgu_sd->rect.eff;
+		rect = imgu_subdev_get_crop(imgu_sd, sd_state, sel->pad,
+					    sel->which);
 		break;
 	case V4L2_SEL_TGT_COMPOSE:
-		try_sel = v4l2_subdev_get_try_compose(sd, sd_state, sel->pad);
-		rect = &imgu_sd->rect.bds;
+		rect = imgu_subdev_get_compose(imgu_sd, sd_state, sel->pad,
+					       sel->which);
 		break;
 	default:
 		return -EINVAL;
 	}
 
-	if (sel->which == V4L2_SUBDEV_FORMAT_TRY)
-		*try_sel = sel->r;
-	else
-		*rect = sel->r;
-
+	*rect = sel->r;
 	return 0;
 }
 


