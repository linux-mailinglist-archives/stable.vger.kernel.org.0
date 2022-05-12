Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A221B525263
	for <lists+stable@lfdr.de>; Thu, 12 May 2022 18:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356179AbiELQVh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 May 2022 12:21:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356510AbiELQVc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 May 2022 12:21:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77C9251331;
        Thu, 12 May 2022 09:21:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9862B61F9C;
        Thu, 12 May 2022 16:21:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73140C385B8;
        Thu, 12 May 2022 16:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652372489;
        bh=NDeYtJoOTyZCZ7rH4NHOQS1V70YxoweEBSxhUWIM/zE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GEZzmykw70nosMdq2UT7qg8LKHXmRTyvKi2MNKMtZZ2CwyO6035MToY/A+CtoWVMY
         oeSXpYZuUcqissIoGJ61njBawHIw+QDkKvnMrIZZylSUEPuDQKvY08371yKuyZbajk
         RIXLkYKVZRAfckK8MXp2I3O8tCFEYOIRx+Ti6yrs=
Date:   Thu, 12 May 2022 18:21:26 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Maximilian Heyne <mheyne@amazon.de>
Cc:     stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org
Subject: Re: [PATCH 0/4] x86: decode Xen/KVM emulate prefixes
Message-ID: <Yn00BsSx060gS94o@kroah.com>
References: <20220512135654.119791-1-mheyne@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220512135654.119791-1-mheyne@amazon.de>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 12, 2022 at 01:56:47PM +0000, Maximilian Heyne wrote:
> This is a backport of a patch series for 5.4.x.
> 
> The patch series allows the x86 decoder to decode the Xen and KVM emulate
> prefixes.
> 
> In particular this solves the following issue that appeared when commit
> db6c6a0df840 ("objtool: Fix noreturn detection for ignored functions") was
> backported to 5.4.69:
> 
>   arch/x86/xen/enlighten_pv.o: warning: objtool: xen_cpuid()+0x25: can't find jump dest instruction at .text+0x9c
> 
> Also now that this decoding is possible, also backport the commit which prevents
> kprobes on probing such prefixed instructions. This was also part of the
> original series.
> 
> The series applied mostly cleanly on 5.4.192 except for a contextual problem in
> the 3rd patch ("x86: xen: insn: Decode Xen and KVM emulate-prefix signature").
> 
> Masami Hiramatsu (4):
>   x86/asm: Allow to pass macros to __ASM_FORM()
>   x86: xen: kvm: Gather the definition of emulate prefixes
>   x86: xen: insn: Decode Xen and KVM emulate-prefix signature
>   x86: kprobes: Prohibit probing on instruction which has emulate prefix
> 
>  arch/x86/include/asm/asm.h                  |  8 +++--
>  arch/x86/include/asm/emulate_prefix.h       | 14 +++++++++
>  arch/x86/include/asm/insn.h                 |  6 ++++
>  arch/x86/include/asm/xen/interface.h        | 11 +++----
>  arch/x86/kernel/kprobes/core.c              |  4 +++
>  arch/x86/kvm/x86.c                          |  4 ++-
>  arch/x86/lib/insn.c                         | 34 +++++++++++++++++++++
>  tools/arch/x86/include/asm/emulate_prefix.h | 14 +++++++++
>  tools/arch/x86/include/asm/insn.h           |  6 ++++
>  tools/arch/x86/lib/insn.c                   | 34 +++++++++++++++++++++
>  tools/objtool/sync-check.sh                 |  3 +-
>  tools/perf/check-headers.sh                 |  3 +-
>  12 files changed, 128 insertions(+), 13 deletions(-)
>  create mode 100644 arch/x86/include/asm/emulate_prefix.h
>  create mode 100644 tools/arch/x86/include/asm/emulate_prefix.h
> 
> 
> base-commit: 1d72b776f6dc973211f5d153453cf8955fb3d70a
> -- 
> 2.32.0
> 
> 
> 
> 
> Amazon Development Center Germany GmbH
> Krausenstr. 38
> 10117 Berlin
> Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
> Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
> Sitz: Berlin
> Ust-ID: DE 289 237 879
> 
> 
> 

All now queued up, thanks.

greg k-h
