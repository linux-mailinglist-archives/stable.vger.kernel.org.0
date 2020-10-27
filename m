Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF9B929B69D
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1797420AbgJ0PX0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:23:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:38448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1797415AbgJ0PXZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:23:25 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5921D20657;
        Tue, 27 Oct 2020 15:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812204;
        bh=09+5vYYQ4VIhQpcPJ4r5qDo7EYsbc7Nl1ZKk6wAVCkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WTsr67oo5v9SNePnSrzPUwwDY/yKCA2oOCBtoYGccxZsXopBqR8L79On7XpknAhQJ
         qqaSaU1PbD4CoP0F6DPZ+IoTJVOWn8cvbyKI5g3GwQBsbRZsfrfaoqxNEoID6eif4R
         Dkl2cwksmemSwXumuEpm52p+oX0OAbnwwXeIFCVg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ezequiel Garcia <ezequiel@collabora.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 128/757] media: hantro: postproc: Fix motion vector space allocation
Date:   Tue, 27 Oct 2020 14:46:18 +0100
Message-Id: <20201027135456.584526513@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ezequiel Garcia <ezequiel@collabora.com>

[ Upstream commit 669ccf19ed2059b9d517664a2dbbf6bde87e1414 ]

When the post-processor is enabled, the driver allocates
"shadow buffers" which are used for the decoder core,
and exposes the post-processed buffers to userspace.

For this reason, extra motion vector space has to
be allocated on the shadow buffers, which the driver
wasn't doing. Fix it.

This fix should address artifacts on high profile bitstreams.

Fixes: 8c2d66b036c77 ("media: hantro: Support color conversion via post-processing")
Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/hantro/hantro_postproc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/hantro/hantro_postproc.c b/drivers/staging/media/hantro/hantro_postproc.c
index 44062ffceaea7..6d2a8f2a8f0bb 100644
--- a/drivers/staging/media/hantro/hantro_postproc.c
+++ b/drivers/staging/media/hantro/hantro_postproc.c
@@ -118,7 +118,9 @@ int hantro_postproc_alloc(struct hantro_ctx *ctx)
 	unsigned int num_buffers = cap_queue->num_buffers;
 	unsigned int i, buf_size;
 
-	buf_size = ctx->dst_fmt.plane_fmt[0].sizeimage;
+	buf_size = ctx->dst_fmt.plane_fmt[0].sizeimage +
+		   hantro_h264_mv_size(ctx->dst_fmt.width,
+				       ctx->dst_fmt.height);
 
 	for (i = 0; i < num_buffers; ++i) {
 		struct hantro_aux_buf *priv = &ctx->postproc.dec_q[i];
-- 
2.25.1



