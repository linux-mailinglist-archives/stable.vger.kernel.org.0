Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D286E30A4DD
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 11:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232995AbhBAKDf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 05:03:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233009AbhBAKDd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 05:03:33 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA727C06178C
        for <stable@vger.kernel.org>; Mon,  1 Feb 2021 02:02:21 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id g10so15884928wrx.1
        for <stable@vger.kernel.org>; Mon, 01 Feb 2021 02:02:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xnIHaUcaGnvu4d6/FdlgyP+cy+Y5o5wrHg5QIdWEM68=;
        b=YjLwUqCDzZLfeAElCV+0/ULjcstLNC/MoLRRObgnQFsRBftrxwI1ybQ0vUegpLMn6u
         w6JnJ4zL2gd9Fn9zHKcL9TH5FdxwM70HSRuaL+9qmERWmViUeIEHpF8Z2CnJrDFO6cLm
         O45+a4z0atnQyjafTZBc5LzGVXAawwy5LJeJR4P+y/3t4hC+dxkchxrnumivMAudYoYm
         N8tp3w+PzNrAJRexiYn5Hcw0eFN+UVW1mtkdg9AE4mxTYkzcvHwrABvwG7sscdKaZ9fy
         oS0Na9+/fKfRtW4fXEPbXdUptsqCyeIsuUM+v+VobKm7sKQCRJugxYGL1+rGR2QmqcD6
         PG8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xnIHaUcaGnvu4d6/FdlgyP+cy+Y5o5wrHg5QIdWEM68=;
        b=n99Vm6FUV4s1YLP8Wy7+KAn7Q5fJ6dsfBBG2jr7AmNoXD+Ku+iYqd3DtT45+k+Ukk+
         xmPy2iT4izFBByUAE9hmHb1rkMcO7Lh+Yke895HyWXiUcrf2T1yVww76k7HG1W/vUEP/
         8jsboc33mrR+BMTzUgBQVqi33b3fn6nNc6Ho1YBC+IB28mgG1sQBzXG0vPZ/it3NptNE
         t09Z/0zCXzDzZsYxfdUaTGzsCflsyNq3Nb99IWLYJaMMXmKJkKgfQNdj0nwvbrXVWFCb
         C66GoUyQY0eTP8VjCnWSfmkj4U3LUaqtnNFy5+Vuw+WjfjohpB4p9LPY6HJ+m4S0WPOh
         GWqA==
X-Gm-Message-State: AOAM533ekzc+LEXICDSvDqE5UdyrUzaofPcWZSeYS7xymtWWAkzNfR9m
        2VmtFfsT0s4c6N5UDN2Ih1nLz6CCl2AARuqx
X-Google-Smtp-Source: ABdhPJxf0+/TrtigSe7+aMjrDwaZahMLYw90hKVZP8BU69vLe8XyKqXgiOVB4D0KNQ4cJKRYMRFtOQ==
X-Received: by 2002:a05:6000:1202:: with SMTP id e2mr5596646wrx.328.1612173740097;
        Mon, 01 Feb 2021 02:02:20 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id p15sm26151387wrt.15.2021.02.01.02.02.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 02:02:19 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 08/12] futex: Sanitize exit state handling
Date:   Mon,  1 Feb 2021 10:01:39 +0000
Message-Id: <20210201100143.2028618-9-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210201100143.2028618-1-lee.jones@linaro.org>
References: <20210201100143.2028618-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 4a8e991b91aca9e20705d434677ac013974e0e30 upstream.

Instead of having a smp_mb() and an empty lock/unlock of task::pi_lock move
the state setting into to the lock section.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20191106224556.645603214@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 kernel/futex.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 482000996b983..f1e8ba64fe8ae 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -3311,16 +3311,19 @@ void futex_exit_recursive(struct task_struct *tsk)
 
 void futex_exit_release(struct task_struct *tsk)
 {
-	tsk->futex_state = FUTEX_STATE_EXITING;
-	/*
-	 * Ensure that all new tsk->pi_lock acquisitions must observe
-	 * FUTEX_STATE_EXITING. Serializes against attach_to_pi_owner().
-	 */
-	smp_mb();
 	/*
-	 * Ensure that we must observe the pi_state in exit_pi_state_list().
+	 * Switch the state to FUTEX_STATE_EXITING under tsk->pi_lock.
+	 *
+	 * This ensures that all subsequent checks of tsk->futex_state in
+	 * attach_to_pi_owner() must observe FUTEX_STATE_EXITING with
+	 * tsk->pi_lock held.
+	 *
+	 * It guarantees also that a pi_state which was queued right before
+	 * the state change under tsk->pi_lock by a concurrent waiter must
+	 * be observed in exit_pi_state_list().
 	 */
 	raw_spin_lock_irq(&tsk->pi_lock);
+	tsk->futex_state = FUTEX_STATE_EXITING;
 	raw_spin_unlock_irq(&tsk->pi_lock);
 
 	futex_exec_release(tsk);
-- 
2.25.1

