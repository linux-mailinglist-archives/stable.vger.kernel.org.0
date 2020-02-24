Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77E9E16A888
	for <lists+stable@lfdr.de>; Mon, 24 Feb 2020 15:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727448AbgBXOiR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Feb 2020 09:38:17 -0500
Received: from www.linuxtv.org ([130.149.80.248]:54432 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727299AbgBXOiR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Feb 2020 09:38:17 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1j6EqW-008usU-8l; Mon, 24 Feb 2020 14:36:32 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Mon, 24 Feb 2020 14:10:04 +0000
Subject: [git:media_tree/master] media: mc-entity.c: use & to check pad flags, not ==
To:     linuxtv-commits@linuxtv.org
Cc:     stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1j6EqW-008usU-8l@www.linuxtv.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: mc-entity.c: use & to check pad flags, not ==
Author:  Hans Verkuil <hverkuil-cisco@xs4all.nl>
Date:    Tue Feb 4 19:19:22 2020 +0100

These are bits so to test if a pad is a sink you use & but not ==.

It looks like the only reason this hasn't caused problems before is that
media_get_pad_index() is currently only used with pads that do not set the
MEDIA_PAD_FL_MUST_CONNECT flag. So a pad really had only the SINK or SOURCE
flag set and nothing else.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc: <stable@vger.kernel.org>      # for v5.3 and up
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/mc/mc-entity.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

---

diff --git a/drivers/media/mc/mc-entity.c b/drivers/media/mc/mc-entity.c
index 7c429ce98bae..668770e9f609 100644
--- a/drivers/media/mc/mc-entity.c
+++ b/drivers/media/mc/mc-entity.c
@@ -639,9 +639,9 @@ int media_get_pad_index(struct media_entity *entity, bool is_sink,
 		return -EINVAL;
 
 	for (i = 0; i < entity->num_pads; i++) {
-		if (entity->pads[i].flags == MEDIA_PAD_FL_SINK)
+		if (entity->pads[i].flags & MEDIA_PAD_FL_SINK)
 			pad_is_sink = true;
-		else if (entity->pads[i].flags == MEDIA_PAD_FL_SOURCE)
+		else if (entity->pads[i].flags & MEDIA_PAD_FL_SOURCE)
 			pad_is_sink = false;
 		else
 			continue;	/* This is an error! */
