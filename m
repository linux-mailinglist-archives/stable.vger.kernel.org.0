Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB3C66EC4
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727528AbfGLMlD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:41:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:32864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728039AbfGLMYW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:24:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F08242084B;
        Fri, 12 Jul 2019 12:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934261;
        bh=pm8q++Y9dYFYoF/2eqrnoIc+x6cNiUOwX1h3tqzg3uY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=irMKK96X5Ak+MxIqwyrTWFyhKMK6yZ/4oARFXQTi+JHe0fslQqCaNfg2mHkEj9hgR
         TZB/dZHgTfny74465mroSWdMl5X0TmmuJzquj5wBc1tKL0dZZa5he3Efn/Bp0ANJG3
         ZZpI+BVgmwZnETc+cJx/ueGKJY92VEy7aodRvas4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dave Stevenson <dave.stevenson@raspberrypi.org>,
        Stefan Wahren <wahrenst@gmx.net>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 4.19 87/91] staging: bcm2835-camera: Replace spinlock protecting context_map with mutex
Date:   Fri, 12 Jul 2019 14:19:30 +0200
Message-Id: <20190712121626.390070383@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121621.422224300@linuxfoundation.org>
References: <20190712121621.422224300@linuxfoundation.org>
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
@@ -162,7 +162,8 @@ struct vchiq_mmal_instance {
 	void *bulk_scratch;
 
 	struct idr context_map;
-	spinlock_t context_map_lock;
+	/* protect accesses to context_map */
+	struct mutex context_map_lock;
 
 	/* component to use next */
 	int component_idx;
@@ -185,10 +186,10 @@ get_msg_context(struct vchiq_mmal_instan
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
@@ -212,9 +213,9 @@ release_msg_context(struct mmal_msg_cont
 {
 	struct vchiq_mmal_instance *instance = msg_context->instance;
 
-	spin_lock(&instance->context_map_lock);
+	mutex_lock(&instance->context_map_lock);
 	idr_remove(&instance->context_map, msg_context->handle);
-	spin_unlock(&instance->context_map_lock);
+	mutex_unlock(&instance->context_map_lock);
 	kfree(msg_context);
 }
 
@@ -1854,7 +1855,7 @@ int vchiq_mmal_init(struct vchiq_mmal_in
 
 	instance->bulk_scratch = vmalloc(PAGE_SIZE);
 
-	spin_lock_init(&instance->context_map_lock);
+	mutex_init(&instance->context_map_lock);
 	idr_init_base(&instance->context_map, 1);
 
 	params.callback_param = instance;


