Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1652337CCE0
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232520AbhELQtE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:49:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:35800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243679AbhELQlz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:41:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45E3861988;
        Wed, 12 May 2021 16:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835560;
        bh=FVMq1pTkT+dnmmgLLDfs001UsFYhNHxG6iZWLJBN9Yg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PY9KxynN1RLIkvAqwg/l6hhKvtmUSIK8SfmHcXuAkQwq8mkmMxG78n8Cp6IGXZYjN
         4uSij0SskpevR7tylTIV9Ry/Mz5ifcUSMZWPDmndLg1pzEp4gkw1hCF9+tEvPS3jMA
         rB7fFH3azD7Od4XC+NHmJBF94zRcdZ62nancAfkw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        John Cox <jc@kynesim.co.uk>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 393/677] media: v4l2-ctrls.c: fix race condition in hdl->requests list
Date:   Wed, 12 May 2021 16:47:19 +0200
Message-Id: <20210512144850.387298157@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit be7e8af98f3af729aa9f08b1053f9533a5cceb91 ]

When a request is re-inited it will release all control handler
objects that are still in the request. It does that by unbinding
and putting all those objects. When the object is unbound the
obj->req pointer is set to NULL, and the object's unbind op is
called. When the object it put the object's release op is called
to free the memory.

For a request object that contains a control handler that means
that v4l2_ctrl_handler_free() is called in the release op.

A control handler used in a request has a pointer to the main
control handler that is created by the driver and contains the
current state of all controls. If the device is unbound (due to
rmmod or a forced unbind), then that main handler is freed, again
by calling v4l2_ctrl_handler_free(), and any outstanding request
objects that refer to that main handler have to be unbound and put
as well.

It does that by this test:

	if (!hdl->req_obj.req && !list_empty(&hdl->requests)) {

I.e. the handler has no pointer to a request, so is the main
handler, and one or more request objects refer to this main
handler.

However, this test is wrong since hdl->req_obj.req is actually
NULL when re-initing a request (the object unbind will set req to
NULL), and the only reason this seemingly worked is that the
requests list is typically empty since the request's unbind op
will remove the handler from the requests list.

But if another thread is at the same time adding a new control
to a request, then there is a race condition where one thread
is removing a control handler object from the requests list and
another thread is adding one. The result is that hdl->requests
is no longer empty and the code thinks that a main handler is
being freed instead of a control handler that is part of a request.

There are two bugs here: first the test for hdl->req_obj.req: this
should be hdl->req_obj.ops since only the main control handler will
have a NULL pointer there.

The second is that adding or deleting request objects from the
requests list of the main handler isn't protected by taking the
main handler's lock.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reported-by: John Cox <jc@kynesim.co.uk>
Fixes: 6fa6f831f095 ("media: v4l2-ctrls: add core request support")
Tested-by: John Cox <jc@kynesim.co.uk>
Reported-by: John Cox <jc@kynesim.co.uk>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 4f0209695f13..6219c8185782 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -2552,7 +2552,15 @@ void v4l2_ctrl_handler_free(struct v4l2_ctrl_handler *hdl)
 	if (hdl == NULL || hdl->buckets == NULL)
 		return;
 
-	if (!hdl->req_obj.req && !list_empty(&hdl->requests)) {
+	/*
+	 * If the main handler is freed and it is used by handler objects in
+	 * outstanding requests, then unbind and put those objects before
+	 * freeing the main handler.
+	 *
+	 * The main handler can be identified by having a NULL ops pointer in
+	 * the request object.
+	 */
+	if (!hdl->req_obj.ops && !list_empty(&hdl->requests)) {
 		struct v4l2_ctrl_handler *req, *next_req;
 
 		list_for_each_entry_safe(req, next_req, &hdl->requests, requests) {
@@ -3595,8 +3603,8 @@ static void v4l2_ctrl_request_unbind(struct media_request_object *obj)
 		container_of(obj, struct v4l2_ctrl_handler, req_obj);
 	struct v4l2_ctrl_handler *main_hdl = obj->priv;
 
-	list_del_init(&hdl->requests);
 	mutex_lock(main_hdl->lock);
+	list_del_init(&hdl->requests);
 	if (hdl->request_is_queued) {
 		list_del_init(&hdl->requests_queued);
 		hdl->request_is_queued = false;
@@ -3655,8 +3663,11 @@ static int v4l2_ctrl_request_bind(struct media_request *req,
 	if (!ret) {
 		ret = media_request_object_bind(req, &req_ops,
 						from, false, &hdl->req_obj);
-		if (!ret)
+		if (!ret) {
+			mutex_lock(from->lock);
 			list_add_tail(&hdl->requests, &from->requests);
+			mutex_unlock(from->lock);
+		}
 	}
 	return ret;
 }
-- 
2.30.2



