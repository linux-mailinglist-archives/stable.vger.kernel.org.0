Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86197621543
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235241AbiKHOKA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:10:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235207AbiKHOJn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:09:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDAE61FCEB
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:09:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B589615CD
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:09:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E6A1C433D6;
        Tue,  8 Nov 2022 14:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916580;
        bh=/uA28JOZsGuGxJeZ8GpFfYvcJZDB16Q/T2hfP/wgi1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TezUEIjth0lK/c2LmFqKUQxmHI37RwDCuD358mWwDlc5IfRRlp6aRqp9E7EAtwPbr
         6dn4PC4EnqAFYNjA9M6jEYimVBIFCywVxbmY3C/H06ZnK24QXnIAneXZ/n2LbLkx3Y
         iJBY9Xeu1rlv+ssDCSicMFkzkBQRY6q+yEQ2Ap+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Paul Elder <paul.elder@ideasonboard.com>,
        Dafna Hirschfeld <dafna@fastmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 068/197] media: rkisp1: Zero v4l2_subdev_format fields in when validating links
Date:   Tue,  8 Nov 2022 14:38:26 +0100
Message-Id: <20221108133357.942657462@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
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

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit c53e3a049f35978a150526671587fd46b1ae7ca1 ]

The local sd_fmt variable in rkisp1_capture_link_validate() has
uninitialized fields, which causes random failures when calling the
subdev .get_fmt() operation. Fix it by initializing the variable when
declaring it, which zeros all other fields.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Paul Elder <paul.elder@ideasonboard.com>
Reviewed-by: Dafna Hirschfeld <dafna@fastmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rockchip/rkisp1/rkisp1-capture.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/rockchip/rkisp1/rkisp1-capture.c b/drivers/media/platform/rockchip/rkisp1/rkisp1-capture.c
index d5904c96ff3f..c66963a2ccd9 100644
--- a/drivers/media/platform/rockchip/rkisp1/rkisp1-capture.c
+++ b/drivers/media/platform/rockchip/rkisp1/rkisp1-capture.c
@@ -1273,11 +1273,12 @@ static int rkisp1_capture_link_validate(struct media_link *link)
 	struct rkisp1_capture *cap = video_get_drvdata(vdev);
 	const struct rkisp1_capture_fmt_cfg *fmt =
 		rkisp1_find_fmt_cfg(cap, cap->pix.fmt.pixelformat);
-	struct v4l2_subdev_format sd_fmt;
+	struct v4l2_subdev_format sd_fmt = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+		.pad = link->source->index,
+	};
 	int ret;
 
-	sd_fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
-	sd_fmt.pad = link->source->index;
 	ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &sd_fmt);
 	if (ret)
 		return ret;
-- 
2.35.1



