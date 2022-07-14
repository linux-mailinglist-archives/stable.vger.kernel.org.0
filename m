Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 528CA5749B1
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 11:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbiGNJxC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 05:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237147AbiGNJxB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 05:53:01 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA9CDE7E;
        Thu, 14 Jul 2022 02:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=RXOON8J5cdaMRGNYYzIEKyaAcGIubDWbXh4Ksvavg9I=; b=dK0DngAMpUPBlwIqTfJMEe8snz
        rXYIB14WiawccAS/FcJ32iHHcgQd2oUqXSGIfOJzGgcFgDfZQrGZoH9JQ9jZPeE3hx7vnjqP5qMvW
        rdjbdwteUct8rlPsRXZc5Bz/F2qQnNjgpDF2Z/HyUsSSWbVXfMhn2xI+dIoo9/YY9a/QvHC+VU3qh
        +eNaRk4WNlUb+nNWux3ux4jQEinG7j8RLVcPAqr/a7Qbhq3ftUtTF3FTQbVFDIF2U7W0zyyv6383h
        WD6g0sAyLa7Og3vnavdJ0vgN40HgZMvnnpJ3rIPZPigs2WnzF190TslfKCk+ldy2ih434OLPF+3lI
        PxBV6r7g==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oBvWb-003oMV-UQ; Thu, 14 Jul 2022 09:52:50 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 533D0980120; Thu, 14 Jul 2022 11:52:49 +0200 (CEST)
Date:   Thu, 14 Jul 2022 11:52:49 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Linux Kernel Functional Testing <lkft@linaro.org>
Subject: Re: [PATCH] x86/kvm: fix FASTOP_SIZE when return thunks are enabled
Message-ID: <Ys/ncSnSFEST4fgL@worktop.programming.kicks-ass.net>
References: <20220713171241.184026-1-cascardo@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220713171241.184026-1-cascardo@canonical.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 13, 2022 at 02:12:41PM -0300, Thadeu Lima de Souza Cascardo wrote:
> The return thunk call makes the fastop functions larger, just like IBT
> does. Consider a 16-byte FASTOP_SIZE when CONFIG_RETHUNK is enabled.
> 
> Otherwise, functions will be incorrectly aligned and when computing their
> position for differently sized operators, they will executed in the middle
> or end of a function, which may as well be an int3, leading to a crash
> like:

Bah.. I did the SETcc stuff, but then forgot about the FASTOP :/

  af2e140f3420 ("x86/kvm: Fix SETcc emulation for return thunks")

> Fixes: aa3d480315ba ("x86: Use return-thunk in asm code")
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Josh Poimboeuf <jpoimboe@kernel.org>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> ---
>  arch/x86/kvm/emulate.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index db96bf7d1122..d779eea1052e 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -190,7 +190,7 @@
>  #define X16(x...) X8(x), X8(x)
>  
>  #define NR_FASTOP (ilog2(sizeof(ulong)) + 1)
> -#define FASTOP_SIZE (8 * (1 + HAS_KERNEL_IBT))
> +#define FASTOP_SIZE (8 * (1 + (HAS_KERNEL_IBT | IS_ENABLED(CONFIG_RETHUNK))))

Would it make sense to do something like this instead?

---
 arch/x86/kvm/emulate.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index db96bf7d1122..b4305d2dcc51 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -189,8 +189,12 @@
 #define X8(x...) X4(x), X4(x)
 #define X16(x...) X8(x), X8(x)
 
-#define NR_FASTOP (ilog2(sizeof(ulong)) + 1)
-#define FASTOP_SIZE (8 * (1 + HAS_KERNEL_IBT))
+#define NR_FASTOP	(ilog2(sizeof(ulong)) + 1)
+#define RET_LENGTH	(1 + (4 * IS_ENABLED(CONFIG_RETHUNK)) + \
+			 IS_ENABLED(CONFIG_SLS))
+#define FASTOP_LENGTH	(7 + ENDBR_INSN_SIZE + RET_LENGTH)
+#define FASTOP_SIZE	(8 << ((FASTOP_LENGTH > 8) & 1) << ((FASTOP_LENGTH > 16) & 1))
+static_assert(FASTOP_LENGTH <= FASTOP_SIZE);
 
 struct opcode {
 	u64 flags;
@@ -442,8 +446,6 @@ static int fastop(struct x86_emulate_ctxt *ctxt, fastop_t fop);
  * RET | JMP __x86_return_thunk	[1,5 bytes; CONFIG_RETHUNK]
  * INT3				[1 byte; CONFIG_SLS]
  */
-#define RET_LENGTH	(1 + (4 * IS_ENABLED(CONFIG_RETHUNK)) + \
-			 IS_ENABLED(CONFIG_SLS))
 #define SETCC_LENGTH	(ENDBR_INSN_SIZE + 3 + RET_LENGTH)
 #define SETCC_ALIGN	(4 << ((SETCC_LENGTH > 4) & 1) << ((SETCC_LENGTH > 8) & 1))
 static_assert(SETCC_LENGTH <= SETCC_ALIGN);
