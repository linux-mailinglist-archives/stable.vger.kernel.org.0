Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7234412EF09
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730749AbgABWe5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:34:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:44206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729967AbgABWe5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:34:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CD2821D7D;
        Thu,  2 Jan 2020 22:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004497;
        bh=HdQ/o7CWYE3V9qn1x9H2B6elzdMDx5vxzQUWP3T8quI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=07f3bQ+TU0y+KdcWnVUsGeZgx0XM6cPaP/uOI1pnMV69xXBDA8M/XfTO3ZlkLK0j5
         wNYZCfw8+EG+D/nIcbvjhIg2xNR2Ei/TV3UmSEVcx3uAnfMtuuMIxf8ZmTXCLz2Hhn
         VCeNYoYhYZXkrBED1RuEm9/R9PkavH+fDorakjPo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benoit Parrot <bparrot@ti.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 024/137] media: ti-vpe: vpe: Make sure YUYV is set as default format
Date:   Thu,  2 Jan 2020 23:06:37 +0100
Message-Id: <20200102220549.876224377@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220546.618583146@linuxfoundation.org>
References: <20200102220546.618583146@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benoit Parrot <bparrot@ti.com>

[ Upstream commit e20b248051ca0f90d84b4d9378e4780bc31f16c6 ]

v4l2-compliance fails with this message:

   fail: v4l2-test-formats.cpp(672): \
	Video Capture Multiplanar: TRY_FMT(G_FMT) != G_FMT
   fail: v4l2-test-formats.cpp(672): \
	Video Output Multiplanar: TRY_FMT(G_FMT) != G_FMT
	...
   test VIDIOC_TRY_FMT: FAIL

The default pixel format was setup as pointing to a specific offset in
the vpe_formats table assuming it was pointing to the V4L2_PIX_FMT_YUYV
entry. This became false after the addition on the NV21 format (see
above commid-id)

So instead of hard-coding an offset which might change over time we need
to use a lookup helper instead so we know the default will always be what
we intended.

Signed-off-by: Benoit Parrot <bparrot@ti.com>
Fixes: 40cc823f7005 ("media: ti-vpe: Add support for NV21 format")
Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/ti-vpe/vpe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index aa2870e864f9..b5f8c425cd2e 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -2000,7 +2000,7 @@ static int vpe_open(struct file *file)
 	v4l2_ctrl_handler_setup(hdl);
 
 	s_q_data = &ctx->q_data[Q_DATA_SRC];
-	s_q_data->fmt = &vpe_formats[2];
+	s_q_data->fmt = __find_format(V4L2_PIX_FMT_YUYV);
 	s_q_data->width = 1920;
 	s_q_data->height = 1080;
 	s_q_data->bytesperline[VPE_LUMA] = (s_q_data->width *
-- 
2.20.1



