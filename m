Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADEA715C6A5
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388278AbgBMQCX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 11:02:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:37932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728712AbgBMPY3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:24:29 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F97320848;
        Thu, 13 Feb 2020 15:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607468;
        bh=RMReYjdA9/i3pOfo+iSra+wq7cF9yY/9YLA/qmUXf4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LOgFnQ/ufnaYfk4ENk7ckkbnu+GRaG6FF4CceM+UtRaZP+MsD8nYhpfdONsA1DhE1
         DRdefAgmPaBSUrwZxDOTE1ghZpP+5x2aRLBS6znj0m7GkuOGxMVbSSZPs1/Ekh5DNI
         QgAdOIQfqdRqiBrZ6kY5CB59wkb3zUtLfvC8+jGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Song Liu <songliubraving@fb.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 4.9 095/116] perf/core: Fix mlock accounting in perf_mmap()
Date:   Thu, 13 Feb 2020 07:20:39 -0800
Message-Id: <20200213151919.786366171@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151842.259660170@linuxfoundation.org>
References: <20200213151842.259660170@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Song Liu <songliubraving@fb.com>

commit 003461559ef7a9bd0239bae35a22ad8924d6e9ad upstream.

Decreasing sysctl_perf_event_mlock between two consecutive perf_mmap()s of
a perf ring buffer may lead to an integer underflow in locked memory
accounting. This may lead to the undesired behaviors, such as failures in
BPF map creation.

Address this by adjusting the accounting logic to take into account the
possibility that the amount of already locked memory may exceed the
current limit.

Fixes: c4b75479741c ("perf/core: Make the mlock accounting simple again")
Suggested-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: <stable@vger.kernel.org>
Acked-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Link: https://lkml.kernel.org/r/20200123181146.2238074-1-songliubraving@fb.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/events/core.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5303,7 +5303,15 @@ accounting:
 	 */
 	user_lock_limit *= num_online_cpus();
 
-	user_locked = atomic_long_read(&user->locked_vm) + user_extra;
+	user_locked = atomic_long_read(&user->locked_vm);
+
+	/*
+	 * sysctl_perf_event_mlock may have changed, so that
+	 *     user->locked_vm > user_lock_limit
+	 */
+	if (user_locked > user_lock_limit)
+		user_locked = user_lock_limit;
+	user_locked += user_extra;
 
 	if (user_locked > user_lock_limit)
 		extra = user_locked - user_lock_limit;


