Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2553C28EDB7
	for <lists+stable@lfdr.de>; Thu, 15 Oct 2020 09:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727437AbgJOH3d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Oct 2020 03:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbgJOH3d (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Oct 2020 03:29:33 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70501C061755;
        Thu, 15 Oct 2020 00:29:33 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id 10so1486799pfp.5;
        Thu, 15 Oct 2020 00:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=NyOBxb8AoqgMUHKsBXW28Vj4sUWrwj4sJ2HYf/jBgew=;
        b=MlOIA+nXW3/bDb+PqTOTIb+xXh78CgOPa/ayPCooqogLZXD8aWauC4GJxf/L3Pez5L
         KP+AoUHMfsk1gUxsUHmmFgqOFjTrtTBxfaJDMMwJe8z1anzpv4ggZRA4Bh38fZqZ5dfp
         GNTcEWbQglnIi93azUEdBko2OMYna5a6Qq0t4SQqbifCM3XoDXN9R8Ru44gd7KJe0Qq4
         ZIPpXamMchjP5aAnW393A3lsUoosYRWyUXU5OSRsZcvCZvY2DlFaIpcS/w+0DBRd+m7n
         CVPCNYjWuf40NsBK3rqKRlzmvADq1BtSOlKvU60siYCNi+29yweLiVngur9cFw3pqUmY
         zPuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=NyOBxb8AoqgMUHKsBXW28Vj4sUWrwj4sJ2HYf/jBgew=;
        b=PLwkmDJNkLxAy9+W0HR3LZxH9yahR6TNikXFuup88H6jEtR2b/oiI/RwKDrIeDA7QR
         5FvG/zC+kFGNaWagxquh3JtNSoLvJRyUT3r06JkmATou36pChPmsHfSLmVQJAchjM/gp
         oRjsx6nkJr55h/FFiVWAUoWFlTJvu0xXcRzO1iqnn03BhS+EHSSvYo8XRhM8gRtr9QqD
         Neti3bfV+hJT/JYg7JpqBccDfjV3RD2XB4i4NNuRRtJUNeaJ41RjCiqTzMvBdnlCq4Mt
         mPWYYt/h/Xy+EZHQMSJlGKgNTR8dwS7ysLlPZy25IWEqv235rAr2KVEjebR0bsUJL3w+
         KLzg==
X-Gm-Message-State: AOAM532b2quVdGBm2Y3NQ0WIxV9pb8bYO4NxCDm2CpdN1FEHuokvmb8P
        DjRbCMlofRB6OcFtFkUtWM0=
X-Google-Smtp-Source: ABdhPJwW7T2inHeWLA2QxFD2R5JIGjpObY6McSyfUtJoEIyfFMSYNCFm7TKYxylXn1eZE6DKx7ABww==
X-Received: by 2002:aa7:86ce:0:b029:152:1702:d791 with SMTP id h14-20020aa786ce0000b02901521702d791mr2909804pfo.13.1602746972721;
        Thu, 15 Oct 2020 00:29:32 -0700 (PDT)
Received: from laptop.hsd1.wa.comcast.net ([2601:600:9b7f:872e:a655:30fb:7373:c762])
        by smtp.gmail.com with ESMTPSA id u7sm2039426pfn.37.2020.10.15.00.29.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2020 00:29:32 -0700 (PDT)
From:   Andrei Vagin <avagin@gmail.com>
To:     Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Shuah Khan <shuah@kernel.org>, Andrei Vagin <avagin@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] futex: adjust a futex timeout with a per-timens offset
Date:   Thu, 15 Oct 2020 00:29:08 -0700
Message-Id: <20201015072909.271426-1-avagin@gmail.com>
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
 kernel/futex.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/futex.c b/kernel/futex.c
index a5876694a60e..9ff2b8c5a506 100644
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
+		else if (!(cmd & FUTEX_CLOCK_REALTIME))
+			t = timens_ktime_to_host(CLOCK_MONOTONIC, t);
 		tp = &t;
 	}
 	/*
-- 
2.26.2

