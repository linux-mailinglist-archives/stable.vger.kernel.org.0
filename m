Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF415AAF02
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236765AbiIBMcc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236666AbiIBMbi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:31:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDD4EE190E;
        Fri,  2 Sep 2022 05:26:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B80B9B82ABD;
        Fri,  2 Sep 2022 12:26:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28271C433B5;
        Fri,  2 Sep 2022 12:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121592;
        bh=ygv5b7Fd2GBK1PHrrtgvE32HVeC9KUYkOtlJ+Y/J1Ds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pp9fxtoqede/2v52gayNt+ZHQTHqnTxBEUO0GGFp4k9U4bpDIy3an1DT6rNiPyL77
         mSp7y2GfuT/UrwMpbYEBin4MGo03V58+nuqoftmI4hvWcptpXYpYVG2bc6ujIO98r6
         3VGo9EA1Bp7iVx/ItSNdBd9h3nPgov0cO5aRyu+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Zhongjin <chenzhongjin@huawei.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 4.19 30/56] x86/unwind/orc: Unwind ftrace trampolines with correct ORC entry
Date:   Fri,  2 Sep 2022 14:18:50 +0200
Message-Id: <20220902121401.293170735@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121400.219861128@linuxfoundation.org>
References: <20220902121400.219861128@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Zhongjin <chenzhongjin@huawei.com>

commit fc2e426b1161761561624ebd43ce8c8d2fa058da upstream.

When meeting ftrace trampolines in ORC unwinding, unwinder uses address
of ftrace_{regs_}call address to find the ORC entry, which gets next frame at
sp+176.

If there is an IRQ hitting at sub $0xa8,%rsp, the next frame should be
sp+8 instead of 176. It makes unwinder skip correct frame and throw
warnings such as "wrong direction" or "can't access registers", etc,
depending on the content of the incorrect frame address.

By adding the base address ftrace_{regs_}caller with the offset
*ip - ops->trampoline*, we can get the correct address to find the ORC entry.

Also change "caller" to "tramp_addr" to make variable name conform to
its content.

[ mingo: Clarified the changelog a bit. ]

Fixes: 6be7fa3c74d1 ("ftrace, orc, x86: Handle ftrace dynamically allocated trampolines")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220819084334.244016-1-chenzhongjin@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/unwind_orc.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/arch/x86/kernel/unwind_orc.c
+++ b/arch/x86/kernel/unwind_orc.c
@@ -89,22 +89,27 @@ static struct orc_entry *orc_find(unsign
 static struct orc_entry *orc_ftrace_find(unsigned long ip)
 {
 	struct ftrace_ops *ops;
-	unsigned long caller;
+	unsigned long tramp_addr, offset;
 
 	ops = ftrace_ops_trampoline(ip);
 	if (!ops)
 		return NULL;
 
+	/* Set tramp_addr to the start of the code copied by the trampoline */
 	if (ops->flags & FTRACE_OPS_FL_SAVE_REGS)
-		caller = (unsigned long)ftrace_regs_call;
+		tramp_addr = (unsigned long)ftrace_regs_caller;
 	else
-		caller = (unsigned long)ftrace_call;
+		tramp_addr = (unsigned long)ftrace_caller;
+
+	/* Now place tramp_addr to the location within the trampoline ip is at */
+	offset = ip - ops->trampoline;
+	tramp_addr += offset;
 
 	/* Prevent unlikely recursion */
-	if (ip == caller)
+	if (ip == tramp_addr)
 		return NULL;
 
-	return orc_find(caller);
+	return orc_find(tramp_addr);
 }
 #else
 static struct orc_entry *orc_ftrace_find(unsigned long ip)


