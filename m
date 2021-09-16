Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8096F40E3B5
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239858AbhIPQve (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:51:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:59202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245086AbhIPQsF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:48:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3661961390;
        Thu, 16 Sep 2021 16:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809629;
        bh=oraHnGZFm1q6kF2RehNTcm+Sqn9GnMrRvzl+imUiu7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=prchKh68Y8XxvjCaK4Dl5zTZU5n06wMvrZ26lH/z+C0pi4CqQB2NBlNpMJ/9ipQnj
         /apMH40YXfeY04Hx/jnbSCTd8eT0BGaXiybmRh3EUTSSZb+LpeoxseiZEZ0wZnXEZb
         /8cYUImgAd8eq0S3CZqQe3X+LIH9zrtjeEQtlvm4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Umang Jain <umang.jain@ideasonboard.com>,
        Bingbu Cao <bingbu.cao@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 225/380] media: imx258: Rectify mismatch of VTS value
Date:   Thu, 16 Sep 2021 17:59:42 +0200
Message-Id: <20210916155811.743478918@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit 51f93add3669f1b1f540de1cf397815afbd4c756 ]

The frame_length_lines (0x0340) registers are hard-coded as follows:

- 4208x3118
  frame_length_lines = 0x0c50

- 2104x1560
  frame_length_lines = 0x0638

- 1048x780
  frame_length_lines = 0x034c

The driver exposes the V4L2_CID_VBLANK control in read-only mode and
sets its value to vts_def - height, where vts_def is a mode-dependent
value coming from the supported_modes array. It is set using one of
the following macros defined in the driver:

  #define IMX258_VTS_30FPS                0x0c98
  #define IMX258_VTS_30FPS_2K             0x0638
  #define IMX258_VTS_30FPS_VGA            0x034c

There's a clear mismatch in the value for the full resolution mode i.e.
IMX258_VTS_30FPS. Fix it by rectifying the macro with the value set for
the frame_length_lines register as stated above.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Umang Jain <umang.jain@ideasonboard.com>
Reviewed-by: Bingbu Cao <bingbu.cao@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/imx258.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/imx258.c b/drivers/media/i2c/imx258.c
index a017ec4e0f50..b3fa28d05fa6 100644
--- a/drivers/media/i2c/imx258.c
+++ b/drivers/media/i2c/imx258.c
@@ -23,7 +23,7 @@
 #define IMX258_CHIP_ID			0x0258
 
 /* V_TIMING internal */
-#define IMX258_VTS_30FPS		0x0c98
+#define IMX258_VTS_30FPS		0x0c50
 #define IMX258_VTS_30FPS_2K		0x0638
 #define IMX258_VTS_30FPS_VGA		0x034c
 #define IMX258_VTS_MAX			0xffff
-- 
2.30.2



