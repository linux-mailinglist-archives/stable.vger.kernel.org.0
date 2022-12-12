Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCF264A02A
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:21:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231795AbiLLNVk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:21:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232608AbiLLNVU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:21:20 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2EE3FEE
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:21:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CAA69CE0F11
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:21:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7132BC433EF;
        Mon, 12 Dec 2022 13:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670851275;
        bh=uAbHIsE6Pxufpz6ZO3sKBhzosc3M/V+AVZVMASvABfc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BZGSyFaaGeWPHGNkqQXmlTrsx0kCHwpsjMyFSlTt9BiU2GUn8j+cAkAYJbN4AVAOy
         AUMRvgKIfHVqLsRJEUJ2d4FkeX0FTlUJAkZb8T1iRL7QfrReSaIGVauIwfwmR8xEGA
         ehoyNDJebgHnVzQ8F6Vpu686SoJvS4yAK5xMaXFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.4 24/67] media: v4l2-dv-timings.c: fix too strict blanking sanity checks
Date:   Mon, 12 Dec 2022 14:16:59 +0100
Message-Id: <20221212130918.778494429@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130917.599345531@linuxfoundation.org>
References: <20221212130917.599345531@linuxfoundation.org>
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

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

commit 5eef2141776da02772c44ec406d6871a790761ee upstream.

Sanity checks were added to verify the v4l2_bt_timings blanking fields
in order to avoid integer overflows when userspace passes weird values.

But that assumed that userspace would correctly fill in the front porch,
backporch and sync values, but sometimes all you know is the total
blanking, which is then assigned to just one of these fields.

And that can fail with these checks.

So instead set a maximum for the total horizontal and vertical
blanking and check that each field remains below that.

That is still sufficient to avoid integer overflows, but it also
allows for more flexibility in how userspace fills in these fields.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Fixes: 4b6d66a45ed3 ("media: v4l2-dv-timings: add sanity checks for blanking values")
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/v4l2-core/v4l2-dv-timings.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -145,6 +145,8 @@ bool v4l2_valid_dv_timings(const struct
 	const struct v4l2_bt_timings *bt = &t->bt;
 	const struct v4l2_bt_timings_cap *cap = &dvcap->bt;
 	u32 caps = cap->capabilities;
+	const u32 max_vert = 10240;
+	u32 max_hor = 3 * bt->width;
 
 	if (t->type != V4L2_DV_BT_656_1120)
 		return false;
@@ -166,14 +168,20 @@ bool v4l2_valid_dv_timings(const struct
 	if (!bt->interlaced &&
 	    (bt->il_vbackporch || bt->il_vsync || bt->il_vfrontporch))
 		return false;
-	if (bt->hfrontporch > 2 * bt->width ||
-	    bt->hsync > 1024 || bt->hbackporch > 1024)
+	/*
+	 * Some video receivers cannot properly separate the frontporch,
+	 * backporch and sync values, and instead they only have the total
+	 * blanking. That can be assigned to any of these three fields.
+	 * So just check that none of these are way out of range.
+	 */
+	if (bt->hfrontporch > max_hor ||
+	    bt->hsync > max_hor || bt->hbackporch > max_hor)
 		return false;
-	if (bt->vfrontporch > 4096 ||
-	    bt->vsync > 128 || bt->vbackporch > 4096)
+	if (bt->vfrontporch > max_vert ||
+	    bt->vsync > max_vert || bt->vbackporch > max_vert)
 		return false;
-	if (bt->interlaced && (bt->il_vfrontporch > 4096 ||
-	    bt->il_vsync > 128 || bt->il_vbackporch > 4096))
+	if (bt->interlaced && (bt->il_vfrontporch > max_vert ||
+	    bt->il_vsync > max_vert || bt->il_vbackporch > max_vert))
 		return false;
 	return fnc == NULL || fnc(t, fnc_handle);
 }


