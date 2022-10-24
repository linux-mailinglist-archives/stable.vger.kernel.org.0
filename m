Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80B9060A7C2
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234825AbiJXM5W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234827AbiJXM5C (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:57:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E5FA3AB14;
        Mon, 24 Oct 2022 05:16:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D34961252;
        Mon, 24 Oct 2022 12:13:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 806F4C433C1;
        Mon, 24 Oct 2022 12:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613586;
        bh=QVxdyH9Kh0TLvy8RfnKx31BeDg9LLwu7Ai4bBHeLUhU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dj11ZVh/c2tVw3FZFfvE1QiIzoZBLuF3rsQgeFyopp44FL3vq+QECEA0NxKEgZ8lG
         ZVAC4mjKO3tbVePETcoXrpzDuQalN1ijMy/9F6uWFBnt9nDD7NlhPkqaibhLUkqm6a
         +rQKKTTpZsfa2RCfvBckf4dOGDcqF4GyHUSmWr8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        David Gow <davidgow@google.com>,
        Julius Werner <jwerner@chromium.org>,
        Petr Mladek <pmladek@suse.com>,
        Evan Green <evgreen@chromium.org>,
        "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 153/255] firmware: google: Test spinlock on panic path to avoid lockups
Date:   Mon, 24 Oct 2022 13:31:03 +0200
Message-Id: <20221024113007.732606344@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
References: <20221024113002.471093005@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guilherme G. Piccoli <gpiccoli@igalia.com>

[ Upstream commit 3e081438b8e639cc76ef1a5ce0c1bd8a154082c7 ]

Currently the gsmi driver registers a panic notifier as well as
reboot and die notifiers. The callbacks registered are called in
atomic and very limited context - for instance, panic disables
preemption and local IRQs, also all secondary CPUs (not executing
the panic path) are shutdown.

With that said, taking a spinlock in this scenario is a dangerous
invitation for lockup scenarios. So, fix that by checking if the
spinlock is free to acquire in the panic notifier callback - if not,
bail-out and avoid a potential hang.

Fixes: 74c5b31c6618 ("driver: Google EFI SMI")
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: David Gow <davidgow@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Julius Werner <jwerner@chromium.org>
Cc: Petr Mladek <pmladek@suse.com>
Reviewed-by: Evan Green <evgreen@chromium.org>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
Link: https://lore.kernel.org/r/20220909200755.189679-1-gpiccoli@igalia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/google/gsmi.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/firmware/google/gsmi.c b/drivers/firmware/google/gsmi.c
index edaa4e5d84ad..517fb57d07d2 100644
--- a/drivers/firmware/google/gsmi.c
+++ b/drivers/firmware/google/gsmi.c
@@ -679,6 +679,15 @@ static struct notifier_block gsmi_die_notifier = {
 static int gsmi_panic_callback(struct notifier_block *nb,
 			       unsigned long reason, void *arg)
 {
+
+	/*
+	 * Panic callbacks are executed with all other CPUs stopped,
+	 * so we must not attempt to spin waiting for gsmi_dev.lock
+	 * to be released.
+	 */
+	if (spin_is_locked(&gsmi_dev.lock))
+		return NOTIFY_DONE;
+
 	gsmi_shutdown_reason(GSMI_SHUTDOWN_PANIC);
 	return NOTIFY_DONE;
 }
-- 
2.35.1



