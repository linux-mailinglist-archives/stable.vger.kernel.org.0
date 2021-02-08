Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70C9B3135FD
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231818AbhBHPEQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:04:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:52066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232552AbhBHPD3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:03:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0971464E88;
        Mon,  8 Feb 2021 15:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612796544;
        bh=QywjCobK+3L+cg1z5UHGhMXLGENY+aKrqItB5V3D3EM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZCU+CFPfvy/HuR31x31iXH/xTOc/AwDHlY8qCYOaN4bdcaVBe6so45d37BpdZykIL
         OEBiTMTGphot4iCKe4ikkzXbl6U8mtxA3vkWfLMBxQpsCID3dTFL7R9Fj3oIDxyJRC
         pLMZGK7ESIG644Gj2fNn0U0+oCQoTciSpDz3LPP8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.4 08/38] rtmutex: Remove unused argument from rt_mutex_proxy_unlock()
Date:   Mon,  8 Feb 2021 16:00:30 +0100
Message-Id: <20210208145805.615517209@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145805.279815326@linuxfoundation.org>
References: <20210208145805.279815326@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lee Jones <lee.jones@linaro.org>

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 2156ac1934166d6deb6cd0f6ffc4c1076ec63697 ]
Nothing uses the argument. Remove it as preparation to use
pi_state_update_owner().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/futex.c                  |    2 +-
 kernel/locking/rtmutex.c        |    3 +--
 kernel/locking/rtmutex_common.h |    3 +--
 3 files changed, 3 insertions(+), 5 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -878,7 +878,7 @@ static void free_pi_state(struct futex_p
 		list_del_init(&pi_state->list);
 		raw_spin_unlock_irq(&pi_state->owner->pi_lock);
 
-		rt_mutex_proxy_unlock(&pi_state->pi_mutex, pi_state->owner);
+		rt_mutex_proxy_unlock(&pi_state->pi_mutex);
 	}
 
 	if (current->pi_state_cache)
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -1662,8 +1662,7 @@ void rt_mutex_init_proxy_locked(struct r
  * No locking. Caller has to do serializing itself
  * Special API call for PI-futex support
  */
-void rt_mutex_proxy_unlock(struct rt_mutex *lock,
-			   struct task_struct *proxy_owner)
+void rt_mutex_proxy_unlock(struct rt_mutex *lock)
 {
 	debug_rt_mutex_proxy_unlock(lock);
 	rt_mutex_set_owner(lock, NULL);
--- a/kernel/locking/rtmutex_common.h
+++ b/kernel/locking/rtmutex_common.h
@@ -101,8 +101,7 @@ enum rtmutex_chainwalk {
 extern struct task_struct *rt_mutex_next_owner(struct rt_mutex *lock);
 extern void rt_mutex_init_proxy_locked(struct rt_mutex *lock,
 				       struct task_struct *proxy_owner);
-extern void rt_mutex_proxy_unlock(struct rt_mutex *lock,
-				  struct task_struct *proxy_owner);
+extern void rt_mutex_proxy_unlock(struct rt_mutex *lock);
 extern int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
 				     struct rt_mutex_waiter *waiter,
 				     struct task_struct *task);


