Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F124216A887
	for <lists+stable@lfdr.de>; Mon, 24 Feb 2020 15:38:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727160AbgBXOiQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Feb 2020 09:38:16 -0500
Received: from www.linuxtv.org ([130.149.80.248]:54442 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727640AbgBXOiQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Feb 2020 09:38:16 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1j6EqW-008ut2-Ev; Mon, 24 Feb 2020 14:36:32 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Mon, 24 Feb 2020 14:09:10 +0000
Subject: [git:media_tree/master] media: v4l2-mem2mem.c: fix broken links
To:     linuxtv-commits@linuxtv.org
Cc:     stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1j6EqW-008ut2-Ev@www.linuxtv.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: v4l2-mem2mem.c: fix broken links
Author:  Hans Verkuil <hverkuil-cisco@xs4all.nl>
Date:    Tue Feb 4 19:13:06 2020 +0100

The topology that v4l2_m2m_register_media_controller() creates for a
processing block actually created a source-to-source link and a sink-to-sink
link instead of two source-to-sink links.

Unfortunately v4l2-compliance never checked for such bad links, so this
went unreported for quite some time.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reported-by: Nicolas Dufresne <nicolas@ndufresne.ca>
Cc: <stable@vger.kernel.org>      # for v4.19 and up
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/v4l2-core/v4l2-mem2mem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

---

diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index 1afd9c6ad908..cc34c5ab7009 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -880,12 +880,12 @@ int v4l2_m2m_register_media_controller(struct v4l2_m2m_dev *m2m_dev,
 		goto err_rel_entity1;
 
 	/* Connect the three entities */
-	ret = media_create_pad_link(m2m_dev->source, 0, &m2m_dev->proc, 1,
+	ret = media_create_pad_link(m2m_dev->source, 0, &m2m_dev->proc, 0,
 			MEDIA_LNK_FL_IMMUTABLE | MEDIA_LNK_FL_ENABLED);
 	if (ret)
 		goto err_rel_entity2;
 
-	ret = media_create_pad_link(&m2m_dev->proc, 0, &m2m_dev->sink, 0,
+	ret = media_create_pad_link(&m2m_dev->proc, 1, &m2m_dev->sink, 0,
 			MEDIA_LNK_FL_IMMUTABLE | MEDIA_LNK_FL_ENABLED);
 	if (ret)
 		goto err_rm_links0;
