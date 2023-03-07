Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 101A26AF094
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232740AbjCGScF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:32:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbjCGSbS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:31:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DF4CB3286
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:24:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF50261530
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:24:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6011C433EF;
        Tue,  7 Mar 2023 18:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213466;
        bh=sekdFoTiLQpuNCOOhesn7RX7CCio0Z6f/JbwigTCsqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mkJgULkG07CBXEL/hacQVHz1edBkG0b081aMc4xtevqcbMimS6RdmwXSVBAXO/wMF
         NhmK/37/OUW0RoKeQOTp0LzXFrR7520+mZC4bRTqfVvW2Cim4oJxBzY3FipH1pil+k
         B9lPERJzYdSXPu8o4ttXU7+TaA8+4hma6mAlpe9A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Robert Mader <robert.mader@collabora.com>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Benjamin Gaignard <benjamin.gaignard@collabora.com>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 516/885] media: hantro: Fix JPEG encoder ENUM_FRMSIZE on RK3399
Date:   Tue,  7 Mar 2023 17:57:30 +0100
Message-Id: <20230307170024.890939112@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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

From: Nicolas Dufresne <nicolas.dufresne@collabora.com>

[ Upstream commit 29bd426764dee14a09e37700406f4a5920825fcc ]

Since 79c987de8b354, enumerating framesize on format set with "MODE_NONE"
(any raw formats) is reporting an invalid frmsize.

  Size: Stepwise 0x0 - 0x0 with step 0/0

Before this change, the driver would return EINVAL, which is also invalid
but worked in GStreamer. The original intent was not to implement it, hence
the -ENOTTY return in this change. While drivers should implement
ENUM_FRMSIZE for all formats and queues, this change is limited in scope to
fix the regression.

This fixes taking picture in Gnome Cheese software, or any software using
GSteamer to encode JPEG with hardware acceleration.

Fixes: 79c987de8b35 ("media: hantro: Use post processor scaling capacities")
Reported-by: Robert Mader <robert.mader@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reviewed-by: Benjamin Gaignard <benjamin.gaignard@collabora.com>
Reviewed-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Tested-by: Robert Mader <robert.mader@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/verisilicon/hantro_v4l2.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/verisilicon/hantro_v4l2.c b/drivers/media/platform/verisilicon/hantro_v4l2.c
index 2c7a805289e7b..30e650edaea8a 100644
--- a/drivers/media/platform/verisilicon/hantro_v4l2.c
+++ b/drivers/media/platform/verisilicon/hantro_v4l2.c
@@ -161,8 +161,11 @@ static int vidioc_enum_framesizes(struct file *file, void *priv,
 	}
 
 	/* For non-coded formats check if postprocessing scaling is possible */
-	if (fmt->codec_mode == HANTRO_MODE_NONE && hantro_needs_postproc(ctx, fmt)) {
-		return hanto_postproc_enum_framesizes(ctx, fsize);
+	if (fmt->codec_mode == HANTRO_MODE_NONE) {
+		if (hantro_needs_postproc(ctx, fmt))
+			return hanto_postproc_enum_framesizes(ctx, fsize);
+		else
+			return -ENOTTY;
 	} else if (fsize->index != 0) {
 		vpu_debug(0, "invalid frame size index (expected 0, got %d)\n",
 			  fsize->index);
-- 
2.39.2



