Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3BA42ED0B
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388012AbfE3Dah (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:30:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:48934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388433AbfE3Dae (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:30:34 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD33F24AF9;
        Thu, 30 May 2019 03:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559187033;
        bh=rHRYoMxf+3+xCzC0iUQ9wehSRgMHzUgWyR+/TDKu0MY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tOXhY2/GTqYF9bscholl+lTA34iQYphvUT0wghvJu05c/GuCQaEPFkwDZES1EXndq
         iE0kB7poukphleUCT0RsKjENGJxxeg0cZgCitqsTpIvQgTn8gK/tHEEGJLxCsl6RWl
         5VCfzicdqtKsn/PVCloW4Ed9LMYeIJAhx80pea38=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 060/128] media: ov2659: make S_FMT succeed even if requested format doesnt match
Date:   Wed, 29 May 2019 20:06:32 -0700
Message-Id: <20190530030445.565807220@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030432.977908967@linuxfoundation.org>
References: <20190530030432.977908967@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit bccb89cf9cd07a0690d519696a00c00a973b3fe4 ]

This driver returns an error if unsupported media bus pixel code is
requested by VIDIOC_SUBDEV_S_FMT.

But according to Documentation/media/uapi/v4l/vidioc-subdev-g-fmt.rst,

Drivers must not return an error solely because the requested format
doesn't match the device capabilities. They must instead modify the
format to match what the hardware can provide.

So select default format code and return success in that case.

This is detected by v4l2-compliance.

Cc: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov2659.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ov2659.c b/drivers/media/i2c/ov2659.c
index 1f999e9c0118e..3554eea77e04c 100644
--- a/drivers/media/i2c/ov2659.c
+++ b/drivers/media/i2c/ov2659.c
@@ -1117,8 +1117,10 @@ static int ov2659_set_fmt(struct v4l2_subdev *sd,
 		if (ov2659_formats[index].code == mf->code)
 			break;
 
-	if (index < 0)
-		return -EINVAL;
+	if (index < 0) {
+		index = 0;
+		mf->code = ov2659_formats[index].code;
+	}
 
 	mf->colorspace = V4L2_COLORSPACE_SRGB;
 	mf->code = ov2659_formats[index].code;
-- 
2.20.1



