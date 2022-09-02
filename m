Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89EB55AB1B1
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 15:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237454AbiIBNi1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 09:38:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236255AbiIBNh4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 09:37:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43D8F124872;
        Fri,  2 Sep 2022 06:16:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC034621EC;
        Fri,  2 Sep 2022 12:36:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BECE6C433C1;
        Fri,  2 Sep 2022 12:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662122201;
        bh=qPtMQN6i7xa1IWnEibQFMTsGeomTP4hM3LBvwPWuPms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U2jlOZHXz8AA371DAKf5q5T4a/s6WJ7G+oS9VoXACN3U6+Pfzbk+9OMFUMxFzjHym
         2S+lxB9b31Z2gJ+VHaFhsLjVzr+2qHlZm/xYe0bHlO2203ViRIy5NBhB3+YvxRsI/z
         B1a2zeON6/2oYpq82p23u/9oApXbyIhzPQNA92ns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        Xiaogang Chen <Xiaogang.Chen@amd.com>
Subject: [PATCH 5.19 44/72] drm/amdkfd: Handle restart of kfd_ioctl_wait_events
Date:   Fri,  2 Sep 2022 14:19:20 +0200
Message-Id: <20220902121406.223114522@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.772492078@linuxfoundation.org>
References: <20220902121404.772492078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Kuehling <Felix.Kuehling@amd.com>

[ Upstream commit bea9a56afbc4b5a41ea579b8b0dc5e189b439504 ]

When kfd_ioctl_wait_events needs to restart due to a signal, we need to
update the timeout to account for the time already elapsed. We also need
to undo auto_reset of events that have signaled already, so that the
restarted ioctl will be able to count those signals again.

This fixes infinite hangs when kfd_ioctl_wait_events is interrupted by a
signal.

Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-and-tested-by: Xiaogang Chen <Xiaogang.Chen@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c |  2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_events.c  | 24 ++++++++++++------------
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h    |  2 +-
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
index 1c7016958d6d9..bfca17ca399c6 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -814,7 +814,7 @@ static int kfd_ioctl_wait_events(struct file *filp, struct kfd_process *p,
 	err = kfd_wait_on_events(p, args->num_events,
 			(void __user *)args->events_ptr,
 			(args->wait_for_all != 0),
-			args->timeout, &args->wait_result);
+			&args->timeout, &args->wait_result);
 
 	return err;
 }
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_events.c b/drivers/gpu/drm/amd/amdkfd/kfd_events.c
index 4df9c36146ba9..cbc20d779e5aa 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_events.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_events.c
@@ -895,7 +895,8 @@ static long user_timeout_to_jiffies(uint32_t user_timeout_ms)
 	return msecs_to_jiffies(user_timeout_ms) + 1;
 }
 
-static void free_waiters(uint32_t num_events, struct kfd_event_waiter *waiters)
+static void free_waiters(uint32_t num_events, struct kfd_event_waiter *waiters,
+			 bool undo_auto_reset)
 {
 	uint32_t i;
 
@@ -904,6 +905,9 @@ static void free_waiters(uint32_t num_events, struct kfd_event_waiter *waiters)
 			spin_lock(&waiters[i].event->lock);
 			remove_wait_queue(&waiters[i].event->wq,
 					  &waiters[i].wait);
+			if (undo_auto_reset && waiters[i].activated &&
+			    waiters[i].event && waiters[i].event->auto_reset)
+				set_event(waiters[i].event);
 			spin_unlock(&waiters[i].event->lock);
 		}
 
@@ -912,7 +916,7 @@ static void free_waiters(uint32_t num_events, struct kfd_event_waiter *waiters)
 
 int kfd_wait_on_events(struct kfd_process *p,
 		       uint32_t num_events, void __user *data,
-		       bool all, uint32_t user_timeout_ms,
+		       bool all, uint32_t *user_timeout_ms,
 		       uint32_t *wait_result)
 {
 	struct kfd_event_data __user *events =
@@ -921,7 +925,7 @@ int kfd_wait_on_events(struct kfd_process *p,
 	int ret = 0;
 
 	struct kfd_event_waiter *event_waiters = NULL;
-	long timeout = user_timeout_to_jiffies(user_timeout_ms);
+	long timeout = user_timeout_to_jiffies(*user_timeout_ms);
 
 	event_waiters = alloc_event_waiters(num_events);
 	if (!event_waiters) {
@@ -971,15 +975,11 @@ int kfd_wait_on_events(struct kfd_process *p,
 		}
 
 		if (signal_pending(current)) {
-			/*
-			 * This is wrong when a nonzero, non-infinite timeout
-			 * is specified. We need to use
-			 * ERESTARTSYS_RESTARTBLOCK, but struct restart_block
-			 * contains a union with data for each user and it's
-			 * in generic kernel code that I don't want to
-			 * touch yet.
-			 */
 			ret = -ERESTARTSYS;
+			if (*user_timeout_ms != KFD_EVENT_TIMEOUT_IMMEDIATE &&
+			    *user_timeout_ms != KFD_EVENT_TIMEOUT_INFINITE)
+				*user_timeout_ms = jiffies_to_msecs(
+					max(0l, timeout-1));
 			break;
 		}
 
@@ -1020,7 +1020,7 @@ int kfd_wait_on_events(struct kfd_process *p,
 					       event_waiters, events);
 
 out_unlock:
-	free_waiters(num_events, event_waiters);
+	free_waiters(num_events, event_waiters, ret == -ERESTARTSYS);
 	mutex_unlock(&p->event_mutex);
 out:
 	if (ret)
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
index 2585d6e61d422..c6eec54b8102f 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
@@ -1314,7 +1314,7 @@ void kfd_event_free_process(struct kfd_process *p);
 int kfd_event_mmap(struct kfd_process *process, struct vm_area_struct *vma);
 int kfd_wait_on_events(struct kfd_process *p,
 		       uint32_t num_events, void __user *data,
-		       bool all, uint32_t user_timeout_ms,
+		       bool all, uint32_t *user_timeout_ms,
 		       uint32_t *wait_result);
 void kfd_signal_event_interrupt(u32 pasid, uint32_t partial_id,
 				uint32_t valid_id_bits);
-- 
2.35.1



