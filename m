Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B60B930AAC9
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 16:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbhBAPO7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 10:14:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231376AbhBAPOz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 10:14:55 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68402C06178C
        for <stable@vger.kernel.org>; Mon,  1 Feb 2021 07:13:44 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id c127so13472345wmf.5
        for <stable@vger.kernel.org>; Mon, 01 Feb 2021 07:13:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XpuIWF2HW9dIBgX/Ld0+OKyOSiCvAVgygw7iJWAFZGs=;
        b=IWN4UOegACrcqKI3wDyqv54yB5lKHxlCgWlnzDfxAFCvoNZwStXF57Ez5Bi7LfCps0
         FJJQrbw2tK6cwO/zw4QAs+4UWRguf3Lt7a3SfVd0k01kOvCMxUOQ0kQ2rs+cXA2cvyg4
         PDCBR25VlCVQfwupiGjTWsKjvdiDDkiwx6TV/TbQpOTY3GCbzj8OgXdKxJEEFNIg6OJY
         zAE7/Q4VqgQKETPQ2foFtiiCVlK22BdJCp9O3qUQZFrnUHjDwQm8V4vMcX/c3WUhKwDJ
         vJqS6JMgauD9aL6d3moCVpUBqupaR0EeYAup7qPB+Z2Vx22AH+tD7ZmDyJULu4v4Kt25
         rBeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XpuIWF2HW9dIBgX/Ld0+OKyOSiCvAVgygw7iJWAFZGs=;
        b=OVzpBSoFVgFRSkPdEK90/petiJ6JXfHMk9Vm8V3xtClwMoJWVx38EKA54ZXOwoxm7y
         wVv9PgjwmiOKiUiLuq4hOnfg7gpJZs3ZBt7luMvWNoodQc7pVguV2fjvqDU3FMQdF6a2
         aNnwU9F04v6XVGvvgCWdhpPrb4ydu5IXPm4kcif2rIvXxIxiZFpb60TlkmGuOJ2rc7qJ
         jJoIrwWXtb0zhJtsYKyNvO6J6cucSFGXTuOXWmOFGQseguF+h26C6tm/I+QW/k7drzb1
         gK5tYDNNE1jmu2UUT8vEHIbvm3zqFDPMGG2SErasxQ6Sy1nWSe3XG/b6f1DxtktKRYoD
         aXHA==
X-Gm-Message-State: AOAM531mAX/admf7/t531vdv1NaL9WanSnBnZnATeq0KyDpO5ZinEoim
        T9Way+aRqh2dsrqugPFwXv6mG+gtmoFK5/BT
X-Google-Smtp-Source: ABdhPJw0QTNYK/bfHpDlpLexs4VmmA+BHL/ie2ip86NGfBrQ1BfbquIH3FaivGz7GQEhqiXGbliE3g==
X-Received: by 2002:a7b:c8c3:: with SMTP id f3mr15560824wml.110.1612192422859;
        Mon, 01 Feb 2021 07:13:42 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id 192sm23323381wme.27.2021.02.01.07.13.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 07:13:42 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 08/12] futex: Sanitize exit state handling
Date:   Mon,  1 Feb 2021 15:12:10 +0000
Message-Id: <20210201151214.2193508-9-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210201151214.2193508-1-lee.jones@linaro.org>
References: <20210201151214.2193508-1-lee.jones@linaro.org>
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
index 5bd3afee4e139..0efcb55455c2a 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -3276,16 +3276,19 @@ void futex_exit_recursive(struct task_struct *tsk)
 
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

