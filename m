Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C78F514703
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 12:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357771AbiD2Kp5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 06:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357767AbiD2Kpb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 06:45:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E2EC6665;
        Fri, 29 Apr 2022 03:42:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7AD762323;
        Fri, 29 Apr 2022 10:42:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7571C385A4;
        Fri, 29 Apr 2022 10:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651228927;
        bh=kO4IqmqhecTTjI1c3QBs2oCIiXGINhsrdjQ9SKOwUmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y3Xi00JKod735NHm4kAYcoZrLXU5Q2u7D+xvJzQE5SIly1t3abslFrPY9Ct/1zjrl
         lUv6fySA9nNHuXufiAMZeJbUrYOsMHmZZMLNkgWffj5Ye1xMHpshniVPToAJJEoPj7
         PB8uf2OQTTavGQZi+B39uodJTXkMxrLaXNRdJ4KE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>
Subject: [PATCH 4.19 08/12] Revert "ia64: kprobes: Fix to pass correct trampoline address to the handler"
Date:   Fri, 29 Apr 2022 12:41:25 +0200
Message-Id: <20220429104048.703832413@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220429104048.459089941@linuxfoundation.org>
References: <20220429104048.459089941@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

This reverts commit f5f96e3643dc33d6117cf7047e73512046e4858b.

The commit f5f96e3643dc ("ia64: kprobes: Fix to pass correct trampoline
address to the handler") was wrongly backported. It involves another
commit which is a part of another bigger series, so it should not be
backported to the stable tree.

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/ia64/kernel/kprobes.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/arch/ia64/kernel/kprobes.c
+++ b/arch/ia64/kernel/kprobes.c
@@ -411,8 +411,7 @@ static void kretprobe_trampoline(void)
 
 int __kprobes trampoline_probe_handler(struct kprobe *p, struct pt_regs *regs)
 {
-	regs->cr_iip = __kretprobe_trampoline_handler(regs,
-		dereference_function_descriptor(kretprobe_trampoline), NULL);
+	regs->cr_iip = __kretprobe_trampoline_handler(regs, kretprobe_trampoline, NULL);
 	/*
 	 * By returning a non-zero value, we are telling
 	 * kprobe_handler() that we don't want the post_handler
@@ -428,7 +427,7 @@ void __kprobes arch_prepare_kretprobe(st
 	ri->fp = NULL;
 
 	/* Replace the return addr with trampoline addr */
-	regs->b0 = (unsigned long)dereference_function_descriptor(kretprobe_trampoline);
+	regs->b0 = ((struct fnptr *)kretprobe_trampoline)->ip;
 }
 
 /* Check the instruction in the slot is break */
@@ -958,14 +957,14 @@ static struct kprobe trampoline_p = {
 int __init arch_init_kprobes(void)
 {
 	trampoline_p.addr =
-		dereference_function_descriptor(kretprobe_trampoline);
+		(kprobe_opcode_t *)((struct fnptr *)kretprobe_trampoline)->ip;
 	return register_kprobe(&trampoline_p);
 }
 
 int __kprobes arch_trampoline_kprobe(struct kprobe *p)
 {
 	if (p->addr ==
-		dereference_function_descriptor(kretprobe_trampoline))
+		(kprobe_opcode_t *)((struct fnptr *)kretprobe_trampoline)->ip)
 		return 1;
 
 	return 0;


