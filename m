Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A16059D37C
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240859AbiHWIJi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:09:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241786AbiHWIJK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:09:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C359025297;
        Tue, 23 Aug 2022 01:05:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 618276120C;
        Tue, 23 Aug 2022 08:05:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 675C9C433D6;
        Tue, 23 Aug 2022 08:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661241950;
        bh=z2eqEAy2YCsxPCM2q4yt8xA1EtQe9IzemHCCZT7Vw1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tKSRtIlxqyBpI9gLE1diyzvqf6ZgdTBEnTcOOI8IeKSVCEqCjxpSOS8sFgg4XMeWY
         lIAitWQtiLC+NWkTECdVxapfzRUT4JfAOUYIUlMv4q1HZ8CWGzTgpIjkbwiioCPTNL
         uH10a1JI+OCXD1Y292wZmXXIPFHj7N4wFprO7YC0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nadav Amit <namit@vmware.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 5.19 029/365] x86/kprobes: Fix JNG/JNLE emulation
Date:   Tue, 23 Aug 2022 09:58:50 +0200
Message-Id: <20220823080119.434870980@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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

From: Nadav Amit <namit@vmware.com>

commit 8924779df820c53875abaeb10c648e9cb75b46d4 upstream.

When kprobes emulates JNG/JNLE instructions on x86 it uses the wrong
condition. For JNG (opcode: 0F 8E), according to Intel SDM, the jump is
performed if (ZF == 1 or SF != OF). However the kernel emulation
currently uses 'and' instead of 'or'.

As a result, setting a kprobe on JNG/JNLE might cause the kernel to
behave incorrectly whenever the kprobe is hit.

Fix by changing the 'and' to 'or'.

Fixes: 6256e668b7af ("x86/kprobes: Use int3 instead of debug trap for single-step")
Signed-off-by: Nadav Amit <namit@vmware.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220813225943.143767-1-namit@vmware.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/kprobes/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -505,7 +505,7 @@ static void kprobe_emulate_jcc(struct kp
 		match = ((regs->flags & X86_EFLAGS_SF) >> X86_EFLAGS_SF_BIT) ^
 			((regs->flags & X86_EFLAGS_OF) >> X86_EFLAGS_OF_BIT);
 		if (p->ainsn.jcc.type >= 0xe)
-			match = match && (regs->flags & X86_EFLAGS_ZF);
+			match = match || (regs->flags & X86_EFLAGS_ZF);
 	}
 	__kprobe_emulate_jmp(p, regs, (match && !invert) || (!match && invert));
 }


