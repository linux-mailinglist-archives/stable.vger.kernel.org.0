Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 262C92F351D
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 17:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392054AbhALQLy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 11:11:54 -0500
Received: from www.linuxtv.org ([130.149.80.248]:53714 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391713AbhALQLy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 11:11:54 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1kzMGF-00BqDD-PX; Tue, 12 Jan 2021 16:11:11 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Tue, 12 Jan 2021 16:09:57 +0000
Subject: [git:media_tree/master] media: ipu3-cio2: Fix mbus_code processing in cio2_subdev_set_fmt()
To:     linuxtv-commits@linuxtv.org
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        stable@vger.kernel.org, Pavel Machek (CIP) <pavel@denx.de>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1kzMGF-00BqDD-PX@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: ipu3-cio2: Fix mbus_code processing in cio2_subdev_set_fmt()
Author:  Pavel Machek <pavel@denx.de>
Date:    Wed Dec 30 13:55:50 2020 +0100

Loop was useless as it would always exit on the first iteration. Fix
it with right condition.

Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>
Fixes: a86cf9b29e8b ("media: ipu3-cio2: Validate mbus format in setting subdev format")
Tested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: stable@vger.kernel.org # v4.16 and up
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/pci/intel/ipu3/ipu3-cio2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
index 36e354ecf71e..e8ea69d30bfd 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
@@ -1269,7 +1269,7 @@ static int cio2_subdev_set_fmt(struct v4l2_subdev *sd,
 	fmt->format.code = formats[0].mbus_code;
 
 	for (i = 0; i < ARRAY_SIZE(formats); i++) {
-		if (formats[i].mbus_code == fmt->format.code) {
+		if (formats[i].mbus_code == mbus_code) {
 			fmt->format.code = mbus_code;
 			break;
 		}
