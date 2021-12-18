Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A32B479A1B
	for <lists+stable@lfdr.de>; Sat, 18 Dec 2021 11:01:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbhLRKBN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Dec 2021 05:01:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbhLRKBN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Dec 2021 05:01:13 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBFA5C061574;
        Sat, 18 Dec 2021 02:01:12 -0800 (PST)
Date:   Sat, 18 Dec 2021 10:01:10 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639821671;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0yCvEbsyrvJ6VKe6uQfIaWCsjbOQ79tyCCplqP0sFUs=;
        b=tPTJSbgppy133SNzO2IRrhgr/eZ6X3jcEza/z+0b+OG7OoQpJk3Pb5HeZaBS30sYpaRunt
        AKc7z+EmZ4Cebj5tOkU8aU28x9vzXE6I53BH4rt2Wd0tyYgIKcColJgF+JC/chnjAUMC7r
        iMpH9KXHWUyQ8GhxDuMipyjtSpax40Qfvii6Vz9pATDU5U9HAf6h9bp2+s7JYyl7cOoKeJ
        aslRxAWNXFEgfMxezpxi5atB2qmvVefik99mGt/uaE1zeb+wj6ZHam6TfDfSRQ98KbRfsD
        2y9WnRndy8cFxdJj7KxBBcCHNCJWgyJIcCaqXaBlDMhCs/84tciFmDgkdbvo8A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639821671;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0yCvEbsyrvJ6VKe6uQfIaWCsjbOQ79tyCCplqP0sFUs=;
        b=VcIJiAkQAjfiGFZuTn6PlHVsU96IAOfR9rtdBupwxM/0DJad3ADvkY8s08vqI5OxSf7pZt
        +/B5ffMPq78EB8BQ==
From:   "tip-bot2 for Zqiang" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: locking/core] locking/rtmutex: Fix incorrect condition in
 rtmutex_spin_on_owner()
Cc:     Zqiang <qiang1.zhang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20211217074207.77425-1-qiang1.zhang@intel.com>
References: <20211217074207.77425-1-qiang1.zhang@intel.com>
MIME-Version: 1.0
Message-ID: <163982167017.23020.3158863463249807527.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the locking/core branch of tip:

Commit-ID:     8f556a326c93213927e683fc32bbf5be1b62540a
Gitweb:        https://git.kernel.org/tip/8f556a326c93213927e683fc32bbf5be1b62540a
Author:        Zqiang <qiang1.zhang@intel.com>
AuthorDate:    Fri, 17 Dec 2021 15:42:07 +08:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Sat, 18 Dec 2021 10:55:51 +01:00

locking/rtmutex: Fix incorrect condition in rtmutex_spin_on_owner()

Optimistic spinning needs to be terminated when the spinning waiter is not
longer the top waiter on the lock, but the condition is negated. It
terminates if the waiter is the top waiter, which is defeating the whole
purpose.

Fixes: c3123c431447 ("locking/rtmutex: Dont dereference waiter lockless")
Signed-off-by: Zqiang <qiang1.zhang@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20211217074207.77425-1-qiang1.zhang@intel.com
---
 kernel/locking/rtmutex.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index 0c6a48d..1f25a4d 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -1380,7 +1380,7 @@ static bool rtmutex_spin_on_owner(struct rt_mutex_base *lock,
 		 *  - the VCPU on which owner runs is preempted
 		 */
 		if (!owner->on_cpu || need_resched() ||
-		    rt_mutex_waiter_is_top_waiter(lock, waiter) ||
+		    !rt_mutex_waiter_is_top_waiter(lock, waiter) ||
 		    vcpu_is_preempted(task_cpu(owner))) {
 			res = false;
 			break;
