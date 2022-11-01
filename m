Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 681F36148EA
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 12:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbiKALbQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 07:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbiKALbA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 07:31:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C3FDF36;
        Tue,  1 Nov 2022 04:29:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 283F0B81CC4;
        Tue,  1 Nov 2022 11:29:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5AEAC433D6;
        Tue,  1 Nov 2022 11:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667302166;
        bh=CmSRNfBV86EsQV9BETmdAkbeneeSLp94EZfRDV42lKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F1D5z5E8G7SSrzEFyWUloZ81k+SODXUKWJT+vxSetplN1MCsEosI1eG716Skw4dv+
         PYGeD/JDbqKtKSSpSPQ4Wrr3RzRjVzYzoZdWZMRIqeS+lX9oMcoRnhioeWAsooPqkt
         cNdf2toDnPMWZTRW15qNymMsl07KvgbrcpvBYSMEhYPFDAzhpP91cEIB9saVPfLh33
         Zk9bvfbdxwt138ZVnahy13HNPoX8FdEOTnGhDEl2qzJRmlwJTquAUgmOtQHOJnnxtg
         ze1NbJBsxc41iCkm9D7hck7BOeZMpQSOHDEN4AYNEaqbUSdgl9PDklpCKAXM0qaoDg
         1XhP8rNEZRolQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Paul Elder <paul.elder@ideasonboard.com>,
        Dafna Hirschfeld <dafna@fastmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, heiko@sntech.de,
        linux-media@vger.kernel.org, linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 04/19] media: rkisp1: Zero v4l2_subdev_format fields in when validating links
Date:   Tue,  1 Nov 2022 07:29:04 -0400
Message-Id: <20221101112919.799868-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221101112919.799868-1-sashal@kernel.org>
References: <20221101112919.799868-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 41988eb0ec0a..0f980f68058c 100644
--- a/drivers/media/platform/rockchip/rkisp1/rkisp1-capture.c
+++ b/drivers/media/platform/rockchip/rkisp1/rkisp1-capture.c
@@ -1270,11 +1270,12 @@ static int rkisp1_capture_link_validate(struct media_link *link)
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

