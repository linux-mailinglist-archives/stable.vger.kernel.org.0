Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C07F5583101
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243058AbiG0RpZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:45:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243332AbiG0Ron (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:44:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CB2A8C160;
        Wed, 27 Jul 2022 09:53:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10AD261748;
        Wed, 27 Jul 2022 16:53:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C42EC433C1;
        Wed, 27 Jul 2022 16:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940801;
        bh=jkT+4xjpS2LtUayr7DDs0NXC2QqliEHufZi6XOBMVyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lI1iSRvxV5y1jbBydqJUSliLcNOfXxIZZd8sJ8D7+Mf7kTVyaH0DeZAImdAz/OJVa
         rj+SN17XJa1mSCsAFCfYL3iWgE922CS7FyW04EdqxCdb6EyA6+eAI/t4sHHITPRqms
         kLJTCXJ8gXb2/i3BcT9lhrwRzGbLXkNqe4d+5ffc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.18 153/158] x86/alternative: Report missing return thunk details
Date:   Wed, 27 Jul 2022 18:13:37 +0200
Message-Id: <20220727161027.482275746@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
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

From: Kees Cook <keescook@chromium.org>

commit 65cdf0d623bedf0e069bb64ed52e8bb20105e2ba upstream.

Debugging missing return thunks is easier if we can see where they're
happening.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/lkml/Ys66hwtFcGbYmoiZ@hirez.programming.kicks-ass.net/
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/alternative.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -555,7 +555,9 @@ void __init_or_module noinline apply_ret
 			dest = addr + insn.length + insn.immediate.value;
 
 		if (__static_call_fixup(addr, op, dest) ||
-		    WARN_ON_ONCE(dest != &__x86_return_thunk))
+		    WARN_ONCE(dest != &__x86_return_thunk,
+			      "missing return thunk: %pS-%pS: %*ph",
+			      addr, dest, 5, addr))
 			continue;
 
 		DPRINTK("return thunk at: %pS (%px) len: %d to: %pS",


