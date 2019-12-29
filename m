Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F49912C865
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732624AbfL2RyH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:54:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:41634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732618AbfL2RyH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:54:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CD2A206A4;
        Sun, 29 Dec 2019 17:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642046;
        bh=9KLXc/1txQHe667UL0Yg42BjKUbKOrs44hrd4l3sz2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m2e+1vsQVJJNT4LJ00e95up5V3OwhZSP87iEkVI5iCLYoA8+LeGtxOCUWa6RPGW/K
         t1V9cZ3xJq+Tp6WHqsJ9wtnyI1+53XgVhVE2465tsO/eWFjag0tWlNvI2bIrLdFe4A
         eU7XXSiC0I1m29Drl0v4BvJ6BdNrxVxA3ZPITDYs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pi-Hsun Shih <pihsun@chromium.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 282/434] media: v4l2-ctrl: Lock main_hdl on operations of requests_queued.
Date:   Sun, 29 Dec 2019 18:25:35 +0100
Message-Id: <20191229172720.679452422@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 1d8f38824631..cd84dbbf6a89 100644
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



