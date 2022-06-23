Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAE3455802D
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232382AbiFWQpv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232363AbiFWQpu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:45:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CD2F424B3;
        Thu, 23 Jun 2022 09:45:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C12261F91;
        Thu, 23 Jun 2022 16:45:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC799C341C4;
        Thu, 23 Jun 2022 16:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656002748;
        bh=lOg5RsQRlFNDlfJynXZhgALPTcEtJxZ87TOIvF3Awnc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C04F6VQDhSC3uqnz21vtLQJa297/jPWJDdjlGS5Arqc5rOPicHtMoZO8WFdfFqu95
         vSq6GYRTS3fPm3goGPRFa1NxlnpqF67d9pp3QmLBzHtgDDg7Zp1+piS79F6DSDTLfz
         DGfVPiz7IxUPc9qTzMc5XLwDHqsblHuIch3Jvazw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        "Theodore Tso" <tytso@mit.edu>, Arnd Bergmann <arnd@arndb.de>,
        Ingo Molnar <mingo@kernel.org>, Jessica Yu <jeyu@redhat.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Tejun Heo <tj@kernel.org>, Prarit Bhargava <prarit@redhat.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 013/264] random: do not ignore early device randomness
Date:   Thu, 23 Jun 2022 18:40:06 +0200
Message-Id: <20220623164344.439233358@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164344.053938039@linuxfoundation.org>
References: <20220623164344.053938039@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit ee7998c50c2697737c6530431709f77c852bf0d6 upstream.

The add_device_randomness() function would ignore incoming bytes if the
crng wasn't ready.  This additionally makes sure to make an early enough
call to add_latent_entropy() to influence the initial stack canary,
which is especially important on non-x86 systems where it stays the same
through the life of the boot.

Link: http://lkml.kernel.org/r/20170626233038.GA48751@beast
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jessica Yu <jeyu@redhat.com>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Lokesh Vutla <lokeshvutla@ti.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    5 +++++
 init/main.c           |    1 +
 2 files changed, 6 insertions(+)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1045,6 +1045,11 @@ void add_device_randomness(const void *b
 	unsigned long time = random_get_entropy() ^ jiffies;
 	unsigned long flags;
 
+	if (!crng_ready()) {
+		crng_fast_load(buf, size);
+		return;
+	}
+
 	trace_add_device_randomness(size, _RET_IP_);
 	spin_lock_irqsave(&input_pool.lock, flags);
 	_mix_pool_bytes(&input_pool, buf, size);
--- a/init/main.c
+++ b/init/main.c
@@ -490,6 +490,7 @@ asmlinkage __visible void __init start_k
 	/*
 	 * Set up the the initial canary ASAP:
 	 */
+	add_latent_entropy();
 	boot_init_stack_canary();
 
 	cgroup_init_early();


