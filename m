Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9907302ADB
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 19:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbhAYSzF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:55:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:41066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731209AbhAYSyq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:54:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E42352083E;
        Mon, 25 Jan 2021 18:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600846;
        bh=KMgFti1aciqb9xziT1srtVmAtoadp61KT7sdpE8SON4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SpOLnJ4/XJNhw5NcqfpaK/V2SzVXf5/v6UMZq4Ei+8S6rFCn/7yeO3Fvk53nOvRQ0
         i6Q2STWTGvYU6x6iVlmCW0NnYl271vNLlwnFi9qXQWO2qMW1mkNZpA6NwyJtliPs71
         8GF7/ym4SJDZR6rnUgjb/xrfS4+AOwylA23Ufgyk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.10 156/199] locking/lockdep: Cure noinstr fail
Date:   Mon, 25 Jan 2021 19:39:38 +0100
Message-Id: <20210125183222.790837209@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 0afda3a888dccf12557b41ef42eee942327d122b upstream.

When the compiler doesn't feel like inlining, it causes a noinstr
fail:

  vmlinux.o: warning: objtool: lock_is_held_type()+0xb: call to lockdep_enabled() leaves .noinstr.text section

Fixes: 4d004099a668 ("lockdep: Fix lockdep recursion")
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20210106144017.592595176@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/locking/lockdep.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -79,7 +79,7 @@ module_param(lock_stat, int, 0644);
 DEFINE_PER_CPU(unsigned int, lockdep_recursion);
 EXPORT_PER_CPU_SYMBOL_GPL(lockdep_recursion);
 
-static inline bool lockdep_enabled(void)
+static __always_inline bool lockdep_enabled(void)
 {
 	if (!debug_locks)
 		return false;


