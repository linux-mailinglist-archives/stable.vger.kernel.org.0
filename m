Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7B0D541323
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353796AbiFGT4K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356251AbiFGTx0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:53:26 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9E5DDEBF;
        Tue,  7 Jun 2022 11:23:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D9938CE1D6F;
        Tue,  7 Jun 2022 18:23:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB50EC385A5;
        Tue,  7 Jun 2022 18:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626191;
        bh=46Qb66EYmPaNXD+6g4oh6ss9dBX6I8aVHOvFe4cJatA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wx6eemUNNerWK+XrqUFkTSfm8bFxpKJm4MBF8lYX8xqVvixlK9LVEHRnEk0R4Fg4E
         r/PX3WPvcIndl3SdZ7arr1VOT3BOzLmbugWZUvAcCkdOUnpfuqipZ/fh29zKTtMFqu
         uXjMvEnihaVZ8/ZECByJHCOtwN9SuYL/5sAy6UtE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wenst@chromium.org>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 288/772] media: hantro: Empty encoder capture buffers by default
Date:   Tue,  7 Jun 2022 18:58:00 +0200
Message-Id: <20220607164957.511639142@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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
index e595905b3bd7..3067d76f7638 100644
--- a/drivers/staging/media/hantro/hantro_v4l2.c
+++ b/drivers/staging/media/hantro/hantro_v4l2.c
@@ -656,8 +656,12 @@ static int hantro_buf_prepare(struct vb2_buffer *vb)
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



