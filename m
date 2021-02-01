Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C96F30AAC3
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 16:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbhBAPOl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 10:14:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbhBAPOW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 10:14:22 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B73C061756
        for <stable@vger.kernel.org>; Mon,  1 Feb 2021 07:13:42 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id u14so12937929wml.4
        for <stable@vger.kernel.org>; Mon, 01 Feb 2021 07:13:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ltrudIytk8l60pTfQhCRnlUeawvarsYISOCC5mS7dpk=;
        b=YBCL+lGGCAyPwLyPt/JVUWMlZrUPnYgZ44oOBXgwxAaOPw4BMSJfY2jMh1SBE9jqrz
         WbZfK7pqQW/1mOLjorBzr+VaZLo5M0aBpxB9fZdeklGiQxjs+It/15vM9fCjYk/yZRYj
         6PGhRDgcYgttNlUV7ETurNk5XU9ZTfeXoaupfBkCGN6DKDFa3QXgNx8OxINtmK6w63zy
         l0GOyY3nBnluVyi25d81wZsG7PnXD3gw9EAGxGYvuoPpCBHwlGnWmbps6xWT3EerXyV/
         zszCNGvjei/yt0eVe8T4A/31VtRIuF9cobiQ9iIt1LJqcg/+XMRgmIT3DTcJ/yRKI88D
         hsdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ltrudIytk8l60pTfQhCRnlUeawvarsYISOCC5mS7dpk=;
        b=T0VTh5Jj39S9pHXVGyibG0WjJ2qCj1P/DzijitMHIQK4UaFlNR2XPskwoflaWoS/Xi
         BJ6+pEpL1aM3MEaAgxKMdfn+O+ujVm8aNPUiHdiesNyc3flH1OVOW6oHBoMcgCq2o2v1
         9shpE/imZsGvO9Vgc/iZtu9wy+xAitC7iM35Ynpav/jvUROjtLHlZZuhv3o83V2FOH5d
         3cG1fOziYgFlXaIujHwJlD0fCIolAhYQ6M4fwphvNmG0LOLdsk+evHgfT+r0AuoR8PYM
         CGMER2kxVM/vkomU+NsP64tSSyHJaO9ltMkqzd6N69jVI4SLQK8x2u9jFgVcwr8At7LL
         1RgA==
X-Gm-Message-State: AOAM530O/ex+NXlHR5RddLAaTrmtaT4PkW81bljN8fH6Xn/6Cxkolg9N
        KAzHIglPlZATljo2QLhv1vKMh/Le6eP+JrWi
X-Google-Smtp-Source: ABdhPJxSJtlGnHGdiIjp7+MRTHAXW8axFq4H2wdUirPJ+U7Xlk6cjSBo1K5yR7RqNpG7W1OmagqHTw==
X-Received: by 2002:a1c:20d8:: with SMTP id g207mr3076950wmg.77.1612192420706;
        Mon, 01 Feb 2021 07:13:40 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id 192sm23323381wme.27.2021.02.01.07.13.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 07:13:40 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 06/12] futex: Set task::futex_state to DEAD right after handling futex exit
Date:   Mon,  1 Feb 2021 15:12:08 +0000
Message-Id: <20210201151214.2193508-7-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210201151214.2193508-1-lee.jones@linaro.org>
References: <20210201151214.2193508-1-lee.jones@linaro.org>
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
index a098d76a9877e..b39f4b3c0f37c 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -784,7 +784,6 @@ void do_exit(long code)
 	 * Make sure we are holding no locks:
 	 */
 	debug_check_no_locks_held();
-	futex_exit_done(tsk);
 
 	if (tsk->io_context)
 		exit_io_context(tsk);
diff --git a/kernel/futex.c b/kernel/futex.c
index 32a606b605cbb..f85635ff2fce1 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -3255,6 +3255,7 @@ void futex_exec_release(struct task_struct *tsk)
 void futex_exit_release(struct task_struct *tsk)
 {
 	futex_exec_release(tsk);
+	futex_exit_done(tsk);
 }
 
 long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
-- 
2.25.1

