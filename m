Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4055116A80B
	for <lists+stable@lfdr.de>; Mon, 24 Feb 2020 15:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727281AbgBXOOP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Feb 2020 09:14:15 -0500
Received: from www.linuxtv.org ([130.149.80.248]:46506 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727494AbgBXOOP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Feb 2020 09:14:15 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1j6ETG-008tRi-G1; Mon, 24 Feb 2020 14:12:30 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Mon, 24 Feb 2020 14:10:39 +0000
Subject: [git:media_tree/fixes] media: hantro: Fix broken media controller links
To:     linuxtv-commits@linuxtv.org
Cc:     Ezequiel Garcia <ezequiel@collabora.com>, stable@vger.kernel.org,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1j6ETG-008tRi-G1@www.linuxtv.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: hantro: Fix broken media controller links
Author:  Ezequiel Garcia <ezequiel@collabora.com>
Date:    Tue Feb 4 20:38:37 2020 +0100

The driver currently creates a broken topology,
with a source-to-source link and a sink-to-sink
link instead of two source-to-sink links.

Reported-by: Nicolas Dufresne <nicolas@ndufresne.ca>
Cc: <stable@vger.kernel.org>      # for v5.3 and up
Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
Tested-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/staging/media/hantro/hantro_drv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

---

diff --git a/drivers/staging/media/hantro/hantro_drv.c b/drivers/staging/media/hantro/hantro_drv.c
index 97c615a2f057..c98835326135 100644
--- a/drivers/staging/media/hantro/hantro_drv.c
+++ b/drivers/staging/media/hantro/hantro_drv.c
@@ -558,13 +558,13 @@ static int hantro_attach_func(struct hantro_dev *vpu,
 		goto err_rel_entity1;
 
 	/* Connect the three entities */
-	ret = media_create_pad_link(&func->vdev.entity, 0, &func->proc, 1,
+	ret = media_create_pad_link(&func->vdev.entity, 0, &func->proc, 0,
 				    MEDIA_LNK_FL_IMMUTABLE |
 				    MEDIA_LNK_FL_ENABLED);
 	if (ret)
 		goto err_rel_entity2;
 
-	ret = media_create_pad_link(&func->proc, 0, &func->sink, 0,
+	ret = media_create_pad_link(&func->proc, 1, &func->sink, 0,
 				    MEDIA_LNK_FL_IMMUTABLE |
 				    MEDIA_LNK_FL_ENABLED);
 	if (ret)
