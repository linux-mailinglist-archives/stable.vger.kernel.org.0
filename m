Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF59C57EE96
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 12:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239536AbiGWKNa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 06:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239535AbiGWKNN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 06:13:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ABEE8B4A2;
        Sat, 23 Jul 2022 03:03:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C131DB82C1B;
        Sat, 23 Jul 2022 10:03:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BE96C341C0;
        Sat, 23 Jul 2022 10:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570605;
        bh=zMPVrNhp/F3QfRcx1IwmUr2ts61b2A89EFn63wrxbtY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tJc7e3WAQ9MG/JsLo6JpnxCMs5Gwr+Pa/wESpXLKykzDY2lOJnHWeN7OibGB4Jtb9
         HwwgrQTj3toxmQ4UPItVA2qFURaAwNm4eEHo2Hbf8hEGJPIQzmogQYmz+skSEec5To
         o8t3X5PdZ8vyfcy8sV5+ra38rEg+EZX5FmT6UWjk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 145/148] kvm: fix objtool relocation warning
Date:   Sat, 23 Jul 2022 11:55:57 +0200
Message-Id: <20220723095304.971051168@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220723095224.302504400@linuxfoundation.org>
References: <20220723095224.302504400@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 291073a566b2094c7192872cc0f17ce73d83cb76 upstream.

The recent change to make objtool aware of more symbol relocation types
(commit 24ff65257375: "objtool: Teach get_alt_entry() about more
relocation types") also added another check, and resulted in this
objtool warning when building kvm on x86:

    arch/x86/kvm/emulate.o: warning: objtool: __ex_table+0x4: don't know how to handle reloc symbol type: kvm_fastop_exception

The reason seems to be that kvm_fastop_exception() is marked as a global
symbol, which causes the relocation to ke kept around for objtool.  And
at the same time, the kvm_fastop_exception definition (which is done as
an inline asm statement) doesn't actually set the type of the global,
which then makes objtool unhappy.

The minimal fix is to just not mark kvm_fastop_exception as being a
global symbol.  It's only used in that one compilation unit anyway, so
it was always pointless.  That's how all the other local exception table
labels are done.

I'm not entirely happy about the kinds of games that the kvm code plays
with doing its own exception handling, and the fact that it confused
objtool is most definitely a symptom of the code being a bit too subtle
and ad-hoc.  But at least this trivial one-liner makes objtool no longer
upset about what is going on.

Fixes: 24ff65257375 ("objtool: Teach get_alt_entry() about more relocation types")
Link: https://lore.kernel.org/lkml/CAHk-=wiZwq-0LknKhXN4M+T8jbxn_2i9mcKpO+OaBSSq_Eh7tg@mail.gmail.com/
Cc: Borislav Petkov <bp@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/emulate.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -452,7 +452,6 @@ static int fastop(struct x86_emulate_ctx
 	".skip " __stringify(SETCC_ALIGN) " - (.-" #op "), 0xcc \n\t"
 
 asm(".pushsection .fixup, \"ax\"\n"
-    ".global kvm_fastop_exception \n"
     "kvm_fastop_exception: xor %esi, %esi; " ASM_RET
     ".popsection");
 


