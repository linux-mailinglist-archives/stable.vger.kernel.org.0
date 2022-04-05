Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB2EB4F3413
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238185AbiDEInz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241221AbiDEIc4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3662617AA9;
        Tue,  5 Apr 2022 01:29:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA3D26062B;
        Tue,  5 Apr 2022 08:29:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8673C385A2;
        Tue,  5 Apr 2022 08:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147382;
        bh=JVi6iNnNgKNf/3WG5A4crMAJ/xLn832x/mT8K/pZK30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zN+XaU87NPzEG7mwtw/bbln7l5YwVwGeHG/SP9ZzNUxyC4LKMQw0lpEDGOOMEAuOg
         MryNHBVFR9tec+WAojgI0/RmuTvfxkV6ULodR7ENIqdkWGQFfVHTPzem9Gm7RbYe5r
         WkzkRE39FVLTH8000J3shfYU9Bs3yDwy6HkCeDjE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.17 1104/1126] media: ov6650: Add try support to selection API operations
Date:   Tue,  5 Apr 2022 09:30:51 +0200
Message-Id: <20220405070439.845546795@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Janusz Krzysztofik <jmkrzyszt@gmail.com>

commit c74052646496ffe0bc606152e6b9653137020cbf upstream.

Try requests are now only supported by format processing pad operations
implemented by the driver.  The driver selection API operations
currently respond to them with -EINVAL.  While that is correct, it
constraints video device drivers to not use subdevice cropping at all
while processing user requested active frame size, otherwise their set
try format results might differ from active.  As a consequence, we
can't fix set format pad operation as not to touch crop rectangle since
that would affect users not being able to set arbitrary frame sizes.
Moreover, without a working set try selection support we are not able
to use pad config crop rectangle as a reference while processing set
try format requests.

Implement missing try selection support.  Moreover, as it will be now
possible to maintain the pad config crop rectangle via selection API,
start using it instead of the active one as a reference while
processing set try format requests.

is_unscaled_ok() helper, now also called from set selection operation,
has been just moved up in the source file to avoid a prototype, with no
functional changes.

[Sakari Ailus: Rebase on subdev state patches]

Fixes: 717fd5b4907a ("[media] v4l2: replace try_mbus_fmt by set_fmt")
Signed-off-by: Janusz Krzysztofik <jmkrzyszt@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ov6650.c |   54 +++++++++++++++++++++++++++++++++++----------
 1 file changed, 43 insertions(+), 11 deletions(-)

--- a/drivers/media/i2c/ov6650.c
+++ b/drivers/media/i2c/ov6650.c
@@ -472,9 +472,16 @@ static int ov6650_get_selection(struct v
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct ov6650 *priv = to_ov6650(client);
+	struct v4l2_rect *rect;
 
-	if (sel->which != V4L2_SUBDEV_FORMAT_ACTIVE)
-		return -EINVAL;
+	if (sel->which == V4L2_SUBDEV_FORMAT_TRY) {
+		/* pre-select try crop rectangle */
+		rect = &sd_state->pads->try_crop;
+
+	} else {
+		/* pre-select active crop rectangle */
+		rect = &priv->rect;
+	}
 
 	switch (sel->target) {
 	case V4L2_SEL_TGT_CROP_BOUNDS:
@@ -483,14 +490,22 @@ static int ov6650_get_selection(struct v
 		sel->r.width = W_CIF;
 		sel->r.height = H_CIF;
 		return 0;
+
 	case V4L2_SEL_TGT_CROP:
-		sel->r = priv->rect;
+		/* use selected crop rectangle */
+		sel->r = *rect;
 		return 0;
+
 	default:
 		return -EINVAL;
 	}
 }
 
+static bool is_unscaled_ok(int width, int height, struct v4l2_rect *rect)
+{
+	return width > rect->width >> 1 || height > rect->height >> 1;
+}
+
 static void ov6650_bind_align_crop_rectangle(struct v4l2_rect *rect)
 {
 	v4l_bound_align_image(&rect->width, 2, W_CIF, 1,
@@ -510,12 +525,30 @@ static int ov6650_set_selection(struct v
 	struct ov6650 *priv = to_ov6650(client);
 	int ret;
 
-	if (sel->which != V4L2_SUBDEV_FORMAT_ACTIVE ||
-	    sel->target != V4L2_SEL_TGT_CROP)
+	if (sel->target != V4L2_SEL_TGT_CROP)
 		return -EINVAL;
 
 	ov6650_bind_align_crop_rectangle(&sel->r);
 
+	if (sel->which == V4L2_SUBDEV_FORMAT_TRY) {
+		struct v4l2_rect *crop = &sd_state->pads->try_crop;
+		struct v4l2_mbus_framefmt *mf = &sd_state->pads->try_fmt;
+		/* detect current pad config scaling factor */
+		bool half_scale = !is_unscaled_ok(mf->width, mf->height, crop);
+
+		/* store new crop rectangle */
+		*crop = sel->r;
+
+		/* adjust frame size */
+		mf->width = crop->width >> half_scale;
+		mf->height = crop->height >> half_scale;
+
+		return 0;
+	}
+
+	/* V4L2_SUBDEV_FORMAT_ACTIVE */
+
+	/* apply new crop rectangle */
 	ret = ov6650_reg_write(client, REG_HSTRT, sel->r.left >> 1);
 	if (!ret) {
 		priv->rect.width += priv->rect.left - sel->r.left;
@@ -567,11 +600,6 @@ static int ov6650_get_fmt(struct v4l2_su
 	return 0;
 }
 
-static bool is_unscaled_ok(int width, int height, struct v4l2_rect *rect)
-{
-	return width > rect->width >> 1 || height > rect->height >> 1;
-}
-
 #define to_clkrc(div)	((div) - 1)
 
 /* set the format we will capture in */
@@ -692,7 +720,11 @@ static int ov6650_set_fmt(struct v4l2_su
 		break;
 	}
 
-	*crop = priv->rect;
+	if (format->which == V4L2_SUBDEV_FORMAT_TRY)
+		*crop = sd_state->pads->try_crop;
+	else
+		*crop = priv->rect;
+
 	half_scale = !is_unscaled_ok(mf->width, mf->height, crop);
 
 	/* adjust new crop rectangle position against its current center */


