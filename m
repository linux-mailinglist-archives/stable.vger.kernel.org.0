Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91CA5695B7
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 17:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389501AbfGOO7n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:59:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:39312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731767AbfGOOSw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:18:52 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 139E6205F4;
        Mon, 15 Jul 2019 14:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563200331;
        bh=HE6ERcQjIe0JLOZKqju78rK1r/f4JuYXJmjufqB2V4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JCQc1E/W/bh2ONlb0JS1LC+nGqjz68cCNMSZLI7u1RKE+eDomE+fb2yPVX76D5Cdi
         y9eiQ7SYg+qamirXiqAvKJeRnhZIcWugjgfMFUkcMCMeKmfoLpQKQk5IWra6OZl7Ks
         5HPeLUi0mmqPdfkK4qUi6Xk+KXO0vEUctbAMfEN4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Wenyou Yang <wenyou.yang@microchip.com>,
        Eugen Hristev <eugen.hristev@microchip.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 014/158] media: ov7740: avoid invalid framesize setting
Date:   Mon, 15 Jul 2019 10:15:45 -0400
Message-Id: <20190715141809.8445-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715141809.8445-1-sashal@kernel.org>
References: <20190715141809.8445-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Akinobu Mita <akinobu.mita@gmail.com>

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
index f5a1ee90a6c5..8a6a7a5929aa 100644
--- a/drivers/media/i2c/ov7740.c
+++ b/drivers/media/i2c/ov7740.c
@@ -761,7 +761,11 @@ static int ov7740_try_fmt_internal(struct v4l2_subdev *sd,
 
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

