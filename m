Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D20654064A
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346921AbiFGRea (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347067AbiFGRaD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:30:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6460DA7E01;
        Tue,  7 Jun 2022 10:25:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 013F260DE0;
        Tue,  7 Jun 2022 17:25:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA0E3C385A5;
        Tue,  7 Jun 2022 17:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622732;
        bh=0y0FFTGDXWZJ7H/rNAVtgt3RCKaImJ3PuVIoA5Yd0qA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fv6WGP/rXv1i1HpXFyV9+4YIOD0DNOkx0V9kzn0uQgRUMu5OYrmV1c6gQlqymUIQ5
         LjJQ8SRcWz+mskdjzS2fAz54oIiGqd4xRKLBG7tCIy8ZutMvU+NM6ExqzeypehJQZM
         MYj71X6H2plQlnv1IDXy3HGB3ULgbbeXzvC+/UXM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wenst@chromium.org>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 156/452] media: hantro: Empty encoder capture buffers by default
Date:   Tue,  7 Jun 2022 19:00:13 +0200
Message-Id: <20220607164913.208046040@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 309373a3571ef7175bd9da0c9b13476a718e8478 ]

The payload size for encoder capture buffers is set by the driver upon
finishing encoding each frame, based on the encoded length returned from
hardware, and whatever header and padding length used. Setting a
non-zero default serves no real purpose, and also causes issues if the
capture buffer is returned to userspace unused, confusing the
application.

Instead, always set the payload size to 0 for encoder capture buffers
when preparing them.

Fixes: 775fec69008d ("media: add Rockchip VPU JPEG encoder driver")
Fixes: 082aaecff35f ("media: hantro: Fix .buf_prepare")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/hantro/hantro_v4l2.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/hantro/hantro_v4l2.c b/drivers/staging/media/hantro/hantro_v4l2.c
index 5c2ca61add8e..b65f2f3ef357 100644
--- a/drivers/staging/media/hantro/hantro_v4l2.c
+++ b/drivers/staging/media/hantro/hantro_v4l2.c
@@ -644,8 +644,12 @@ static int hantro_buf_prepare(struct vb2_buffer *vb)
 	 * (for OUTPUT buffers, if userspace passes 0 bytesused, v4l2-core sets
 	 * it to buffer length).
 	 */
-	if (V4L2_TYPE_IS_CAPTURE(vq->type))
-		vb2_set_plane_payload(vb, 0, pix_fmt->plane_fmt[0].sizeimage);
+	if (V4L2_TYPE_IS_CAPTURE(vq->type)) {
+		if (ctx->is_encoder)
+			vb2_set_plane_payload(vb, 0, 0);
+		else
+			vb2_set_plane_payload(vb, 0, pix_fmt->plane_fmt[0].sizeimage);
+	}
 
 	return 0;
 }
-- 
2.35.1



