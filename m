Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FBFF40E74C
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243739AbhIPRbI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:31:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:47062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352807AbhIPR2k (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:28:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 735B4613C8;
        Thu, 16 Sep 2021 16:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810755;
        bh=TnE9Wlka/HbaP3UhSIR4v05u7JFUS6ZvZ5/7L0O4TAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U+gECLyuT+Z8JlPEjM/IDmNzoJonDBSDvmB0uXV6Cr6N5wtP6r+pHsUDWf6F5vSrE
         kBbTVVhJx++u/CsLVRufolqoyAy9zb2x/2qW4fwau2r/mfB+IRRAKh4YhQ+UZtlHPX
         USmXcvnIC38jSdjKYE6QCEQCAjjc0qSE3UlqkplU=
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
Subject: [PATCH 5.14 255/432] media: imx258: Rectify mismatch of VTS value
Date:   Thu, 16 Sep 2021 18:00:04 +0200
Message-Id: <20210916155819.468844818@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
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
index 7ab9e5f9f267..4e695096e5d0 100644
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



