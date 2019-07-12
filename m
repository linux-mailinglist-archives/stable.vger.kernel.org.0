Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B076766DF4
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727811AbfGLMeb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:34:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:54306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729742AbfGLMe2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:34:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C909320645;
        Fri, 12 Jul 2019 12:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934867;
        bh=kHmhzJ+BlbwwuCrF47YLjZgNe7oXTK2407h6My7ZG7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AmbmMySm/5EpCtN8AgxSnLud4g3W0MBPUFaDim3NhBMt0+PVhP4giIFQtW93ix46b
         bWy36sz5wVEMep4OT0h3l33/YwXAvYgmxAkdEhVCYysTC6bFPkG+LjmaKtsEt0pySu
         lWg0w42HYStYp9EruPIdNKfAe4B3hVoZXxgDhVWs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dave Stevenson <dave.stevenson@raspberrypi.org>,
        Stefan Wahren <wahrenst@gmx.net>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 5.2 57/61] staging: bcm2835-camera: Replace spinlock protecting context_map with mutex
Date:   Fri, 12 Jul 2019 14:20:10 +0200
Message-Id: <20190712121623.850418045@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121620.632595223@linuxfoundation.org>
References: <20190712121620.632595223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Stevenson <dave.stevenson@raspberrypi.org>

commit 8dedab2903f152aa3cee9ae3d57c828dea0d356e upstream.

The commit "staging: bcm2835-camera: Replace open-coded idr with a struct idr."
replaced an internal implementation of an idr with the standard functions
and a spinlock. idr_alloc(GFP_KERNEL) can sleep whilst calling kmem_cache_alloc
to allocate the new node, but this is not valid whilst in an atomic context
due to the spinlock.

There is no need for this to be a spinlock as a standard mutex is
sufficient.

Fixes: 950fd867c635 ("staging: bcm2835-camera: Replace open-coded idr with a struct idr.")
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.org>
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Acked-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.c
+++ b/drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.c
@@ -161,7 +161,8 @@ struct vchiq_mmal_instance {
 	void *bulk_scratch;
 
 	struct idr context_map;
-	spinlock_t context_map_lock;
+	/* protect accesses to context_map */
+	struct mutex context_map_lock;
 
 	/* component to use next */
 	int component_idx;
@@ -184,10 +185,10 @@ get_msg_context(struct vchiq_mmal_instan
 	 * that when we service the VCHI reply, we can look up what
 	 * message is being replied to.
 	 */
-	spin_lock(&instance->context_map_lock);
+	mutex_lock(&instance->context_map_lock);
 	handle = idr_alloc(&instance->context_map, msg_context,
 			   0, 0, GFP_KERNEL);
-	spin_unlock(&instance->context_map_lock);
+	mutex_unlock(&instance->context_map_lock);
 
 	if (handle < 0) {
 		kfree(msg_context);
@@ -211,9 +212,9 @@ release_msg_context(struct mmal_msg_cont
 {
 	struct vchiq_mmal_instance *instance = msg_context->instance;
 
-	spin_lock(&instance->context_map_lock);
+	mutex_lock(&instance->context_map_lock);
 	idr_remove(&instance->context_map, msg_context->handle);
-	spin_unlock(&instance->context_map_lock);
+	mutex_unlock(&instance->context_map_lock);
 	kfree(msg_context);
 }
 
@@ -1849,7 +1850,7 @@ int vchiq_mmal_init(struct vchiq_mmal_in
 
 	instance->bulk_scratch = vmalloc(PAGE_SIZE);
 
-	spin_lock_init(&instance->context_map_lock);
+	mutex_init(&instance->context_map_lock);
 	idr_init_base(&instance->context_map, 1);
 
 	params.callback_param = instance;


