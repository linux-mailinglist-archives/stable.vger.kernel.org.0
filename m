Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF174F3A0D
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379064AbiDELkM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354225AbiDEKMT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:12:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B2CA5A5A0;
        Tue,  5 Apr 2022 02:59:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4EAEB81BAE;
        Tue,  5 Apr 2022 09:59:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED431C385A2;
        Tue,  5 Apr 2022 09:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152756;
        bh=5l6ORz8eE2NVxh7n5XMeTQ77XrdLfW9u905815LIC3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UI+Zl7wmKbfGU/6AhVgihqDR87zc6C2WOZin1BqY/VdviVfJRP6EjfDOSu6JapN7d
         7f+AI4oDLM+t/v+DciMxCHUM959u6x30RlN3tI7UC0sfQ2VVjf0coOqSfvDdGQhzZ5
         Y4Tq8CNg64rs5M+m94e7pDAxjDlL50REPu5xoTcw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.15 891/913] media: ov6650: Fix crop rectangle affected by set format
Date:   Tue,  5 Apr 2022 09:32:33 +0200
Message-Id: <20220405070406.530053519@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

commit 985d2d7a482e9b64ef9643702b066da9cbd6ae8e upstream.

According to subdevice interface specification found in V4L2 API
documentation, set format pad operations should not affect image
geometry set in preceding image processing steps. Unfortunately, that
requirement is not respected by the driver implementation of set format
as it was not the case when that code was still implementing a pair of
now obsolete .s_mbus_fmt() / .try_mbus_fmt() video operations before
they have been merged and reused as an implementation of .set_fmt() pad
operation by commit 717fd5b4907a ("[media] v4l2: replace try_mbus_fmt
by set_fmt").

Exclude non-compliant crop rectangle adjustments from set format try,
as well as a call to .set_selection() from set format active processing
path, so only frame scaling is applied as needed and crop rectangle is
no longer modified.

[Sakari Ailus: Rebase on subdev state patches]

Fixes: 717fd5b4907a ("[media] v4l2: replace try_mbus_fmt by set_fmt")
Signed-off-by: Janusz Krzysztofik <jmkrzyszt@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ov6650.c |   28 ++++------------------------
 1 file changed, 4 insertions(+), 24 deletions(-)

--- a/drivers/media/i2c/ov6650.c
+++ b/drivers/media/i2c/ov6650.c
@@ -693,11 +693,7 @@ static int ov6650_set_fmt(struct v4l2_su
 	struct v4l2_mbus_framefmt *mf = &format->format;
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct ov6650 *priv = to_ov6650(client);
-	struct v4l2_subdev_selection sel = {
-		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
-		.target = V4L2_SEL_TGT_CROP,
-	};
-	struct v4l2_rect *crop = &sel.r;
+	struct v4l2_rect *crop;
 	bool half_scale;
 
 	if (format->pad)
@@ -721,24 +717,13 @@ static int ov6650_set_fmt(struct v4l2_su
 	}
 
 	if (format->which == V4L2_SUBDEV_FORMAT_TRY)
-		*crop = sd_state->pads->try_crop;
+		crop = &sd_state->pads->try_crop;
 	else
-		*crop = priv->rect;
+		crop = &priv->rect;
 
 	half_scale = !is_unscaled_ok(mf->width, mf->height, crop);
 
-	/* adjust new crop rectangle position against its current center */
-	crop->left += (crop->width - (mf->width << half_scale)) / 2;
-	crop->top += (crop->height - (mf->height << half_scale)) / 2;
-	/* adjust new crop rectangle size */
-	crop->width = mf->width << half_scale;
-	crop->height = mf->height << half_scale;
-
 	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
-		/* store new crop rectangle, hadware bound, in pad config */
-		ov6650_bind_align_crop_rectangle(crop);
-		sd_state->pads->try_crop = *crop;
-
 		/* store new mbus frame format code and size in pad config */
 		sd_state->pads->try_fmt.width = crop->width >> half_scale;
 		sd_state->pads->try_fmt.height = crop->height >> half_scale;
@@ -751,12 +736,7 @@ static int ov6650_set_fmt(struct v4l2_su
 		mf->code = sd_state->pads->try_fmt.code;
 
 	} else {
-		int ret;
-
-		/* apply new crop rectangle */
-		ret = ov6650_set_selection(sd, NULL, &sel);
-		if (ret)
-			return ret;
+		int ret = 0;
 
 		/* apply new media bus frame format and scaling if changed */
 		if (mf->code != priv->code || half_scale != priv->half_scale)


