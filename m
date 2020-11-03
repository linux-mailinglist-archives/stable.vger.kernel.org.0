Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB8692A5296
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731923AbgKCUvR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:51:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:46164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731921AbgKCUvQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:51:16 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDC702242A;
        Tue,  3 Nov 2020 20:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436676;
        bh=emCc2Ab1uGtl61bDgS4ItTc28bWn/ttDicuuYkl6pAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N4KrGo/O+StOsgIJVKtWw3LfXow5alV7gtkrxPE2sPgdmQ3wkdDQm3SSmfhNEC0VE
         mhYrZI9akyRwYoSlc7AHqof71fYr+E/Pm0CB2VWoUjQx1jwLuYDm2tuhTAozz+hxoO
         A8bLoCOWVR+V6x+sJqG+g/VC8meE18ydR6WEMGWw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Hans van der Laan <j.h.vanderlaan@student.utwente.nl>,
        Andrei Vagin <avagin@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dmitry Safonov <0x7f454c46@gmail.com>
Subject: [PATCH 5.9 355/391] futex: Adjust absolute futex timeouts with per time namespace offset
Date:   Tue,  3 Nov 2020 21:36:46 +0100
Message-Id: <20201103203411.090203232@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrei Vagin <avagin@gmail.com>

commit c2f7d08cccf4af2ce6992feaabb9e68e4ae0bff3 upstream.

For all commands except FUTEX_WAIT, the timeout is interpreted as an
absolute value. This absolute value is inside the task's time namespace and
has to be converted to the host's time.

Fixes: 5a590f35add9 ("posix-clocks: Wire up clock_gettime() with timens offsets")
Reported-by: Hans van der Laan <j.h.vanderlaan@student.utwente.nl>
Signed-off-by: Andrei Vagin <avagin@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Dmitry Safonov <0x7f454c46@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201015160020.293748-1-avagin@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/futex.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -39,6 +39,7 @@
 #include <linux/freezer.h>
 #include <linux/memblock.h>
 #include <linux/fault-inject.h>
+#include <linux/time_namespace.h>
 
 #include <asm/futex.h>
 
@@ -3799,6 +3800,8 @@ SYSCALL_DEFINE6(futex, u32 __user *, uad
 		t = timespec64_to_ktime(ts);
 		if (cmd == FUTEX_WAIT)
 			t = ktime_add_safe(ktime_get(), t);
+		else if (!(op & FUTEX_CLOCK_REALTIME))
+			t = timens_ktime_to_host(CLOCK_MONOTONIC, t);
 		tp = &t;
 	}
 	/*
@@ -3991,6 +3994,8 @@ SYSCALL_DEFINE6(futex_time32, u32 __user
 		t = timespec64_to_ktime(ts);
 		if (cmd == FUTEX_WAIT)
 			t = ktime_add_safe(ktime_get(), t);
+		else if (!(op & FUTEX_CLOCK_REALTIME))
+			t = timens_ktime_to_host(CLOCK_MONOTONIC, t);
 		tp = &t;
 	}
 	if (cmd == FUTEX_REQUEUE || cmd == FUTEX_CMP_REQUEUE ||


