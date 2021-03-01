Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80516328602
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236787AbhCARCr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:02:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:55582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235860AbhCAQzq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:55:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0ADF664FDC;
        Mon,  1 Mar 2021 16:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616553;
        bh=4RruyhyVHfln5y2TDo3A+Hm/dS4KdRCqdIkGVB8OS7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FlYl/dppVkqrtQlA+on7fMG11xqZuPPP5RAyO4UZdPYL8EWrEER05HW/aT9Sen7mw
         QPl5qTb0Jttu665/6pHwyjlfXGOf/05FHlE7kOZGFcLKbj++G1mXgR0BzYT/opOhwo
         f7P3y39hfuBmoqSDYJY9YNTvO+uqP4Tbf1FaTFLI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Will McVicker <willmcvicker@google.com>
Subject: [PATCH 4.19 015/247] jump_label/lockdep: Assert we hold the hotplug lock for _cpuslocked() operations
Date:   Mon,  1 Mar 2021 17:10:35 +0100
Message-Id: <20210301161032.435478568@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit cb538267ea1e9e025ec692577c9ae75797261889 upstream.

Weirdly we seem to have forgotten this...

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Will McVicker <willmcvicker@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/jump_label.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -83,6 +83,7 @@ void static_key_slow_inc_cpuslocked(stru
 	int v, v1;
 
 	STATIC_KEY_CHECK_USE(key);
+	lockdep_assert_cpus_held();
 
 	/*
 	 * Careful if we get concurrent static_key_slow_inc() calls;
@@ -128,6 +129,7 @@ EXPORT_SYMBOL_GPL(static_key_slow_inc);
 void static_key_enable_cpuslocked(struct static_key *key)
 {
 	STATIC_KEY_CHECK_USE(key);
+	lockdep_assert_cpus_held();
 
 	if (atomic_read(&key->enabled) > 0) {
 		WARN_ON_ONCE(atomic_read(&key->enabled) != 1);
@@ -158,6 +160,7 @@ EXPORT_SYMBOL_GPL(static_key_enable);
 void static_key_disable_cpuslocked(struct static_key *key)
 {
 	STATIC_KEY_CHECK_USE(key);
+	lockdep_assert_cpus_held();
 
 	if (atomic_read(&key->enabled) != 1) {
 		WARN_ON_ONCE(atomic_read(&key->enabled) != 0);
@@ -183,6 +186,8 @@ static void __static_key_slow_dec_cpuslo
 					   unsigned long rate_limit,
 					   struct delayed_work *work)
 {
+	lockdep_assert_cpus_held();
+
 	/*
 	 * The negative count check is valid even when a negative
 	 * key->enabled is in use by static_key_slow_inc(); a


