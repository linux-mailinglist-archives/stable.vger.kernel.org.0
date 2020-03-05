Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11BE617B0DE
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 22:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbgCEVtf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 16:49:35 -0500
Received: from www.linuxtv.org ([130.149.80.248]:48800 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbgCEVtf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Mar 2020 16:49:35 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1j9yLC-004Drb-6S; Thu, 05 Mar 2020 21:47:38 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Thu, 05 Mar 2020 21:44:06 +0000
Subject: [git:media_tree/master] media: v4l2-core: fix a use-after-free bug of sd->devnode
To:     linuxtv-commits@linuxtv.org
Cc:     Dafna Hirschfeld <dafna.hirschfeld@collabora.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1j9yLC-004Drb-6S@www.linuxtv.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: v4l2-core: fix a use-after-free bug of sd->devnode
Author:  Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
Date:    Wed Feb 19 16:25:54 2020 +0100

sd->devnode is released after calling
v4l2_subdev_release. Therefore it should be set
to NULL so that the subdev won't hold a pointer
to a released object. This fixes a reference
after free bug in function
v4l2_device_unregister_subdev

Fixes: 0e43734d4c46e ("media: v4l2-subdev: add release() internal op")

Cc: stable@vger.kernel.org
Signed-off-by: Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
Reviewed-by: Ezequiel Garcia <ezequiel@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/v4l2-core/v4l2-device.c | 1 +
 1 file changed, 1 insertion(+)

---

diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
index 63d6b147b21e..41da73ce2e98 100644
--- a/drivers/media/v4l2-core/v4l2-device.c
+++ b/drivers/media/v4l2-core/v4l2-device.c
@@ -179,6 +179,7 @@ static void v4l2_subdev_release(struct v4l2_subdev *sd)
 
 	if (sd->internal_ops && sd->internal_ops->release)
 		sd->internal_ops->release(sd);
+	sd->devnode = NULL;
 	module_put(owner);
 }
 
