Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D35D313644
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231894AbhBHPIY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:08:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:52062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232221AbhBHPGM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:06:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00BF364ED5;
        Mon,  8 Feb 2021 15:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612796683;
        bh=BzrQ+Brp4qSgyNAtHGJ0AshXoAVuslOy0sbxqUDQg0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KsyIihtVoaGUv73AyAktBU5B2BjfbZcRuxlCrJgP9+1keoiESluof167uTlTSv1aK
         /PpN9glXuyGx5MpR+fRoHUKXdv7twrWy6q5QkhloNNiNt0z28k1RkJB3mT9tVEmiib
         YTfuGasb4NfweW+vSSng8aCyW8RueadtH4b6mCwc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.9 08/43] futex: Replace pointless printk in fixup_owner()
Date:   Mon,  8 Feb 2021 16:00:34 +0100
Message-Id: <20210208145806.624737255@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145806.281758651@linuxfoundation.org>
References: <20210208145806.281758651@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 04b79c55201f02ffd675e1231d731365e335c307 ]

If that unexpected case of inconsistent arguments ever happens then the
futex state is left completely inconsistent and the printk is not really
helpful. Replace it with a warning and make the state consistent.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/futex.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2447,14 +2447,10 @@ static int fixup_owner(u32 __user *uaddr
 
 	/*
 	 * Paranoia check. If we did not take the lock, then we should not be
-	 * the owner of the rt_mutex.
+	 * the owner of the rt_mutex. Warn and establish consistent state.
 	 */
-	if (rt_mutex_owner(&q->pi_state->pi_mutex) == current) {
-		printk(KERN_ERR "fixup_owner: ret = %d pi-mutex: %p "
-				"pi-state %p\n", ret,
-				q->pi_state->pi_mutex.owner,
-				q->pi_state->owner);
-	}
+	if (WARN_ON_ONCE(rt_mutex_owner(&q->pi_state->pi_mutex) == current))
+		return fixup_pi_state_owner(uaddr, q, current);
 
 out:
 	return ret ? ret : locked;


