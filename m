Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6FF23ED699
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240079AbhHPNW0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:22:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:44276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240940AbhHPNUY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:20:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFF1263311;
        Mon, 16 Aug 2021 13:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119736;
        bh=kJmcgmGYi640eHzY2tZWsTqNiJQOUQshw2kZV8uqb04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xFLDcvvUzgsGwYvIjmDMwNcBxSKAEdD4tMujMDLwzM8qgYo4pF/5ea02TDeDxeMwh
         Zj1KCoKhsoJwzLkKv6OslECJ2mweZCqGjWvwmrcyxd3Yg6RxO7fuViJnj2OToMfnuV
         jGrpWP1Cilk53/rFcbc0QxlJ9LH0c1BaStz4qR+k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhen Lei <thunder.leizhen@huawei.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>
Subject: [PATCH 5.13 143/151] locking/rtmutex: Use the correct rtmutex debugging config option
Date:   Mon, 16 Aug 2021 15:02:53 +0200
Message-Id: <20210816125448.785163932@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

commit 07d25971b220e477eb019fcb520a9f2e3ac966af upstream.

It's CONFIG_DEBUG_RT_MUTEXES not CONFIG_DEBUG_RT_MUTEX.

Fixes: f7efc4799f81 ("locking/rtmutex: Inline chainwalk depth check")
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Will Deacon <will@kernel.org>
Acked-by: Boqun Feng <boqun.feng@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210731123011.4555-1-thunder.leizhen@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/locking/rtmutex.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -343,7 +343,7 @@ static __always_inline bool
 rt_mutex_cond_detect_deadlock(struct rt_mutex_waiter *waiter,
 			      enum rtmutex_chainwalk chwalk)
 {
-	if (IS_ENABLED(CONFIG_DEBUG_RT_MUTEX))
+	if (IS_ENABLED(CONFIG_DEBUG_RT_MUTEXES))
 		return waiter != NULL;
 	return chwalk == RT_MUTEX_FULL_CHAINWALK;
 }


