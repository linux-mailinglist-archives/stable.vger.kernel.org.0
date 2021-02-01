Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90E4330AACD
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 16:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbhBAPPD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 10:15:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231352AbhBAPPA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 10:15:00 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2E6DC061797
        for <stable@vger.kernel.org>; Mon,  1 Feb 2021 07:13:47 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id m1so10220915wml.2
        for <stable@vger.kernel.org>; Mon, 01 Feb 2021 07:13:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xELEKrhqhTmDdRYtgPgdfO9RZGP1Kih4SIlHlfBN9xk=;
        b=xvHNKVH52mIQidJjuSVbHHFtT7epo7ypTi7PBlUXI0RYeeNUQ9swqA5YUA8xrTCXTK
         32DIeKf4AlJhiotmKXi277YWUR3W4GGQ26+ZSueMiRIXq3nUFbR/+pb5CJjYfZE46zPT
         XOiwEZa2839QI/lm5UhF5iQ80MQmbYhLViDa5kbfRIEqFJFDr6J4SXTa886EmT4GqMGQ
         qf0P4cb5m4Ud6BxAMi0g3t4xl0yvgjLDc1q2mSUMn7zmoWbfAVNGqvDjXvOitefM3YkT
         cPJ4KpciJiz1AGWuXZThiWA8XRkKYgVmlW580BuWKyzFUeWajN4u7kitz/mxxvEXnww9
         Y7dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xELEKrhqhTmDdRYtgPgdfO9RZGP1Kih4SIlHlfBN9xk=;
        b=VjqNHRnrKvrCisuYZI6y4qTYPCD6X9PdJpIVDEkIP+aRiEUGwV4W/W1OkfKXDDJoiV
         7nQNPaATOLM3t5RME+zvCdfXv25RCyyFnM9HOXoYgO4jHcNIPtjvh+/txKMMf6AAa6w7
         nYEIOyNsy5SgB1LOknGJRpx7vMb6xL1enCj7qc5MxWumS8cPg27bnrv3lfE7Z1AbIxrP
         ijJ1WydmjgIgVMzZely5v0ewP1hD22cpH9BSbE1m59wmsLgGivLL5pIXt1RHXN4Ltg5O
         bd99Ieoxe1WmFux3ih9+jftnW0GC839KVvSbABnGCZRKFRfT32KFRXgZo2JsB+rXl7jW
         u99A==
X-Gm-Message-State: AOAM532waEPhBjpj+rHF3Uu/4pQ/w/dPvxRSl2YSBeWMcfWdEakIhi1E
        +SrLgiQV1IK7hAgUBRqIipKX6W3XVcsfesIv
X-Google-Smtp-Source: ABdhPJxZ1BlZGVW0MpCCAKZKRnsdv+pElaEg0poumZC0W9p8MnqtJxcWxUy5Er/V4uTlBPkhunQkCA==
X-Received: by 2002:a05:600c:35d6:: with SMTP id r22mr15430041wmq.44.1612192426025;
        Mon, 01 Feb 2021 07:13:46 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id 192sm23323381wme.27.2021.02.01.07.13.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 07:13:45 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 11/12] futex: Provide distinct return value when owner is exiting
Date:   Mon,  1 Feb 2021 15:12:13 +0000
Message-Id: <20210201151214.2193508-12-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210201151214.2193508-1-lee.jones@linaro.org>
References: <20210201151214.2193508-1-lee.jones@linaro.org>
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
index d21b151216aa3..32d799b9bd205 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1909,12 +1909,13 @@ retry_private:
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
 			free_pi_state(pi_state);
 			pi_state = NULL;
@@ -2580,12 +2581,13 @@ retry_private:
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

