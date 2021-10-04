Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE15A421017
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238499AbhJDNkf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:40:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:52290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238578AbhJDNir (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:38:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76C4C6323C;
        Mon,  4 Oct 2021 13:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353474;
        bh=ySpziAZem5KNqlDnou3VwQL1fS/N6AvHf+/pgMkMVQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y4LwBmzH1JGL4OLoNT+IepK+Ow/6onCv63lYHufJZ1thztKzcg06ltGi3haX09a7F
         KhaLC8i2kt8jBFCRswGfBN285l/vafN/Gg87GXEcLCjH0TNgN/vIzi6w2VhXRjezjt
         OshhSjNa2idX+7jy70FjKSivsjgLGLAJctAY18ps=
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
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 143/172] kvm: fix objtool relocation warning
Date:   Mon,  4 Oct 2021 14:53:13 +0200
Message-Id: <20211004125049.582434477@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 291073a566b2094c7192872cc0f17ce73d83cb76 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/emulate.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 2837110e66ed..50050d06672b 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -435,7 +435,6 @@ static int fastop(struct x86_emulate_ctxt *ctxt, fastop_t fop);
 	__FOP_RET(#op)
 
 asm(".pushsection .fixup, \"ax\"\n"
-    ".global kvm_fastop_exception \n"
     "kvm_fastop_exception: xor %esi, %esi; ret\n"
     ".popsection");
 
-- 
2.33.0



