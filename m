Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78E2828F645
	for <lists+stable@lfdr.de>; Thu, 15 Oct 2020 18:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388583AbgJOQAl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Oct 2020 12:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388393AbgJOQAl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Oct 2020 12:00:41 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4831C061755;
        Thu, 15 Oct 2020 09:00:41 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id y14so2155342pgf.12;
        Thu, 15 Oct 2020 09:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=XWjeAwSwJUB4odQ/5eOsa55JFw248FhKheVyetCUznE=;
        b=KDzaud37AeZ7EnsiAUPFvKVuyDGeZo3s4QeIstQAQs3yqxVYuRAHhtFV7u5vdmoi6I
         2J3mFrIhSCok2XSvyWOSlQSN167RnlPfp78PQZTthfdH86i05Ccprk3SCwdnDkfUO15Z
         MFor+el37FtaBbM3j3hXWb0kYCGwC79s4dZJdpoq0teQnL14WwJ4aJO8D+/ywf0rbgZk
         GplQuqTFXY2at6UmONUXRvJZCzgCZQQLIg1HghVrZFKcQEAliz1DBA/5QXn30qB/FQ1u
         xxpwHJLntzeFxFzUPfshZEjufRG2QTKp5zykcNZHNwheFE9OQruEFb+uXR9uuMu8U6BE
         x8kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=XWjeAwSwJUB4odQ/5eOsa55JFw248FhKheVyetCUznE=;
        b=QIdCRNNSe1QH3IuzlLQPbxQSsHS9q6B6Gq0wUf+C/DHys/lMM/ZrTUO/sNmmYnaOh+
         o92stJJJ4/RKvprRFP+DH7PDyHC/MZ1n2csbNVnkbCSFU7i3G3JSdcHZiHj+HAfzMK+l
         FM9V5BcPKRyc154ycUWeooQ3rqzFU7okpqRiutGDRvB1TyBpMNq7nmJIkmuem3S5fSWH
         aHCzXL2TMZgkht/RNZvLMeMsUxqmeQH7vfXxoEIPCQuzNtHMYmvIoUzHSqvqIj0hDCsV
         LtwXoPzD5GWbKBSxZbDPMOpgM49/O7VyHuRq3hcC0CFvw6Rvw5CQJEjdP6zKGgnbp+dW
         mkMw==
X-Gm-Message-State: AOAM530KVkm3Usr+hOps5aQpvzHpWOvB3FSaiaYYSLV0kSExO1xC4cwI
        HysFKH+R3FCheOH5OcscwIQ=
X-Google-Smtp-Source: ABdhPJwPJfuGmrcnnF6SiKM4DSH3uny1EY9OymBOtZdH+lnXjY8YzbMj43TDQ9S+wKeKqLJqsWlPrg==
X-Received: by 2002:a63:5fca:: with SMTP id t193mr3794243pgb.261.1602777640967;
        Thu, 15 Oct 2020 09:00:40 -0700 (PDT)
Received: from laptop.hsd1.wa.comcast.net ([2601:600:9b7f:872e:a655:30fb:7373:c762])
        by smtp.gmail.com with ESMTPSA id q24sm3664414pgb.12.2020.10.15.09.00.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2020 09:00:40 -0700 (PDT)
From:   Andrei Vagin <avagin@gmail.com>
To:     Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Shuah Khan <shuah@kernel.org>, Andrei Vagin <avagin@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/2 v2] futex: adjust a futex timeout with a per-timens offset
Date:   Thu, 15 Oct 2020 09:00:19 -0700
Message-Id: <20201015160020.293748-1-avagin@gmail.com>
X-Mailer: git-send-email 2.17.2
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

For all commands except FUTEX_WAIT, timeout is interpreted as an
absolute value. This absolute value is inside the task's time namespace
and has to be converted to the host's time.

Cc: <stable@vger.kernel.org>
Fixes: 5a590f35add9 ("posix-clocks: Wire up clock_gettime() with timens offsets")
Reported-by: Hans van der Laan <j.h.vanderlaan@student.utwente.nl>
Signed-off-by: Andrei Vagin <avagin@gmail.com>
---

v2:
* check FUTEX_CLOCK_REALTIME properly
* fix futex_time32 too

 kernel/futex.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/futex.c b/kernel/futex.c
index a5876694a60e..32056d2d4171 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -39,6 +39,7 @@
 #include <linux/freezer.h>
 #include <linux/memblock.h>
 #include <linux/fault-inject.h>
+#include <linux/time_namespace.h>
 
 #include <asm/futex.h>
 
@@ -3797,6 +3798,8 @@ SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
 		t = timespec64_to_ktime(ts);
 		if (cmd == FUTEX_WAIT)
 			t = ktime_add_safe(ktime_get(), t);
+		else if (!(op & FUTEX_CLOCK_REALTIME))
+			t = timens_ktime_to_host(CLOCK_MONOTONIC, t);
 		tp = &t;
 	}
 	/*
@@ -3989,6 +3992,8 @@ SYSCALL_DEFINE6(futex_time32, u32 __user *, uaddr, int, op, u32, val,
 		t = timespec64_to_ktime(ts);
 		if (cmd == FUTEX_WAIT)
 			t = ktime_add_safe(ktime_get(), t);
+		else if (!(op & FUTEX_CLOCK_REALTIME))
+			t = timens_ktime_to_host(CLOCK_MONOTONIC, t);
 		tp = &t;
 	}
 	if (cmd == FUTEX_REQUEUE || cmd == FUTEX_CMP_REQUEUE ||
-- 
2.26.2

