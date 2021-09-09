Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8942E4057D6
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356317AbhIINmf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:42:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:58638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356618AbhIIMzd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:55:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E58D63246;
        Thu,  9 Sep 2021 11:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188691;
        bh=1a5y8LiFONH2ffe+Lg7p+xIrgh8MKkOsFNyV/nOJ6tg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oaoAcT1oHBC97ZzHURAgWk6JDC7iAyJ6JW5QAjwOIoNp5U7gH0YlS4J55g5xO/aYu
         0RlSPpgZUZeQpgSWOi/8xgHj11wVZkEL8X9+CW0O9Ukhi1e9xyAA8ZBBWNlchvSXrF
         wFyXUlbBL9y/fh+TQNFlkAPB6gvXb4T8ERMpEO5/6WrgZhC4cxrTSAsrFXLjuWbGSw
         JXLFmjHHP1bPdA0BPevS/j5XBwqS5zxfwgr4AH3sFnF0EvmIuUn0cXEtkE4q5UXzsY
         9FTtkuisvZ/XP8Wu/0RREVWqiTFHuk8ldVRHwSZR4Uyc54gfsH1n/Mgccmx+fNHS7D
         6I8fYA3wQ7BSQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Umang Jain <umang.jain@ideasonboard.com>,
        Bingbu Cao <bingbu.cao@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 36/74] media: imx258: Rectify mismatch of VTS value
Date:   Thu,  9 Sep 2021 07:56:48 -0400
Message-Id: <20210909115726.149004-36-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115726.149004-1-sashal@kernel.org>
References: <20210909115726.149004-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 31a1e2294843..68ce63333744 100644
--- a/drivers/media/i2c/imx258.c
+++ b/drivers/media/i2c/imx258.c
@@ -22,7 +22,7 @@
 #define IMX258_CHIP_ID			0x0258
 
 /* V_TIMING internal */
-#define IMX258_VTS_30FPS		0x0c98
+#define IMX258_VTS_30FPS		0x0c50
 #define IMX258_VTS_30FPS_2K		0x0638
 #define IMX258_VTS_30FPS_VGA		0x034c
 #define IMX258_VTS_MAX			0xffff
-- 
2.30.2

