Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27CDF66E3F
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729315AbfGLMbJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:31:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:47520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729309AbfGLMbI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:31:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51D892166E;
        Fri, 12 Jul 2019 12:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934667;
        bh=DrKf4v5E+3WHVAqw5IXlKo4ZXMWvRxDk4TnO9UEpVwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YNbKh5i9exVG34eGq9ciUVnJT/13EnkQjLazZqESjEfKXFxHdsJYWGhLP3CNPosSX
         KeobxokmQSrzllwVJbemyqcFLEQ9ubWogpEu68qcyTFYEj2TbYGn7mZ/rNUmUyiEe2
         FBaX7e+WYT6gLYfdzItPDTkf7zFwKS3GExu85f0M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Stefan Wahren <stefan.wahren@i2se.com>
Subject: [PATCH 5.1 131/138] staging: vchiq: revert "switch to wait_for_completion_killable"
Date:   Fri, 12 Jul 2019 14:19:55 +0200
Message-Id: <20190712121633.746968125@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121628.731888964@linuxfoundation.org>
References: <20190712121628.731888964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>

commit 086efbabdc04563268372aaef4d66039d85ee76c upstream.

The killable version of wait_for_completion() is meant to be used on
situations where it should not fail at all costs, but still have the
convenience of being able to kill it if really necessary. VCHIQ doesn't
fit this criteria, as it's mainly used as an interface to V4L2 and ALSA
devices.

Fixes: a772f116702e ("staging: vchiq: switch to wait_for_completion_killable")
Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Acked-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c  |   21 +++++-----
 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_core.c |   21 +++++-----
 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_util.c |    6 +-
 3 files changed, 25 insertions(+), 23 deletions(-)

