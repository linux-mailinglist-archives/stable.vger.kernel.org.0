Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF17551A6A
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244913AbiFTNF7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:05:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244226AbiFTNEo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:04:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DF8519C03;
        Mon, 20 Jun 2022 06:00:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A95561542;
        Mon, 20 Jun 2022 13:00:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20E19C3411C;
        Mon, 20 Jun 2022 13:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730008;
        bh=uGrc4TFtsDDheb0tYM3honumC3oheP7ORB0HHwlNEes=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X4lT8BOCexjpEkHtFjQSF9cCVFb+MzlPDcm5E9cN7uIsLw3aIXky5ZqmvBLTsoUhs
         HDX4JCuMV58xoakMuyHhHeFmfTTjCg3eHJcjaQ0j1H0VNamWxSDiK9pI673kekIC4l
         3WSpVl56hU9i333TvhvqOv85VsakeKASxxXI30+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.18 124/141] cfi: Fix __cfi_slowpath_diag RCU usage with cpuidle
Date:   Mon, 20 Jun 2022 14:51:02 +0200
Message-Id: <20220620124733.217761642@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
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

From: Sami Tolvanen <samitolvanen@google.com>

commit 57cd6d157eb479f0a8e820fd36b7240845c8a937 upstream.

RCU_NONIDLE usage during __cfi_slowpath_diag can result in an invalid
RCU state in the cpuidle code path:

  WARNING: CPU: 1 PID: 0 at kernel/rcu/tree.c:613 rcu_eqs_enter+0xe4/0x138
  ...
  Call trace:
    rcu_eqs_enter+0xe4/0x138
    rcu_idle_enter+0xa8/0x100
    cpuidle_enter_state+0x154/0x3a8
    cpuidle_enter+0x3c/0x58
    do_idle.llvm.6590768638138871020+0x1f4/0x2ec
    cpu_startup_entry+0x28/0x2c
    secondary_start_kernel+0x1b8/0x220
    __secondary_switched+0x94/0x98

Instead, call rcu_irq_enter/exit to wake up RCU only when needed and
disable interrupts for the entire CFI shadow/module check when we do.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Link: https://lore.kernel.org/r/20220531175910.890307-1-samitolvanen@google.com
Fixes: cf68fffb66d6 ("add support for Clang CFI")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cfi.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

--- a/kernel/cfi.c
+++ b/kernel/cfi.c
@@ -281,6 +281,8 @@ static inline cfi_check_fn find_module_c
 static inline cfi_check_fn find_check_fn(unsigned long ptr)
 {
 	cfi_check_fn fn = NULL;
+	unsigned long flags;
+	bool rcu_idle;
 
 	if (is_kernel_text(ptr))
 		return __cfi_check;
@@ -290,13 +292,21 @@ static inline cfi_check_fn find_check_fn
 	 * the shadow and __module_address use RCU, so we need to wake it
 	 * up if necessary.
 	 */
-	RCU_NONIDLE({
-		if (IS_ENABLED(CONFIG_CFI_CLANG_SHADOW))
-			fn = find_shadow_check_fn(ptr);
+	rcu_idle = !rcu_is_watching();
+	if (rcu_idle) {
+		local_irq_save(flags);
+		rcu_irq_enter();
+	}
 
-		if (!fn)
-			fn = find_module_check_fn(ptr);
-	});
+	if (IS_ENABLED(CONFIG_CFI_CLANG_SHADOW))
+		fn = find_shadow_check_fn(ptr);
+	if (!fn)
+		fn = find_module_check_fn(ptr);
+
+	if (rcu_idle) {
+		rcu_irq_exit();
+		local_irq_restore(flags);
+	}
 
 	return fn;
 }


