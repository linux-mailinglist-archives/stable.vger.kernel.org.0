Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC0C830A4E3
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 11:03:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233020AbhBAKDn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 05:03:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233011AbhBAKDm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 05:03:42 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC22C0617A7
        for <stable@vger.kernel.org>; Mon,  1 Feb 2021 02:02:25 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id s7so12882436wru.5
        for <stable@vger.kernel.org>; Mon, 01 Feb 2021 02:02:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YvIosSfqayR6zcFHOY8c0x/JdWmP1VyW0c+N7TdenS0=;
        b=dEO9JyacwmaNh722rkMqymWjpemauzfTZo9g6zy6O3h0+aVdJI0fT0egpN0lkOapR4
         dEbSVoXXQLVegZrXuhI0JW/mzj/vGy1TE0lf9YVPfvApAkUO7AnULl3X0QkLmwnLgI5D
         0QGKjd2uWNOTg5j3ll5of6xK00r5v3uEkqS1Ki3nN5VaaeHKL7Pr2UtiBvH1urnskihx
         bu0lC9kBMyiVCMLtXel/iNjToeKnGtQmoDPpnBK8wtGKuOCrmnQPVekKCn2zvVcPwFhs
         9V3tUg2xpFZq89ABmzrKo2ZTkbdbsod2B4ULRnyA7qFX6yEUcsGpiR6vckmzpMD7+NrI
         4fsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YvIosSfqayR6zcFHOY8c0x/JdWmP1VyW0c+N7TdenS0=;
        b=SR9E4uEZxOkVROZNfQsoANmhP+4K2f0Aa1dqGluGeOvl3g1yA0HovX+zWVdpZxXdyv
         YxAY2GF9BLr+3u0xV7eNCn+R0vqSv2PF7y8lVHfPHCej3UzlokvIJYv7+Y0rfB3ly9Yb
         yJrVANA+iYoEPFvIYIqz/ejLoOhDYj3NPArmUU/aiMJR0m5sC3qqk1ORLIRuRATkue1M
         rWMCG6VyJDgXOwh46GhTb8KmL7TGu9ovWeFM7CID1PSpmR7+1Z5TJP2DIOTlOYGHfCoQ
         hvW1PxbfL1agEqcs7LVsmNXV91FNNmWaB9O5uuffLfWJjD0YZmCx8UHJSlYt7sN+mQOs
         gXiQ==
X-Gm-Message-State: AOAM533icZ0gHSwb4BSbzATSAlnWXwOgx7c2JcV5mLZTr/gFQahoObpr
        +ki8H3hQ2IMJ83MNiDf9MOiyQZ5IeDfglojF
X-Google-Smtp-Source: ABdhPJwzvowiI3qyeyz/lbtbqz6dxmZmmHq7ifsGMafx3yBmXHCIr0/mrXl+RIgg4nZeBog2eB8xAw==
X-Received: by 2002:a5d:4f84:: with SMTP id d4mr16951524wru.374.1612173743342;
        Mon, 01 Feb 2021 02:02:23 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id p15sm26151387wrt.15.2021.02.01.02.02.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 02:02:22 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 11/12] futex: Provide distinct return value when owner is exiting
Date:   Mon,  1 Feb 2021 10:01:42 +0000
Message-Id: <20210201100143.2028618-12-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210201100143.2028618-1-lee.jones@linaro.org>
References: <20210201100143.2028618-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit ac31c7ff8624409ba3c4901df9237a616c187a5d upstream.

attach_to_pi_owner() returns -EAGAIN for various cases:

 - Owner task is exiting
 - Futex value has changed

The caller drops the held locks (hash bucket, mmap_sem) and retries the
operation. In case of the owner task exiting this can result in a live
lock.

As a preparatory step for seperating those cases, provide a distinct return
value (EBUSY) for the owner exiting case.

No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20191106224556.935606117@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 kernel/futex.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index e7798ef3b4b71..cc4590d9fe645 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1918,12 +1918,13 @@ static int futex_requeue(u32 __user *uaddr1, unsigned int flags,
 			if (!ret)
 				goto retry;
 			goto out;
+		case -EBUSY:
 		case -EAGAIN:
 			/*
 			 * Two reasons for this:
-			 * - Owner is exiting and we just wait for the
+			 * - EBUSY: Owner is exiting and we just wait for the
 			 *   exit to complete.
-			 * - The user space value changed.
+			 * - EAGAIN: The user space value changed.
 			 */
 			double_unlock_hb(hb1, hb2);
 			hb_waiters_dec(hb2);
@@ -2615,12 +2616,13 @@ static int futex_lock_pi(u32 __user *uaddr, unsigned int flags,
 			goto out_unlock_put_key;
 		case -EFAULT:
 			goto uaddr_faulted;
+		case -EBUSY:
 		case -EAGAIN:
 			/*
 			 * Two reasons for this:
-			 * - Task is exiting and we just wait for the
+			 * - EBUSY: Task is exiting and we just wait for the
 			 *   exit to complete.
-			 * - The user space value changed.
+			 * - EAGAIN: The user space value changed.
 			 */
 			queue_unlock(hb);
 			put_futex_key(&q.key);
-- 
2.25.1

