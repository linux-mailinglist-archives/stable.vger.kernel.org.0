Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4F211955C
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:20:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728991AbfLJVUY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:20:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:35552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728663AbfLJVMH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:12:07 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10DFF246A2;
        Tue, 10 Dec 2019 21:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012326;
        bh=4nmCBGDmTjlj8RxkgiEgGZZWDF4POOuLpQPwXgDNb1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vBbiGxwWBujMiClJ1FkL24gLhGdyCgE9YMJAKN+QIsasdXpCq0uM3Sq/5T35boGSr
         UJI4jdRZXp2CxYlp65e9xHNGYtPgm4rVEU6b9PoC2j2YnhQm5nlxCCOcBWLAhyFLVr
         bJGRY4jjeMnBxewXg4c1H1AS0wbf0uhwQVWuQyD0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pi-Hsun Shih <pihsun@chromium.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 259/350] media: v4l2-ctrl: Lock main_hdl on operations of requests_queued.
Date:   Tue, 10 Dec 2019 16:06:04 -0500
Message-Id: <20191210210735.9077-220-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pi-Hsun Shih <pihsun@chromium.org>

[ Upstream commit df4a3e7f88e3b0d7ae46d70b9ff8e3c0ea730785 ]

There's a race condition between the list_del_init in the
v4l2_ctrl_request_complete, and the list_add_tail in the
v4l2_ctrl_request_queue, since they can be called in different thread
and the requests_queued list is not protected by a lock. This can lead
to that the v4l2_ctrl_handler is still in the requests_queued list while
the request_is_queued is already set to false, which would cause
use-after-free if the v4l2_ctrl_handler is later released.

Fix this by locking the ->lock of main_hdl (which is the owner of the
requests_queued list) when doing list operations on the
->requests_queued list.

Signed-off-by: Pi-Hsun Shih <pihsun@chromium.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 1d8f388246313..cd84dbbf6a890 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -3144,6 +3144,7 @@ static void v4l2_ctrl_request_queue(struct media_request_object *obj)
 	struct v4l2_ctrl_handler *prev_hdl = NULL;
 	struct v4l2_ctrl_ref *ref_ctrl, *ref_ctrl_prev = NULL;
 
+	mutex_lock(main_hdl->lock);
 	if (list_empty(&main_hdl->requests_queued))
 		goto queue;
 
@@ -3175,18 +3176,22 @@ static void v4l2_ctrl_request_queue(struct media_request_object *obj)
 queue:
 	list_add_tail(&hdl->requests_queued, &main_hdl->requests_queued);
 	hdl->request_is_queued = true;
+	mutex_unlock(main_hdl->lock);
 }
 
 static void v4l2_ctrl_request_unbind(struct media_request_object *obj)
 {
 	struct v4l2_ctrl_handler *hdl =
 		container_of(obj, struct v4l2_ctrl_handler, req_obj);
+	struct v4l2_ctrl_handler *main_hdl = obj->priv;
 
 	list_del_init(&hdl->requests);
+	mutex_lock(main_hdl->lock);
 	if (hdl->request_is_queued) {
 		list_del_init(&hdl->requests_queued);
 		hdl->request_is_queued = false;
 	}
+	mutex_unlock(main_hdl->lock);
 }
 
 static void v4l2_ctrl_request_release(struct media_request_object *obj)
@@ -4128,9 +4133,11 @@ void v4l2_ctrl_request_complete(struct media_request *req,
 		v4l2_ctrl_unlock(ctrl);
 	}
 
+	mutex_lock(main_hdl->lock);
 	WARN_ON(!hdl->request_is_queued);
 	list_del_init(&hdl->requests_queued);
 	hdl->request_is_queued = false;
+	mutex_unlock(main_hdl->lock);
 	media_request_object_complete(obj);
 	media_request_object_put(obj);
 }
-- 
2.20.1

