Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3659560FE37
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236877AbiJ0RDT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236881AbiJ0RDS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:03:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF72194227
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:03:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3211B824DB
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:03:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 570B8C433D6;
        Thu, 27 Oct 2022 17:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890193;
        bh=Ixtyy5U9zsM2ftU7rUP3EHr+IvR5PosfgCmr6HIp3xs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P+N/t6TyypdCAO1oeTs2b35lyMkS/0auHzkzSvkp5UpdjfJ2OQls+iqj79HsDYLWx
         noGmlHNmoAjFik1QnMF7V0jHy/eFgLIshqxchXrgfnUdfpJ+G8yWiPjhydIy9S6N7d
         aVZKU0kZCjw4HJTXo5WbcXcuVDSrZvk75/RjU+xE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Bingbu Cao <bingbu.cao@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.15 27/79] media: ipu3-imgu: Fix NULL pointer dereference in active selection access
Date:   Thu, 27 Oct 2022 18:55:25 +0200
Message-Id: <20221027165055.853068757@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.917467648@linuxfoundation.org>
References: <20221027165054.917467648@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit b9eb3ab6f30bf32f7326909f17949ccb11bab514 upstream.

What the IMGU driver did was that it first acquired the pointers to active
and try V4L2 subdev state, and only then figured out which one to use.

The problem with that approach and a later patch (see Fixes: tag) is that
as sd_state argument to v4l2_subdev_get_try_crop() et al is NULL, there is
now an attempt to dereference that.

Fix this.

Also rewrap lines a little.

Fixes: 0d346d2a6f54 ("media: v4l2-subdev: add subdev-wide state struct")
Cc: stable@vger.kernel.org # for v5.14 and later
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Bingbu Cao <bingbu.cao@intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/ipu3/ipu3-v4l2.c |   31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

--- a/drivers/staging/media/ipu3/ipu3-v4l2.c
+++ b/drivers/staging/media/ipu3/ipu3-v4l2.c
@@ -192,33 +192,30 @@ static int imgu_subdev_get_selection(str
 				     struct v4l2_subdev_state *sd_state,
 				     struct v4l2_subdev_selection *sel)
 {
-	struct v4l2_rect *try_sel, *r;
-	struct imgu_v4l2_subdev *imgu_sd = container_of(sd,
-							struct imgu_v4l2_subdev,
-							subdev);
+	struct imgu_v4l2_subdev *imgu_sd =
+		container_of(sd, struct imgu_v4l2_subdev, subdev);
 
 	if (sel->pad != IMGU_NODE_IN)
 		return -EINVAL;
 
 	switch (sel->target) {
 	case V4L2_SEL_TGT_CROP:
-		try_sel = v4l2_subdev_get_try_crop(sd, sd_state, sel->pad);
-		r = &imgu_sd->rect.eff;
-		break;
+		if (sel->which == V4L2_SUBDEV_FORMAT_TRY)
+			sel->r = *v4l2_subdev_get_try_crop(sd, sd_state,
+							   sel->pad);
+		else
+			sel->r = imgu_sd->rect.eff;
+		return 0;
 	case V4L2_SEL_TGT_COMPOSE:
-		try_sel = v4l2_subdev_get_try_compose(sd, sd_state, sel->pad);
-		r = &imgu_sd->rect.bds;
-		break;
+		if (sel->which == V4L2_SUBDEV_FORMAT_TRY)
+			sel->r = *v4l2_subdev_get_try_compose(sd, sd_state,
+							      sel->pad);
+		else
+			sel->r = imgu_sd->rect.bds;
+		return 0;
 	default:
 		return -EINVAL;
 	}
-
-	if (sel->which == V4L2_SUBDEV_FORMAT_TRY)
-		sel->r = *try_sel;
-	else
-		sel->r = *r;
-
-	return 0;
 }
 
 static int imgu_subdev_set_selection(struct v4l2_subdev *sd,


