Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8742573A03
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 17:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232449AbiGMPYI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 11:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236926AbiGMPYH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 11:24:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C95DA15FE6;
        Wed, 13 Jul 2022 08:24:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A8DBB8204D;
        Wed, 13 Jul 2022 15:24:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7933CC34114;
        Wed, 13 Jul 2022 15:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657725844;
        bh=h53LTrPedEhY3bM9vbncNkqrULxJF3EKAjvif3liSIo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YxmhN0pRnl9WaNV5CLQ5t0k/TNk3+cql6b8DvJ0RfJoKe2WC9GGwHJfP61VLirhEp
         t6SkxwMmYzLmPXlVX388oVj40hlcYnhOj48PCO3Cb+8wqH4+t/fh0uAf+diNrxod8l
         7jp1sENMPqV1wiVvQBwvMwXj0QNFF5JbNJA6Hz9oEcvtZdDqOI4wRvWXpi2gX63iGt
         Alf2EGSgE0AvLSGMqH3w2kTKBWDMjocGuea/x/JVwrBwhRpAo0qyxhU9PW1Z/0pfgx
         GVGsdhHc2xDBl8heg9x94IrKIEW5BPj1W7zh48LqEsMq7isZx3EO3ZwM0iOIHQm02n
         WNOsvB4K9Nwpg==
Date:   Wed, 13 Jul 2022 08:24:01 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] x86/speculation: Use DECLARE_PER_CPU for
 x86_spec_ctrl_current
Message-ID: <Ys7jkUxe4FXfyH/L@dev-arch.thelio-3990X>
References: <20220713152222.1697913-1-nathan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220713152222.1697913-1-nathan@kernel.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 13, 2022 at 08:22:22AM -0700, Nathan Chancellor wrote:
> Clang warns:
> 
>   arch/x86/kernel/cpu/bugs.c:58:21: error: section attribute is specified on redeclared variable [-Werror,-Wsection]
>   DEFINE_PER_CPU(u64, x86_spec_ctrl_current);
>                       ^
>   arch/x86/include/asm/nospec-branch.h:283:12: note: previous declaration is here
>   extern u64 x86_spec_ctrl_current;
>              ^
>   1 error generated.
> 
> The declaration should be using DECLARE_PER_CPU instead so all
> attributes stay in sync.
> 
> Cc: stable@vger.kernel.org
> Fixes: fc02735b14ff ("KVM: VMX: Prevent guest RSB poisoning attacks with eIBRS")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  arch/x86/include/asm/nospec-branch.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
> index bb05ed4f46bd..99a29c83adf8 100644
> --- a/arch/x86/include/asm/nospec-branch.h
> +++ b/arch/x86/include/asm/nospec-branch.h
> @@ -6,6 +6,7 @@
>  #include <linux/static_key.h>
>  #include <linux/objtool.h>
>  #include <linux/linkage.h>
> +#include <linux/percpu.h>

Argh, forgot to amend... v2 incoming.

>  #include <asm/alternative.h>
>  #include <asm/cpufeatures.h>
> @@ -280,7 +281,7 @@ static inline void indirect_branch_prediction_barrier(void)
>  
>  /* The Intel SPEC CTRL MSR base value cache */
>  extern u64 x86_spec_ctrl_base;
> -extern u64 x86_spec_ctrl_current;
> +DECLARE_PER_CPU(u64, x86_spec_ctrl_current);
>  extern void write_spec_ctrl_current(u64 val, bool force);
>  extern u64 spec_ctrl_current(void);
>  
> 
> base-commit: 72a8e05d4f66b5af7854df4490e3135168694b6b
> -- 
> 2.37.1
> 
