Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 738B174013
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727593AbfGXTXk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:23:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:39474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387835AbfGXTXk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:23:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 845DB229ED;
        Wed, 24 Jul 2019 19:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996219;
        bh=DW0BB2DTYiRuPIgJVs7ix7BEP9vmGWAvsSoJQnzaCJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PxIZMT9EeimY3KCThwJfPXzxWqzrFNfa2B1yY8EZzS243ml4oH2hT77czEwMZXteM
         zr2K1v84P1QkH9dT286O2dtgPABe3TwbmSyRGwnzOT0f3d+efGjigLCGDkOdfHl68T
         DlqNdPlJjoT6fmzyd26RxmX2yvjz1PZzMfAyNR00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenyou Yang <wenyou.yang@microchip.com>,
        Eugen Hristev <eugen.hristev@microchip.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 021/413] media: ov7740: avoid invalid framesize setting
Date:   Wed, 24 Jul 2019 21:15:12 +0200
Message-Id: <20190724191736.960254327@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 6e4ab830ac6d6a0d7cd7f87dc5d6536369bf24a8 ]

If the requested framesize by VIDIOC_SUBDEV_S_FMT is larger than supported
framesizes, it causes an out of bounds array access and the resulting
framesize is unexpected.

Avoid out of bounds array access and select the default framesize.

Cc: Wenyou Yang <wenyou.yang@microchip.com>
Cc: Eugen Hristev <eugen.hristev@microchip.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov7740.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov7740.c b/drivers/media/i2c/ov7740.c
index 54e80a60aa57..63011d4b4738 100644
--- a/drivers/media/i2c/ov7740.c
+++ b/drivers/media/i2c/ov7740.c
@@ -785,7 +785,11 @@ static int ov7740_try_fmt_internal(struct v4l2_subdev *sd,
 
 		fsize++;
 	}
-
+	if (i >= ARRAY_SIZE(ov7740_framesizes)) {
+		fsize = &ov7740_framesizes[0];
+		fmt->width = fsize->width;
+		fmt->height = fsize->height;
+	}
 	if (ret_frmsize != NULL)
 		*ret_frmsize = fsize;
 
-- 
2.20.1



