Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 535671039FB
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 13:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729140AbfKTMWa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 07:22:30 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:43754 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728611AbfKTMWa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Nov 2019 07:22:30 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: dafna)
        with ESMTPSA id 4B2A429011E
From:   Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     dafna.hirschfeld@collabora.com, hverkuil@xs4all.nl,
        dafna3@gmail.com, helen.koike@collabora.com,
        ezequiel@collabora.com, stable@vger.kernel.org
Subject: [PATCH v3] media: v4l2-core: fix a use-after-free bug of sd->devnode
Date:   Wed, 20 Nov 2019 13:22:17 +0100
Message-Id: <20191120122217.845-1-dafna.hirschfeld@collabora.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

sd->devnode is released after calling
v4l2_subdev_release. Therefore it should be set
to NULL so that the subdev won't hold a pointer
to a released object. This fixes a reference
after free bug in function
v4l2_device_unregister_subdev

Cc: stable@vger.kernel.org
Fixes: 0e43734d4c46e ("media: v4l2-subdev: add release() internal op")
Signed-off-by: Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
Reviewed-by: Ezequiel Garcia <ezequiel@collabora.com>
---
changes since v2:
- since this is a regresion fix, I added Fixes and Cc to stable tags,
- change the commit title and log to be more clear.

 drivers/media/v4l2-core/v4l2-device.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
index 63d6b147b21e..2b3595671d62 100644
--- a/drivers/media/v4l2-core/v4l2-device.c
+++ b/drivers/media/v4l2-core/v4l2-device.c
@@ -177,6 +177,7 @@ static void v4l2_subdev_release(struct v4l2_subdev *sd)
 {
 	struct module *owner = !sd->owner_v4l2_dev ? sd->owner : NULL;
 
+	sd->devnode = NULL;
 	if (sd->internal_ops && sd->internal_ops->release)
 		sd->internal_ops->release(sd);
 	module_put(owner);
-- 
2.20.1

