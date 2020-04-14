Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5428F1A7874
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 12:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438383AbgDNKdK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 06:33:10 -0400
Received: from www.linuxtv.org ([130.149.80.248]:39870 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438363AbgDNKc7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Apr 2020 06:32:59 -0400
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1jOIpK-001Ok4-DG; Tue, 14 Apr 2020 10:29:58 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Tue, 14 Apr 2020 10:18:37 +0000
Subject: [git:media_tree/master] media: ov5640: fix use of destroyed mutex
To:     linuxtv-commits@linuxtv.org
Cc:     stable@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Benoit Parrot <bparrot@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1jOIpK-001Ok4-DG@www.linuxtv.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: ov5640: fix use of destroyed mutex
Author:  Tomi Valkeinen <tomi.valkeinen@ti.com>
Date:    Wed Mar 25 13:20:00 2020 +0100

v4l2_ctrl_handler_free() uses hdl->lock, which in ov5640 driver is set
to sensor's own sensor->lock. In ov5640_remove(), the driver destroys the
sensor->lock first, and then calls v4l2_ctrl_handler_free(), resulting
in the use of the destroyed mutex.

Fix this by calling moving the mutex_destroy() to the end of the cleanup
sequence, as there's no need to destroy the mutex as early as possible.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: stable@vger.kernel.org # v4.14+
Reviewed-by: Benoit Parrot <bparrot@ti.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/i2c/ov5640.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

---

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 854031f0b64a..2fe4a7ac0592 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -3093,8 +3093,8 @@ static int ov5640_probe(struct i2c_client *client)
 free_ctrls:
 	v4l2_ctrl_handler_free(&sensor->ctrls.handler);
 entity_cleanup:
-	mutex_destroy(&sensor->lock);
 	media_entity_cleanup(&sensor->sd.entity);
+	mutex_destroy(&sensor->lock);
 	return ret;
 }
 
@@ -3104,9 +3104,9 @@ static int ov5640_remove(struct i2c_client *client)
 	struct ov5640_dev *sensor = to_ov5640_dev(sd);
 
 	v4l2_async_unregister_subdev(&sensor->sd);
-	mutex_destroy(&sensor->lock);
 	media_entity_cleanup(&sensor->sd.entity);
 	v4l2_ctrl_handler_free(&sensor->ctrls.handler);
+	mutex_destroy(&sensor->lock);
 
 	return 0;
 }