--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
@@ -560,7 +560,8 @@ add_completion(VCHIQ_INSTANCE_T instance
 		vchiq_log_trace(vchiq_arm_log_level,
 			"%s - completion queue full", __func__);
 		DEBUG_COUNT(COMPLETION_QUEUE_FULL_COUNT);
-		if (wait_for_completion_killable( &instance->remove_event)) {
+		if (wait_for_completion_interruptible(
+					&instance->remove_event)) {
 			vchiq_log_info(vchiq_arm_log_level,
 				"service_callback interrupted");
 			return VCHIQ_RETRY;
@@ -671,7 +672,7 @@ service_callback(VCHIQ_REASON_T reason,
 			}
 
 			DEBUG_TRACE(SERVICE_CALLBACK_LINE);
-			if (wait_for_completion_killable(
+			if (wait_for_completion_interruptible(
 						&user_service->remove_event)
 				!= 0) {
 				vchiq_log_info(vchiq_arm_log_level,
@@ -1006,7 +1007,7 @@ vchiq_ioctl(struct file *file, unsigned
 		   has been closed until the client library calls the
 		   CLOSE_DELIVERED ioctl, signalling close_event. */
 		if (user_service->close_pending &&
-			wait_for_completion_killable(
+			wait_for_completion_interruptible(
 				&user_service->close_event))
 			status = VCHIQ_RETRY;
 		break;
@@ -1182,7 +1183,7 @@ vchiq_ioctl(struct file *file, unsigned
 
 			DEBUG_TRACE(AWAIT_COMPLETION_LINE);
 			mutex_unlock(&instance->completion_mutex);
-			rc = wait_for_completion_killable(
+			rc = wait_for_completion_interruptible(
 						&instance->insert_event);
 			mutex_lock(&instance->completion_mutex);
 			if (rc != 0) {
@@ -1352,7 +1353,7 @@ vchiq_ioctl(struct file *file, unsigned
 			do {
 				spin_unlock(&msg_queue_spinlock);
 				DEBUG_TRACE(DEQUEUE_MESSAGE_LINE);
-				if (wait_for_completion_killable(
+				if (wait_for_completion_interruptible(
 					&user_service->insert_event)) {
 					vchiq_log_info(vchiq_arm_log_level,
 						"DEQUEUE_MESSAGE interrupted");
@@ -2360,7 +2361,7 @@ vchiq_keepalive_thread_func(void *v)
 	while (1) {
 		long rc = 0, uc = 0;
 
-		if (wait_for_completion_killable(&arm_state->ka_evt)
+		if (wait_for_completion_interruptible(&arm_state->ka_evt)
 				!= 0) {
 			vchiq_log_error(vchiq_susp_log_level,
 				"%s interrupted", __func__);
@@ -2611,7 +2612,7 @@ block_resume(struct vchiq_arm_state *arm
 		write_unlock_bh(&arm_state->susp_res_lock);
 		vchiq_log_info(vchiq_susp_log_level, "%s wait for previously "
 			"blocked clients", __func__);
-		if (wait_for_completion_killable_timeout(
+		if (wait_for_completion_interruptible_timeout(
 				&arm_state->blocked_blocker, timeout_val)
 					<= 0) {
 			vchiq_log_error(vchiq_susp_log_level, "%s wait for "
@@ -2637,7 +2638,7 @@ block_resume(struct vchiq_arm_state *arm
 		write_unlock_bh(&arm_state->susp_res_lock);
 		vchiq_log_info(vchiq_susp_log_level, "%s wait for resume",
 			__func__);
-		if (wait_for_completion_killable_timeout(
+		if (wait_for_completion_interruptible_timeout(
 				&arm_state->vc_resume_complete, timeout_val)
 					<= 0) {
 			vchiq_log_error(vchiq_susp_log_level, "%s wait for "
@@ -2844,7 +2845,7 @@ vchiq_arm_force_suspend(struct vchiq_sta
 	do {
 		write_unlock_bh(&arm_state->susp_res_lock);
 
-		rc = wait_for_completion_killable_timeout(
+		rc = wait_for_completion_interruptible_timeout(
 				&arm_state->vc_suspend_complete,
 				msecs_to_jiffies(FORCE_SUSPEND_TIMEOUT_MS));
 
@@ -2940,7 +2941,7 @@ vchiq_arm_allow_resume(struct vchiq_stat
 	write_unlock_bh(&arm_state->susp_res_lock);
 
 	if (resume) {
-		if (wait_for_completion_killable(
+		if (wait_for_completion_interruptible(
 			&arm_state->vc_resume_complete) < 0) {
 			vchiq_log_error(vchiq_susp_log_level,
 				"%s interrupted", __func__);
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_core.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_core.c
@@ -590,7 +590,7 @@ reserve_space(struct vchiq_state *state,
 			remote_event_signal(&state->remote->trigger);
 
 			if (!is_blocking ||
-				(wait_for_completion_killable(
+				(wait_for_completion_interruptible(
 				&state->slot_available_event)))
 				return NULL; /* No space available */
 		}
@@ -860,7 +860,7 @@ queue_message(struct vchiq_state *state,
 			spin_unlock(&quota_spinlock);
 			mutex_unlock(&state->slot_mutex);
 
-			if (wait_for_completion_killable(
+			if (wait_for_completion_interruptible(
 						&state->data_quota_event))
 				return VCHIQ_RETRY;
 
@@ -891,7 +891,7 @@ queue_message(struct vchiq_state *state,
 				service_quota->slot_use_count);
 			VCHIQ_SERVICE_STATS_INC(service, quota_stalls);
 			mutex_unlock(&state->slot_mutex);
-			if (wait_for_completion_killable(
+			if (wait_for_completion_interruptible(
 						&service_quota->quota_event))
 				return VCHIQ_RETRY;
 			if (service->closing)
@@ -1740,7 +1740,8 @@ parse_rx_slots(struct vchiq_state *state
 					&service->bulk_rx : &service->bulk_tx;
 
 				DEBUG_TRACE(PARSE_LINE);
-				if (mutex_lock_killable(&service->bulk_mutex)) {
+				if (mutex_lock_killable(
+					&service->bulk_mutex) != 0) {
 					DEBUG_TRACE(PARSE_LINE);
 					goto bail_not_ready;
 				}
@@ -2458,7 +2459,7 @@ vchiq_open_service_internal(struct vchiq
 			       QMFLAGS_IS_BLOCKING);
 	if (status == VCHIQ_SUCCESS) {
 		/* Wait for the ACK/NAK */
-		if (wait_for_completion_killable(&service->remove_event)) {
+		if (wait_for_completion_interruptible(&service->remove_event)) {
 			status = VCHIQ_RETRY;
 			vchiq_release_service_internal(service);
 		} else if ((service->srvstate != VCHIQ_SRVSTATE_OPEN) &&
@@ -2825,7 +2826,7 @@ vchiq_connect_internal(struct vchiq_stat
 	}
 
 	if (state->conn_state == VCHIQ_CONNSTATE_CONNECTING) {
-		if (wait_for_completion_killable(&state->connect))
+		if (wait_for_completion_interruptible(&state->connect))
 			return VCHIQ_RETRY;
 
 		vchiq_set_conn_state(state, VCHIQ_CONNSTATE_CONNECTED);
@@ -2924,7 +2925,7 @@ vchiq_close_service(VCHIQ_SERVICE_HANDLE
 	}
 
 	while (1) {
-		if (wait_for_completion_killable(&service->remove_event)) {
+		if (wait_for_completion_interruptible(&service->remove_event)) {
 			status = VCHIQ_RETRY;
 			break;
 		}
@@ -2985,7 +2986,7 @@ vchiq_remove_service(VCHIQ_SERVICE_HANDL
 		request_poll(service->state, service, VCHIQ_POLL_REMOVE);
 	}
 	while (1) {
-		if (wait_for_completion_killable(&service->remove_event)) {
+		if (wait_for_completion_interruptible(&service->remove_event)) {
 			status = VCHIQ_RETRY;
 			break;
 		}
@@ -3068,7 +3069,7 @@ VCHIQ_STATUS_T vchiq_bulk_transfer(VCHIQ
 		VCHIQ_SERVICE_STATS_INC(service, bulk_stalls);
 		do {
 			mutex_unlock(&service->bulk_mutex);
-			if (wait_for_completion_killable(
+			if (wait_for_completion_interruptible(
 						&service->bulk_remove_event)) {
 				status = VCHIQ_RETRY;
 				goto error_exit;
@@ -3145,7 +3146,7 @@ waiting:
 
 	if (bulk_waiter) {
 		bulk_waiter->bulk = bulk;
-		if (wait_for_completion_killable(&bulk_waiter->event))
+		if (wait_for_completion_interruptible(&bulk_waiter->event))
 			status = VCHIQ_RETRY;
 		else if (bulk_waiter->actual == VCHIQ_BULK_ACTUAL_ABORTED)
 			status = VCHIQ_ERROR;
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_util.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_util.c
@@ -80,7 +80,7 @@ void vchiu_queue_push(struct vchiu_queue
 		return;
 
 	while (queue->write == queue->read + queue->size) {
-		if (wait_for_completion_killable(&queue->pop))
+		if (wait_for_completion_interruptible(&queue->pop))
 			flush_signals(current);
 	}
 
@@ -93,7 +93,7 @@ void vchiu_queue_push(struct vchiu_queue
 struct vchiq_header *vchiu_queue_peek(struct vchiu_queue *queue)
 {
 	while (queue->write == queue->read) {
-		if (wait_for_completion_killable(&queue->push))
+		if (wait_for_completion_interruptible(&queue->push))
 			flush_signals(current);
 	}
 
@@ -107,7 +107,7 @@ struct vchiq_header *vchiu_queue_pop(str
 	struct vchiq_header *header;
 
 	while (queue->write == queue->read) {
-		if (wait_for_completion_killable(&queue->push))
+		if (wait_for_completion_interruptible(&queue->push))
 			flush_signals(current);
 	}
 


