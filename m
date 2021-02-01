Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E614630A4DB
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 11:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232893AbhBAKDe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 05:03:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232995AbhBAKDc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 05:03:32 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 366F8C06178A
        for <stable@vger.kernel.org>; Mon,  1 Feb 2021 02:02:19 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id 6so15866126wri.3
        for <stable@vger.kernel.org>; Mon, 01 Feb 2021 02:02:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AWHPQeLileZutTX3lhjpX/znrmKRPfFsORf0TLQerQ4=;
        b=JXsktWtI4N+2CsLZCZ4Gdc9iJ0cpbUsmX60SKgfItYjkzRz0DkuW6MIl/Gz2r4H0+/
         fMPJGiN3w7h1jzaY7NoZr9GH80QOY4BASXdGeJgw0Mi2ppH36QxZ5J0kRQsE7eU7Vd1k
         roQv1l3Q8INz1WUK8/RyzYyohB7kpqwv+nDkuc/hWCr11HRDVJT4Udf3Yq3ibjbV6UIT
         kRJ1eOCZxQKi0UDSMpvIDLaTqrWU/ZW7O0Va0utcLZ/+IS7JmImmKIG9KHCm/83q/VhO
         j88USs0Y3eMpbrUcOmNDeEWgtTa9csc6Vujr2d24UpJAYYdLaQhMHm5yLll4UfFlrXIB
         tSXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AWHPQeLileZutTX3lhjpX/znrmKRPfFsORf0TLQerQ4=;
        b=CXmrDBqxlw5VBp1/t9/Dt9EZrMOzDLmZOib2eqHUq9F7B6F3rAscjvmsQgvL833vb5
         UEZLhdHSd/OYnMazQEy0FPoFm9PIzKm2vySCZbUGWfKFJXOVmv+I5d/V+CQdol0wqGwW
         js+iwJLdeWQ7bPkT9Lt1ojNNprgTvS7Ry+OV0KcOiK4AzuWuT5ljdgo+rDuMaruEJMqU
         o7QfOdNXnExj/1daHYfJ7xUowSsFqwsSnFMdIsXjJbe6rv3S1Oc5DakQW+VHmNMhzMaD
         O2o9z7Aswk0vhl9TB8KUL9NuhptllADgeV0DRNzK9VCxZE0gTokTRX+3WFnp5dF7pk9S
         V6rA==
X-Gm-Message-State: AOAM5336tFxGa0ERpyKBRM1kn2NOT5cn1wwQuylrP1LIYwCBqbDZzLx9
        Po1W04+CKLIZUtgeHoi7aO+AggoNCaaEvbLm
X-Google-Smtp-Source: ABdhPJygCKFNnP4QhYvwRch9ZusWCMd4XF1vblI/RMBRXXUo0nqB8uSQlWWSRiZPxG2WRGbVY0dL6w==
X-Received: by 2002:adf:dfc7:: with SMTP id q7mr17239970wrn.153.1612173737649;
        Mon, 01 Feb 2021 02:02:17 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id p15sm26151387wrt.15.2021.02.01.02.02.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 02:02:16 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 06/12] futex: Set task::futex_state to DEAD right after handling futex exit
Date:   Mon,  1 Feb 2021 10:01:37 +0000
Message-Id: <20210201100143.2028618-7-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210201100143.2028618-1-lee.jones@linaro.org>
References: <20210201100143.2028618-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit f24f22435dcc11389acc87e5586239c1819d217c upstream.

Setting task::futex_state in do_exit() is rather arbitrarily placed for no
reason. Move it into the futex code.

Note, this is only done for the exit cleanup as the exec cleanup cannot set
the state to FUTEX_STATE_DEAD because the task struct is still in active
use.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20191106224556.439511191@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 kernel/exit.c  | 1 -
 kernel/futex.c | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index b65285f5ee0c9..e87ab2ec654bc 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -867,7 +867,6 @@ void __noreturn do_exit(long code)
 	 * Make sure we are holding no locks:
 	 */
 	debug_check_no_locks_held();
-	futex_exit_done(tsk);
 
 	if (tsk->io_context)
 		exit_io_context(tsk);
diff --git a/kernel/futex.c b/kernel/futex.c
index 902ce420c4ba0..e8322c3208a44 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -3290,6 +3290,7 @@ void futex_exec_release(struct task_struct *tsk)
 void futex_exit_release(struct task_struct *tsk)
 {
 	futex_exec_release(tsk);
+	futex_exit_done(tsk);
 }
 
 long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
-- 
2.25.1

