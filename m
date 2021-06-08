Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F15B3A03CE
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236840AbhFHTWC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:22:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:39612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237956AbhFHTSK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:18:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2422B6140F;
        Tue,  8 Jun 2021 18:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178314;
        bh=WBaDR/3bp+5KoI+MO9Nv5iU1JRrzhFLaNPv4RszXNUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1GJy3x2cFrNgYsC8eYs6uW7asCLJSIJbUIACTqsztP3eRIW0bZnt2wDjIMzqBy+3m
         YvaVpt88XJmahkY/7Fp8ABVSwqw2+cksqm98AGwzLn3Kjjj1kcRyZMZckuE8b9Bis0
         daRW3RZN+A4VkWU98EgDDz5PM8HTce6MwJq1ffVU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marco Elver <elver@google.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Hillf Danton <hdanton@sina.com>, Jann Horn <jannh@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.12 123/161] kfence: maximize allocation wait timeout duration
Date:   Tue,  8 Jun 2021 20:27:33 +0200
Message-Id: <20210608175949.600600450@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Elver <elver@google.com>

commit 37c9284f6932b915043717703d6496dfd59c85f5 upstream.

The allocation wait timeout was initially added because of warnings due to
CONFIG_DETECT_HUNG_TASK=y [1].  While the 1 sec timeout is sufficient to
resolve the warnings (given the hung task timeout must be 1 sec or larger)
it may cause unnecessary wake-ups if the system is idle:

  https://lkml.kernel.org/r/CADYN=9J0DQhizAGB0-jz4HOBBh+05kMBXb4c0cXMS7Qi5NAJiw@mail.gmail.com

Fix it by computing the timeout duration in terms of the current
sysctl_hung_task_timeout_secs value.

Link: https://lkml.kernel.org/r/20210421105132.3965998-3-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Jann Horn <jannh@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kfence/core.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -20,6 +20,7 @@
 #include <linux/moduleparam.h>
 #include <linux/random.h>
 #include <linux/rcupdate.h>
+#include <linux/sched/sysctl.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
@@ -620,7 +621,16 @@ static void toggle_allocation_gate(struc
 	/* Enable static key, and await allocation to happen. */
 	static_branch_enable(&kfence_allocation_key);
 
-	wait_event_timeout(allocation_wait, atomic_read(&kfence_allocation_gate), HZ);
+	if (sysctl_hung_task_timeout_secs) {
+		/*
+		 * During low activity with no allocations we might wait a
+		 * while; let's avoid the hung task warning.
+		 */
+		wait_event_timeout(allocation_wait, atomic_read(&kfence_allocation_gate),
+				   sysctl_hung_task_timeout_secs * HZ / 2);
+	} else {
+		wait_event(allocation_wait, atomic_read(&kfence_allocation_gate));
+	}
 
 	/* Disable static key and reset timer. */
 	static_branch_disable(&kfence_allocation_key);


