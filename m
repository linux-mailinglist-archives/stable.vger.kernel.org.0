Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2623135F9
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbhBHPDo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:03:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:52062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232593AbhBHPD3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:03:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DAE9464EA1;
        Mon,  8 Feb 2021 15:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612796538;
        bh=xVZtRdnUhd6xyBtitThzLXOc5XRPWzzMjcGNgxSH07k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ne/I0pkcjbZz3cjRrzLbo1K2uv510FoB603leoNXvsenlMml+88SZ1LQfExRRmfUb
         5w9MUG9YHuFBj01nagi1HGS+WyK2X0wYFnR2FEZ0b6nOhzQ5f46db8glEaAtEYIW/V
         m8qVYbJF8u4O4RDGHoZ2x6eK3uaVRKG2IjRIrQ4w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.4 06/38] futex: Replace pointless printk in fixup_owner()
Date:   Mon,  8 Feb 2021 16:00:28 +0100
Message-Id: <20210208145805.536973210@linuxfoundation.org>
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
@@ -2412,14 +2412,10 @@ static int fixup_owner(u32 __user *uaddr
 
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


