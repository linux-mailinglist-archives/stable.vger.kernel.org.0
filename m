Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E607C34CAD4
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234273AbhC2IkM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:40:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:34124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234399AbhC2IjP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:39:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2EDBB61477;
        Mon, 29 Mar 2021 08:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617007154;
        bh=HKAJRd6zJIMAV11utaQkOKpyX7HG55LD4h3oDTTA7f8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EAzRm9xAkqD0a/oOptErrPHJhF4w76jIoP5BXL0l+1US7peFmGFRP5RQft3BlMZbI
         JdAMT3o5cRUgXxWsYJpPG1CC7YlZhQ2uxr9ELmmTkG4XHixoce7HUeU5BZAi642RHa
         wfrHEUOyzC6qovqg5D/U5fFbrC0aAPMfd0GNu8JM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 5.11 241/254] locking/mutex: Fix non debug version of mutex_lock_io_nested()
Date:   Mon, 29 Mar 2021 09:59:17 +0200
Message-Id: <20210329075640.996576339@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 291da9d4a9eb3a1cb0610b7f4480f5b52b1825e7 upstream.

If CONFIG_DEBUG_LOCK_ALLOC=n then mutex_lock_io_nested() maps to
mutex_lock() which is clearly wrong because mutex_lock() lacks the
io_schedule_prepare()/finish() invocations.

Map it to mutex_lock_io().

Fixes: f21860bac05b ("locking/mutex, sched/wait: Fix the mutex_lock_io_nested() define")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/878s6fshii.fsf@nanos.tec.linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/mutex.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -185,7 +185,7 @@ extern void mutex_lock_io(struct mutex *
 # define mutex_lock_interruptible_nested(lock, subclass) mutex_lock_interruptible(lock)
 # define mutex_lock_killable_nested(lock, subclass) mutex_lock_killable(lock)
 # define mutex_lock_nest_lock(lock, nest_lock) mutex_lock(lock)
-# define mutex_lock_io_nested(lock, subclass) mutex_lock(lock)
+# define mutex_lock_io_nested(lock, subclass) mutex_lock_io(lock)
 #endif
 
 /*


